// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Extensions.Logging;
using Microsoft.Jupyter.Core;
using Microsoft.Quantum.IQSharp;
using Microsoft.Quantum.IQSharp.Common;
using Microsoft.Quantum.Simulation.Common;
using Microsoft.Quantum.Simulation.Core;

namespace Microsoft.Quantum.Katas
{
    public class KataMagic : MagicSymbol
    {
        /// <summary>
        /// IQ# Magic that enables executing the Katas on Jupyter.
        /// </summary>
        public KataMagic(IOperationResolver resolver, ISnippets snippets, ILogger<KataMagic> logger)
        {
            this.Name = $"%kata";
            this.Documentation = new Documentation() { Summary = "Executes a single test.", Full = "## Executes a single test.\n##Usage: \n%kata Test \"q# operation\"" };
            this.Kind = SymbolKind.Magic;
            this.Execute = this.Run;

            this.Resolver = resolver;
            this.Snippets = snippets;
            this.Logger = logger;
            this.AllAnswers = new Dictionary<OperationInfo, OperationInfo>();
        }

        /// <summary>
        /// The Resolver lets us find compiled Q# operations from the workspace
        /// </summary>
        protected IOperationResolver Resolver { get; }

        /// <summary>
        /// The list of user-defined Q# code snippets from the notebook.
        /// </summary>
        protected ISnippets Snippets { get; }

        protected ILogger<KataMagic> Logger { get; }

        protected Dictionary<OperationInfo, OperationInfo> AllAnswers { get; }

        /// <summary>
        /// What this Magic does when triggered. It will:
        /// - find the Test to execute based on the given name,
        /// - compile the code after found after the name as the user's answer.
        /// - run (simulate) the test and report its result.
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
        public virtual OperationInfo Compile(string code, IChannel channel)
        {
            try
            {
                var result = Snippets.Compile(code);

                foreach (var m in result.warnings) { channel.Stdout(m); }

                // Gets the names of all the operations found for this snippet
                var opsNames =
                    result.Elements?
                        .Where(e => e.IsQsCallable)
                        .Select(e => e.ToFullName().WithoutNamespace(Microsoft.Quantum.IQSharp.Snippets.SNIPPETS_NAMESPACE))
                        .OrderBy(o => o)
                        .ToArray();

                if (opsNames.Length > 1)
                {
                    channel.Stdout("Expecting only one Q# operation in code. Using the first one");
                }

                return Resolver.Resolve(opsNames.First());
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
        /// Executes the given kata using the provided <c>userAnswer</c> as the actual answer.
        /// To do this, it finds another operation with the same name but in the Kata's namespace
        /// (by calling `FindRawAnswer`) and replace its implementation with the userAnswer
        /// in the simulator.
        /// </summary>
        public virtual bool Simulate(OperationInfo test, OperationInfo userAnswer, IChannel channel)
        {
            var skeletonAnswer = FindSkeletonAnswer(test, userAnswer);
            if (skeletonAnswer == null)
            {
                channel.Stderr($"Invalid task: {userAnswer.FullName}");
                return false;
            }

            try
            {
                var qsim = CreateSimulator();

                qsim.DisableLogToConsole();
                // Register all solutions to previously executed tasks (including the current one)
                foreach (KeyValuePair<OperationInfo, OperationInfo> answer in AllAnswers) {
                    Logger.LogDebug($"Registering {answer.Key.FullName}");
                    qsim.Register(answer.Key.RoslynType, answer.Value.RoslynType, typeof(ICallable));
                }
                qsim.OnLog += channel.Stdout;

                var value = test.RunAsync(qsim, null).Result;

                if (qsim is IDisposable dis) { dis.Dispose(); }

                return true;
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
        /// Creates the instance of the simulator to use to run the Test 
        /// (for now always CounterSimulator from the same package).
        /// </summary>
        public virtual SimulatorBase CreateSimulator() =>
            new CounterSimulator();

        /// <summary>
        /// Returns the OperationInfo with the Test to run based on the given name.
        /// </summary>
        public virtual OperationInfo FindTest(string testName) =>
             Resolver.Resolve(testName);

        /// <summary>
        /// Returns the original shell for the test's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// test's namespace
        /// </summary>
        public virtual OperationInfo FindSkeletonAnswer(OperationInfo test, OperationInfo userAnswer)
        {
            var skeletonAnswer = Resolver.Resolve($"{test.Header.QualifiedName.Namespace.Value}.{userAnswer.FullName}");
            Logger.LogDebug($"Resolved {userAnswer.FullName} to {skeletonAnswer}");
            if (skeletonAnswer != null)
            {
                // Remember the last user answer for this task
                AllAnswers[skeletonAnswer] = userAnswer;
            }
            return skeletonAnswer;
        }
    }
}

