// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in the tutorial.
// We strongly recommend to use the Notebook version of the tutorial
// to enjoy the full experience.
//////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SingleQubitSystemMeasurements {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    
    // Exercise 2. Distinguish |0❭ and |1❭
    operation IsQubitZero (q : Qubit) : Bool {
        // ...
        return false;
    }

    // Exercise 3. Distinguish |+❭ and |-❭ using Measure operation
    operation IsQubitMinus (q : Qubit) : Bool {
        // ...
        return false;
    }

    // Exercise 5. Distinguish specific orthogonal states
    operation IsQubitPsiPlus (q : Qubit) : Bool {
        // ...
        return false;
    }

    // Exercise 6. Distinguish states |A❭ and |B❭
    operation IsQubitA (alpha : Double, q : Qubit) : Bool {
        // ...
        return false;
    }

    // Exercise 7. Measure state in {|A❭, |B❭} basis
    operation MeasureInABBasis (alpha : Double, q : Qubit) : Result {
        // ...
        return One;
    }
}

