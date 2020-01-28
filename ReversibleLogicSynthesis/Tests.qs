// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.ReversibleLogicSynthesis {
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;

    operation T11_ProjectiveTruthTables_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference(); // REVERT
        Fact(x1::bits == 0b10101010, "Truth table of x1 is not correct");
        Fact(x2::bits == 0b11001100, "Truth table of x2 is not correct");
        Fact(x3::bits == 0b11110000, "Truth table of x3 is not correct");
        Fact(x1::numVars == 3, "Number of variables of x1 is not correct");
        Fact(x2::numVars == 3, "Number of variables of x2 is not correct");
        Fact(x3::numVars == 3, "Number of variables of x3 is not correct");
    }

    operation T12_TTAnd_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference(); // REVERT
        let and12 = TTAnd_Reference(x1, x2); // REVERT
        let and13 = TTAnd_Reference(x1, x3); // REVERT
        let and23 = TTAnd_Reference(x2, x3); // REVERT
        Fact(and12::bits == 0b10001000, "Truth table of x1 ∧ x2 is not correct");
        Fact(and13::bits == 0b10100000, "Truth table of x1 ∧ x3 is not correct");
        Fact(and23::bits == 0b11000000, "Truth table of x2 ∧ x3 is not correct");
        Fact(and12::numVars == 3, "Number of variables in truth table is not correct");
        Fact(and13::numVars == 3, "Number of variables in truth table is not correct");
        Fact(and23::numVars == 3, "Number of variables in truth table is not correct");
    }

    operation T13_TTOr_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference(); // REVERT
        let or12 = TTOr_Reference(x1, x2); // REVERT
        let or13 = TTOr_Reference(x1, x3); // REVERT
        let or23 = TTOr_Reference(x2, x3); // REVERT
        Fact(or12::bits == 0b11101110, "Truth table of x1 ∨ x2 is not correct");
        Fact(or13::bits == 0b11111010, "Truth table of x1 ∨ x3 is not correct");
        Fact(or23::bits == 0b11111100, "Truth table of x2 ∨ x3 is not correct");
        Fact(or12::numVars == 3, "Number of variables in truth table is not correct");
        Fact(or13::numVars == 3, "Number of variables in truth table is not correct");
        Fact(or23::numVars == 3, "Number of variables in truth table is not correct");
    }

    operation T14_TTXor_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference(); // REVERT
        let xor12 = TTXor_Reference(x1, x2); // REVERT
        let xor13 = TTXor_Reference(x1, x3); // REVERT
        let xor23 = TTXor_Reference(x2, x3); // REVERT
        Fact(xor12::bits == 0b01100110, "Truth table of x1 ⊕ x2 is not correct");
        Fact(xor13::bits == 0b01011010, "Truth table of x1 ⊕ x3 is not correct");
        Fact(xor23::bits == 0b00111100, "Truth table of x2 ⊕ x3 is not correct");
        Fact(xor12::numVars == 3, "Number of variables in truth table is not correct");
        Fact(xor13::numVars == 3, "Number of variables in truth table is not correct");
        Fact(xor23::numVars == 3, "Number of variables in truth table is not correct");
    }

    operation T15_TTNot_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference(); // REVERT
        let not1 = TTNot_Reference(x1); // REVERT
        let not2 = TTNot_Reference(x2); // REVERT
        let not3 = TTNot_Reference(x3); // REVERT
        Fact(not1::bits == 0b01010101, "Truth table of ¬x1 is not correct");
        Fact(not2::bits == 0b00110011, "Truth table of ¬x2 is not correct");
        Fact(not3::bits == 0b00001111, "Truth table of ¬x3 is not correct");
        Fact(not1::numVars == 3, "Number of variables in truth table is not correct");
        Fact(not2::numVars == 3, "Number of variables in truth table is not correct");
        Fact(not3::numVars == 3, "Number of variables in truth table is not correct");
    }

    operation T16_IfThenElseTruthTable_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let y = TTIfThenElse_Reference(x1, x2, x3); // REVERT
        Fact(y::numVars == 3, "Number of variables in truth table is not correct");
        Fact(y::bits == 0b11011000, "Truth table is not correct");
    }

    operation T17_AllMinterms_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let minterms = AllMinterms_Reference(TTIfThenElse_Reference(x1, x2, x3)); // REVERT
        EqualityFactI(Length(minterms), 4, "Number of minterms is not correct");
        for (minterm in [3, 4, 6, 7]) {
            Fact(IndexOf(EqualI(minterm, _), minterms) != -1, "Some minterm is not correct");
        }
    }
}


