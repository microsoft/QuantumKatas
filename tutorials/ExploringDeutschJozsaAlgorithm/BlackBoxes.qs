// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains implementations of "black boxes" used in the tutorial -
// both classical functions and quantum oracles.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    //////////////////////////////////////////////////////////////////
    // Part I. Classical functions
    //////////////////////////////////////////////////////////////////
    
    // Function 1. f(x) = 0
    function Function_Zero_Reference (x : Int) : Int {
        return 0;
    }

    
    // Function 2. f(x) = 1
    function Function_One_Reference (x : Int) : Int {
        return 1;
    }


    // Function 3. f(x) = x mod 2
    function Function_Xmod2_Reference (x : Int) : Int {
        return x % 2;
    }


    // Function 4. f(x) = 1 if the binary notation of x has odd number of 1s, and 0 otherwise
    function Function_OddNumberOfOnes_Reference (x : Int) : Int {
        mutable nOnes = 0;
        mutable xBits = x;
        while (xBits > 0) {
            if (xBits % 2 > 0) {
                set nOnes += 1;
            }
            set xBits /= 2;
        }
        return nOnes % 2;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum oracles implementing classical functions
    //////////////////////////////////////////////////////////////////
    
    // Function 1. f(x) = 0
    operation PhaseOracle_Zero_Reference (x : Qubit[]) : Unit is Adj {
        // Since f(x) = 0 for all values of x, Uf|y⟩ = |y⟩.
        // This means that the operation doesn't need to do any transformation to the inputs.
        // Build the project and run the tests to see that T01_Oracle_Zero_Test test passes.
    }


    // Function 2. f(x) = 1
    operation PhaseOracle_One_Reference (x : Qubit[]) : Unit is Adj {
        // Since f(x) = 1 for all values of x, Uf|y⟩ = -|y⟩.
        // This means that the operation needs to add a global phase of -1.
        R(PauliI, 2.0 * PI(), x[0]);
    }


    // Function 3. f(x) = x mod 2
    operation PhaseOracle_Xmod2_Reference (x : Qubit[]) : Unit is Adj {
        // Length(x) gives you the length of the array.
        // Array elements are indexed 0 through Length(x)-1, inclusive.
        Z(x[Length(x) - 1]);
    }


    // Function 4. f(x) = 1 if x has odd number of 1s, and 0 otherwise
    operation PhaseOracle_OddNumberOfOnes_Reference (x : Qubit[]) : Unit is Adj {
        ApplyToEachA(Z, x);
    }
}