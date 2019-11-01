// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SingleQubitGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    
    // Exercise 1.
    operation ApplyY_Reference (q : Qubit) : Unit is Adj+Ctl {
        Y(q);
    }

    // Exercise 2.
    operation GlobalPhaseI_Reference (q : Qubit) : Unit is Adj+Ctl {
        X(q);
        Z(q);
        Y(q);
    }

    // Exercise 3.
    operation SignFlipOnZero_Reference (q : Qubit) : Unit is Adj+Ctl {
        X(q);
        Z(q);
        X(q);
    }

    // Exercise 4.
    operation PrepareMinus_Reference (q : Qubit) : Unit is Adj+Ctl {
        X(q);
        H(q);
    }

    // Exercise 5.
    operation ThreeQuatersPiPhase_Reference (q : Qubit) : Unit is Adj+Ctl {
        S(q);
        T(q);
    }

    // Exercise 6.
    operation PrepareRotatedState_Reference (alpha : Double, beta : Double, q : Qubit) : Unit is Adj+Ctl {
        let phi = ArcTan2(beta, alpha);
        Rx(2.0 * phi, q);
    }

    // Exercise 7.
    operation PrepareArbitraryState_Reference (alpha : Double, beta : Double, theta : Double, q : Qubit) : Unit is Adj+Ctl {
        let phi = ArcTan2(beta, alpha);
        Ry(2.0 * phi, q);
        R1(theta, q);
    }
}