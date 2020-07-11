// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.RandomNumberGeneration {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    

    // Exercise 1.
    operation RandomBit_Reference () : Int {
        using (q = Qubit()) {
            H(q);
            return MResetZ(q) == Zero ? 0 | 1;
        }
    }

    // Exercise 2. 
    operation RandomTwoBits_Reference () : Int {
        let firstBit = RandomBit_Reference();
        let secondBit = RandomBit_Reference();
        if (firstBit == 0) {
            return secondBit == 0 ? 0 | 1;
        } else {
            return secondBit == 0 ? 2 | 3;
        }
    }

    // Exercise 3.
    operation RandomNBits_Reference (N: Int) : Int {
        mutable result = 0;
        for (i in 0..(N - 1)) {
            set result = result + RandomBit_Reference() * PowI(2, i);
        }
        return result;
    }

    // Exercise 4. 
    operation WeightedRandomBit_Reference (x : Double) : Int {
        let theta = ArcCos(Sqrt(x));
        using (q = Qubit()) {
            Ry(2.0 * theta, q);
            return MResetZ(q) == Zero ? 0 | 1;
        }
    }
}