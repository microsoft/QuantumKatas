// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Math;
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
        // Try all the following inputs to see if any of the values differ; should be run 2ᴺ⁻¹ times
        for input in 1 .. 2 ^ (N - 1) {
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
    // Part II. Single-bit problem
    //////////////////////////////////////////////////////////////////

    // Exercise 3.
    operation PhaseOracle_OneMinusX_Reference (x : Qubit) : Unit is Adj + Ctl {
        Z(x);
        R(PauliI, 2.0 * PI(), x);
    }
    

    // Exercise 4.
    operation DeutschAlgorithm_Reference (oracle : (Qubit => Unit)) : Bool {
        use x = Qubit();
        H(x);
        oracle(x);
        H(x);
        return M(x) == Zero;
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Multi-bit problem
    //////////////////////////////////////////////////////////////////
    
    // Exercise 5.
    operation PhaseOracle_MostSignificantBit_Reference (x : Qubit[]) : Unit is Adj {
        Z(x[0]);
    }


    // Exercise 6.
    operation DeutschJozsaAlgorithm_Reference (N : Int, oracle : (Qubit[] => Unit)) : Bool {
        mutable isConstantFunction = true;
        use x = Qubit[N];
        ApplyToEach(H, x);
        oracle(x);
        ApplyToEach(H, x);
        for q in x {
            if (M(q) == One) {
                set isConstantFunction = false;
            }
        }
        return isConstantFunction;
    }
}
