// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////

    operation T11_DiagonalPolarization_Test () : Unit {
        for (i in 1 .. 5) {
            AssertOperationsEqualReferenced(i, DiagonalPolarization, DiagonalPolarization_Reference);
        }
    }


    operation T12_EqualSuperposition_Test () : Unit {
        using (q = Qubit()) {
            EqualSuperposition(q);
            DumpMachine(());
            AssertProb([PauliZ], [q], One, 0.5, "Measuring should produce 0 and 1 with 50/50 chance.", 1e-5);
            Reset(q);
        }
    }
  

    //////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////

    operation T21_RandomArray_Test () : Unit {
        // The test checks that the operation does not return always the same array.
        let N = 7;
        let arr1 = RandomArray(N);
        Fact(N == Length(arr1), "Returned array should be of the given length");

        let arr2 = RandomArray(N);
        Fact(N == Length(arr2), "Returned array should be of the given length");
        Fact(BoolArrayAsInt(arr1) != BoolArrayAsInt(arr2), 
            "Random generation should not return equal arrays. Run again to see if problem goes away");

        let arr3 = RandomArray(N);
        Fact(N == Length(arr3), "Returned array should be of the given length");
        Fact(BoolArrayAsInt(arr2) != BoolArrayAsInt(arr3), 
            "Random generation should not return equal arrays. Run again to see if problem goes away");
        Fact(BoolArrayAsInt(arr1) != BoolArrayAsInt(arr3), 
            "Random generation should not return equal arrays. Run again to see if problem goes away");
    }
    

    // ------------------------------------------------------
    // Helper operation to generate two random arrays
    operation GenerateRandomState (N : Int) : (Bool[], Bool[]) {
        return (RandomArray_Reference(N), RandomArray_Reference(N));
    }


    operation T22_PrepareAlicesQubits_Test () : Unit {
        for (N in 2 .. 10) {
            let (bases, state) = GenerateRandomState(N);
            using (qs = Qubit[N]) {
                PrepareAlicesQubits(qs, bases, state);
                Adjoint PrepareAlicesQubits_Reference(qs, bases, state);
                AssertAllZero(qs);
            }
        }
    }


    // ------------------------------------------------------
    operation T23_MeasureBobsQubits_Test () : Unit {
        for (N in 2 .. 10) {
            let (bases, state) = GenerateRandomState(N);
            using (qs = Qubit[N]) {
                // Prepare the input qubits in the given state
                PrepareAlicesQubits_Reference(qs, bases, state);
                // Measure the qubits in the bases used for preparation - this should return encoded state
                let result = MeasureBobsQubits(qs, bases);
                Fact(N == Length(result), "The returned array should have the same length as the inputs");
                Fact(BoolArrayAsInt(state) == BoolArrayAsInt(result), "Some of the measurements were done in the wrong basis");
                ResetAll(qs);
            }
        }
    }


    // ------------------------------------------------------
    operation T24_GenerateSharedKey_Test () : Unit {
        for (N in 10 .. 30) {
            let basesAlice = RandomArray_Reference(N);
            let (basesBob, bitsBob) = GenerateRandomState(N);
            let expected = GenerateSharedKey_Reference(basesAlice, basesBob, bitsBob);
            let result = GenerateSharedKey(basesAlice, basesBob, bitsBob);

            Fact(Length(result) == Length(expected), $"Generated key should have length {Length(expected)}");
            Fact(BoolArrayAsInt(result) == BoolArrayAsInt(expected), "Unexpected key value {result}, expected {expected}");
        }        
    }


    // ------------------------------------------------------
    operation T25_CheckKeysMatch_Test () : Unit {
        for (i in 10 .. 30) {
            let (key1, key2) = GenerateRandomState(i);
            let threshold = RandomInt(50) + 50;
            let expected = CheckKeysMatch_Reference(key1, key2, threshold);
            let result = CheckKeysMatch(key1, key2, threshold);

            Fact(expected == result, $"Check for {key1} vs {key2} with threshold {threshold}% should return {expected}, returned {result}");
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    operation T31_Eavesdrop_Test () : Unit {
        using (q = Qubit()) {
            // q = 0, Real value: b = rectangular, Input: b = rectangular
            let res00 = Eavesdrop(q, false);
            Fact(res00 == false, $"Incorrect result: {res00} (expected False)");
            // check that the qubit was restored to its state
            AssertQubit(Zero, q);

            // q = 0, Real value: b = diagonal, Input: b = diagonal 
            H(q);
            let res01 = Eavesdrop(q, true);
            Fact(res01 == false, $"Incorrect result: {res01} (expected False)");
            // check that the qubit was restored to its state
            H(q);
            AssertQubit(Zero, q);

            // q = 1, Real value: b = rectangular, Input: b = rectangular 
            X(q);
            let res10 = Eavesdrop(q, false);
            Fact(res10 == true, $"Incorrect result: {res10} (expected True)");
            AssertQubit(One, q);
            Reset(q);

            // q = 1, Real value: b = diagonal, Input: b = diagonal 
            X(q);
            H(q);
            let res11 = Eavesdrop(q, true);
            Fact(res11 == true, $"Incorrect result: {res11} (expected True)");
            H(q);
            AssertQubit(One, q);
            Reset(q);
        }
    }
}
