// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.TruthTables {
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;

    operation T1_ProjectiveTruthTables_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables();
        Fact(x1::bits == 0b10101010, "Truth table of x1 is not correct");
        Fact(x2::bits == 0b11001100, "Truth table of x2 is not correct");
        Fact(x3::bits == 0b11110000, "Truth table of x3 is not correct");
        Fact(x1::numVars == 3, "Number of variables of x1 is not correct");
        Fact(x2::numVars == 3, "Number of variables of x2 is not correct");
        Fact(x3::numVars == 3, "Number of variables of x3 is not correct");
    }

    operation T2_TTAnd_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let and12 = TTAnd(x1, x2);
        let and13 = TTAnd(x1, x3);
        let and23 = TTAnd(x2, x3);
        Fact(and12::bits == 0b10001000, "Truth table of x1 ∧ x2 is not correct");
        Fact(and13::bits == 0b10100000, "Truth table of x1 ∧ x3 is not correct");
        Fact(and23::bits == 0b11000000, "Truth table of x2 ∧ x3 is not correct");
        Fact(and12::numVars == 3, "Number of variables in truth table is not correct");
        Fact(and13::numVars == 3, "Number of variables in truth table is not correct");
        Fact(and23::numVars == 3, "Number of variables in truth table is not correct");
    }

    operation T3_TTOr_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let or12 = TTOr(x1, x2);
        let or13 = TTOr(x1, x3);
        let or23 = TTOr(x2, x3);
        Fact(or12::bits == 0b11101110, "Truth table of x1 ∨ x2 is not correct");
        Fact(or13::bits == 0b11111010, "Truth table of x1 ∨ x3 is not correct");
        Fact(or23::bits == 0b11111100, "Truth table of x2 ∨ x3 is not correct");
        Fact(or12::numVars == 3, "Number of variables in truth table is not correct");
        Fact(or13::numVars == 3, "Number of variables in truth table is not correct");
        Fact(or23::numVars == 3, "Number of variables in truth table is not correct");
    }

    operation T4_TTXor_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let xor12 = TTXor(x1, x2);
        let xor13 = TTXor(x1, x3);
        let xor23 = TTXor(x2, x3);
        Fact(xor12::bits == 0b01100110, "Truth table of x1 ⊕ x2 is not correct");
        Fact(xor13::bits == 0b01011010, "Truth table of x1 ⊕ x3 is not correct");
        Fact(xor23::bits == 0b00111100, "Truth table of x2 ⊕ x3 is not correct");
        Fact(xor12::numVars == 3, "Number of variables in truth table is not correct");
        Fact(xor13::numVars == 3, "Number of variables in truth table is not correct");
        Fact(xor23::numVars == 3, "Number of variables in truth table is not correct");
    }

    operation T5_TTNot_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let not1 = TTNot(x1);
        let not2 = TTNot(x2);
        let not3 = TTNot(x3);
        Fact(not1::bits == 0b01010101, "Truth table of ¬x1 is not correct");
        Fact(not2::bits == 0b00110011, "Truth table of ¬x2 is not correct");
        Fact(not3::bits == 0b00001111, "Truth table of ¬x3 is not correct");
        Fact(not1::numVars == 3, "Number of variables in truth table is not correct");
        Fact(not2::numVars == 3, "Number of variables in truth table is not correct");
        Fact(not3::numVars == 3, "Number of variables in truth table is not correct");
    }

    operation T6_IfThenElseTruthTable_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let y = TTIfThenElse(x1, x2, x3);
        Fact(y::numVars == 3, "Number of variables in truth table is not correct");
        Fact(y::bits == 0b11011000, "Truth table is not correct");
    }

    operation T7_AllMinterms_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let minterms = AllMinterms(TTIfThenElse_Reference(x1, x2, x3));
        EqualityFactI(Length(minterms), 4, "Number of minterms is not correct");
        for (minterm in [3, 4, 6, 7]) {
            Fact(IndexOf(EqualI(minterm, _), minterms) != -1, "Some minterm is not correct");
        }
    }

    operation _ApplyFunctionWrap (op : ((Qubit[], Qubit) => Unit is Adj), qubits : Qubit[]) : Unit is Adj {
        op(Most(qubits), Tail(qubits));
    }

    operation T8_ApplyFunction_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let tt = TTIfThenElse_Reference(x1, x2, x3);
        let opUser = _ApplyFunctionWrap(ApplyFunction(tt, _, _), _);
        let opRef = _ApplyFunctionWrap(ApplyFunction_Reference(tt, _, _), _);
        AssertOperationsEqualReferenced(4, opUser, opRef);
    }
}


