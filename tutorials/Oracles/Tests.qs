// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Oracles {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    open Quantum.Kata.Utils;

    // ------------------------------------------------------
    // Helper functions


    // ------------------------------------------------------
    function Check_Classical_Oracle(x: String, expected: Bool) : Unit {
        let actual = Is_Seven(x);

        if (actual != expected) {
            fail $"    Failed on test case x = {x}. got {actual}, expected {expected}";
        }
    }
    
    @Test("QuantumSimulator")
    function E1_Classical_Oracle() : Unit {
        Check_Classical_Oracle("111", true);
        Check_Classical_Oracle("010101", false);
        Check_Classical_Oracle("0", false);
        Check_Classical_Oracle("1000111", false);
        Check_Classical_Oracle("1110", false);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E2_Phase_Quantum_Oracle() : Unit {
        AssertOperationsEqualReferenced(3,
                                        Phase_7_Oracle,
                                        Phase_7_Oracle_Reference);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E3_Marking_Quantum_Oracle() : Unit {
        AssertOperationsEqualReferenced(3, 
                                        Oracle_Converter_Reference(Marking_7_Oracle),
                                        Oracle_Converter_Reference(Marking_7_Oracle_Reference));
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E4_Apply_Phase_Oracle() : Unit {
        for (N in 1..5) {
            AssertOperationsEqualReferenced(N, 
                                            Oracle_Converter(Marking_7_Oracle),
                                            Oracle_Converter_Reference(Marking_7_Oracle));
                                            
            AssertOperationsEqualReferenced(N, 
                                            Oracle_Converter(Marking_7_Oracle_Reference),
                                            Oracle_Converter_Reference(Marking_7_Oracle_Reference));
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E5_Or_Oracle() : Unit {
        for (N in 1..5) {
            AssertOperationsEqualReferenced(N, 
                                            Oracle_Converter_Reference(Or_Oracle),
                                            Oracle_Converter_Reference(Or_Oracle_Reference));
        }
    }


    // ------------------------------------------------------
    operation kth_Element_Apply_Oracle(phaseOracle: ((Qubit[], Int) => Unit is Adj), qubits: Qubit[], n: Int) : Unit
    is Adj {
        phaseOracle(qubits, n);
    }

    function kth_Element_Oracle_Converter(phaseOracle: ((Qubit[], Int) => Unit is Adj), n: Int) : (Qubit[] => Unit is Adj) {
        return kth_Element_Apply_Oracle(phaseOracle, _, n);
    }
    
    @Test("QuantumSimulator")
    operation E6_kth_Spin_Up() : Unit {
        for (N in 1..5) {
            AssertOperationsEqualReferenced(7,
                                            kth_Element_Oracle_Converter(kth_Spin_Up, N),
                                            kth_Element_Oracle_Converter(kth_Spin_Up_Reference, N));
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E7_kth_Excluded_Or() : Unit {
        for (N in 1..5) {
            AssertOperationsEqualReferenced(7,
                                            kth_Element_Oracle_Converter(kth_Excluded_Or, N),
                                            kth_Element_Oracle_Converter(kth_Excluded_Or_Reference, N));
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E8_Arbitrary_Pattern_Oracle() : Unit {
        
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E9_Meeting_Oracle() : Unit {

    }
}
    