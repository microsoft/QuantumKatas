// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;
using Microsoft.Extensions.Logging;
using Microsoft.Jupyter.Core;
using Microsoft.Quantum.IQSharp;
using Microsoft.Quantum.IQSharp.Jupyter;
using Microsoft.Quantum.Simulation.Common;
using Microsoft.Quantum.Simulation.Simulators;

namespace Microsoft.Quantum.Katas
{
    public class KataMagic : AbstractKataMagic
    {
        /// <summary>
        /// IQ# Magic that enables executing the Katas on Jupyter.
        /// </summary>
        public KataMagic(IOperationResolver resolver, ISnippets snippets, ILogger<KataMagic> logger, IConfigurationSource configurationSource)
            : base(resolver, snippets, logger)
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
                    "     : operation StateFlip (q : Qubit) : Unit is Adj + Ctl {\n" +
                    "           // The Pauli X gate will change the |0⟩ state to the |1⟩ state and vice versa.\n" +
                    "           // Type X(q);\n" +
                    "           // Then run the cell using Ctrl/⌘+Enter.\n" +
                    "\n" +
                    "           // ...\n" +
                    "       }\n" +
                    "Out[]: Qubit in invalid state. Expecting: Zero\n" +
	                "       \tExpected:\t0\n"+
	                "       \tActual:\t0.5000000000000002\n" +
                    "       Try again!" +
                    "```\n"
                }
            };
            this.ConfigurationSource = configurationSource;
        }

        /// <summary>
        ///     The configuration source used by this magic command to control
        ///     simulation options (e.g.: dump formatting options).
        /// </summary>
        protected IConfigurationSource ConfigurationSource { get; }

        /// <summary>
        /// Logs the messages with rich Jupyter formatting for simulators of the type QuantumSimulator
        /// and stack traces for exceptions for the other simulators
        /// </summary>
        protected override SimulatorBase SetDisplay(SimulatorBase simulator, IChannel channel)
        {
            if(simulator is QuantumSimulator qsim)
            {
                // To display diagnostic output with rich Jupyter formatting
                return qsim.WithJupyterDisplay(channel, ConfigurationSource);
            }
            else if(simulator is SimulatorBase sim)
            {
                // Add logging ability for simulators other than quantum simulator
                sim.OnLog += channel.Stdout;
                // To display diagnostic output and stack traces for exceptions
                return sim.WithStackTraceDisplay(channel);
            }
            throw new Exception($"Can't set display for the simulator of type {simulator.GetType().FullName}");
        }
    }
}
