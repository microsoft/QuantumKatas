// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in Basic Gates tutorial.
// We strongly recommend to use the Notebook version of the tutorial
// to enjoy the full experience.
//////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SingleQubitGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    
    // Exercise 1.
    operation ApplyY (q : Qubit) : Unit is Adj {
        // ...

    }

    // Exercise 2.
    operation ApplyZ (q : Qubit) : Unit is Adj {
        // ...

    }

    // Exercise 3.
    operation ZeroFlip (q : Qubit) : Unit is Adj+Ctl {
        // ...
        
    }

    // Exercise 4.
    operation PrepareMinus (q : Qubit) : Unit is Adj {
        // ...

    }

    // Exercise 5.
    operation ThreePiPhase (q : Qubit) : Unit is Adj+Ctl {
        // ...
        
    }

    operation RotatedState (alpha : Double, beta : Double, q : Qubit) : Unit is Adj {
        // ...
        
    }

    // Exercise 7.
    operation ArbitraryState (alpha : Double, beta : Double, theta : Double, q : Qubit) : Unit is Adj {
        // ...
        
    }
}