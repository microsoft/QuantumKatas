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


    operation T22_PrepareAlicesQubits_Test() : Unit {
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
    operation T23_MeasureBobsQubits_Test() : Unit {
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


    operation Task24_Test() : Unit {
		for (i in 5..9) {
			let (basis1, state) = GenerateRandomState(i);
			let (basis2, state2) = GenerateRandomState(i);
			let expected = Task24_GenerateKey_Reference(basis1, basis2, state);
			let result = Task24_GenerateKey(basis1, basis2, state);

			Fact(Length(result) == Length(expected), $"key should be length {Length(expected)}");
		    for (j in 0..Length(expected) - 1) {
			    Fact(result[j] == expected[j], "Unexpected key value");
            }
		}        
    }


    operation Task25_Test() : Unit {
		let (p1, p2) = (0.66, 0.85);

		for (i in 5..9) {
			let (key1, key2) = GenerateRandomState(i);
			let result1 = Task25_CheckKeysMatch_Reference(key1, key2, p1);
			let result2 = Task25_CheckKeysMatch_Reference(key1, key2, p2);

			Fact(Task25_CheckKeysMatch(key1, key2, p1) == result1, $"Should return {result1}");
			Fact(Task25_CheckKeysMatch(key1, key2, p2) == result2, $"Should return {result2}");
		}
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    operation Task31_Test () : Unit {
        using (q = Qubit()) {
            mutable res = 0;
            // q = 0, Real value: b = rectangular, Input: b = rectangular
            set res = Task31(q, false);
            Fact(res == 0, $"Incorrect result: {res}");
            Reset(q);

            // q = 0, Real value: b = diagonal, Input: b = diagonal 
            H(q);
            set res = Task31(q, true);
            Fact(res == 0, $"Incorrect result: {res}");
            Reset(q);

            // q = 1, Real value: b = rectangular, Input: b = rectangular 
            X(q);
            set res = Task31(q, false);
            Fact(res == 1, $"Incorrect result: {res}");
            Reset(q);

            // q = 1, Real value: b = diagonal, Input: b = diagonal 
            X(q);
            H(q);
            set res = Task31(q, true);
            Fact(res == 1, $"Incorrect result: {res}");
            Reset(q);
        }
    }


    operation Task32_Test () : Unit {
        mutable emptyKeys = 0;
        for (i in 0 .. 9) {
            using (qs = Qubit[7]) {
                let key = Task32(qs,  0.8);
                set emptyKeys = emptyKeys + (Length(key) == 0 ? 1 | 0);

                ResetAll(qs);
            }
        }
        
        Fact(emptyKeys != 0, "Should return some empty keys");
        Fact(emptyKeys != 10, "Should return some nonempty keys");
    }
}
