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
    open Microsoft.Quantum.Convert;
    

    // Exercise 1.
    operation RandomBit_Reference () : Int {
        using (q = Qubit()) {
            H(q);
            let result = MResetZ(q);
            if (IsResultOne(result)) {
                return 1;
            } else {
                return 0;
            }
        }
    }

    // Exercise 2. 
    operation RandomTwoBits_Reference () : Int {
        let firstBit = RandomBit();
        let secondBit = RandomBit();
        if (firstBit == 0) {
            if (secondBit == 0) {
                return 0;
            } else {
                return 1;
            }
        } else {
            if (secondBit == 0) {
                return 2;
            } else {
                return 3;
            }
        } 
    }

    operation RandomNBits_Reference (N: Int) : Int {
        mutable result = 0;
        for (i in 0..(N - 1)) {
            set result = result + RandomBit() * PowI(2, i);
        }
        return result;
    }

    // Exercise 2. 
    operation WeightedRandomBit_Reference (x : Double) : Int {
        let alpha = Sqrt(x);
        let beta = Sqrt(IntAsDouble(1) - x);
        let theta = Microsoft.Quantum.Convert.IntAsDouble(2) * Microsoft.Quantum.Math.ArcTan2(beta, alpha);
        using (q = Qubit()) {
            Ry(theta, q);
            let result = MResetZ(q);
            if (IsResultOne(result)) {
                return 1;
            } else {
                return 0;
            }
        }
    }


}