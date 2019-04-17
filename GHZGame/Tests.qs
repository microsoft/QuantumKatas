// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GHZGame {

    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    open Microsoft.Quantum.Extensions.Diagnostics;

    // All possible starting bits (r, s and t) that the referee can give
    // to Alice, Bob and Charlie.
    function RefereeBits () : (Bool, Bool, Bool)[] {
        return [(false, false, false),
                (true, true, false),
                (false, true, true),
                (true, false, true)];
    }

    operation T11_WinCondition_Test () : Unit {
        for ((r, s, t) in RefereeBits()) {
            for (i in 0..1 <<< 3 - 1) {
                let abc = BoolArrFromPositiveInt(i, 3);
                AssertBoolEqual(
                    WinCondition(r, s, t, abc[0], abc[1], abc[2]),
                    WinCondition_Reference(r, s, t, abc[0], abc[1], abc[2]),
                    $"Win condition is wrong for r={r}, s={s}, t={t}, a={abc[0]}, b={abc[1]}, " +
                    $"c={abc[2]}");
            }
        }
    }


    // ------------------------------------------------------
    operation GetClassicalStrategySuccessRate (N : Int, strategy : (Bool => Bool)) : Double {
        let inputs = RefereeBits();
        mutable wins = 0;
        for (i in 0..N - 1) {
            let (r, s, t) = inputs[RandomInt(Length(inputs))];
            let res = PlayClassicalGHZ_Reference(BestClassicalStrategy, [r, s, t]);
            if (WinCondition_Reference(r, s, t, res[0], res[1], res[2])) {
                set wins = wins + 1;
            }
        }
        return ToDouble(wins) / ToDouble(wins);
    }

    operation T12_RandomClassical_Test () : Unit {
        AssertAlmostEqualTol(GetClassicalStrategySuccessRate(10000, RandomClassicalStrategy), 0.5, 0.02);
    }


    // ------------------------------------------------------
    operation T13_BestClassical_Test () : Unit {
        AssertAlmostEqualTol(GetClassicalStrategySuccessRate(10000, BestClassicalStrategy), 0.75, 0.02);
    }


    // ------------------------------------------------------
    operation TestStrategy (input : Bool, mode : Int) : Bool {
        return mode == 0 ? false | mode == 1 ? true | mode == 2 ? input | not input;
    }


    operation T14_PlayClassicalGHZ_Test () : Unit {
        // To test the interaction, run it on several deterministic strategies (not necessarily good ones)
        let inputs = RefereeBits();
        for ((r, s, t) in inputs) {
            for (mode in 0..3) {
                let result = PlayClassicalGHZ(TestStrategy(_, mode), [r, s, t]);
                let expected = PlayClassicalGHZ_Reference(TestStrategy(_, mode), [r, s, t]);
                AssertBoolArrayEqual(result, expected, $"Unexpected result for r={r}, s={s}, t={t}");
            }
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Quantum GHZ
    //////////////////////////////////////////////////////////////////

    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => Unit), refImpl : (Qubit[] => Unit : Adjoint)) : Unit {
        using (qs = Qubit[N]) {
            // apply operation that needs to be tested
            taskImpl(qs);
            
            // apply adjoint reference operation and check that the result is |0ᴺ⟩
            Adjoint refImpl(qs);
            
            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }

    operation T21_CreateEntangledTriple_Test () : Unit {
        AssertEqualOnZeroState(3, CreateEntangledTriple, CreateEntangledTriple_Reference);
    }


    // ------------------------------------------------------
    operation T22_QuantumStrategy_Test () : Unit {
        using (q = Qubit()) {
            AssertBoolEqual(QuantumStrategy(false, q), false, "|0⟩ not measured as false");
            Reset(q);

            X(q);
            AssertBoolEqual(QuantumStrategy(false, q), true, "|1⟩ not measured as true");
            Reset(q);

            H(q);
            AssertBoolEqual(QuantumStrategy(true, q), false, "|+⟩ is not measured as false");
            Reset(q);

            X(q);
            H(q);
            AssertBoolEqual(QuantumStrategy(true, q), true, "|-⟩ is not measured as true");
            Reset(q);
        }
    }


    // ------------------------------------------------------
    operation T23_PlayQuantumGHZ_Test () : Unit {
        for (i in 0..1000) {
            let (r, s, t) = (RefereeBits())[RandomInt(Length(RefereeBits()))];
            let (a, b, c) = PlayQuantumGHZ(QuantumStrategy(r, _),
                                           QuantumStrategy(s, _),
                                           QuantumStrategy(t, _));
            AssertBoolEqual(WinCondition_Reference(r, s, t, a, b, c),
                            true,
                            $"Quantum strategy lost with r={r}, s={s}, t={t}, a={a}, b={b}, c={c}");
        }
    }

}
