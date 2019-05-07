// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.CHSHGame {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;


    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The "CHSH Game" quantum kata is a series of exercises designed
    // to get you familiar with the CHSH game.
    // In it two players (Alice and Bob) try to win the following game: 
    // each of them is given a bit (Alice gets X and Bob gets Y), and
    // they have to return new bits (Alice returns A and Bob returns B)
    // so that X ∧ Y = A ⊕ B. The trick is, they can not communicate during the game.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task has a unit test associated with it, which initially fails. 
    // Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.


    //////////////////////////////////////////////////////////////////
    // Part I. Classical CHSH
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Win condition
    // Input:
    //     1) Alice and Bob's starting bits (X and Y),
    //     2) Alice and Bob's output bits (A and B).
    // Output:
    //     True if Alice and Bob won the CHSH game, that is, if X ∧ Y = A ⊕ B,
    //     and false otherwise.
    function WinCondition (x : Bool, y : Bool, a : Bool, b : Bool) : Bool {
        // ...
        fail "Task 1.1 not implemented yet";
    }


    // Task 1.2. Alice and Bob's classical strategy
    // In this task you have to implement two functions, one for Alice's classical strategy and one for Bob's.
    // Note that they are covered by one test, so you have to implement both before attemping the test.

    // Input: Alice's starting bit (X).
    // Output: The bit that Alice should output (A) to maximize their chance of winning.
    operation AliceClassical (x : Bool) : Bool {
        // ...
        fail "Alice's strategy in task 1.2 not implemented yet";
    }

    // Input: Bob's starting bit (Y).
    // Output: The bit that Bob should output (B) to maximize their chance of winning.
    operation BobClassical (y : Bool) : Bool {
        // ...
        fail "Bob's strategy in task 1.2 not implemented yet";
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum CHSH
    //////////////////////////////////////////////////////////////////

    // In the quantum version of the game, the players still can not
    // communicate during the game, but they are allowed to share 
    // qubits from a Bell pair before the start of the game.

    // Task 2.1. Entangled pair
    // Input: An array of two qubits in the |00⟩ state.
    // Goal:  Create a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    operation CreateEntangledPair (qs : Qubit[]) : Unit {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        EqualityFactI(Length(qs), 2, "The array should have exactly 2 qubits.");

        // ...
        fail "Task 2.1 not implemented yet";
    }


    // Task 2.2. Alice's quantum strategy
    // Inputs:
    //      1) Alice's starting bit (X), 
    //      2) Alice's half of Bell pair they share with Bob.
    // Goal:  Measure Alice's qubit in the Z basis if her bit is 0 (false), 
    //        or the X basis if her bit is 1 (true), and return the result.
    // The state of the qubit after the operation does not matter.
    operation AliceQuantum (bit : Bool, qubit : Qubit) : Bool {
        // ...
        fail "Task 2.2 not implemented yet";
    }


    // Task 2.3. Rotate Bob's qubit
    // Inputs:
    //      1) The direction to rotate: true for clockwise, false for counterclockwise,
    //      2) Bob's qubit.
    // Goal:  Rotate the qubit π/8 radians around the Y axis in the given direction.
    operation RotateBobQubit (clockwise : Bool, qubit : Qubit) : Unit {
        // Hint: Ry operation applies a rotation by a given angle in counterclockwise direction.
        // ...
        fail "Task 2.3 not implemented yet";
    }


    // Task 2.4. Bob's quantum strategy
    // Inputs:
    //      1) Bob's starting bit (Y), 
    //      2) Bob's half of Bell pair they share with Alice.
    // Goal:  Measure Bob's qubit in the π/8 basis if his bit is 0 (false), 
    //        or the -π/8 basis if his bit is 1 (true), and return the result.
    // The state of the qubit after the operation does not matter.
    operation BobQuantum (bit : Bool, qubit : Qubit) : Bool {
        // ...
        fail "Task 2.4 not implemented yet";
    }


    // Task 2.5. Play the CHSH game using the quantum strategy
    // Input: Operations that return Alice and Bob's output bits (A and B) based on their quantum
    //        strategies and given their respective qubits from the Bell pair. 
    //        Alice and Bob have already been told what their starting bits X and Y are.
    // Goal:  Return Alice and Bob's output bits (A, B).
    //
    // Note that this task uses strategies AliceQuantum and BobQuantum 
    // which you've implemented in tasks 2.2 and 2.4, respectively.
    operation PlayQuantumCHSH (askAlice : (Qubit => Bool), askBob : (Qubit => Bool))
            : (Bool, Bool) {
        // ...
        fail "Task 2.5 not implemented yet";
    }

}
