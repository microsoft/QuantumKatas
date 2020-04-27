// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MultiQubitGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation CompoundGate_Reference (qs : Qubit[]) : Unit is Adj {
        S(qs[0]);
        Y(qs[2]);
    }

    operation BellState_Reference (qs : Qubit[]) : Unit is Adj {
        H(qs[0]);
        CNOT(qs[0], qs[1]);
    }

    operation QubitSwap_Reference (qs : Qubit[], index1 : Int, index2 : Int) : Unit is Adj {
        SWAP(qs[index1], qs[index2]);
    }

    operation ControlledRotation_Reference (qs : Qubit[], theta : Double) : Unit is Adj {
        let control = qs[0];
        let target = qs[1];
        Controlled Rx([control], (theta, target));
    }

    operation MultiControls_Reference (controls : Qubit[], target : Qubit, controlBits : Bool[]) : Unit is Adj {
        (ControlledOnBitString(controlBits, X))(controls, target);
    }
}