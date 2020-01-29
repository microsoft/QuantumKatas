// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.TruthTables {
    
    open Microsoft.Quantum.Diagnostics;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // This tutorial teaches you how to represent Boolean functions as
    // integers.  We use the bits in the binary integer representation
    // as truth values in the truth table of the Boolean function.
    
    // We can think of an n-variable Boolean function as an integer with at
    // least 2^n binary digits.  Each digit represents the truth value for
    // each of the 2^n assignments.  The least-significant bit represents the
    // assignment 00...00, the next one 00...01, and the most-significant bit
    // represents 11...11.

    // In Q# we can use the 0b prefix to specify integers in binary notation,
    // which is useful when describing the truth table of a Boolean function.
    // For example, the truth table of the 2-input function (x1 & x2) can be
    // represented by the integer 0b1000.

    // Since the number of bits in an integer is always the same, we need to
    // specify the number of variables explicitly.  Therefore, it makes sense
    // to introduce a user defined type for truth tables.

    newtype TruthTable = (bits : Int, numVars : Int);

    // Task 1. Projective functions (elementary variables)
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

    // Task 2. Compute AND of two truth tables
    //
    // Goal: Compute a truth table that computes the conjunction (AND)
    //       of two truth tables.
    //
    // Hint: You can use bit-wise operations in Q# for this task.  For
    //       AND the fitting operation is `&&&`.
    operation TTAnd (tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        let (bits1, numVars1) = tt1!;
        let (bits2, numVars2) = tt2!;
        EqualityFactI(numVars1, numVars2, "Number of variables for both truth tables must match");

        fail ("Task 2 not implemented!");
    }

    // Task 3. Compute OR of two truth tables
    //
    // Goal: Compute a truth table that computes the disjunction (OR)
    //       of two truth tables.
    operation TTOr (tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        fail ("Task 3 not implemented!");
    }

    // Task 4. Compute XOR of two truth tables
    //
    // Goal: Compute a truth table that computes the exclusive-OR (XOR)
    //       of two truth tables.
    operation TTXor (tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        fail ("Task 4 not implemented!");
    }

    // Task 5. Compute NOT of a truth table
    //
    // Goal: Compute a truth table that computes negation of a truth
    //       table.
    //
    // Hint: Be careful not to set bits in the integer that are out-of-range
    //       in the truth table.
    operation TTNot (tt : TruthTable) : TruthTable {
        fail ("Task 5 not implemented!");
    }

    // Task 6. Build if-then-else truth table
    //
    // Goal: Compute the truth table of the if-then-else function x1 ? x2 : x3
    //       (if x1 then x2 else x3) by making use of the truth table operations
    //       defined in the previous 4 tasks.
    operation TTIfThenElse (ttCond : TruthTable, ttThen : TruthTable, ttElse : TruthTable) : TruthTable {
        fail ("Task 6 not implemented!");
    }

    // Task 7. Find all true input assignments in a truth table
    //
    // Goal: Return an array that contains all input assignments for
    //       function represented as truth table.  Make use of Q# library functions
    //       to implement this operation without implementing any helper operations.
    //       Useful Q# library functions to complete this task are Mapped, Filtered,
    //       Compose, Enumerated, IntAsBoolArray, EqualB, Fst, and Snd.
    //
    // Example: The truth table of 2-input OR is 0b1110, i.e., its minterms are
    //          [1, 2, 3].
    operation AllMinterms (tt : TruthTable) : Int[] {
        fail ("Task 7 not implemented!");
    }

    // Task 8. Apply truth table as a quantum operation
    //
    // Goal: The goal is to apply the X operation on the target qubit, if and only if
    //       the classical state of the controls is a minterm of the truth table.
    //
    // Hint: Make use of the ControlledOnInt operation in Microsoft.Quantum.Canon.
    //       Note that this quantum operation is self-inverse.
    operation ApplyFunction (tt : TruthTable, controls : Qubit[], target : Qubit) : Unit is Adj {
        fail ("Task 8 not implemented!");
    }
}
