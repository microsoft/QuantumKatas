// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.RandomNumberGeneration {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    

    // Exercise 1.
    operation RandomBit_Reference () : Int {
        use q = Qubit();
        H(q);
        return M(q) == Zero ? 0 | 1;
    }

    // Exercise 2. 
    operation RandomTwoBits_Reference () : Int {
        return 2 * RandomBit_Reference() + RandomBit_Reference();
    }

    // Exercise 3.
    operation RandomNBits_Reference (N: Int) : Int {
        mutable result = 0;
        for i in 0..(N - 1) {
            set result = result * 2 + RandomBit_Reference();
        }
        return result;
    }

    // Exercise 4. 
    operation WeightedRandomBit_Reference (x : Double) : Int {
        let theta = ArcCos(Sqrt(x));
        use q = Qubit();
        Ry(2.0 * theta, q);
        return M(q) == Zero ? 0 | 1;
    }

    // Exercise 5.
    operation RandomNumberInRange_Reference (min : Int, max : Int) : Int {
        let nBits = BitSizeI(max);
        mutable output = 0; 
        repeat {
            set output = RandomNBits_Reference(nBits); 
        } until (output <= max and output >= min);
        return output;
    }
}