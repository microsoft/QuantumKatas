// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in the tutorial.
// We strongly recommend to use the Notebook version of the tutorial
// to enjoy the full experience.
//////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MultiQubitGates {
    open Microsoft.Quantum.Intrinsic;

    operation CompoundGate (qs : Qubit[]) : Unit is Adj {
        // ...
    }

    operation BellState (qs : Qubit[]) : Unit is Adj {
        // ...        
    }

    operation QubitSwap (qs : Qubit[], index1 : Int, index2 : Int) : Unit is Adj {
        // ...        
    }

    operation ControlledRotation (qs : Qubit[], theta : Double) : Unit is Adj {
        // ...        
    }

    operation MultiControls (controls : Qubit[], target : Qubit, controlBits : Bool[]) : Unit is Adj {
        // ...        
    }
}