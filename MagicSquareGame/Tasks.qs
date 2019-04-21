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

    // Task 3
    // Given a length 2 array of qubits in state |00>,
    // change them to be in state (1/sqrt(2))(|00> + |11>).
    operation CreateEntangledPair (qs : Qubit[]) : Unit {
        body (...) {
            
        }

        adjoint invert;
    }


    // Task 4. Two entangled pairs shared between Alice and Bob
    operation CreateAliceAndBobQubits (aliceQubits : Qubit[], bobQubits : Qubit[])
            : Unit {
        
    }

    // Task 5. Create the observable corresponding to a specific square.
    // It will help you to make a helper operation which applies the operation
    // in that square, and return a partial application of that operation.
    operation CreateSquareObservable (row : Int, column : Int) : (Qubit[] => Unit : Controlled) {
        // This is here only to make the code compile. You should replace it with your logic.
        return ApplyToEachC(I, _);
    }

    // Task 6.
    // Given two qubits interpreted as an input vector |psi>,
    // Measure the operator provided Observable operator on |psi>.
    // Note that as a side effect, this should project |psi> onto
    // an eigenstate of Observable.
    // You should be using an ancilla qubit.
    operation MeasureObservable(q0 : Qubit, 
                                q1 : Qubit, 
                                Observable : (Qubit[] => Unit : Controlled)) : Int {
        // This is here only to make the code compile. You should replace it with your logic.
        return -1;
    }

    // Task 7.1
    // Finally, with the logic we've implemented so far, the last step is
    // to put in the logic for the players to choose their moves.
    // You may assume that alice's q0 is entangled with bob's q0,
    // and that alice's q1 is entangled with bob's q1, and that
    // bob does the logic in PlayAsBob.
    // Return the length 3 list of moves alice makes, where the first index
    // is closest to the left of the 3x3 grid.
    // Remember alice is subject to the following constraints:
    // - MUST return an even number of -1 elements
    // - MUST return and odd number of 1 elements
    // - MUST return 3 moves.
    // You win if alice and bob place the same element in their shared square.
    // This strategy should ALWAYS win.
    operation PlayAsAlice(row : Int, q0 : Qubit, q1 : Qubit) : Int[] {
        mutable result = new Int[3];

        // Your code goes here
        // Hint: Most of the logic for this should be implemented in previous methods.

        return result;
    }

    // Task 7.2
    // You may assume that alice's q0 is entangled with bob's q0,
    // and that alice's q1 is entangled with bob's q1, and that
    // alice does the logic in PlayAsAlice.
    // Return the length 3 list of moves bob makes, where the first index
    // is closest to the top of the 3x3 grid.
    // Remember bob is subject to the following constraints:
    // - MUST return an odd number of -1 elements
    // - MUST return an even number of 1 elements
    // - MUST return 3 moves.
    // You win if alice and bob place the same element in their shared square.
    // This strategy should ALWAYS win.
    operation PlayAsBob(col : Int, q0 : Qubit, q1 : Qubit) : Int[] {
        mutable result = new Int[3];

        // Your code goes here
        // Hint: Most of the logic for this should be implemented in previous methods.

        return result;
    }

}