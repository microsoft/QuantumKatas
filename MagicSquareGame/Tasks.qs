// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.MagicSquareGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;


    ///////////////////////////////////////////////////////////////////////
    //                                                                   //
    //  Mermin-Peres Magic Square Game Kata                              //
    //                                                                   //
    ///////////////////////////////////////////////////////////////////////

    // Resources for your reference which may be helpful for solving this:
    // http://edu.itp.phys.ethz.ch/fs13/atqit/sol01.pdf

    // Task 1.1
    // Come up with some classical strategy which wins about
    // 66% of the time. You can assume bob will use BobStrategyClassical,
    // and should implement them together. You must abide by alice's placement rules.
    operation AliceStrategyClassical(row : Int) : Int[] {
        // This is here only to make the code compile. You should replace it with your logic.
        return [0, 0, 0];
    }

    // Task 1.2
    // Come up with some classical strategy which wins about
    // 66% of the time. You can assume alice will use AliceStrategyClassical,
    // and should implement them together. You must abide by bob's placement rules.
    operation BobStrategyClassical(col : Int) : Int[] {
        // This is here only to make the code compile. You should replace it with your logic.
        return [0, 0, 0];
    }

    // Task 2.1
    // Come up with some classical strategy which wins about
    // 88% of the time. You can assume bob will use BobStrategyOptimalClassical,
    // and should implement them together. You must abide by alice's placement rules.
    operation AliceStrategyOptimalClassical(row : Int) : Int[] {
        // This is here only to make the code compile. You should replace it with your logic.
        return [0, 0, 0];
    }

    // Task 2.2
    // Come up with some classical strategy which wins about
    // 88% of the time. You can assume alice will use AliceStrategyOptimalClassical,
    // and should implement them together. You must abide by bob's placement rules.
    operation BobStrategyOptimalClassical(col : Int) : Int[] {
        // This is here only to make the code compile. You should replace it with your logic.
        return [0, 0, 0];
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    // TODO: Place a summary here briefing the user on the context of the strategy they'll be using to
    // solve mermin-peres quantumly, so that all the below methods don't just sound like nonsense.
    ///////////////////////////////////////////////////////////////////////////////////////////////////

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
