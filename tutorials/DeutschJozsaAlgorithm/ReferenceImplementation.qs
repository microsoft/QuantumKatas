// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Classical algorithm
    //////////////////////////////////////////////////////////////////

    // Exercise 1. 
    function Function_MostSignificantBit_Reference (x : Int, N : Int) : Int {
        return x >>> (N-1);
    }


    // Exercise 2. 
    function IsFunctionConstant_Classical_Reference (N : Int, f : (Int -> Int)) : Bool {
        // Get the first value of the function
        let firstValue = f(0);
        // Try all the following inputs to see if any of the values differ
        for (input in 1 .. 2 <<< (N - 1)) {
            let nextValue = f(input);
            if (nextValue != firstValue) {
                // Got two different values - the function is balanced
                return false;
            }
        }
        // Got 2ᴺ⁻¹ + 1 copies of the same value - the function is constant
        return true;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum oracles
    //////////////////////////////////////////////////////////////////
    
    // Exercise 3.
    operation PhaseOracle_MostSignificantBit_Reference (x : Qubit[]) : Unit is Adj {
        Z(x[0]);
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Quantum algorithm
    //////////////////////////////////////////////////////////////////
    
    // Exercise 4.
    operation DeutschJozsaAlgorithm_Reference (N : Int, oracle : (Qubit[] => Unit)) : Bool {
        mutable isConstantFunction = true;
        using (x = Qubit[N]) {
            ApplyToEach(H, x);
            oracle(x);
            ApplyToEach(H, x);
            for (q in x) {
                if (M(q) == One) {
                    set isConstantFunction = false;
                }
            }
            ResetAll(x);
        }
        return isConstantFunction;
    }
}