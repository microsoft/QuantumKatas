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

    operation ArrayWrapperOperation (op : (Qubit => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(qs[0]);
    }

    // Exercise 1.
    operation T1_ApplyY_Test () : Unit {
        AssertOperationsEqualReferenced(1, ArrayWrapperOperation(ApplyY, _), ArrayWrapperOperation(Y, _));
    }

    // Exercise 2.
    operation T2_ApplyZ_Test () : Unit {
        AssertOperationsEqualReferenced(1, ArrayWrapperOperation(ApplyZ, _), ArrayWrapperOperation(Z, _));
    }

    // Exercise 3.
    operation T3_ZeroFlip_Test () : Unit {
        AssertOperationsEqualReferenced(2, ControlledArrayWrapperOperation(ZeroFlip, _), ControlledArrayWrapperOperation(ZeroFlip_Reference, _));
    }

    // Exercise 4.
    operation T4_PrepareMinus_Test () : Unit {
        AssertOperationsEqualReferenced(1, ArrayWrapperOperation(PrepareMinus, _), ArrayWrapperOperation(PrepareMinus_Reference, _));
    }

    // Exercise 5.
    operation T5_ThreePiPhase_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(ThreePiPhase, _), ArrayWrapperOperation(ThreePiPhase_Reference, _));
    }

    operation T6_RotatedState_Test () : Unit {
        for (i in 0 .. 10) {
            AssertOperationsEqualReferenced(1, ArrayWrapperOperation(RotatedState(Cos(IntAsDouble(i)), Sin(IntAsDouble(i)), _), _), ArrayWrapperOperation(RotatedState_Reference(Cos(IntAsDouble(i)), Sin(IntAsDouble(i)), _), _));
        }
    }

    // Exercise 7.
    operation T7_ArbitraryState_Test () : Unit {
        for (i in 0 .. 10) {
            for (j in 0 .. 10) {
                AssertOperationsEqualReferenced(1, ArrayWrapperOperation(ArbitraryState(Cos(IntAsDouble(i)), Sin(IntAsDouble(i)), IntAsDouble(j), _), _), ArrayWrapperOperation(ArbitraryState_Reference(Cos(IntAsDouble(i)), Sin(IntAsDouble(i)), IntAsDouble(j), _), _));
            }
        }
    }
}