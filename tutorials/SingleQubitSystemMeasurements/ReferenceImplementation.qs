// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SingleQubitSystemMeasurements {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    
    // Exercise 2.
    operation IsQubitZero_Reference (q : Qubit) : Bool {
        return M(q) == Zero;
    }

    // Exercise 3.
    operation IsQubitMinus_Reference (q : Qubit) : Bool {
        return Measure([PauliX], [q]) == One;
    }

    // Exercise 5.
    operation IsQubitPsiPlus_Reference (q : Qubit) : Bool { 
        Ry(-2.0 * ArcTan2(0.8, 0.6), q);
        return M(q) == Zero;
    }

    // Exercise 6.
    operation IsQubitA_Reference (alpha : Double, q : Qubit) : Bool { 
        Rx(-2.0 * alpha, q);
        return M(q) == Zero;
    }

    // Exercise 7.
    operation MeasureInABBasis_Reference (alpha : Double, q : Qubit) : Result { 
        Rx(-2.0 * alpha, q);
        let measurementResult = M(q);
        Rx(2.0 * alpha, q);
        return measurementResult;
    }
}