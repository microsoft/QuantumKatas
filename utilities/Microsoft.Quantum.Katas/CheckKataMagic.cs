// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;
using Microsoft.Extensions.Logging;
using Microsoft.Jupyter.Core;
using Microsoft.Quantum.IQSharp;
using Microsoft.Quantum.Simulation.Common;

namespace Microsoft.Quantum.Katas
{
    public class CheckKataMagic : AbstractKataMagic
    {
        /// <summary>
        /// IQ# Magic that checks that the reference implementation of a Kata's test runs successfully.
        /// </summary>
        public CheckKataMagic(IOperationResolver resolver, ISnippets snippets, ILogger<CheckKataMagic> logger)
            : base(resolver, snippets, logger)
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
                    "     : operation StateFlip (q : Qubit) : Unit is Adj + Ctl {\n" +
                    "           // The Pauli X gate will change the |0⟩ state to the |1⟩ state and vice versa.\n" +
                    "           // Type X(q);\n" +
                    "           // Then run the cell using Ctrl/⌘+Enter.\n" +
                    "\n" +
                    "           // ...\n" +
                    "       }\n" +
                    "Out[]: Success!" +
                    "```\n"
                }
            };
        }

        /// <summary>
        /// Returns the reference implementation for the test's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// test's namespace and with <c>_Reference</c> added to the userAnswer's name.
        /// </summary>
        protected virtual OperationInfo FindReferenceImplementation(OperationInfo test, OperationInfo userAnswer)
        {
            var referenceAnswer = Resolver.Resolve($"{test.Header.QualifiedName.Namespace}.{userAnswer.FullName}_Reference");
            Logger.LogDebug($"Found Reference answer {referenceAnswer} for {userAnswer}");

            if (referenceAnswer == null)
            {
                throw new Exception($"Reference answer not found for : {userAnswer}");
            }
            return referenceAnswer;
        }

        /// <summary>
        /// Returns the original shell for the test's answer in the workspace for the given userAnswer.
        /// It does this by finding another operation with the same name as the `userAnswer` but in the 
        /// test's namespace
        /// </summary>
        protected override OperationInfo FindSkeletonAnswer(OperationInfo test, OperationInfo userAnswer)
        {
            var skeletonAnswer = base.FindSkeletonAnswer(test, userAnswer);
            var referenceAnswer = FindReferenceImplementation(test, userAnswer);
            if (skeletonAnswer != null)
            {
                // Remember the reference answer for this task
                AllAnswers[skeletonAnswer] = referenceAnswer;
            }
            return skeletonAnswer;
        }

        protected override SimulatorBase SetDisplay(SimulatorBase simulator, IChannel channel)
        {
            if(simulator is SimulatorBase sim)
            {
                var simHasWarnings = false;
                sim.OnLog += (msg) =>
                {
                    simHasWarnings = msg?.StartsWith("[WARNING]") ?? simHasWarnings;
                    if(simHasWarnings == true)
                    {
                        throw new Exception($"Errors on {sim.GetType().Name} : " + msg);
                    }
                    else
                    {
                        channel.Stdout($"Msg from {sim.GetType().Name} : " + msg);
                    }
                };
                return sim;
            }
            throw new Exception($"Can't set display for the simulator of type {simulator.GetType().FullName}");
        }

    }
}
