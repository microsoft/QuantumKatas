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

    function EqualityFactTT (actual : TruthTable, expected : TruthTable, name : String) : Unit {
        Fact(actual::numVars == expected::numVars, $"Number of variables in truth table for {name} is not correct");
        Fact(actual::bits == expected::bits, $"Truth table for {name} is not correct");
    }

    operation T1_ProjectiveTruthTables_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables();
        EqualityFactTT(x1, TruthTable(0b10101010, 3), "x₁");
        EqualityFactTT(x2, TruthTable(0b11001100, 3), "x₂");
        EqualityFactTT(x3, TruthTable(0b11110000, 3), "x₃");
    }

    operation T2_TTAnd_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTAnd(x1, x2), TruthTable(0b10001000, 3), "x₁ ∧ x₂");
        EqualityFactTT(TTAnd(x1, x3), TruthTable(0b10100000, 3), "x₁ ∧ x₃");
        EqualityFactTT(TTAnd(x2, x3), TruthTable(0b11000000, 3), "x₂ ∧ x₃");
    }

    operation T3_TTOr_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTOr(x1, x2), TruthTable(0b11101110, 3), "x₁ ∨ x₂");
        EqualityFactTT(TTOr(x1, x3), TruthTable(0b11111010, 3), "x₁ ∨ x₃");
        EqualityFactTT(TTOr(x2, x3), TruthTable(0b11111100, 3), "x₂ ∨ x₃");
    }

    operation T4_TTXor_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTXor(x1, x2), TruthTable(0b01100110, 3), "x₁ ⊕ x₂");
        EqualityFactTT(TTXor(x1, x3), TruthTable(0b01011010, 3), "x₁ ⊕ x₃");
        EqualityFactTT(TTXor(x2, x3), TruthTable(0b00111100, 3), "x₂ ⊕ x₃");
    }

    operation T5_TTNot_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTNot(x1), TruthTable(0b01010101, 3), "¬x₁");
        EqualityFactTT(TTNot(x2), TruthTable(0b00110011, 3), "¬x₂");
        EqualityFactTT(TTNot(x3), TruthTable(0b00001111, 3), "¬x₃");
    }

    operation T6_IfThenElseTruthTable_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTIfThenElse(x1, x2, x3), TruthTable(0b11011000, 3), "if x₁ then x₂ else x₃");
    }

    operation T7_AllMinterms_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let testTT = TTIfThenElse_Reference(x1, x2, x3);
        Message($"Testing on truth table {testTT}");
        let minterms = AllMinterms(testTT);
        EqualityFactI(Length(minterms), 4, "Number of minterms is not correct");
        for (minterm in [3, 4, 6, 7]) {
            Fact(IndexOf(EqualI(minterm, _), minterms) != -1, $"Minterm {minterm} should be part of the result");
        }
    }

    operation _ApplyFunctionWrap (op : ((Qubit[], Qubit) => Unit is Adj), qubits : Qubit[]) : Unit is Adj {
        op(Most(qubits), Tail(qubits));
    }

    operation T8_ApplyFunction_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let tt = TTIfThenElse_Reference(x1, x2, x3);
        let opUser = _ApplyFunctionWrap(ApplyXControlledOnFunction(tt, _, _), _);
        let opRef = _ApplyFunctionWrap(ApplyXControlledOnFunction_Reference(tt, _, _), _);
        AssertOperationsEqualReferenced(4, opUser, opRef);
    }
}


