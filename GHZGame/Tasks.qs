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
    //     1) Alice, Bob and Charlie's input bits (r, s and t),
    //     2) Alice, Bob and Charlie's output bits (a, b and c).
    // Output:
    //     True if Alice, Bob and Charlie won the GHZ game, that is, if r ∨ s ∨ t = a ⊕ b ⊕ c, and
    //     false otherwise.
    function WinCondition (r : Bool, s : Bool, t : Bool, a : Bool, b : Bool, c : Bool) : Bool {
        // ...
        return false;
    }

    // Task 1.2. Random classical strategy
    // Input: One of the input bits for Alice, Bob or Charlie (r, s or t).
    // Output:
    //     A random bit that Alice, Bob or Charlie will output (a, b or c). All players will use the
    //     same strategy.
    // This strategy will win about 50% of the time.
    operation RandomClassicalStrategy (input : Bool) : Bool {
        // ...
        return false;
    }

    // Task 1.3. Best classical strategy
    // Input: One of the input bits for Alice, Bob or Charlie (r, s or t).
    // Output:
    //     A bit that Alice, Bob or Charlie will output (a, b or c) which will maximize their chance
    //     of winning. All players will use the same strategy.
    // The best classical strategy should win about 75% of the time.
    operation BestClassicalStrategy (input : Bool) : Bool {
        // ...
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

    // In the quantum version of the game, the players still can not
    // communicate during the game, but they are allowed to share 
    // qubits from an entangled triple before the start of the game.

    // Task 2.1. Entangled triple
    // Input: An array of three qubits in the |000⟩ state.
    // Goal: Create the entangled state |ψ⟩ = (|000⟩ - |011⟩ - |101⟩ - |110⟩) / 2 on these qubits.
    operation CreateEntangledTriple (qs : Qubit[]) : Unit {
        // ...
    }

    // Task 2.2. Quantum strategy
    // Inputs:
    //     1) One of the input bits for Alice, Bob or Charlie (r, s or t),
    //     2) The entangled qubit for the player whose input bit you were given.
    // Goal:
    //     Use the entangled qubit to decide which bit to output to maximize the players' chance of
    //     winning. All players will use the same strategy.
    // The best quantum strategy can win every time.
    operation QuantumStrategy (input : Bool, qubit : Qubit) : Bool {
        // ...
        return false;
    }

    // This method is here to show how the game is run. You should not modify it, though
    // if you have ideas for new ways to solve the game, just keep in mind that Alice,
    // Bob, and Charlie should never communicate during the game.
    operation PlayQuantumGHZ(input : Bool[]) : Bool[] {
        mutable res = new Bool[3];
        using (qs = Qubit[3]) {
            CreateEntangledTriple(qs);

            set res[0] = QuantumStrategy(input[0], qs[0]);
            set res[1] = QuantumStrategy(input[1], qs[1]);
            set res[2] = QuantumStrategy(input[2], qs[2]);

            ResetAll(qs);
        }

        return res;
    }

}
