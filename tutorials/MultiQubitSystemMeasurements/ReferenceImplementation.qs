// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MultiQubitSystemMeasurements {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    
    // Exercise 3. Identify computational basis states
    operation BasisStateMeasurement_Reference(qs : Qubit[]) : Int {
        // Measurement on the first qubit gives the higher bit of the answer, on the second - the lower
        let m1 = M(qs[0]) == Zero ? 0 | 1;
        let m2 = M(qs[1]) == Zero ? 0 | 1;
        return m1 * 2 + m2;
    }
    // Exercise 5. Distinguish orthogonal states
    operation IsPlusPlusMinus_Reference (qs : Qubit[]) : Int {
        return Measure([PauliX], [qs[0]]) == Zero  ? 0 | 1;
    }

    // Exercise 7. State selection using partial measurements
    operation StateSelctionViaPartialMeasurement_Reference (qs : Qubit[], i : Int) : Unit  {
        // ...
    }

    // Exercise 8. State preparation using partial measurements
    operation PreparationUsingPostSelection_Reference ( qs : Qubit[] ): Unit {
        // ...
    }

    // Exercise 9. Two qubit parity Measurement
    operation ParityMeasurement_Reference (qs : Qubit[]) : Int{
        // ...
        return 1;
    }
}