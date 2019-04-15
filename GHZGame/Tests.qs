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

    // These are the possible inputs by the referee in the GHZ game.
    function GeneratePossibleInputs() : Bool[][] {
        mutable res = new Bool[][4];
        set res[0] = [false, false, false];
        set res[1] = [true, true, false];
        set res[2] = [false, true, true];
        set res[3] = [true, false, true];
        return res;
    }

    // Performs the verification step of the game. Returns true iff
    // the solution satisfied the constraints.
    function VerifyResult(input : Bool[], result : Bool[]) : Bool {
        if (Length(input) != 3 or Length(result) != 3) {
            return false;
        }

        return XOR(XOR(result[0], result[1]), result[2]) == (input[0] or input[1] or input[2]);
    }

    operation ClassicalRandomDataTest() : Unit {
        mutable wins = 0;
        let possible = GeneratePossibleInputs();
        for (i in 0..10000) {
            let selected = RandomInt(4);
            let input = possible[selected];
            let res = PlayClassicalGHZ(ClassicalRandomStrategy, input);
            if (VerifyResult(input, res)) {
                set wins = wins + 1;
            }
        }
        let rate = ToDouble(wins) / 10000.0;
        AssertAlmostEqualTol(rate, 0.5, 0.02);
        Message($"Classical Random: {rate}");
    }


    // ------------------------------------------------------
    operation ClassicalOptimalTest() : Unit {
        let inputs = GeneratePossibleInputs();
        mutable wins = 0;
        for (i in 0..10000) {
            let input = inputs[RandomInt(Length(inputs))];
            let res = PlayClassicalGHZ(ClassicalOptimalStrategy, input);
            if (VerifyResult(input, res)) {
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

    operation StatePreparationTest() : Unit {
        AssertEqualOnZeroState(3, PrepareEntangledSuperPosition, PrepareEntangledSuperPosition_Reference);
    }


    // ------------------------------------------------------
    operation QuantumWinsAllTest() : Unit {
        let inputs = GeneratePossibleInputs();

        // Run many times, since a wrong strategy could nondeterministically win.
        for (i in 0..10000) {
            let input = inputs[RandomInt(Length(inputs))];
            let res = PlayQuantumGHZ(input);
            if (not VerifyResult(input, res)) {
                Message($"input was {input}");
                Message($"output was {res}");
                Message($"iteration was {i}");
                fail "Alice and bob lost.";
            }
        }
        Message($"Quantum Optimal: 1");
    }

}
