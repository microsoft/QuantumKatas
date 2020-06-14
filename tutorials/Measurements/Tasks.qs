// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in the tutorial.
// We strongly recommend to use the Notebook version of the tutorial
// to enjoy the full experience.
//////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Measurements {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    operation SetPositiveBit(q: Qubit) : Unit {
        //TODO: Add your code here.
    }

    operation SetNegativeBit(q: Qubit) : Unit {
        //TODO: Add your code here.
    }

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
}
