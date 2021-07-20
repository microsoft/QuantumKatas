// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.CHSHGame {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Math;


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T11_WinCondition () : Unit {
        for i in 0..1 <<< 4 - 1 {
            let bits = IntAsBoolArray(i, 4);
            EqualityFactB(
                WinCondition(bits[0], bits[1], bits[2], bits[3]),
                (bits[0] and bits[1]) == (bits[2] != bits[3]),
                $"Win condition is wrong for X = {bits[0]}, Y = {bits[1]}, A = {bits[2]}, " +
                $"B = {bits[3]}");
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T12_ClassicalStrategy () : Unit {
        mutable wins = 0;
        for i in 1..1000 {
            let x = DrawRandomInt(0, 1) == 1 ? true | false;
            let y = DrawRandomInt(0, 1) == 1 ? true | false;
            let (a, b) = (AliceClassical(x), BobClassical(y));
            if ((x and y) == (a != b)) {
                set wins = wins + 1;
            }
        }
        Message($"Win rate {IntAsDouble(wins) / 1000.}");

        Fact(wins >= 700, "Alice and Bob's classical strategy is not optimal");
    }


    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => Unit),
                                      refImpl : (Qubit[] => Unit is Adj)) : Unit {
        use qs = Qubit[N];
        // apply operation that needs to be tested
        taskImpl(qs);
            
        // apply adjoint reference operation and check that the result is |0^N⟩
        Adjoint refImpl(qs);
            
        // assert that all qubits end up in |0⟩ state
        AssertAllZero(qs);
    }

    @Test("QuantumSimulator")
    operation T21_CreateEntangledPair () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, CreateEntangledPair, CreateEntangledPair_Reference);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T22_AliceQuantum () : Unit {
        for _ in 1 .. 4 {
            // repeat 4 times since we are testing a measurement and wrong basis still might get
            // the correct answer, reduces probability of false positives
            use q = Qubit();
            EqualityFactB(AliceQuantum(false, q), false, "|0⟩ not measured as false");
            Reset(q);

            // apply the Pauli X gate
            X(q);
            EqualityFactB(AliceQuantum(false, q), true, "|1⟩ not measured as true");
            Reset(q);

            // apply the Hadamard gate
            H(q);
            EqualityFactB(AliceQuantum(true, q), false, "|+⟩ is not measured as false");
            Reset(q);

            // apply the Pauli X and then the Hadamard gate
            X(q);
            H(q);
            EqualityFactB(AliceQuantum(true, q), true, "|-⟩ is not measured as true");
            Reset(q);
        }
    }


    // ------------------------------------------------------
    operation QubitToRegisterOperation (op : (Qubit => Unit), qs : Qubit[]) : Unit {
        op(qs[0]);
    }

    operation QubitToRegisterOperationA (op : (Qubit => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(qs[0]);
    }

    @Test("QuantumSimulator")
    operation T23_RotateBobQubit () : Unit {
        AssertOperationsEqualReferenced(1, QubitToRegisterOperation(RotateBobQubit(true, _), _),
                                        QubitToRegisterOperationA(Ry(-2.0 * PI() / 8.0, _), _));
        AssertOperationsEqualReferenced(1, QubitToRegisterOperation(RotateBobQubit(false, _), _),
                                        QubitToRegisterOperationA(Ry(2.0 * PI() / 8.0, _), _));
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T24_BobQuantum () : Unit {
        for _ in 1 .. 4 {
            // repeat 4 times since we are testing a measurement and wrong basis still might get
            // the correct answer, reduces probability of false positives
            use q = Qubit();
            RotateBobQubit_Reference(false, q);
            EqualityFactB(BobQuantum(false, q), false, "π/8 from |0⟩ not measured as false");
            Reset(q);

            X(q);
            RotateBobQubit_Reference(false, q);
            EqualityFactB(BobQuantum(false, q), true, "π/8 from |1⟩ not measured as true");
            Reset(q);

            RotateBobQubit_Reference(true, q);
            EqualityFactB(BobQuantum(true, q), false, "-π/8 from |0⟩ not measured as false");
            Reset(q);

            X(q);
            RotateBobQubit_Reference(true, q);
            EqualityFactB(BobQuantum(true, q), true, "-π/8 from |1⟩ not measured as true");
            Reset(q);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T25_PlayQuantumCHSH () : Unit {
        mutable wins = 0;
        for i in 1..10000 {
            let x = DrawRandomInt(0, 1) == 1 ? true | false;
            let y = DrawRandomInt(0, 1) == 1 ? true | false;
            let (a, b) = PlayQuantumCHSH(AliceQuantum(x, _), BobQuantum(y, _));
            if ((x and y) == (a != b)) {
                set wins = wins + 1;
            }
        }
        EqualityWithinToleranceFact(IntAsDouble(wins) / 10000., 0.85, 0.01);
    }
}
