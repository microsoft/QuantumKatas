// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.WGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Logical;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The "W Game" is an original quantum "kata" similar to the GHZ game
    // and the CHSH game, but oriented to the properties of the W state.

    // In it three players (Alice, Bob and Charlie) try to win the
    // following game:

    // Each of them is given a bit (r, s and t respectively), and
    // they have to return new bits (a, b and c respectively) according
    // to the following table:

    // +-------------------+------------------+
    // |  Number of true   |  Number of true  |
    // |  bits in input    |  bits in output  |
    // |  between players  |  needed to win   |
    // +-------------------+------------------+
    // |         0         |     exactly 1    |
    // |         1         |    0, 1, or 2    |
    // |         2         |    0, 2, or 3    |
    // +-------------------+------------------+
    
    // All that is given is that at least one of the input bits is set
    // to false, leaving seven scenarios that are all equally likely:

    //  F,F,F    T,F,F    F,T,F    F,F,T    T,T,F    T,F,T    F,T,T

    // Like the GHZ and CHSH games, the players can not communicate during the game.

    // Each task is wrapped in one operation preceded by the
    // description of the task. Each task has a unit test associated
    // with it, which initially fails. Your goal is to fill in the
    // blank (marked with // ... comment) with some Q# code to make
    // the failing test pass.


    //////////////////////////////////////////////////////////////////
    // Part I. Classical W game
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Win condition
    // Input:
    //     1) Alice, Bob and Charlie's input bits (r, s and t), stored as an array of length 3,
    //     2) Alice, Bob and Charlie's output bits (a, b and c), stored as an array of length 3.
    // The input bits will have zero, one, or two bits set to true.
    // Output:
    //     True if Alice, Bob and Charlie won the W game (see above table),
    //     and false otherwise.
    function WinCondition (rst : Bool[], abc : Bool[]) : Bool {
        // ...
        fail "Task 1.1 not implemented yet";
    }


    // Task 1.2. Random classical strategy
    // Input: The input bit for one of the players (r, s or t).
    // Output: A random bit that this player will output (a, b or c).
    // If all players use this strategy, their win odds will be:
    //    (1/7 x 1/8) (zero input bits true)
    //  + (3/7 x 7/8) ( one input bit  true)
    //  + (3/7 x 5/8) ( two input bits true)  =  37/56, or about 66.1% of the time.
    operation RandomClassicalStrategy (input : Bool) : Bool {
        // ...
        fail "Task 1.2 not implemented yet";
    }


    // Task 1.3. Simple classical strategy
    // Input: The input bit for one of the players (r, s or t).
    // Output: A bit that this player will output (a, b or c) for a good chance of winning. 
    // All players will use the same strategy.
    // Any of several possible naive classical strategies that win 6/7 of the time (85.7%).
    operation SimpleClassicalStrategy (input : Bool) : Bool {
        // ...
        fail "Task 1.3 not implemented yet";
    }


    // "Bonus" Task 1.4. Best classical strategy
    // Input: The input bit for one of the players (r, s or t).
    // Output: A bit that this player will output (a, b or c) to maximize their chance of winning. 
    // All players will use the same strategy.
    // The optimal classical strategy should win just under 90% of the time.

    // NOTE:  Calculus, advanced probability theory, and heavy-duty number crunching
    //        may come into play here!
    // Those who are here for the quantum content, I advise proceeding past this, to 1.5.
    operation BestClassicalStrategy (input : Bool) : Bool {
        // ...
        fail "Task 1.4 not implemented yet";
    }


    // Task 1.5. Referee classical W game
    // Inputs:
    //      1) an operation which implements a classical strategy 
    //         (i.e., takes an input bit and produces and output bit),
    //      2) an array of 3 input bits that should be passed to the players.
    // Output:
    //      An array of 3 bits that will be produced if each player uses this strategy.
    operation PlayClassicalW (strategy : (Bool => Bool), inputs : Bool[]) : Bool[] {
        // ...
        fail "Task 1.5 not implemented yet";
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum W game
    //////////////////////////////////////////////////////////////////

    // In the quantum version of the game, the players still can not
    // communicate during the game, but they are allowed to share 
    // qubits from an entangled triple before the start of the game.

    // Task 2.1. Entangled triple
    // Input: An array of three qubits in the |000⟩ state.
    // Goal: Create the entangled state |W⟩ = (|001⟩ + |010⟩ + |100⟩) / sqrt(3) on these qubits.
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


    // Task 2.3. Play the W game using the quantum strategy
    // Input: Operations that return Alice, Bob and Charlie's output bits (a, b and c) based on
    //        their quantum strategies and given their respective qubits from the entangled triple. 
    //        The players have already been told what their starting bits (r, s and t) are.
    // Goal:  Return an array of players' output bits (a, b and c).
    operation PlayQuantumW (strategies : (Qubit => Bool)[]) : Bool[] {
        // ...
        fail "Task 2.3 not implemented yet";
    }
}
