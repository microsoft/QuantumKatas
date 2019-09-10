//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Testing;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////
	operation Task11_Test () : Unit {
        for (i in 1 .. 5) {
            AssertOperationsEqualReferenced(Task11, Task11_Reference, i);
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
    operation GenerateRandomState(N : Int) : (Int[], Int[]) {
        mutable basis = new Int[N];
        mutable state = new Int[N];

        for (i in 0..N- 1) {
            set basis w/= i <- RandomInt(2);
            set state w/= i <- RandomInt(2);
        }

        return (basis, state);
    }

	operation CheckElementsInRange0To1(a : Int[]) : Unit {
        for (i in 0..Length(a) - 1) {
            AssertBoolEqual(a[i] <= 1 and a[i] >= 0, true, $"Value at index {i} is not 0 or 1");
        }
    }

    operation CheckNotEqual(a1 : Int[], a2 : Int[]) : Unit {
        mutable equal = true;
        for (i in 0..Length(a1) - 1) {
            if (a1[i] != a2[i]) {
                set equal = false;
            }
        }
        AssertBoolEqual(equal, false, 
            "Random generation should not return equal arrays. RUn again to see if problem goes away");
    }

    operation Task21_Test() : Unit {
        let N = 7;
        let basis = Task21_ChooseBasis(N);
        AssertIntEqual(N, Length(basis), "Returned array should be of the given length");
        CheckElementsInRange0To1(basis);

        let basis2 = Task21_ChooseBasis(N);
        AssertIntEqual(N, Length(basis), "Returned array should be of the given length");
        CheckElementsInRange0To1(basis2);
        CheckNotEqual(basis, basis2);

        let basis3 = Task21_ChooseBasis(N);
        AssertIntEqual(N, Length(basis), "Returned array should be of the given length");
        CheckElementsInRange0To1(basis3);
        CheckNotEqual(basis, basis3);
        CheckNotEqual(basis2, basis3);
    }
    
    operation Task22_Test() : Unit {
        using (qs = Qubit[2]) {
            mutable basis = [0, 0];
            mutable state = [0, 0];
            for (i in 1..16) {
                Task22_PrepareAlice(qs, basis, state);
                Adjoint Task22_PrepareAlice_Reference(qs, basis, state);
                AssertAllZero(qs);
                
                if (i % 4 == 0) {
                    set state w/= (i / 4) % 2 <- (state[(i / 4) % 2] + 1) % 2;
                }
                set basis w/= i % 2 <- (basis[i %2] + 1) % 2;
                ResetAll(qs);
            }
        }

        using (qs = Qubit[7]) {
            let basis = [0, 1, 1, 0, 0, 1, 0];
            let state = [1, 1, 0, 1, 0, 0, 1];

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
                    AssertIntEqual(result[i], state[i], "Measured in wrong basis");
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

			AssertIntEqual(Length(result), Length(expected), $"key should be length {Length(expected)}");
		    for (j in 0..Length(expected) - 1) {
			    AssertIntEqual(result[j], expected[j], "Unexpected key value");
            }
		}        
    }

    operation Task25_Test() : Unit {
		let (p1, p2) = (0.66, 0.75);

		for (i in 5..9) {
			let (key1, key2) = GenerateRandomState(i);
			let result1 = Task25_CheckKeysMatch_Reference(key1, key2, p1);
			let result2 = Task25_CheckKeysMatch_Reference(key1, key2, p2);

			AssertBoolEqual(Task25_CheckKeysMatch(key1, key2, p1), result1, $"Should return {result1}");
			AssertBoolEqual(Task25_CheckKeysMatch(key1, key2, p2), result2, $"Should return {result2}");
		}
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////
    operation Task31_Test () : Unit {
        using (q = Qubit()) {
            mutable res = 0;
            // q = 0, Real value: b = rectangular, Input: b = rectangular
            set res = Task31(q, 0);
            AssertIntEqual(res, 0, $"Incorrect result: {res}");
            Reset(q);

            // q = 0, Real value: b = diagonal, Input: b = diagonal 
            H(q);
            set res = Task31(q, 1);
            AssertIntEqual(res, 0, $"Incorrect result: {res}");
            Reset(q);

            // q = 1, Real value: b = rectangular, Input: b = rectangular 
            X(q);
            set res = Task31(q, 0);
            AssertIntEqual(res, 1, $"Incorrect result: {res}");
            Reset(q);

            // q = 1, Real value: b = diagonal, Input: b = diagonal 
            X(q);
            H(q);
            set res = Task31(q, 1);
            AssertIntEqual(res, 1, $"Incorrect result: {res}");
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
        
        AssertBoolEqual(emptyKeys == 0, false, "Should return some empty keys");
        AssertBoolEqual(emptyKeys == 10, false, "Should return some nonempty keys");
    }
}
