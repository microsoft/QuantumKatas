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
        using (qs = Qubit[3]) {
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
    }

    operation T1_PrepareState1_Test () : Unit {
        AssertEqualOnZeroState(PrepareState1, PrepareState1_Reference);
    }

    operation T2_PrepareState2_Test () : Unit {
        AssertEqualOnZeroState(PrepareState2, PrepareState2_Reference);
    }

    operation T3_PrepareState3_Test () : Unit {
        AssertEqualOnZeroState(PrepareState3, PrepareState3_Reference);
    }

    operation T4_PrepareState4_Test () : Unit {
        AssertEqualOnZeroState(PrepareState4, PrepareState4_Reference);
    }
}