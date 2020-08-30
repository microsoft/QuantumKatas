// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Random;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////

    operation T11_DiagonalBasis_Test () : Unit {
        for (i in 1 .. 5) {
            AssertOperationsEqualReferenced(i, DiagonalBasis, DiagonalBasis_Reference);
        }
    }


    operation T12_EqualSuperposition_Test () : Unit {
        using (q = Qubit()) {
            EqualSuperposition(q);
            DumpMachine();
            AssertMeasurementProbability([PauliZ], [q], One, 0.5, "Measuring should produce 0 and 1 with 50/50 chance.", 1e-5);
            Reset(q);
        }
    }
  

    //////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////

    operation T21_RandomArray_Test () : Unit {
        // The test checks that the operation does not return always the same array.
        let N = 30;
        let randomArrays = ForEach(RandomArray, [N, N, N]);

        for (array in randomArrays) {
            Fact(Length(array) == N, "Returned array should be of the given length");
        }

        let randomInts = Mapped(BoolArrayAsInt, randomArrays);
        Fact(randomInts[0] != randomInts[1] or randomInts[1] != randomInts[2] or randomInts[0] != randomInts[2], 
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
        // Hard-coded test to validate that the solution checks the right relation with error rate
        mutable key1 = ConstantArray(10, false);
        mutable key2 = key1 w/ 3 <- true;
        mutable errorRate = 15;
        mutable result = CheckKeysMatch(key1, key2, errorRate);
        // 10% mismatch with 15% error rate should pass
        Fact(result, $"Check for {key1} vs {key2} with errorRate {errorRate}% should return {true}, returned {result}");

        set key2 w/= 5 <- true;
        set result = CheckKeysMatch(key1, key2, errorRate);
        // 20% mismatch with 15% error rate should fail
        Fact(not result, $"Check for {key1} vs {key2} with errorRate {errorRate}% should return {false}, returned {result}");

        for (i in 10 .. 30) {
            set (key1, key2) = GenerateRandomState(i);
            set errorRate = DrawRandomInt(0, 49);
            let expected = CheckKeysMatch_Reference(key1, key2, errorRate);
            set result = CheckKeysMatch(key1, key2, errorRate);

            Fact(expected == result, $"Check for {key1} vs {key2} with errorRate {errorRate}% should return {expected}, returned {result}");
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
