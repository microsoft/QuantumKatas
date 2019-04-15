// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.GHZGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Diagnostics;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The "GHZ Game" quantum kata is a series of exercises designed
    // to get you familiar with the GHZ game.

    // In it three players (Alice, Bob and Charlie) try to win the
    // following game:

    // Each of them is given a bit (r, s and t respectively), and
    // they have to return new bits (a, b and c respectively) so
    // that  r ∨ s ∨ t = a ⊕ b ⊕ c. The trick is, they cannot
    // communicate during the game.

    // Each task is wrapped in one operation preceded by the
    // description of the task. Each task has a unit test associated
    // with it, which initially fails. Your goal is to fill in the
    // blank (marked with // ... comment) with some Q# code to make
    // the failing test pass.


    //////////////////////////////////////////////////////////////////
    // Part I. Classical GHZ
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Win condition
    // Input:
    //     1) Alice, Bob and Charlie's starting bits (r, s and t),
    //     2) Alice, Bob and Charlie's output bits (a, b and c).
    // Output:
    //     True if Alice, Bob and Charlie won the GHZ game, that is, if
    //     r ∨ s ∨ t = a ⊕ b ⊕ c, and false otherwise.
    function WinCondition (r : Bool, s : Bool, t : Bool, a : Bool, b : Bool, c : Bool) : Bool {
        // ...
        return false;
    }

    // Implement a strategy which randomly chooses outputs.
    operation ClassicalRandomStrategy(input : Bool) : Bool {
        // Stub code -- change to your implementation.
        return false;
    }

    // Implement a strategy which wins 75% of the time and
    // does not use quantum logic.
    operation ClassicalOptimalStrategy(input : Bool) : Bool {
        // Stub code -- change to your implementation.
        return false;
    }

    operation PlayClassicalGHZ(strategy : (Bool => Bool), inputs : Bool[]) : Bool[] {
        mutable results = new Bool[Length(inputs)];
        for (i in 0..Length(inputs) - 1) {
            set results[i] = strategy(inputs[i]);
        }
        return results;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum GHZ
    //////////////////////////////////////////////////////////////////

    // Given qubits in the state |000> in big-endian format, prepare the state:
    // (1/2)(|000> - |110> - |101> - |011>)
    // This is sometimes known as the GHZ state.
    operation PrepareEntangledSuperPosition(qs : Qubit[]) : Unit {
        // Your code here
    }

    // You are Alice.
    // You have one of three qubits which form the superposition (1/2)(|000> - |110> - |101> - |011>).
    // You know that the other two players will do the same strategy as you.
    // What will you do to ensure a victory in this game?
    // That is to say, assuming the other players do the same strategy as you,
    // Answer correctly such that you have a XOR b XOR c == r OR s OR t
    operation QuantumStrategy(input : Bool, qMe : Qubit) : Bool {
        // Your code here
        return false;
    }

    // This method is here to show how the game is run. You should not modify it, though
    // if you have ideas for new ways to solve the game, just keep in mind that Alice,
    // Bob, and Charlie should never communicate during the game.
    operation PlayQuantumGHZ(input : Bool[]) : Bool[] {
        mutable res = new Bool[3];
        using (qs = Qubit[3]) {
            PrepareEntangledSuperPosition(qs);

            set res[0] = QuantumStrategy(input[0], qs[0]);
            set res[1] = QuantumStrategy(input[1], qs[1]);
            set res[2] = QuantumStrategy(input[2], qs[2]);

            ResetAll(qs);
        }

        return res;
    }

}
