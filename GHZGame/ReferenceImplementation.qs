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


    // Implement a strategy which randomly chooses outputs.
    operation ClassicalRandomStrategy_Reference(input : Bool) : Bool {
        return RandomInt(2) == 1;
    }

    // Implement a strategy which wins 75% of the time and
    // does not use quantum logic.
    operation ClassicalOptimalStrategy_Reference(input : Bool) : Bool {
        // Really advanced tactics here... I'm talking earth shattering stuff
        return true;
    }

    // Given qubits in the state |000> in big-endian format, prepare the state:
    // (1/2)(|000> - |110> - |101> - |011>)
    // This is sometimes known as the GHZ state.
    operation PrepareEntangledSuperPosition_Reference(qs : Qubit[]) : Unit {
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

    // You are Alice.
    // You have one of three qubits which form the superposition (1/2)(|000> - |110> - |101> - |011>).
    // You know that the other two players will do the same strategy as you.
    // What will you do to ensure a victory in this game?
    // That is to say, assuming the other players do the same strategy as you,
    // Answer correctly such that you have a XOR b XOR c == r OR s OR t
    operation QuantumStrategy_Reference(input : Bool, qMe : Qubit) : Unit {
        if (input) {
            H(qMe);
        }
    }

}
