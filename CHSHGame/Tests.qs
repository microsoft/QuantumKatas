// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.CHSHGame {

    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;

    operation T1_WonCHSHGame_Test () : Unit {
        for (i in 0..1 <<< 4 - 1) {
            let bits = BoolArrFromPositiveInt(i, 4);
            AssertBoolEqual(
                WonCHSHGame(bits[0], bits[1], bits[2], bits[3]),
                (bits[0] and bits[1]) == (bits[2] != bits[3]),
                $"Win condition is wrong for X = {bits[0]}, Y = {bits[1]}, A = {bits[2]}, " +
                $"B = {bits[3]}");
        }
    }

    operation T2_T3_Classical_Test () : Unit {
        for (i in 0..1 <<< 2 - 1) {
            let bits = BoolArrFromPositiveInt(i, 2);
            AssertBoolEqual(AliceClassical(bits[0]), BobClassical(bits[1]),
                            "Alice and Bob's classical strategy is not optimal");
        }
    }

    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => Unit),
                                      refImpl : (Qubit[] => Unit : Adjoint)) : Unit {
        using (qs = Qubit[N]) {
            // apply operation that needs to be tested
            taskImpl(qs);
            
            // apply adjoint reference operation and check that the result is |0^N⟩
            Adjoint refImpl(qs);
            
            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }

    operation T4_CreateEntangledPair_Test () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, CreateEntangledPair, CreateEntangledPair_Reference);
    }

    operation T5_AliceQuantum_Test () : Unit {
        using (q = Qubit()) {
            AssertBoolEqual(AliceQuantum(false, q), false, "|0> not measured as false");
            AssertQubit(Zero, q);

            X(q);
            AssertBoolEqual(AliceQuantum(false, q), true, "|1> not measured as true");
            AssertQubit(One, q);

            H(q);
            AssertBoolEqual(AliceQuantum(true, q), true, "|-> is not measured as true");
            H(q);
            AssertQubit(One, q);

            X(q);
            H(q);
            AssertBoolEqual(AliceQuantum(true, q), false, "|+> is not measured as false");
            H(q);
            AssertQubit(Zero, q);
        }
    }

    operation QubitToRegisterOperation (op : (Qubit => Unit), qs : Qubit[]) : Unit {
        op(qs[0]);
    }

    operation QubitToRegisterOperationA (op : (Qubit => Unit : Adjoint), qs : Qubit[]) : Unit {
        body (...) {
            op(qs[0]);
        }
        adjoint auto;
    }

    operation T6_RotateBobQubit_Test () : Unit {
        AssertOperationsEqualReferenced(QubitToRegisterOperation(RotateBobQubit(true, _), _),
                                        QubitToRegisterOperationA(Ry(-2.0 * PI() / 8.0, _), _), 1);
        AssertOperationsEqualReferenced(QubitToRegisterOperation(RotateBobQubit(false, _), _),
                                        QubitToRegisterOperationA(Ry(2.0 * PI() / 8.0, _), _), 1);
    }

    operation T7_BobQuantum_Test () : Unit {
        using (q = Qubit()) {
            RotateBobQubit_Reference(false, q);
            AssertBoolEqual(BobQuantum(false, q), false, "π/8 from |0> not measured as false");
            AssertQubit(Zero, q);

            X(q);
            RotateBobQubit_Reference(false, q);
            AssertBoolEqual(BobQuantum(false, q), true, "π/8 from |1> not measured as true");
            AssertQubit(One, q);

            RotateBobQubit_Reference(true, q);
            AssertBoolEqual(BobQuantum(true, q), true, "-π/8 from |1> not measured as true");
            AssertQubit(One, q);

            X(q);
            RotateBobQubit_Reference(true, q);
            AssertBoolEqual(BobQuantum(true, q), false, "-π/8 from |0> not measured as false");
            AssertQubit(Zero, q);
        }
    }

    operation T8_PlayQuantumCHSH_Test () : Unit {
        mutable wins = 0;
        for (i in 1..10000) {
            let x = RandomInt(2) == 1 ? true | false;
            let y = RandomInt(2) == 1 ? true | false;
            let (a, b) = PlayQuantumCHSH(AliceQuantum(x, _), BobQuantum(y, _));
            if ((x and y) == (a != b)) {
                set wins = wins + 1;
            }
        }
        AssertAlmostEqualTol(ToDouble(wins) / 10000., 0.85, 0.01);
    }

}
