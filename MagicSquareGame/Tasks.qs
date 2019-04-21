// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.MagicSquareGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The "Magic Square Game" quantum kata is a series of exercises
    // designed to get you familiar with the Mermin-Peres magic square
    // game.

    // TODO: Add description of the game.

    // Each task is wrapped in one operation preceded by the
    // description of the task. Each task has a unit test associated
    // with it, which initially fails. Your goal is to fill in the
    // blank (marked with // ... comment) with some Q# code to make
    // the failing test pass.


    //////////////////////////////////////////////////////////////////
    // Part I. Classical Magic Square
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Validate Alice and Bob's moves
    // In this task you have to implement two functions, one for Alice's move and one for Bob's.
    // Note that they are covered by one test, so you have to implement both before attemping the test.

    // Input: The signs Alice chose for each cell in her row in an array of length 3.
    // Output: True if Alice's move is valid (that is, if every cell is either +1 or -1 and it has
    //         an even number of minus signs) and false otherwise.
    function ValidAliceMove (cells : Int[]) : Bool {
        // ...
        fail "Validating Alice's move in task 1.1 not implemented yet";
    }

    // Input: The signs Bob chose for each cell in his row in an array of length 3.
    // Output: True if Bob's move is valid (that is, if every cell is either +1 or -1 and it has
    //         an odd number of minus signs) and false otherwise.
    function ValidBobMove (cells : Int[]) : Bool {
        // ...
        fail "Validating Bob's move in task 1.1 not implemented yet";
    }


    // Task 1.2. Win condition
    // Input:
    //     1) Alice and Bob's moves in arrays of length 3,
    //     2) The row and column Alice and Bob were assigned from 0 to 2.
    // Output:
    //     True if Alice and Bob won the magic square game (that is, if both Alice and Bob's moves
    //     are valid and they chose the same sign in the cell that intersects Alice's row and Bob's
    //     column) and false otherwise.
    function WinCondition (alice : Int[], row : Int, bob : Int[], column : Int) : Bool {
        // ...
        fail "Task 1.2 not implemented yet";
    }


    // Task 1.3. Alice and Bob's classical strategy
    // In this task you have to implement two functions, one for Alice's classical strategy and one for Bob's.
    // Note that they are covered by one test, so you have to implement both before attemping the test.
    // The best classical strategy should win about 8/9 of the time.

    // Input: Alice's row.
    // Output:
    //     The signs Alice will place in her row (as an array of length 3) to maximize their
    //     chance of winning.
    function AliceClassical (row : Int) : Int[] {
        // ...
        fail "Alice's strategy in task 1.3 not implemented yet";
    }

    // Input: Bob's row.
    // Output:
    //     The signs Bob will place in his row (as an array of length 3) to maximize their
    //     chance of winning.
    function BobClassical (column : Int) : Int[] {
        // ...
        fail "Bob's strategy in task 1.3 not implemented yet";
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum Magic Square
    //////////////////////////////////////////////////////////////////

    // In the quantum version of the game, the players still can not
    // communicate during the game, but they are allowed to share 
    // qubits from two entangled pairs before the start of the game.

    // Task 2.1. Entangled state
    // Input: Two arrays of two qubits each in the |00⟩ state.
    // Goal:
    //     Create the entangled state
    //     |ϕ⟩ = ((|+⟩₀ ⊗ |+⟩₂ + |-⟩₀ ⊗ |-⟩₂) / sqrt(2)) ⊗ ((|+⟩₁ ⊗ |+⟩₃ + |-⟩₁ ⊗ |-⟩₃) / sqrt(2))
    //     where |ψ⟩₀ and |ψ⟩₁ are Alice's qubits and |ψ⟩₂ and |ψ⟩₃ are Bob's qubits.
    operation CreateEntangledState (qs : Qubit[]) : Unit {
        // ...
        fail "Task 2.1 not implemented yet";
    }


    // Task 2.2. Magic square observables
    // Input: A row and column corresponding to a cell in a magic square.
    // Output:
    //     The observable operator from the given row and column of a magic square that satisfies
    //     these properties:
    //
    //     1) The observables in each row and column mutually commute,
    //     2) The product of observables in each row is I,
    //     3) The product of observables in each column is -I.
    function MagicSquareObservable (row : Int, column : Int) : (Qubit[] => Unit : Adjoint, Controlled) {
        // Hint: Remember that you can define auxiliary operations.

        // ...
        fail "Task 2.2 not implemented yet";
    }


    // Task 2.3. Measure an operator
    // Input:
    //     1) An operator to measure,
    //     2) A qubit register to measure the operator on.
    // Output: The result of measuring the operator on the target register.
    operation MeasureOperator (op : (Qubit[] => Unit : Controlled), target : Qubit[]) : Result {
        // ...
        fail "Task 2.3 not implemented yet";
    }


    // Task 2.4. Alice and Bob's quantum strategy
    // In this task you have to implement two functions, one for Alice's quantum strategy and one for Bob's.
    // Note that they are covered by one test, so you have to implement both before attemping the test.
    // The best quantum strategy can win every time.

    // Input:
    //     1) Alice's row,
    //     2) Alice's half of the entangled qubits as an array of length 2.
    // Output:
    //     The signs Alice will place in her row (as an array of length 3) to maximize their
    //     chance of winning.
    operation AliceQuantum (row : Int, qs : Qubit[]) : Int[] {
        // Hint: Use MagicSquareObservable and MeasureOperator from tasks 2.2 and 2.3.

        // ...
        fail "Alice's strategy in task 2.4 not implemented yet";
    }

    // Input:
    //     1) Bob's column,
    //     2) Bob's half of the entangled qubits as an array of length 2.
    // Output:
    //     The signs Bob will place in his row (as an array of length 3) to maximize their
    //     chance of winning.
    operation BobQuantum (column : Int, qs : Qubit[]) : Int[] {
        // Hint: Use MagicSquareObservable and MeasureOperator from tasks 2.2 and 2.3.

        // ...
        fail "Bob's strategy in task 2.4 not implemented yet";
    }


    // Task 2.5. Play the magic square game using the quantum strategy
    // Input: Operations that return Alice and Bob's moves based on their quantum
    //        strategies and given their respective qubits from the entangled state.
    //        Alice and Bob have already been told their row and column.
    // Goal:  Return Alice and Bob's moves.
    //
    // Note that this task uses strategies AliceQuantum and BobQuantum 
    // which you've implemented in task 2.4.
    operation PlayQuantumMagicSquare (askAlice : (Qubit[] => Int[]), askBob : (Qubit[] => Int[])) : (Int[], Int[]) {
        // Hint: Use CreateEntangledState from task 2.1.

        // ...
        fail "Task 2.5 not implemented yet";
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Experimenting with the Magic Square
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Testing magic square strategies
    // Goal:
    //    Use your classical and quantum magic square strategies from tasks 1.3, 2.4 and 2.5 to
    //    verify their probabilities of winning. Can you make the classical strategy lose?
    operation MagicSquare_Test () : Unit {
        // Hint: You will need to use partial application to use your quantum strategies from task
        // 2.4 with PlayQuantumMagicSquare from task 2.5.

        // Hint: Use AssertBoolEqual along with the your WinCondition function from task 1.2 to
        // assert that Alice and Bob won the game.

        // Hint: Use the DrawMagicSquare function in Tests.qs to see what the magic square looks
        // like after Alice and Bob make their moves.

        // MagicSquare_Test appears in the list of unit tests for the solution; run it to verify
        // your code.

        // ...
        fail "Task 3.1 not implemented yet";
    }

}