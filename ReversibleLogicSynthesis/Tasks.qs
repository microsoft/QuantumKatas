// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.ReversibleLogicSynthesis {
    
    open Microsoft.Quantum.Diagnostics;

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

    newtype TruthTable = (bits : Int, numVars : Int);

    // Task 1.1. Projective functions (elementary variables)
    //
    // Goal: Describe the three projective functions x1, x2, x3 as 3-input
    //       functions, represented by integers.
    //
    // Example: The function x1 (least-significant input) is given as an
    //          example.  The function is true for assignments 001, 011, 101,
    //          and 111.
    operation ProjectiveTruthTables () : (TruthTable, TruthTable, TruthTable) {
        let x1 = TruthTable(0b10101010, 3);
        let x2 = TruthTable(0, 0);           // Update the value of x2 ...
        let x3 = TruthTable(0, 0);           // Update the value of x3 ...

        return (x1, x2, x3);
    }

    // Task 1.2. Compute AND of two truth tables
    operation TTAnd (tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        let (bits1, numVars1) = tt1!;
        let (bits2, numVars2) = tt2!;
        EqualityFactI(numVars1, numVars2, "Number of variables for both truth tables must match");

        return TruthTable(0, numVars1);      // Update the return value
    }

    // Task 1.3. Compute OR of two truth tables
    operation TTOr (tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        return TruthTable(0, 0);             // Update the return value
    }

    // Task 1.4. Compute XOR of two truth tables
    operation TTXor (tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        return TruthTable(0, 0);             // Update the return value
    }

    // Task 1.5. Compute NOT of a truth table
    operation TTNot (tt : TruthTable) : TruthTable {
        return TruthTable(0, 0);             // Update the return value
    }

    // Task 1.6. Build if-then-else truth table
    //
    // Goal: Compute the truth table of the if-then-else function x1 ? x2 : x3
    //       (if x1 then x2 else x3) using bit-wise operations based on the
    //       truth tables of the projective functions.
    //
    // Example: You can compute the AND of x1 and x2 using `x1 &&& x2`.  Other
    //          bit-wise operations are ||| (OR), ^^^ (XOR), and ~~~ (bitwise negation).
    operation TTIfThenElse (ttCond : TruthTable, ttThen : TruthTable, ttElse : TruthTable) : TruthTable {
        return TruthTable(0, 0);             // Update the return value
    }

    // Task 1.7. Find all true input assignments in a truth table
    //
    // Goal: Return an array that contains all input assignments for which the
    //       if-then-else function returns true.  Make use of Q# library functions
    //       to implement this operation without implementing any helper operations.
    //       Useful Q# library functions to complete this task are Mapped, Filtered,
    //       Compose, Enumerated, IntAsBoolArray, EqualB, Fst, and Snd.
    //
    // Example: The truth table of 2-input OR is 0b1110, i.e., its minterms are
    //          [1, 2, 3].
    operation AllMinterms (tt : TruthTable) : Int[] {
        return new Int[0]; // Update the return value
    }

    // Task 1.8. ...
    operation ApplyFunction (tt : TruthTable, controls : Qubit[], target : Qubit) : Unit is Adj {
        // Implement quantum operation
    }
}
