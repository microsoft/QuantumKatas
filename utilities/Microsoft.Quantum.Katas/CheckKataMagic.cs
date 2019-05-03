// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;
using System.Linq;
using Microsoft.Extensions.Logging;
using Microsoft.Jupyter.Core;
using Microsoft.Quantum.IQSharp;
using Microsoft.Quantum.IQSharp.Common;
using Microsoft.Quantum.Simulation.Common;
using Microsoft.Quantum.Simulation.Core;

namespace Microsoft.Quantum.Katas
{
    public class CheckKataMagic : MagicSymbol
    {
        /// <summary>
        /// IQ# Magic that checks that the reference implementation of a Kata's test runs successfully.
        /// </summary>
        public CheckKataMagic(IOperationResolver resolver, ICompilerService compiler, ILogger<KataMagic> logger)
        {
            this.Name = $"%check_kata";
            this.Documentation = new Documentation() { Summary = "Checks the resference implementaiton of a single kata's test." };
            this.Kind = SymbolKind.Magic;
            this.Execute = this.Run;

            this.Resolver = resolver;
            this.Compiler = compiler;
            this.Logger = logger;
        }

        /// <summary>
        /// The Resolver lets us find compiled Q# operations from the workspace
        /// </summary>
        protected IOperationResolver Resolver { get; }

        /// <summary>
        /// The list of user-defined Q# code snippets from the notebook.
        /// </summary>
        protected ICompilerService Compiler { get; }

        protected ILogger<KataMagic> Logger { get; }

        /// <summary>
        /// What this Magic does when triggered. It will:
        /// - find the Test to execute based on the provided name,
        /// - semi-compile the code after to identify the name of the operation with the user's answer.
        /// - call simulate to execute the test.
        /// </summary>
        public virtual ExecutionResult Run(string input, IChannel channel)
        {
            channel = channel.WithNewLines();

            // Expect exactly two arguments, the name of the Kata and the user's answer (code).
            var args = input?.Split(new char[] { ' ', '\n', '\t' }, 2);
            if (args == null || args.Length != 2)
            {
                channel.Stderr("Invalid parameters. Usage: `%kata Test \"Q# operation\"`");
                return ExecuteStatus.Error.ToExecutionResult();
            }

            var name = args[0];
            var code = args[1];

            var test = FindTest(name);
            if (test == null)
            {
                channel.Stderr($"Invalid test name: {name}");
                return ExecuteStatus.Error.ToExecutionResult();
            }

            var userAnswer = Compile(code, channel);
            if (userAnswer == null) { return ExecuteStatus.Error.ToExecutionResult(); }

            return Simulate(test, userAnswer, channel)
                ? "Success!".ToExecutionResult()
                : ExecuteStatus.Error.ToExecutionResult();
        }

        /// <summary>
        /// Compiles the given code. Checks there is only one operation defined in the code,
        /// and returns its corresponding OperationInfo
        /// </summary>
        public virtual string Compile(string code, IChannel channel)
        {
            try
            {
                var result = Compiler.IdentifyElements(code);

                // Gets the names of all the operations found for this snippet
                var opsNames =
                    result
                        .Where(e => e.IsQsCallable)
                        .Select(e => e.ToFullName().WithoutNamespace(Microsoft.Quantum.IQSharp.Snippets.SNIPPETS_NAMESPACE))
                        .OrderBy(o => o)
                        .ToArray();

                if (opsNames.Length > 1)
                {
                    channel.Stdout("Expecting only one Q# operation in code. Using the first one");
                }

                return opsNames.First();
            }
            catch (CompilationErrorsException c)
            {
                foreach (var m in c.Errors) channel.Stderr(m);
                return null;
            }
            catch (Exception e)
            {
                Logger?.LogWarning(e, "Unexpected error.");
                channel.Stderr(e.Message);
                return null;
            }
        }

        /// <summary>
        /// Executes the given test by replacing the userAnswer with its reference implementation.
        /// It is expected that the test will succeed with no warnings.
        /// </summary>
        public virtual bool Simulate(OperationInfo test, string userAnswer, IChannel channel)
        {
            // The skeleton answer used to compile the workspace
            var skeletonAnswer = FindSkeletonAnswer(test, userAnswer);
            if (skeletonAnswer == null)
            {
                channel.Stderr($"Invalid task name: {userAnswer}");
                return false;
            }

            // The reference implementation
            var referenceAnswer = FindReferenceImplementation(test, userAnswer);
            if (referenceAnswer == null)
            {
                channel.Stderr($"Reference answer not found: {userAnswer}");
                return false;
            }

            try
            {
                var qsim = CreateSimulator();
                var hasWarnings = false;

                qsim.DisableLogToConsole();
                qsim.Register(skeletonAnswer.RoslynType, referenceAnswer.RoslynType, typeof(ICallable));
                qsim.OnLog += (msg) =>
                {
                    hasWarnings = msg?.StartsWith("[WARNING]") ?? hasWarnings;
                    channel.Stdout(msg);
                };

                var value = test.RunAsync(qsim, null).Result;

                if (qsim is IDisposable dis) { dis.Dispose(); }

                return !hasWarnings;
            }
            catch (AggregateException agg)
            {
                foreach (var e in agg.InnerExceptions) { channel.Stderr(e.Message); }
                channel.Stderr($"Try again!");
                return false;
            }
            catch (Exception e)
            {
                channel.Stderr(e.Message);
                channel.Stderr($"Try again!");
                return false;
            }
        }

        /// <summary>
        /// Creates the instance of the simulator to use to run the test 
        /// (for now always CounterSimulator from the same package).
        /// </summary>
        public virtual SimulatorBase CreateSimulator() =>
            new CounterSimulator();

        /// <summary>
        /// Returns the OperationInfo for the test to run.
        /// </summary>
        public virtual OperationInfo FindTest(string testName) =>
             Resolver.Resolve(testName);

        /// <summary>
        /// Returns the original shell for the test's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// test's namespace
        /// </summary>
        public virtual OperationInfo FindSkeletonAnswer(OperationInfo test, string userAnswer) =>
            Resolver.Resolve($"{test.Header.QualifiedName.Namespace.Value}.{userAnswer}");

        /// <summary>
        /// Returns the reference implementation for the test's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// test's namespace and with <c>_Reference</c> added to the userAnswer's name.
        /// </summary>
        public virtual OperationInfo FindReferenceImplementation(OperationInfo test, string userAnswer) =>
            Resolver.Resolve($"{test.Header.QualifiedName.Namespace.Value}.{userAnswer}_Reference");
    }
}

