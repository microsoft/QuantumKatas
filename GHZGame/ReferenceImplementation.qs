// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GHZGame {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;


    //////////////////////////////////////////////////////////////////
    // Part I. Classical GHZ
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Win condition
    function WinCondition_Reference (rst : Bool[], abc : Bool[]) : Bool {
        return (rst[0] or rst[1] or rst[2]) == XOR(XOR(abc[0], abc[1]), abc[2]);
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


    // Task 1.4. Referee classical GHZ game
    operation PlayClassicalGHZ_Reference (strategy : (Bool => Bool), inputs : Bool[]) : Bool[] {
        return ForEach(strategy, inputs);
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum GHZ
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Entangled triple
    operation CreateEntangledTriple_Reference (qs : Qubit[]) : Unit is Adj {
        X(qs[0]);
        X(qs[1]);

        H(qs[0]);
        H(qs[1]);
        // At this point we have (|000⟩ - |010⟩ - |100⟩ + |110⟩) / 2

        // Flip the sign of the last term
        Controlled Z([qs[0]], qs[1]);

        // Flip the state of the last qubit for the two middle terms
        (ControlledOnBitString([false, true], X))([qs[0], qs[1]], qs[2]);
        (ControlledOnBitString([true, false], X))([qs[0], qs[1]], qs[2]);
    }


    // Task 2.2. Quantum strategy
    operation QuantumStrategy_Reference (input : Bool, qubit : Qubit) : Bool {
        if (input) {
            H(qubit);
        }
        return ResultAsBool(M(qubit));
    }


    // Task 2.3. Play the GHZ game using the quantum strategy
    operation PlayQuantumGHZ_Reference (strategies : (Qubit => Bool)[]) : Bool[] {

        using (qs = Qubit[3]) {
            CreateEntangledTriple_Reference(qs);
            
            mutable abc = new Bool[3];
            for (i in 0..2) {
                set abc w/= i <- strategies[i](qs[i]);
            }

            ResetAll(qs);
            return abc;
        }
    }

}
