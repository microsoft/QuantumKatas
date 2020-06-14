// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Measurements {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    
    // ------------------------------------------------------
    // To Set a Positive Value to a Qubit:
    operation SetPositiveBit(q: Qubit) : Unit {
        Reset(q);
        H(q);     //pauli gate H
    }

    // To set a Negative Value to a Qubit
    operation SetNegativeBit(q: Qubit) : Unit {
        Reset(q);
        X(q);     //pauli gate X
        H(q);     //pauli gate H
    }
    
    // To randomly select one of the state
    operation SetRandomBit(q: Qubit) : Unit {

        let choice = RandomInt(2);

        if (choice == 0) {
            Message("Prepared |-⟩");
            SetMinus(q);
        } else {
            Message("Prepared |+⟩");
            SetPlus(q);
        }
    }

    operation NextRandomBit() : Result {
        using (q = Qubit()) {
            PrepareRandomBit(q);        // You can try out other operations here by trying SetPositiveBit(q) 
            return MResetZ(q);          // or SetNegativeBit(q) instead of PrepareRandomBit(q)
        }
    }
}
