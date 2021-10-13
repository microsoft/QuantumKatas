// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.TruthTables {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;

    //////////////////////////////////////////////////////////////////
    // Part I. Truth tables as integers
    //////////////////////////////////////////////////////////////////
    
    // Task 1. Projective functions (elementary variables)
    function ProjectiveTruthTables_Reference () : (TruthTable, TruthTable, TruthTable) {
        let x1 = TruthTable(0b10101010, 3);
        let x2 = TruthTable(0b11001100, 3);
        let x3 = TruthTable(0b11110000, 3);
        return (x1, x2, x3);
    }

    // Task 2. "Exactly 1 bit is true" function
    function ExactlyOneBitTrue_Reference () : TruthTable {
        let f = TruthTable(0b00010110, 3);
        return f;
    }

    // Task 3. "Exactly 2 bits are true" function
    function ExactlyTwoBitsTrue_Reference () : TruthTable {
        let f = TruthTable(0b01101000, 3);
        return f;
    }


    // Task 4. Compute AND of two truth tables
    function TTAnd_Reference(tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        let (bits1, numVars1) = tt1!;
        let (bits2, numVars2) = tt2!;
        EqualityFactI(numVars1, numVars2, "Number of variables for both truth tables must match");
        return TruthTable(bits1 &&& bits2, numVars1);
    }


    // Task 5. Compute OR of two truth tables
    function TTOr_Reference(tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        let (bits1, numVars1) = tt1!;
        let (bits2, numVars2) = tt2!;
        EqualityFactI(numVars1, numVars2, "Number of variables for both truth tables must match");
        return TruthTable(bits1 ||| bits2, numVars1);
    }


    // Task 6. Compute XOR of two truth tables
    function TTXor_Reference(tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        let (bits1, numVars1) = tt1!;
        let (bits2, numVars2) = tt2!;
        EqualityFactI(numVars1, numVars2, "Number of variables for both truth tables must match");
        return TruthTable(bits1 ^^^ bits2, numVars1);
    }


    // Task 7. Compute NOT of a truth tables
    function TTNot_Reference(tt : TruthTable) : TruthTable {
        let (bits, numVars) = tt!;
        let mask = (1 <<< (1 <<< numVars)) - 1;
        return TruthTable(~~~bits &&& mask, numVars);
    }


    // Task 8. Build if-then-else truth table
    function TTIfThenElse_Reference (ttCond : TruthTable, ttThen: TruthTable, ttElse : TruthTable) : TruthTable {
        return TTXor_Reference(TTAnd_Reference(ttCond, ttThen), TTAnd_Reference(TTNot_Reference(ttCond), ttElse));
    }


    // Task 9. Find all true input assignments in a truth table
    function AllMinterms_Reference (tt : TruthTable) : Int[] {
        return Mapped(
                   Fst,
                   Filtered(
                       Compose(EqualB(true, _), Snd),
                       Enumerated(IntAsBoolArray(tt::bits, 2^tt::numVars))
                   )
               );
    }


    // Task 10. Apply truth table as a quantum operation
    operation ApplyXControlledOnFunction_Reference (tt : TruthTable, controls : Qubit[], target : Qubit) : Unit is Adj {
        for i in AllMinterms_Reference(tt) {
            (ControlledOnInt(i, X))(controls, target);
        }
    }
}
