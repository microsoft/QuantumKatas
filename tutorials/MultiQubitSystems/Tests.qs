// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MultiQubitSystems {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    
    // ------------------------------------------------------
    operation AssertEqualOnZeroState (testImpl : (Qubit[] => Unit is Ctl), refImpl : (Qubit[] => Unit is Adj+Ctl)) : Unit {
        use qs = Qubit[3];
        within {
            H(qs[0]);
        }
        apply {
            // apply operation that needs to be tested
            Controlled testImpl([qs[0]], qs[1..2]);

            // apply adjoint reference operation
            Adjoint Controlled refImpl([qs[0]], qs[1..2]);
        }

        // assert that all qubits end up in |0⟩ state
        AssertAllZero(qs);
    }

    @Test("QuantumSimulator")
    operation T1_PrepareState1 () : Unit {
        AssertEqualOnZeroState(PrepareState1, PrepareState1_Reference);
    }

    @Test("QuantumSimulator")
    operation T2_PrepareState2 () : Unit {
        AssertEqualOnZeroState(PrepareState2, PrepareState2_Reference);
    }

    @Test("QuantumSimulator")
    operation T3_PrepareState3 () : Unit {
        AssertEqualOnZeroState(PrepareState3, PrepareState3_Reference);
    }

    @Test("QuantumSimulator")
    operation T4_PrepareState4 () : Unit {
        AssertEqualOnZeroState(PrepareState4, PrepareState4_Reference);
    }
}