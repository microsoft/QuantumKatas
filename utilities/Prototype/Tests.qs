// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Prototype {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Quantum.Kata.Utils;

    @Test("QuantumSimulator")
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation QuantumSimulatorCheck() : Unit {
        use q = Qubit();

        H(q);

        FlipZeroToPlusNoRestriction(q);

        AssertQubit(Zero, q);
        
        Message("Test passed...");
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation CounterSimulatorCheck() : Unit {
        use q = Qubit();
        H(q);

        ResetOracleCallsCount();

        FlipZeroToPlusRestriction(q);
        let nu = GetOracleCallsCount(H);

        AssertQubit(Zero, q);
        
        EqualityFactI(nu, 1, $"You are allowed to call H gate exactly once, and you called it {nu} times");
    
        Message("Test passed...");
    }

    // Toffoli Simulator check
    @Test("ToffoliSimulator")
    operation ToffoliSimulatorCheck() : Unit {
        use qs = Qubit[50];

        FlipZerosToOnes(qs);

        for q in qs
        {
            AssertQubit(One, q);
        }

        ResetAll(qs);

        Message("Test passed...");
	}


    // Check on multiple simulators
    @Test("QuantumSimulator")
    @Test("ToffoliSimulator")
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation MultipleSimulatorCheck() : Unit {
        use qs = Qubit[2];

        FlipZerosToOnes(qs);

        for q in qs
        {
            AssertQubit(One, q);
        }

        ResetAll(qs);

        Message("Test passed...");
	}

}
