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

    @Test("QuantumSimulator")
    operation T01_ProjectiveTruthTables () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables();
        EqualityFactTT(x1, TruthTable(0b10101010, 3), "x₁");
        EqualityFactTT(x2, TruthTable(0b11001100, 3), "x₂");
        EqualityFactTT(x3, TruthTable(0b11110000, 3), "x₃");
    }

    @Test("QuantumSimulator")
    operation T02_ExactlyOneBitTrue () : Unit {
        let f = ExactlyOneBitTrue();
        EqualityFactTT(f, TruthTable(0b00010110, 3), "\"Exactly one bit is true\" function");
    }

    @Test("QuantumSimulator")
    operation T03_ExactlyTwoBitsTrue () : Unit {
        let f = ExactlyTwoBitsTrue();
        EqualityFactTT(f, TruthTable(0b01101000, 3), "\"Exactly two bits are true\" function");
    }

    @Test("QuantumSimulator")
    operation T04_TTAnd () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTAnd(x1, x2), TruthTable(0b10001000, 3), "x₁ ∧ x₂");
        EqualityFactTT(TTAnd(x1, x3), TruthTable(0b10100000, 3), "x₁ ∧ x₃");
        EqualityFactTT(TTAnd(x2, x3), TruthTable(0b11000000, 3), "x₂ ∧ x₃");
    }

    @Test("QuantumSimulator")
    operation T05_TTOr () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTOr(x1, x2), TruthTable(0b11101110, 3), "x₁ ∨ x₂");
        EqualityFactTT(TTOr(x1, x3), TruthTable(0b11111010, 3), "x₁ ∨ x₃");
        EqualityFactTT(TTOr(x2, x3), TruthTable(0b11111100, 3), "x₂ ∨ x₃");
    }

    @Test("QuantumSimulator")
    operation T06_TTXor () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTXor(x1, x2), TruthTable(0b01100110, 3), "x₁ ⊕ x₂");
        EqualityFactTT(TTXor(x1, x3), TruthTable(0b01011010, 3), "x₁ ⊕ x₃");
        EqualityFactTT(TTXor(x2, x3), TruthTable(0b00111100, 3), "x₂ ⊕ x₃");
    }

    @Test("QuantumSimulator")
    operation T07_TTNot () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTNot(x1), TruthTable(0b01010101, 3), "¬x₁");
        EqualityFactTT(TTNot(x2), TruthTable(0b00110011, 3), "¬x₂");
        EqualityFactTT(TTNot(x3), TruthTable(0b00001111, 3), "¬x₃");
    }

    @Test("QuantumSimulator")
    operation T08_IfThenElseTruthTable () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        EqualityFactTT(TTIfThenElse(x1, x2, x3), TruthTable(0b11011000, 3), "if x₁ then x₂ else x₃");
    }

    @Test("QuantumSimulator")
    operation T09_AllMinterms () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let testTT = TTIfThenElse_Reference(x1, x2, x3);
        Message($"Testing on truth table {testTT}");
        let minterms = AllMinterms(testTT);
        EqualityFactI(Length(minterms), 4, "Number of minterms is not correct");
        for minterm in [3, 4, 6, 7] {
            Fact(IndexOf(EqualI(minterm, _), minterms) != -1, $"Minterm {minterm} should be part of the result");
        }
    }

    operation _ApplyFunctionWrap (op : ((Qubit[], Qubit) => Unit is Adj), qubits : Qubit[]) : Unit is Adj {
        op(Most(qubits), Tail(qubits));
    }

    @Test("QuantumSimulator")
    operation T10_ApplyFunction () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();
        let tt = TTIfThenElse_Reference(x1, x2, x3);
        let opUser = _ApplyFunctionWrap(ApplyXControlledOnFunction(tt, _, _), _);
        let opRef = _ApplyFunctionWrap(ApplyXControlledOnFunction_Reference(tt, _, _), _);
        AssertOperationsEqualReferenced(4, opUser, opRef);
    }
}


