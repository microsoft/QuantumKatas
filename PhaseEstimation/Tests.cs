// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

using Microsoft.Quantum.Intrinsic;
using Microsoft.Quantum.Katas;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using Quantum.Kata.PhaseEstimation;
using System.Diagnostics;
using Xunit;

namespace T13
{
    public class EigenstateAssertion
    {
        void TestFailingAssertOnUnitaries(QuantumSimulator sim, ICallable unitary, IAdjointable prep)
        {
            bool exceptionThrown = false;
            try
            {
                AssertIsEigenstate.Run(sim, unitary, prep).Wait();
            }
            catch (System.Exception e)
            {
                exceptionThrown = true;
                System.Console.WriteLine(e);
            }
            Xunit.Assert.True(exceptionThrown, "An exception should have been thrown if the state was not an eigenstate");
        }

        [Fact]
        public void T13_AssertIsEigenstate_Test()
        {
            using (var sim = new CounterSimulator())
            {
                sim.OnLog += (msg) => { Debug.WriteLine(msg); };

                // First, test state/unitary pairs which are eigenstates.
                // Neither pair should throw an exception, so we can test them all together.
                try
                {
                    TestAssertIsEigenstate_True.Run(sim).Wait();
                }
                catch (System.Exception e)
                {
                    System.Console.WriteLine(e);
                    Xunit.Assert.False(true, "An exception should not have been thrown if the state was an eigenstate");
                }

                // Second, test pairs which are not eigenstates.
                // Since each pair has to throw an exception, each pair has to be tested separately.
                var Xgate = sim.Get<IAdjointable, X>();
                var Ygate = sim.Get<IAdjointable, Y>();
                var Zgate = sim.Get<IAdjointable, Z>();
                var Hgate = sim.Get<IAdjointable, H>();
                TestFailingAssertOnUnitaries(sim, Zgate, Hgate);
                TestFailingAssertOnUnitaries(sim, Xgate, Xgate);
                TestFailingAssertOnUnitaries(sim, Xgate, Zgate);
                TestFailingAssertOnUnitaries(sim, Ygate, Hgate);
                TestFailingAssertOnUnitaries(sim, Ygate, Xgate);
                TestFailingAssertOnUnitaries(sim, Ygate, Zgate);
                TestFailingAssertOnUnitaries(sim, Hgate, Xgate);
                TestFailingAssertOnUnitaries(sim, Hgate, Zgate);
                TestFailingAssertOnUnitaries(sim, Hgate, Hgate);
            }
        }
    }
}
