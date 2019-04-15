// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GHZGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;


    //////////////////////////////////////////////////////////////////
    // Part I. Classical GHZ
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Win condition
    function WinCondition_Reference (r : Bool, s : Bool, t : Bool, a : Bool, b : Bool, c : Bool) : Bool {
        return (r or s or t) == XOR(XOR(a, b), c);
    }

    // Task 1.2. Random classical strategy
    operation RandomClassicalStrategy_Reference (input : Bool) : Bool {
        return RandomInt(2) == 1;
    }

    // Task 1.3. Best classical strategy
    operation BestClassicalStrategy_Reference (input : Bool) : Bool {
        // Really advanced tactics here... I'm talking earth-shattering stuff.
        return true;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum GHZ
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Entangled triple
    operation CreateEntangledTriple_Reference (qs : Qubit[]) : Unit {
        body (...) {
            X(qs[0]);
            X(qs[1]);

            H(qs[0]);
            H(qs[1]);

            Controlled Z([qs[0]], qs[1]);
            (ControlledOnBitString([false, true], X))([qs[0], qs[1]], qs[2]);
            (ControlledOnBitString([true, false], X))([qs[0], qs[1]], qs[2]);
        }
        adjoint auto;
    }

    // Task 2.2. Quantum strategy
    operation QuantumStrategy_Reference (input : Bool, qubit : Qubit) : Bool {
        if (input) {
            H(qubit);
        }
        return BoolFromResult(M(qubit));
    }

}
