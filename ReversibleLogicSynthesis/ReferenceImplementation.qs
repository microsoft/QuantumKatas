// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.ReversibleLogicSynthesis {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;

    //////////////////////////////////////////////////////////////////
    // Part I. Truth tables as integers
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. Projective functions (elementary variables)
    operation ProjectiveTruthTables_Reference () : (TruthTable, TruthTable, TruthTable) {
        let x1 = TruthTable(0b10101010, 3);
        let x2 = TruthTable(0b11001100, 3);
        let x3 = TruthTable(0b11110000, 3);
        return (x1, x2, x3);
    }

    operation TTAnd_Reference(tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        let (bits1, numVars1) = tt1!;
        let (bits2, numVars2) = tt2!;
        EqualityFactI(numVars1, numVars2, "Number of variables for both truth tables must match");
        return TruthTable(bits1 &&& bits2, numVars1);
    }

    operation TTOr_Reference(tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        let (bits1, numVars1) = tt1!;
        let (bits2, numVars2) = tt2!;
        EqualityFactI(numVars1, numVars2, "Number of variables for both truth tables must match");
        return TruthTable(bits1 ||| bits2, numVars1);
    }

    operation TTXor_Reference(tt1 : TruthTable, tt2 : TruthTable) : TruthTable {
        let (bits1, numVars1) = tt1!;
        let (bits2, numVars2) = tt2!;
        EqualityFactI(numVars1, numVars2, "Number of variables for both truth tables must match");
        return TruthTable(bits1 ^^^ bits2, numVars1);
    }

    operation TTNot_Reference(tt : TruthTable) : TruthTable {
        let (bits, numVars) = tt!;
        let mask = (1 <<< (1 <<< numVars)) - 1;
        return TruthTable(~~~bits &&& mask, numVars);
    }

    // Task 1.6. Build if-then-else truth table
    operation TTIfThenElse_Reference (ttCond : TruthTable, ttThen: TruthTable, ttElse : TruthTable) : TruthTable {
        return TTXor_Reference(TTAnd_Reference(ttCond, ttThen), TTAnd_Reference(TTNot_Reference(ttCond), ttElse));
    }

    // Task 1.7. Find all true input assignments in a truth table
    operation AllMinterms_Reference (tt : TruthTable) : Int[] {
        return Mapped(
                   Fst<Int, Bool>,
                   Filtered(
                       Compose(EqualB(true, _), Snd<Int, Bool>),
                       Enumerated(IntAsBoolArray(tt::bits, 2^tt::numVars))
                   )
               );
    }

    // Task 1.8.
    operation ApplyFunction_Reference (tt : TruthTable, controls : Qubit[], target : Qubit) : Unit is Adj {
        body {
            for (op in Mapped(ControlledOnInt(_, X), AllMinterms_Reference(tt))) {
                op(controls, target);
            }
        }
        adjoint self;
    }
}
