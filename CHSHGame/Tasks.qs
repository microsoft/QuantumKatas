// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.CHSHGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;


    ///////////////////////////////////////////////////////////////////////
    //                                                                   //
    //  CHSH Game Kata                                                   //
    //                                                                   //
    ///////////////////////////////////////////////////////////////////////

    // Task 1. Win condition
    // Input: Alice and Bob's starting bits (X and Y) and output bits (A and B).
    // Goal:  Return true if Alice and Bob won the CHSH game; that is, if X·Y = A ⊕ B.
    function WonCHSHGame (x : Bool, y : Bool, a : Bool, b : Bool) : Bool {
        // ...
        return false;
    }


    // Task 2. Alice's classical strategy
    // Input: Alice's starting bit (X).
    // Goal:  Return the bit that Alice should output (A) to maximize Alice and Bob's chance of
    //        winning the CHSH game.
    function AliceClassical (x : Bool) : Bool {
        // ...
        return false;
    }


    // Task 3. Bob's classical strategy
    // Input: Bob's starting bit (Y).
    // Goal:  Return the bit that Bob should output (B) to maximize Alice and Bob's chance of
    //        winning the CHSH game.
    function BobClassical (y : Bool) : Bool {
        // ...
        return true;
    }


    // Task 4. Entangled pair
    // Input: An array of two qubits in the |00⟩ state.
    // Goal:  Create a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    operation CreateEntangledPair (qs : Qubit[]) : Unit {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to
        // fail.
        AssertIntEqual(Length(qs), 2, "The array should have exactly 2 qubits.");

        // ...
    }


    // Task 5. Alice's quantum strategy
    // Input: The classical bit Alice was given, and Alice's entangled qubit.
    // Goal:  Measure Alice's qubit in the Z basis if her bit is 0 or the X basis if her bit is 1
    //        return the result.
    operation AliceQuantum (bit : Bool, qubit : Qubit) : Bool {
        // ...
        return false;
    }


    // Task 6. Rotate Bob's qubit
    // Input: The direction to rotate, and Bob's entangled qubit.
    // Goal:  Rotate Bob's qubit π/8 radians around the Y axis either clockwise or counterclockwise.
    operation RotateBobQubit (clockwise : Bool, qubit : Qubit) : Unit {
        // ...
    }


    // Task 7. Bob's quantum strategy
    // Input: The classical bit Bob was given, and Bob's entangled qubit.
    // Goal:  Measure Bob's qubit in the π/8 basis if his bit is 0 or the -π/8 basis if his bit is
    //        1 and return the result.
    operation BobQuantum (bit : Bool, qubit : Qubit) : Bool {
        // ...
        return false;
    }


    // Task 8. Play the CHSH game using the quantum strategy
    // Input: Operations that return Alice and Bob's output bits (A and B) based on their quantum
    //        strategies and given their respective entangled qubits. Alice and Bob have already
    //        been told what their starting bits are.
    // Goal: Return Alice and Bob's output bits (A, B).
    operation PlayQuantumCHSH (askAlice : (Qubit => Bool), askBob : (Qubit => Bool))
            : (Bool, Bool) {
        // ...
        return (false, false);
    }

}
