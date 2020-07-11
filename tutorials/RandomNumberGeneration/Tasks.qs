// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in Deutsch-Jozsa algorithm tutorial.
// We strongly recommend to use the Notebook version of the tutorial
// to enjoy the full experience.
//////////////////////////////////////////////////////////////////

namespace Quantum.Kata.RandomNumberGeneration {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    // Exercise 1.
    operation RandomBit () : Int {
        using (q = Qubit()) {
            // ...
            return -1;
        }
    }

    // Exercise 2. 
    operation RandomTwoBits () : Int {
        // ...
        return -1;
    }

    // Exercise 3.
    operation RandomNBits (N: Int) : Int {
        // ...
        return -1;
    }

    // Exercise 4.
    operation WeightedRandomBit (x : Double) : Int {
        // ...
        return -1;
    }

}