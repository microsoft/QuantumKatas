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
                    $"Win condition is wrong for r = {r}, s = {s}, t = {t}, a = {abc[0]}, " +
                    $"b = {abc[1]}, c = {abc[2]}");
            }
        }
    }


    // ------------------------------------------------------
    operation T12_RandomClassical_Test () : Unit {
        mutable wins = 0;
        for (i in 0..10000) {
            let selected = RandomInt(4);
            let (r, s, t) = (RefereeBits())[selected];
            let res = PlayClassicalGHZ(RandomClassicalStrategy, [r, s, t]);
            if (WinCondition_Reference(r, s, t, res[0], res[1], res[2])) {
                set wins = wins + 1;
            }
        }
        let rate = ToDouble(wins) / 10000.0;
        AssertAlmostEqualTol(rate, 0.5, 0.02);
        Message($"Classical Random: {rate}");
    }


    // ------------------------------------------------------
    operation T13_BestClassical_Test () : Unit {
        let inputs = RefereeBits();
        mutable wins = 0;
        for (i in 0..10000) {
            let (r, s, t) = inputs[RandomInt(Length(inputs))];
            let res = PlayClassicalGHZ(BestClassicalStrategy, [r, s, t]);
            if (WinCondition_Reference(r, s, t, res[0], res[1], res[2])) {
                    set wins = wins + 1;
            }
        }
        let rate = ToDouble(wins) / 10000.0;
        AssertAlmostEqualTol(rate, 0.75, 0.02);
        Message($"Classical Optimal: {rate}");
    }


    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => Unit), refImpl : (Qubit[] => Unit : Adjoint)) : Unit {
        using (qs = Qubit[N]) {
            // apply operation that needs to be tested
            taskImpl(qs);
            
            // apply adjoint reference operation and check that the result is |0^N⟩
            Adjoint refImpl(qs);
            
            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }

    operation T21_CreateEntangledTriple_Test () : Unit {
        AssertEqualOnZeroState(3, CreateEntangledTriple, CreateEntangledTriple_Reference);
    }


    // ------------------------------------------------------
    operation QuantumWinsAllTest() : Unit {
        let inputs = RefereeBits();

        // Run many times, since a wrong strategy could nondeterministically win.
        for (i in 0..10000) {
            let (r, s, t) = inputs[RandomInt(Length(inputs))];
            let res = PlayQuantumGHZ([r, s, t]);
            if (not WinCondition_Reference(r, s, t, res[0], res[1], res[2])) {
                Message($"input was ({r}, {s}, {t})");
                Message($"output was {res}");
                Message($"iteration was {i}");
                fail "Alice and bob lost.";
            }
        }
        Message($"Quantum Optimal: 1");
    }

}
