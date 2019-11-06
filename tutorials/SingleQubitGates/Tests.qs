// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SingleQubitGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    
    // The tests are written to test controlled versions of operations instead of plain ones.
    // This is done to verify that the tasks don't add a global phase to the implementations.
    // Global phase is not relevant physically, but it can be very confusing for a beginner to consider R1 vs Rz,
    // so the tests use controlled version of the operations which converts the global phase into a relative phase
    // and makes it possible to detect.

    // ------------------------------------------------------
    // Helper wrapper to represent controlled variant of operation on one qubit 
    // as an operation on an array of two qubits
    operation ControlledArrayWrapperOperation (op : (Qubit => Unit is Adj+Ctl), qs : Qubit[]) : Unit is Adj+Ctl {
        Controlled op([qs[0]], qs[1]);
    }


    // ------------------------------------------------------
    operation AssertEqualOnZeroState (testImpl : (Qubit => Unit is Ctl), refImpl : (Qubit => Unit is Adj+Ctl)) : Unit {
        using (qs = Qubit[2]) {
            within {
                H(qs[0]);
            }
            apply {
                // apply operation that needs to be tested
                Controlled testImpl([qs[0]], qs[1]);

                // apply adjoint reference operation
                Adjoint Controlled refImpl([qs[0]], qs[1]);
            }

            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }

    // Exercise 1.
    operation T1_ApplyY_Test () : Unit {
        AssertOperationsEqualReferenced(2, ControlledArrayWrapperOperation(ApplyY, _), ControlledArrayWrapperOperation(Y, _));
    }

    // Exercise 2.
    operation T2_GlobalPhaseI_Test () : Unit {
        AssertOperationsEqualReferenced(2, ControlledArrayWrapperOperation(GlobalPhaseI, _), ControlledArrayWrapperOperation(GlobalPhaseI_Reference, _));
    }

    // Exercise 3.
    operation T3_SignFlipOnZero_Test () : Unit {
        AssertOperationsEqualReferenced(2, ControlledArrayWrapperOperation(SignFlipOnZero, _), ControlledArrayWrapperOperation(SignFlipOnZero_Reference, _));
    }

    // Exercise 4.
    operation T4_PrepareMinus_Test () : Unit {
        AssertEqualOnZeroState(PrepareMinus, PrepareMinus_Reference);
    }

    // Exercise 5.
    operation T5_ThreeQuatersPiPhase_Test () : Unit {
        AssertOperationsEqualReferenced(2, ControlledArrayWrapperOperation(ThreeQuatersPiPhase, _), ControlledArrayWrapperOperation(ThreeQuatersPiPhase_Reference, _));
    }

    // Exercise 6.
    operation T6_PrepareRotatedState_Test () : Unit {
        for (i in 0 .. 10) {
            AssertEqualOnZeroState(PrepareRotatedState(Cos(IntAsDouble(i)), Sin(IntAsDouble(i)), _),  
                                   PrepareRotatedState_Reference(Cos(IntAsDouble(i)), Sin(IntAsDouble(i)), _));
        }
    }

    // Exercise 7.
    operation T7_PrepareArbitraryState_Test () : Unit {
        for (i in 0 .. 10) {
            for (j in 0 .. 10) {
                AssertEqualOnZeroState(PrepareArbitraryState(Cos(IntAsDouble(i)), Sin(IntAsDouble(i)), IntAsDouble(j), _), 
                                       PrepareArbitraryState_Reference(Cos(IntAsDouble(i)), Sin(IntAsDouble(i)), IntAsDouble(j), _));
            }
        }
    }
}