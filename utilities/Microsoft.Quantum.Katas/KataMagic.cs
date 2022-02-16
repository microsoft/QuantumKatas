// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using Microsoft.Jupyter.Core;
using Microsoft.Quantum.IQSharp;
using Microsoft.Quantum.IQSharp.Jupyter;
using Microsoft.Quantum.Simulation.Common;
using Microsoft.Quantum.Simulation.Simulators;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.QsCompiler.SyntaxTree;

namespace Microsoft.Quantum.Katas
{
    public class KataMagic : AbstractKataMagic
    {
        /// <summary>
        /// IQ# Magic that enables executing the Katas on Jupyter.
        /// </summary>
        public KataMagic(IOperationResolver resolver, ILogger<KataMagic> logger, ISnippets snippets, IConfigurationSource configurationSource)
            : base(resolver, logger)
        {
            this.Name = $"%kata";
            this.Documentation = new Microsoft.Jupyter.Core.Documentation
            {
                Summary = "Executes a single test.",
                Description = "Executes a single test, and reports whether the test passed successfully.",
                Examples = new []
                {
                    "To run a test called `Test`:\n" +
                    "```\n" +
                    "In []: %kata T101_StateFlip \n" +
                    "       operation StateFlip (q : Qubit) : Unit is Adj + Ctl {\n" +
                    "           // The Pauli X gate will change the |0⟩ state to the |1⟩ state and vice versa.\n" +
                    "           // Type X(q);\n" +
                    "           // Then run the cell using Ctrl/⌘+Enter.\n" +
                    "\n" +
                    "           // ...\n" +
                    "       }\n" +
                    "Out[]: Qubit in invalid state. Expecting: Zero\n" +
	                "       \tExpected:\t0\n"+
	                "       \tActual:\t0.5000000000000002\n" +
                    "       Try again!\n" +
                    "```\n"
                }
            };
            this.Snippets = snippets;
            this.ConfigurationSource = configurationSource;
        }

        /// <summary>
        /// The list of user-defined Q# code snippets from the notebook.
        /// </summary>
        protected ISnippets Snippets { get; }

        /// <summary>
        ///     The configuration source used by this magic command to control
        ///     simulation options (e.g.: dump formatting options).
        /// </summary>
        protected IConfigurationSource ConfigurationSource { get; }

        ///<inheritdoc/>
        protected override IEnumerable<QsNamespaceElement> GetDeclaredCallables(string code, IChannel channel)
        {
            var result = Snippets.Compile(code);

            foreach (var m in result.warnings) { channel.Stdout(m); }

            return result.Elements;
        }

        /// <summary>
        /// Executes the given kata using the provided <c>userAnswer</c> as the actual answer.
        /// To do this, it finds another operation with the same name but in the Kata's namespace
        /// (by calling `FindSkeltonAnswer`) and replace its implementation with the userAnswer
        /// in the simulator.
        /// </summary>
        protected override bool Simulate(OperationInfo test, string userAnswer, IChannel channel)
        {
            var skeletonAnswer = FindSkeletonAnswer(test, userAnswer);
            if (skeletonAnswer == null)
            {
                channel.Stderr($"Invalid task: {userAnswer}");
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

            var allTestsPassed = true;
            foreach(SimulatorBase testSim in testSimulators)
            {
                try
                {
                    testSim.DisableExceptionPrinting();
                    testSim.DisableLogToConsole();
                    testSim.OnDisplayableDiagnostic += channel.Display;
                    testSim.OnLog += channel.Stdout;

                    // Register all solutions to previously executed tasks (including the current one)
                    foreach (KeyValuePair<OperationInfo, OperationInfo> answer in AllAnswers) {
                        Logger.LogDebug($"Registering {answer.Key.FullName}");
                        testSim.Register(answer.Key.RoslynType, answer.Value.RoslynType, typeof(ICallable));
                    }

                    var value = test.RunAsync(testSim, null).Result;
                    channel.Stdout($"Success on {testSim.GetType().Name}!");
                    if (testSim is IDisposable dis) { dis.Dispose(); }
                }
                catch (AggregateException agg)
                {
                    foreach (var e in agg.InnerExceptions) { channel.Stderr(e.Message); }
                    channel.Stderr(testSim != null ? $"Test failed on {testSim.GetType().Name}!" : "Test failed.");
                    channel.Stderr($"Try again!");
                    allTestsPassed = false;
                }
                catch (Exception e)
                {
                    channel.Stderr(e.Message);
                    channel.Stderr(testSim != null ? $"Test failed on {testSim.GetType().Name}!" : "Test failed.");
                    channel.Stderr($"Try again!");
                    allTestsPassed = false;
                }
            }
            return allTestsPassed;
        }

        /// <summary>
        /// Returns the original shell for the test's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// test's namespace
        /// </summary>
        public virtual OperationInfo FindSkeletonAnswer(OperationInfo test, string userAnswer)
        {
            var userAnswerInfo = Resolver.Resolve(userAnswer);
            var skeletonAnswer = Resolver.Resolve($"{test.Header.QualifiedName.Namespace}.{userAnswerInfo.FullName}");
            Logger.LogDebug($"Resolved {userAnswerInfo.FullName} to {skeletonAnswer}");
            if (skeletonAnswer != null)
            {
                // Remember the last user answer for this task
                AllAnswers[skeletonAnswer] = userAnswerInfo;
            }
            return skeletonAnswer;
        }

    }
}
