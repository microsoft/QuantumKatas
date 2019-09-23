// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.GHZGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The "GHZ Game" quantum kata is a series of exercises designed
    // to get you familiar with the GHZ game.

    // In it three players (Alice, Bob and Charlie) try to win the
    // following game:

    // Each of them is given a bit (r, s and t respectively), and
    // they have to return new bits (a, b and c respectively) so
    // that  r ∨ s ∨ t = a ⊕ b ⊕ c. The input bits will have 
    // zero or two bits set to true and three or one bits set to false.
    // The trick is, the players can not communicate during the game.

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
    //     1) Alice, Bob and Charlie's input bits (r, s and t), stored as an array of length 3,
    //     2) Alice, Bob and Charlie's output bits (a, b and c), stored as an array of length 3.
    // The input bits will have zero or two bits set to true.
    // Output:
    //     True if Alice, Bob and Charlie won the GHZ game, that is, if r ∨ s ∨ t = a ⊕ b ⊕ c,
    //     and false otherwise.
    function WinCondition (rst : Bool[], abc : Bool[]) : Bool {
        // ...
        fail "Task 1.1 not implemented yet";
    }


    // Task 1.2. Random classical strategy
    // Input: The input bit for one of the players (r, s or t).
    // Output: A random bit that this player will output (a, b or c).
    // If all players use this strategy, they will win about 50% of the time.
    operation RandomClassicalStrategy (input : Bool) : Bool {
        // ...
        fail "Task 1.2 not implemented yet";
    }


    // Task 1.3. Best classical strategy
    // Input: The input bit for one of the players (r, s or t).
    // Output: A bit that this player will output (a, b or c) to maximize their chance of winning. 
    // All players will use the same strategy.
    // The best classical strategy should win about 75% of the time.
    operation BestClassicalStrategy (input : Bool) : Bool {
        // ...
        fail "Task 1.3 not implemented yet";
    }


    // Task 1.4. Referee classical GHZ game
    // Inputs:
    //      1) an operation which implements a classical strategy 
    //         (i.e., takes an input bit and produces and output bit),
    //      2) an array of 3 input bits that should be passed to the players.
    // Output:
    //      An array of 3 bits that will be produced if each player uses this strategy.
    operation PlayClassicalGHZ (strategy : (Bool => Bool), inputs : Bool[]) : Bool[] {
        // ...
        fail "Task 1.4 not implemented yet";
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
        fail "Task 2.1 not implemented yet";
    }


    // Task 2.2. Quantum strategy
    // Inputs:
    //     1) The input bit for one of the players (r, s or t),
    //     2) That player's qubit of the entangled triple shared between the players.
    // Goal:  Measure the qubit in the Z basis if the bit is 0 (false),
    //        or the X basis if the bit is 1 (true), and return the result.
    // The state of the qubit after the operation does not matter.
    operation QuantumStrategy (input : Bool, qubit : Qubit) : Bool {
        // ...
        fail "Task 2.2 not implemented yet";
    }


    // Task 2.3. Play the GHZ game using the quantum strategy
    // Input: Operations that return Alice, Bob and Charlie's output bits (a, b and c) based on
    //        their quantum strategies and given their respective qubits from the entangled triple. 
    //        The players have already been told what their starting bits (r, s and t) are.
    // Goal:  Return an array of players' output bits (a, b and c).
    operation PlayQuantumGHZ (strategies : (Qubit => Bool)[]) : Bool[] {
        // ...
        fail "Task 2.3 not implemented yet";
    }
}
