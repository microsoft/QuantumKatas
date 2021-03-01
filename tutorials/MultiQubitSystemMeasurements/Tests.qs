// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SingleQubitSystemMeasurements {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Random;

    open Quantum.Kata.Utils;
    // ------------------------------------------------------

    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return
    operation DistinguishStates_MultiQubit (nQubits : Int,
                                            nStates : Int,
                                            statePrep : ((Qubit[], Int) => Unit),
                                            testImpl : (Qubit[] => Int),
                                            stateNames : String[]) : Unit {
        let nTotal = 100;
        // misclassifications will store the number of times state i has been classified as state j (dimension nStates^2)
        mutable misclassifications = new Int[nStates * nStates];
        // unknownClassifications will store the number of times state i has been classified as some invalid state (index < 0 or >= nStates)
        mutable unknownClassifications = new Int[nStates];
                
        use qs = Qubit[nQubits];
        for _ in 1 .. nTotal {
            // get a random integer to define the state of the qubits
            let state = DrawRandomInt(0, nStates - 1);

            // do state prep: convert |0...0⟩ to outcome with return equal to state
            statePrep(qs, state);

            // if (measurementsPerRun > 0) {
            //     ResetOracleCallsCount();
            // }
            // get the solution's answer and verify that it's a match, if not, increase the exact mismatch count
            let ans = testImpl(qs);
            if ((ans >= 0) and (ans < nStates)) {
                // classification result is a valid state index - check if is it correct
                if (ans != state) {
                    set misclassifications w/= ((state * nStates) + ans) <- (misclassifications[(state * nStates) + ans] + 1);
                }
            }
            else {
                // classification result is an invalid state index - file it separately
                set unknownClassifications w/= state <- (unknownClassifications[state] + 1);  
            }
            // if we have a max number of measurements per solution run specified, check that it is not exceeded
            // if (measurementsPerRun > 0) {
            //     let nm = GetOracleCallsCount(Measure);
            //     EqualityFactB(nm <= 1, true, $"You are allowed to do at most one measurement, and you did {nm}");
            // }

            // we're not checking the state of the qubit after the operation
            ResetAll(qs);
        }
        
        mutable totalMisclassifications = 0;
        for i in 0 .. nStates - 1 {
            for j in 0 .. nStates - 1 {
                if (misclassifications[(i * nStates) + j] != 0) {
                    set totalMisclassifications += misclassifications[i * nStates + j];
                    Message($"Misclassified {stateNames[i]} as {stateNames[j]} in {misclassifications[(i * nStates) + j]} test runs.");
                }
            }
            if (unknownClassifications[i] != 0) {
                set totalMisclassifications += unknownClassifications[i];
                Message($"Misclassified {stateNames[i]} as Unknown State in {unknownClassifications[i]} test runs.");
            }
        }
        // This check will tell the total number of failed classifications
        Fact(totalMisclassifications == 0, $"{totalMisclassifications} test runs out of {nTotal} returned incorrect state (see output for details).");
    }


    // ------------------------------------------------------
    // Exercise 3: Distinguish four basis states
    // ------------------------------------------------------
    operation StatePrep_BasisStateMeasurement (qs : Qubit[], state : Int) : Unit {
        if (state / 2 == 1) {
            // |10⟩ or |11⟩
            X(qs[0]);
        }
        if (state % 2 == 1) {
            // |01⟩ or |11⟩
            X(qs[1]);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    @Test("QuantumSimulator")
    operation T1_BasisStateMeasurement () : Unit {
        DistinguishStates_MultiQubit(2, 4, StatePrep_BasisStateMeasurement, BasisStateMeasurement, ["|00⟩", "|01⟩", "|10⟩", "|11⟩"]);
    }

    // ------------------------------------------------------

}