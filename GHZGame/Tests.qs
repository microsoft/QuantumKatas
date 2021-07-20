// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GHZGame {

    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Random;

    // All possible starting bits (r, s and t) that the referee can give
    // to Alice, Bob and Charlie.
    function RefereeBits () : Bool[][] {
        return [[false, false, false],
                [true, true, false],
                [false, true, true],
                [true, false, true]];
    }

    @Test("QuantumSimulator")
    operation T11_WinCondition () : Unit {
        for rst in RefereeBits() {
            for i in 0 .. 1 <<< 3 - 1 {
                let abc = IntAsBoolArray(i, 3);
                EqualityFactB(
                    WinCondition(rst, abc),
                    WinCondition_Reference(rst, abc),
                    $"Win condition is wrong for rst={rst}, abc={abc}");
            }
        }
    }


    // ------------------------------------------------------
    operation GetClassicalStrategySuccessRate (N : Int, strategy : (Bool => Bool)) : Double {
        let inputs = RefereeBits();
        mutable wins = 0;
        for _ in 0 .. N - 1 {
            let rst = inputs[DrawRandomInt(0, Length(inputs) - 1)];
            let abc = PlayClassicalGHZ_Reference(strategy, rst);
            if (WinCondition_Reference(rst, abc)) {
                set wins = wins + 1;
            }
        }
        return IntAsDouble(wins) / IntAsDouble(N);
    }

    @Test("QuantumSimulator")
    operation T12_RandomClassical () : Unit {
        EqualityWithinToleranceFact(GetClassicalStrategySuccessRate(10000, RandomClassicalStrategy), 0.5, 0.02);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T13_BestClassical () : Unit {
        EqualityWithinToleranceFact(GetClassicalStrategySuccessRate(10000, BestClassicalStrategy), 0.75, 0.02);
    }


    // ------------------------------------------------------
    operation TestStrategy (input : Bool, mode : Int) : Bool {
        return mode == 0 ? false | mode == 1 ? true | mode == 2 ? input | not input;
    }

    @Test("QuantumSimulator")
    operation T14_PlayClassicalGHZ () : Unit {
        // To test the interaction, run it on several deterministic strategies (not necessarily good ones)
        let inputs = RefereeBits();
        for rst in inputs {
            for mode in 0 .. 3 {
                let result = PlayClassicalGHZ(TestStrategy(_, mode), rst);
                let expected = PlayClassicalGHZ_Reference(TestStrategy(_, mode), rst);
                AllEqualityFactB(result, expected, $"Unexpected result for rst={rst}");
            }
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Quantum GHZ
    //////////////////////////////////////////////////////////////////

    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => Unit), refImpl : (Qubit[] => Unit is Adj)) : Unit {
        use qs = Qubit[N];
        // apply operation that needs to be tested
        taskImpl(qs);
            
        // apply adjoint reference operation and check that the result is |0ᴺ⟩
        Adjoint refImpl(qs);
            
        // assert that all qubits end up in |0⟩ state
        AssertAllZero(qs);
    }

    @Test("QuantumSimulator")
    operation T21_CreateEntangledTriple () : Unit {
        AssertEqualOnZeroState(3, CreateEntangledTriple, CreateEntangledTriple_Reference);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T22_QuantumStrategy () : Unit {
        for _ in 1 .. 4 {
            // repeat 4 times since we are testing a measurement, it's possible to get
            // correct answer with wrong basis, reduces probability of false positives
            use q = Qubit();
            EqualityFactB(QuantumStrategy(false, q), false, "|0⟩ not measured as false");

            X(q);
            EqualityFactB(QuantumStrategy(false, q), true, "|1⟩ not measured as true");
            Reset(q);

            H(q);
            EqualityFactB(QuantumStrategy(true, q), false, "|+⟩ is not measured as false");
            Reset(q);

            X(q);
            H(q);
            EqualityFactB(QuantumStrategy(true, q), true, "|-⟩ is not measured as true");
            Reset(q);

        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T23_PlayQuantumGHZ () : Unit {
        for _ in 0 .. 1000 {
            let rst = (RefereeBits())[DrawRandomInt(0, Length(RefereeBits()) - 1)];
            let strategies = [QuantumStrategy_Reference(rst[0], _), 
                              QuantumStrategy_Reference(rst[1], _), 
                              QuantumStrategy_Reference(rst[2], _)];
            let abc = PlayQuantumGHZ(strategies);
            EqualityFactB(WinCondition_Reference(rst, abc), true,
                            $"Quantum strategy lost: for rst={rst} the players returned abc={abc}");
        }
    }

}
