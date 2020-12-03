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
    operation ApplyOracle (qs : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj)) : Unit
    is Adj {
        let N = Length(qs);
        oracle(qs[0 .. N - 2], qs[N - 1]);
    }

    operation AssertTwoOraclesAreEqual (nQubits : Range, 
        oracle1 : ((Qubit[], Qubit) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit) => Unit is Adj)) : Unit {
        let sol = ApplyOracle(_, oracle1);
        let refSol = ApplyOracle(_, oracle2);
        
        for (i in nQubits) {
            AssertOperationsEqualReferenced(i + 1, sol, refSol);
        }
    }

    // https://github.com/microsoft/QuantumKatas/blob/main/DeutschJozsaAlgorithm/Tests.qs#L19


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
        //Check_Classical_Oracle([true, true, true]);
        //Check_Classical_Oracle([false, false, false]);
        //Check_Classical_Oracle([false]);
        //Check_Classical_Oracle([true]);
        //Check_Classical_Oracle([true, false, false, false, true, true, true]);
        //Check_Classical_Oracle([true, true, true, false]);

        for (N in 1..4) {
            for (k in 0..N) {
                let x = IntAsBoolArray(k, N);

                Check_Classical_Oracle(x);
            }           
        }
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
        //AssertOperationsEqualReferenced(3, 
        //                                Oracle_Converter_Reference(Marking_7_Oracle),
        //                                Oracle_Converter_Reference(Marking_7_Oracle_Reference));
        AssertTwoOraclesAreEqual(1..10, Marking_7_Oracle, Marking_7_Oracle_Reference);
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
        AssertTwoOraclesAreEqual(1..10, Or_Oracle, Or_Oracle_Reference);
        // for (N in 1..5) {
        //     AssertOperationsEqualReferenced(N, 
        //                                     Oracle_Converter_Reference(Or_Oracle),
        //                                     Oracle_Converter_Reference(Or_Oracle_Reference));
        // }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E6_kth_Spin_Up() : Unit {
        for (N in 1..5) {
            AssertOperationsEqualReferenced(N,
                                            kth_Spin_Up(_, N/2),
                                            kth_Spin_Up_Reference(_, N/2));
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E7_kth_Excluded_Or() : Unit {
        for (N in 1..5) {
            AssertOperationsEqualReferenced(N,
                                            kth_Excluded_Or(_, N/2),
                                            kth_Excluded_Or_Reference(_, N/2));
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E8_Arbitrary_Pattern_Oracle() : Unit {
        
    }

    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E9_Arbitrary_Pattern_Oracle_Challenge() : Unit {
        for (N in 1..4) {
            for (k in 0..N) {
                //for (j in 0..N) {
                    //let x = IntAsBoolArray(j, N);
                let pattern = IntAsBoolArray(k, N);

                within {
                    AllowAtMostNQubits(N, "You are not allowed to allocate extra qubits");
                } apply {
                    AssertOperationsEqualReferenced(N,
                                                    Arbitrary_Pattern_Oracle_Challenge(_, pattern),
                                                    Arbitrary_Pattern_Oracle_Challenge_Reference(_, pattern));
                }
                //}
            }           
        }
    }

    //@Test("QuantumSimulator")
    //@EntryPoint()
    operation Wills_Test() : Unit {
        for (N in 1..4) {
            for (k in 0..N) {
                //for (j in 0..N) {
                    //let x = IntAsBoolArray(j, N);
                let pattern = IntAsBoolArray(k, N);

                AssertOperationsEqualReferenced(N,
                                                Oracle_Converter_Reference(Arbitrary_Pattern_Oracle_Reference(_, _, pattern)),
                                                Arbitrary_Pattern_Oracle_Challenge_Reference(_, pattern));
                //}
            }           
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation E10_Meeting_Oracle() : Unit {

    }

    //From Mariia Mykhailova to Everyone: 11:17 AM https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arrays.exclude 
    //From Mariia Mykhailova to Everyone: 11:25 AM https://github.com/microsoft/QuantumKatas/blob/main/DeutschJozsaAlgorithm/Tests.qs#L19 
    //From Mariia Mykhailova to Everyone: 11:36 AM https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.intrinsic.r 
    //From Mariia Mykhailova to Everyone: 11:47 AM https://github.com/microsoft/QuantumKatas/pull/560/files 
    //From Mariia Mykhailova to Everyone: 11:55 AM https://github.com/microsoft/QuantumKatas/blob/main/RippleCarryAdder/Tests.qs#L122 
    //From Mariia Mykhailova to Everyone: 12:01 PM https://github.com/microsoft/QuantumKatas/blob/main/GraphColoring/Tests.qs#L66
}
    