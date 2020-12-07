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
    open Microsoft.Quantum.Convert;

    open Quantum.Kata.Utils;

    // ------------------------------------------------------
    // Helper functions
    operation ApplyOracle (qs : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj + Ctl)) : Unit
    is Adj + Ctl {
        let N = Length(qs);
        oracle(qs[0 .. N - 2], qs[N - 1]);
    }

    operation AssertTwoOraclesAreEqual (nQubits : Range, 
        oracle1 : ((Qubit[], Qubit) => Unit is Adj + Ctl), 
        oracle2 : ((Qubit[], Qubit) => Unit is Adj + Ctl)) : Unit {
        let sol = ApplyOracle(_, oracle1);
        let refSol = ApplyOracle(_, oracle2);
        
        for (i in nQubits) {
            AssertOperationsEqualReferenced(i + 1, sol, refSol);
        }
    }


    // ------------------------------------------------------
    function Check_Classical_Oracle(x: Bool[]) : Unit {
        let actual = Is_Seven(x);
        let expected = Is_Seven_Reference(x);

        if (actual != expected) {
            fail $"    Failed on test case x = {x}. got {actual}, expected {expected}";
        }
    }
    
    @Test("QuantumSimulator")
    function E1_Classical_Oracle() : Unit {
        for (N in 1..4) {
            for (k in 0..((2^N)-1)) {
                let x = IntAsBoolArray(k, N);

                Check_Classical_Oracle(x);
            }           
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E2_Phase_Quantum_Oracle() : Unit {
        AssertOperationsEqualReferenced(3, Phase_7_Oracle, Phase_7_Oracle_Reference);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E3_Marking_Quantum_Oracle() : Unit {
        AssertTwoOraclesAreEqual(1..10, Marking_7_Oracle, Marking_7_Oracle_Reference);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E4_Apply_Phase_Oracle() : Unit {
        for (N in 1..5) {
            AssertOperationsEqualReferenced(N, 
                                            Oracle_Converter(Marking_7_Oracle_Reference),
                                            Oracle_Converter_Reference(Marking_7_Oracle_Reference));

            AssertOperationsEqualReferenced(N, 
                                            Oracle_Converter(Or_Oracle_Reference),
                                            Oracle_Converter_Reference(Or_Oracle_Reference));
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E5_Or_Oracle() : Unit {
        AssertTwoOraclesAreEqual(1..10, Or_Oracle, Or_Oracle_Reference);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E6_kth_Spin_Up() : Unit {
        for (N in 1..5) {
            for (k in 0..(N-1)) {
                AssertOperationsEqualReferenced(N,
                                                kth_Spin_Up(_, k),
                                                kth_Spin_Up_Reference(_, k));
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E7_kth_Excluded_Or() : Unit {
        for (N in 1..5) {
            for (k in 0..(N-1)) {
                AssertOperationsEqualReferenced(N,
                                                kth_Excluded_Or(_, k),
                                                kth_Excluded_Or_Reference(_, k));
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E8_Arbitrary_Pattern_Oracle() : Unit {
        for (N in 1..4) {
            for (k in 0..((2^N)-1)) {
                let pattern = IntAsBoolArray(k, N);

                AssertTwoOraclesAreEqual(N..N, Arbitrary_Pattern_Oracle(_, _, pattern),
                                        Arbitrary_Pattern_Oracle_Reference(_, _, pattern));
            }
        }    
    }

    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E9_Arbitrary_Pattern_Oracle_Challenge() : Unit {
        for (N in 1..4) {
            for (k in 0..((2^N)-1)) {
                let pattern = IntAsBoolArray(k, N);

                within {
                    AllowAtMostNQubits(2*N, "You are not allowed to allocate extra qubits");
                } apply {
                    AssertOperationsEqualReferenced(N,
                                                    Arbitrary_Pattern_Oracle_Challenge(_, pattern),
                                                    Arbitrary_Pattern_Oracle_Challenge_Reference(_, pattern));
                }
            }           
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E10_Meeting_Oracle() : Unit {
        for (N in 1..4) {
            using (jasmine = Qubit[N]) {
                for (k in 0..(2^N-1)) {
                    let binaryJasmine = IntAsBoolArray(k, N);

                    within {
                        ApplyPauliFromBitString(PauliX, true, binaryJasmine, jasmine);
                    } apply {
                        AssertTwoOraclesAreEqual(1..N, Meeting_Oracle(_, jasmine, _),
                                                Meeting_Oracle_Reference(_, jasmine, _)); 
                    }                 
                }
            }
        }
    }
}
    