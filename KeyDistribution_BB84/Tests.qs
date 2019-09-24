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
	operation Task11_Test () : Unit {
        for (i in 1 .. 5) {
            AssertOperationsEqualReferenced(i, Task11, Task11_Reference);
        }
    }


    operation Task12_Test () : Unit {
        using (q = Qubit()) {
            Task12(q);
            AssertProb([PauliZ], [q], One, 0.5, "Measuring did not give 50/50 results.", 1e-5);
            Reset(q);
        }
    }
  

    //////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////

    operation GenerateRandomState(N : Int) : (Bool[], Bool[]) {
        mutable basis = new Bool[N];
        mutable state = new Bool[N];

        for (i in 0..N- 1) {
            set basis w/= i <- RandomInt(2) == 1;
            set state w/= i <- RandomInt(2) == 1;
        }

        return (basis, state);
    }


    operation Task21_Test() : Unit {
        let N = 7;
        let basis = Task21_ChooseBasis(N);
        Fact(N == Length(basis), "Returned array should be of the given length");

        let basis2 = Task21_ChooseBasis(N);
        Fact(N == Length(basis), "Returned array should be of the given length");
        Fact(BoolArrayAsInt(basis) != BoolArrayAsInt(basis2), 
			"Random generation should not return equal arrays. Run again to see if problem goes away");

        let basis3 = Task21_ChooseBasis(N);
        Fact(N == Length(basis), "Returned array should be of the given length");
        Fact(BoolArrayAsInt(basis2) != BoolArrayAsInt(basis3), 
		    "Random generation should not return equal arrays. Run again to see if problem goes away");
		Fact(BoolArrayAsInt(basis) != BoolArrayAsInt(basis3), 
		    "Random generation should not return equal arrays. Run again to see if problem goes away");
    }
    

    operation Task22_Test() : Unit {
        using (qs = Qubit[2]) {
            for (i in 0..3) {
			    let basis = IntAsBoolArray(i, 2);
			    for (j in 0..3) {
				    let state = IntAsBoolArray(j, 2);
				    Task22_PrepareAlice(qs, basis, state);
                    Adjoint Task22_PrepareAlice_Reference(qs, basis, state);
                    AssertAllZero(qs);
			    }
                ResetAll(qs);
            }
        }

        using (qs = Qubit[7]) {
            let basis = [false, true, true, false, false, true, false];
            let state = [true, true, false, true, false, false, true];

            Task22_PrepareAlice(qs, basis, state);
            Adjoint Task22_PrepareAlice_Reference(qs, basis, state);
            AssertAllZero(qs);
            
            ResetAll(qs);
        }
    }


    operation Task23_Test() : Unit {
        let N = 7;
    
        using (qs = Qubit[N]) {
            for (iter in 1..5) {
                let (basis, state) = GenerateRandomState(N);

                Task22_PrepareAlice_Reference(qs, basis, state);
                let result = Task23_Measure(qs, basis);
                
                for (i in 0..N - 1) {
                    Fact(result[i] == state[i], "Measured in wrong basis");
                }
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
