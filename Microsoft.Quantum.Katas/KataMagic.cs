using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Microsoft.Jupyter.Core;
using Microsoft.Quantum.IQSharp;
using Microsoft.Quantum.IQSharp.Common;
using Microsoft.Quantum.Simulation.Common;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Microsoft.Quantum.Katas
{
    public class KataMagic : MagicSymbol
    {
        public KataMagic(IOperationResolver resolver, ISnippets snippets)
        {
            this.Name = $"%kata";
            this.Documentation = new Documentation() { Summary = "Executes a single kata.", Full = "## Executes a single kata.\n##Usage: \n%kata Test \"q# operation\"" };
            this.Kind = SymbolKind.Magic;
            this.Execute = this.Run;

            this.Resolver = resolver;
            this.Snippets = snippets;
        }

        internal IOperationResolver Resolver { get; }

        internal ISnippets Snippets { get; }

        public virtual ExecutionResult Run(string input, IChannel channel)
        {
            channel = channel.WithNewLines();

            var args = input?.Split(new char[] { ' ', '\n', '\t' }, 2);

            if (args == null || args.Length != 2) throw new InvalidOperationException("Invalid parameters. Usage: `%kata Test \"q# operation\"`");

            var name = args[0];
            var code = args[1];

            var kata = FindKata(name);
            if (kata == null) throw new InvalidOperationException($"Invalid test name: {name}");

            var userAnswer = Compile(code, channel);
            if (userAnswer == null) { return ExecuteStatus.Error.ToExecutionResult(); }

            return Simulate(kata, userAnswer, channel)
                ? "x成功 (success)!".ToExecutionResult()
                : ExecuteStatus.Error.ToExecutionResult();
        }

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
                    channel.Stdout("Expecting only one Q# operation in code. Using first");
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
                channel.Stderr(e.Message);
                return null;
            }
        }

        public virtual bool Simulate(OperationInfo kata, OperationInfo userAnswer, IChannel channel)
        {
            var rawAnswer = FindRawAnswer(kata, userAnswer);
            if (rawAnswer == null) throw new InvalidOperationException($"Invalid task: {userAnswer.FullName}");

            try
            {
                var qsim = CreateSimulator();

                qsim.DisableLogToConsole();
                qsim.Register(rawAnswer.RoslynType, userAnswer.RoslynType, typeof(ICallable));
                qsim.OnLog += channel.Stdout;

                var value = kata.RunAsync(qsim, null).Result;

                if (qsim is IDisposable dis) { dis.Dispose(); }

                return true;
            }
            catch (AggregateException agg)
            {
                channel.Stderr($"try again!");
                foreach (var e in agg.InnerExceptions) { channel.Stderr(e.Message); }
                return false;
            }
            catch (Exception e)
            {
                channel.Stderr($"try again!");
                channel.Stderr(e.Message);
                return false;
            }
        }

        public virtual SimulatorBase CreateSimulator() =>
            new QuantumSimulator();


        public virtual OperationInfo FindKata(string kataName) =>
                    Resolver.Resolve(kataName);

        public virtual OperationInfo FindRawAnswer(OperationInfo kata, OperationInfo userAnswer) =>
            Resolver.Resolve($"{kata.Header.QualifiedName.Namespace.Value}.{userAnswer.FullName}");
    }
}

