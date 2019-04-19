// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.CHSHGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Primitive;



    //////////////////////////////////////////////////////////////////
    // Part I. Classical CHSH
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Win condition
    function WinCondition_Reference (x : Bool, y : Bool, a : Bool, b : Bool) : Bool {
        return (x and y) == (a != b);
    }


    // Task 1.2. Alice and Bob's classical strategy
    // (Both players should return the same value, regardless of input)
    function AliceClassical_Reference (x : Bool) : Bool {
        return false;
    }

    function BobClassical_Reference (y : Bool) : Bool {
        return false;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum CHSH
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Entangled pair
    operation CreateEntangledPair_Reference (qs : Qubit[]) : Unit {
        body (...) {
            H(qs[0]);
            CNOT(qs[0], qs[1]);
        }

        adjoint invert;
    }


    // Task 2.2. Alice's quantum strategy
    operation AliceQuantum_Reference (bit : Bool, qubit : Qubit) : Bool {
        if (bit) {
            // Measure in sign basis if bit is 1
            return BoolFromResult(Measure([PauliX], [qubit]));
        } else {
            // Measure in computational basis if bit is 0
            return BoolFromResult(Measure([PauliZ], [qubit]));
        }
    }


    // Task 2.3. Rotate Bob's qubit
    operation RotateBobQubit_Reference (clockwise : Bool, qubit : Qubit) : Unit {
        if (clockwise) {
            Ry(-2.0 * PI() / 8.0, qubit);
        } else {
            Ry(2.0 * PI() / 8.0, qubit);
        }
    }


    // Task 2.4. Bob's quantum strategy
    operation BobQuantum_Reference (bit : Bool, qubit : Qubit) : Bool {
        RotateBobQubit_Reference(not bit, qubit);
        return BoolFromResult(M(qubit));
    }


    // Task 2.5. Play the CHSH game
    operation PlayQuantumCHSH_Reference (askAlice : (Qubit => Bool),
                                         askBob : (Qubit => Bool)) : (Bool, Bool) {
        mutable aliceResult = false;
        mutable bobResult = false;

        using ((aliceQubit, bobQubit) = (Qubit(), Qubit())) {
            CreateEntangledPair_Reference([aliceQubit, bobQubit]);

            set aliceResult = askAlice(aliceQubit);
            set bobResult = askBob(bobQubit);

            Reset(aliceQubit);
            Reset(bobQubit);
        }

        return (aliceResult, bobResult);
    }

}
