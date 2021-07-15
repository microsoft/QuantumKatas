// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Oracles {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    open Quantum.Kata.Utils;

    // ------------------------------------------------------
    // Helper functions
    operation ApplyOracle (qs : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj + Ctl)) : Unit is Adj + Ctl {
        let N = Length(qs);
        oracle(qs[0 .. N - 2], qs[N - 1]);
    }

    operation AssertTwoOraclesAreEqual (nQubits : Range,
        oracle1 : ((Qubit[], Qubit) => Unit is Adj + Ctl),
        oracle2 : ((Qubit[], Qubit) => Unit is Adj + Ctl)) : Unit {
        let sol = ApplyOracle(_, oracle1);
        let refSol = ApplyOracle(_, oracle2);

        for i in nQubits {
            AssertOperationsEqualReferenced(i + 1, sol, refSol);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    function T11_IsSeven_ClassicalOracle () : Unit {
        let N = 3;
        for k in 0..((2^N)-1) {
            let x = IntAsBoolArray(k, N);

            let actual = IsSeven(x);
            let expected = IsSeven_Reference(x);

            Fact(actual == expected, $"    Failed on test case x = {x}: got {actual}, expected {expected}");
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T12_IsSeven_PhaseOracle () : Unit {
        let N = 3;
        within {
            AllowAtMostNQubits(2*N, "You are not allowed to allocate extra qubits");
        } apply {
            AssertOperationsEqualReferenced(N, IsSeven_PhaseOracle, IsSeven_PhaseOracle_Reference);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T13_IsSeven_MarkingOracle () : Unit {
        AssertTwoOraclesAreEqual(3..3, IsSeven_MarkingOracle, IsSeven_MarkingOracle_Reference);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T21_ApplyMarkingOracleAsPhaseOracle () : Unit {
        for N in 1..5 {
            for k in 0..(2^N-1) {
                let pattern = IntAsBoolArray(k, N);

                AssertOperationsEqualReferenced(N,
                                                Oracle_Converter(ArbitraryBitPattern_Oracle_Reference(_, _, pattern)),
                                                Oracle_Converter_Reference(ArbitraryBitPattern_Oracle_Reference(_, _, pattern)));
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T31_Or_Oracle () : Unit {
        AssertTwoOraclesAreEqual(1..10, Or_Oracle, Or_Oracle_Reference);
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T32_KthBit_Oracle () : Unit {
        for N in 1..5 {
            for k in 0..(N-1) {
                within {
                    AllowAtMostNQubits(2*N, "You are not allowed to allocate extra qubits");
                } apply {
                    AssertOperationsEqualReferenced(N,
                                                KthBit_Oracle(_, k),
                                                KthBit_Oracle_Reference(_, k));
                }
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T33_OrOfBitsExceptKth_Oracle () : Unit {
        for N in 1..5 {
            for k in 0..(N-1) {
                AssertOperationsEqualReferenced(N,
                                                OrOfBitsExceptKth_Oracle(_, k),
                                                OrOfBitsExceptKth_Oracle_Reference(_, k));
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T41_ArbitraryBitPattern_Oracle () : Unit {
        for N in 1..4 {
            for k in 0..((2^N)-1) {
                let pattern = IntAsBoolArray(k, N);

                AssertTwoOraclesAreEqual(N..N, ArbitraryBitPattern_Oracle(_, _, pattern),
                                        ArbitraryBitPattern_Oracle_Reference(_, _, pattern));
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T42_ArbitraryBitPattern_Oracle_Challenge () : Unit {
        for N in 1..4 {
            for k in 0..((2^N)-1) {
                let pattern = IntAsBoolArray(k, N);

                within {
                    AllowAtMostNQubits(2*N, "You are not allowed to allocate extra qubits");
                } apply {
                    AssertOperationsEqualReferenced(N,
                                                    ArbitraryBitPattern_Oracle_Challenge(_, pattern),
                                                    ArbitraryBitPattern_Oracle_Challenge_Reference(_, pattern));
                }
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T43_Meeting_Oracle () : Unit {
        for N in 1..4 {
            use jasmine = Qubit[N];
            for k in 0..(2^N-1) {
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
