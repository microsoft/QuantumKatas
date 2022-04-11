// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using Microsoft.Jupyter.Core;
using Microsoft.Quantum.IQSharp;
using Microsoft.Quantum.Simulation.Common;
using Microsoft.Quantum.QsCompiler.SyntaxTree;
using System.Threading.Tasks;

namespace Microsoft.Quantum.Katas
{
    public class CheckKataMagic : AbstractKataMagic
    {
        /// <summary>
        /// IQ# Magic that checks that the reference implementation of a Kata's test runs successfully.
        /// </summary>
        public CheckKataMagic(IOperationResolver resolver, ILogger<CheckKataMagic> logger, ICompilerService compiler)
            : base(resolver, logger)
        {
            this.Name = $"%check_kata";
            this.Documentation = new Microsoft.Jupyter.Core.Documentation
            {
                Summary = "Checks the reference implementation for a single kata's test.",
                Description =
                    "Substitutes the reference implementation for a " +
                    "single task into the cell, and reports whether the test " +
                    "passed successfully using the reference implementation.",
                Examples = new []
                {
                    "To check a test called `Test`:\n" +
                    "```\n" +
                    "In []: %check_kata T101_StateFlip \n" +
                    "       operation StateFlip (q : Qubit) : Unit is Adj + Ctl {\n" +
                    "           // The Pauli X gate will change the |0⟩ state to the |1⟩ state and vice versa.\n" +
                    "           // Type X(q);\n" +
                    "           // Then run the cell using Ctrl/⌘+Enter.\n" +
                    "\n" +
                    "           // ...\n" +
                    "       }\n" +
                    "Out[]: Success!\n" +
                    "```\n"
                }
            };
            this.Compiler = compiler;
        }

        /// <summary>
        /// The list of user-defined Q# code snippets from the notebook.
        /// </summary>
        protected ICompilerService Compiler { get; }

        ///<inheritdoc/>
        protected override Task<IEnumerable<QsNamespaceElement>> GetDeclaredCallables(string code, IChannel channel) =>
               Task.FromResult(Compiler.IdentifyElements(code));

        /// <summary>
        /// Executes the given test by replacing the userAnswer with its reference implementation.
        /// It is expected that the test will succeed with no warnings.
        /// </summary>
       protected override bool Simulate(OperationInfo test, string userAnswer, IChannel channel)
       {
            // The skeleton answer used to compile the workspace
            var skeletonAnswer = FindSkeletonAnswer(test, userAnswer);
            if (skeletonAnswer == null)
            {
                channel.Stderr($"Invalid task: {userAnswer}");
                return false;
            }
            
            // The reference implementation
            var referenceAnswer = FindReferenceImplementation(test, userAnswer);
            if (referenceAnswer == null)
            {
                channel.Stderr($"Reference answer not found: {userAnswer}");
                return false;
            }

            List<SimulatorBase> testSimulators;
            try 
            {
                testSimulators = CreateSimulators(channel, test);
            } 
            catch (Exception e) {
                channel.Stderr($"Failed to create test simulators: {e.Message}");
                return false;
            }

            var testsPassedWithoutWarnings = true;
            foreach(SimulatorBase testSim in testSimulators)
            {
                try
                {
                    testSim.DisableLogToConsole();
                    testSim.OnDisplayableDiagnostic += channel.Display;

                    var hasWarnings = false;
                    testSim.OnLog += (msg) =>
                    {
                        hasWarnings = msg?.StartsWith("[WARNING]") ?? hasWarnings;
                        channel.Stdout(msg);
                    };

                    var value = test.RunAsync(testSim, null).Result;
                    testsPassedWithoutWarnings &= !hasWarnings;
                    channel.Stdout($"Success on {testSim.GetType().Name}!");
                    
                    if (testSim is IDisposable dis) { dis.Dispose(); }
                }
                catch (AggregateException agg)
                {
                    foreach (var e in agg.InnerExceptions) { channel.Stderr(e.Message); }
                    channel.Stderr(testSim != null ? $"Test failed on {testSim.GetType().Name}!" : "Test failed.");
                    channel.Stderr($"Try again!");
                    testsPassedWithoutWarnings = false;
                }
                catch (Exception e)
                {
                    channel.Stderr(e.Message);
                    channel.Stderr(testSim != null ? $"Test failed on {testSim.GetType().Name}!" : "Test failed.");
                    channel.Stderr($"Try again!");
                    testsPassedWithoutWarnings = false;
                }
            }
            return testsPassedWithoutWarnings;
       }

        /// <summary>
        /// Returns the original shell for the test's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// test's namespace
        /// </summary>
        public virtual OperationInfo FindSkeletonAnswer(OperationInfo test, string userAnswer) =>
            Resolver.Resolve($"{test.Header.QualifiedName.Namespace}.{userAnswer}");

        /// <summary>
        /// Returns the reference implementation for the test's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the <c>userAnswer</c> but in the 
        /// test's namespace and with <c>_Reference</c> added to the userAnswer's name.
        /// </summary>
        public virtual OperationInfo FindReferenceImplementation(OperationInfo test, string userAnswer) =>
            Resolver.Resolve($"{test.Header.QualifiedName.Namespace}.{userAnswer}_Reference");

    }
}
