// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.ReversibleLogicSynthesis {
    
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // ...
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Truth tables as integers
    //////////////////////////////////////////////////////////////////
    
    // We can think of an n-variable Boolean function as an integer with at
    // least 2^n binary digits.  Each digit represents the truth value for
    // each of the 2^n assignments.  The least-significant bit represents the
    // assignment 00...00, the next one 00...01, and the most-significant bit
    // represents 11...11.

    // In Q# we can use the 0b prefix to specify integers in binary notation,
    // which is useful when describing the truth table of a Boolean function.
    // For example, the truth table of the 2-input function (x1 & x2) can be
    // represented by the integer 0b1000.

    // Task 1.1. Projective functions (elementary variables)
    //
    // Goal: Describe the three projective functions x1, x2, x3 as 3-input
    //       functions, represented by integers.
    //
    // Example: The function x1 (least-significant input) is given as an
    //          example.  The function is true for assignments 001, 011, 101,
    //          and 111.
    operation ProjectiveTruthTables () : (Int, Int, Int) {
        let x1 = 0b10101010;
        let x2 = 0;           // Update the value of x2 ...
        let x3 = 0;           // Update the value of x3 ...

        return (x1, x2, x3);
    }
}
