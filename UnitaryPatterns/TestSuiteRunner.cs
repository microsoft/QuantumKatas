﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

using Microsoft.Quantum.Simulation.XUnit;
using Xunit.Abstractions;
using System.Diagnostics;

using Microsoft.Quantum.Katas;

namespace Quantum.Kata.UnitaryPatterns
{
    public class TestSuiteRunner
    {
        private readonly ITestOutputHelper output;

        public TestSuiteRunner(ITestOutputHelper output)
        {
            this.output = output;
        }

        /// <summary>
        /// This driver will run all Q# tests (operations named "...Test") 
        /// that belong to namespace Quantum.Kata.UnitaryPatterns.
        /// </summary>
        [OperationDriver(TestNamespace = "Quantum.Kata.UnitaryPatterns")]
        public void TestTarget(TestOperation op)
        {
            using (var sim = new CounterSimulator())
            {
                // OnLog defines action(s) performed when Q# test calls function Message
                sim.OnLog += (msg) => { output.WriteLine(msg); };
                sim.OnLog += (msg) => { Debug.WriteLine(msg); };
                op.TestOperationRunner(sim);
            }
        }
    }
}
