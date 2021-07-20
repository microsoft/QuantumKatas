// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MultiQubitGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    @Test("QuantumSimulator")
    operation T1_CompoundGate () : Unit {
        AssertOperationsEqualReferenced(3, CompoundGate, CompoundGate_Reference);
    }


    operation AssertEqualOnZeroState (testImpl : (Qubit[] => Unit), refImpl : (Qubit[] => Unit is Adj)) : Unit {
        use qs = Qubit[2];
        // apply operation that needs to be tested
        testImpl(qs);

        // apply adjoint reference operation
        Adjoint refImpl(qs);

        // assert that all qubits end up in |0⟩ state
        AssertAllZero(qs);
    }

    @Test("QuantumSimulator")
    operation T2_BellState () : Unit {
        AssertEqualOnZeroState(BellState, BellState_Reference);
    }

    @Test("QuantumSimulator")
    operation T3_QubitSwap () : Unit {
        for N in 2 .. 5 {
            for j in 0 .. N-2 {
                for k in j+1 .. N-1 {
                    AssertOperationsEqualReferenced(N, QubitSwap(_, j, k), QubitSwap_Reference(_, j, k));
                }
            }
        }
    }

    @Test("QuantumSimulator")
    operation T4_ControlledRotation () : Unit {
        for i in 0 .. 20 {
            let angle = IntAsDouble(i) / 10.0;
            AssertOperationsEqualReferenced(2, ControlledRotation(_, angle), ControlledRotation_Reference(_,angle));
        }
    }


    operation ArrayControlledOperationWrapper (op : ((Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(Most(qs), Tail(qs));
    }

    @Test("QuantumSimulator")
    operation T5_MultiControls () : Unit {
        for i in 0 .. (2 ^ 4) - 1 {
            let bits = IntAsBoolArray(i, 4);
            AssertOperationsEqualReferenced(5, ArrayControlledOperationWrapper(MultiControls(_, _, bits), _), ArrayControlledOperationWrapper(MultiControls_Reference(_, _, bits), _));
        }
    }
}