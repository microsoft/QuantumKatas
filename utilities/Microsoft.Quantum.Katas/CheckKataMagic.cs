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
        /// IQ# Magic that checks that the Reference implementation of a Kata runs successfully.
        /// </summary>
        public CheckKataMagic(IOperationResolver resolver, ICompilerService compiler, ILogger<KataMagic> logger)
        {
            this.Name = $"%check_kata";
            this.Documentation = new Documentation() { Summary = "Checks the resference implementaiton of a single kata." };
            this.Kind = SymbolKind.Magic;
            this.Execute = this.Run;

            this.Resolver = resolver;
            this.Compiler = compiler;
            this.Logger = logger;
        }

        /// <summary>
        /// The Resolver let's us find compiled Q# operations from the workspace
        /// </summary>
        protected IOperationResolver Resolver { get; }

        /// <summary>
        /// The list of user-defined Q# code snippets from the notebook.
        /// </summary>
        protected ICompilerService Compiler { get; }

        protected ILogger<KataMagic> Logger { get; }

        /// <summary>
        /// What this Magic does when triggered. It will:
        /// - find the Kata to execute based on the Kata name,
        /// - compile the code after found after the name as the user's answer.
        /// - run (simulate) the kata.
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

            var kata = FindKata(name);
            if (kata == null)
            {
                channel.Stderr($"Invalid test name: {name}");
                return ExecuteStatus.Error.ToExecutionResult();
            }

            var userAnswer = Compile(code, channel);
            if (userAnswer == null) { return ExecuteStatus.Error.ToExecutionResult(); }

            return Simulate(kata, userAnswer, channel)
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
        /// Executes the given kata using the provided <c>userAnswer</c> as the actual answer.
        /// To do this, it finds another operation with the same name but in the Kata's namespace
        /// (by calling `FindRawAnswer`) and replace its implementation with the userAnswer
        /// in the simulator.
        /// </summary>
        public virtual bool Simulate(OperationInfo kata, string userAnswer, IChannel channel)
        {
            var rawAnswer = FindRawAnswer(kata, userAnswer);
            if (rawAnswer == null)
            {
                channel.Stderr($"Invalid task: {userAnswer}");
                return false;
            }

            var referenceAnser = FindReferenceImplementation(kata, userAnswer);
            if (referenceAnser == null)
            {
                channel.Stderr($"Invalid Reference answer: {userAnswer}");
                return false;
            }

            try
            {
                var qsim = CreateSimulator();
                var hasWarnings = false;

                qsim.DisableLogToConsole();
                qsim.Register(rawAnswer.RoslynType, referenceAnser.RoslynType, typeof(ICallable));
                qsim.OnLog += (msg) =>
                {
                    hasWarnings = msg?.StartsWith("[WARNING]") ?? hasWarnings;
                    channel.Stdout(msg);
                };

                var value = kata.RunAsync(qsim, null).Result;

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
        /// Creates the instance of the simulator to use to run the Kata 
        /// (for now always CounterSimulator from the same package).
        /// </summary>
        public virtual SimulatorBase CreateSimulator() =>
            new CounterSimulator();

        /// <summary>
        /// Returns the OperationInfo for the Kata to run.
        /// </summary>
        public virtual OperationInfo FindKata(string kataName) =>
             Resolver.Resolve(kataName);

        /// <summary>
        /// Returns the original shell for the Kata's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// Kata's namespace
        /// </summary>
        public virtual OperationInfo FindRawAnswer(OperationInfo kata, string userAnswer) =>
            Resolver.Resolve($"{kata.Header.QualifiedName.Namespace.Value}.{userAnswer}");

        /// <summary>
        /// Returns the original shell for the Kata's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// Kata's namespace
        /// </summary>
        public virtual OperationInfo FindReferenceImplementation(OperationInfo kata, string userAnswer) =>
            Resolver.Resolve($"{kata.Header.QualifiedName.Namespace.Value}.{userAnswer}_Reference");
    }
}

