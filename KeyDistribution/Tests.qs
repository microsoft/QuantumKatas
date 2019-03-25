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
        using (q = Qubit()) {
			mutable ones = 0;
            for (i in 0 .. 5) {
				Task11(q);
				if (M(q) == One) {
					set ones = ones + 1;
				}
				Reset(q);
			}
			AssertBoolEqual(ones > 0 && ones < 6, true, $"Invalid: saw {ones} one qubits out of six (should be ~3)");

			Task11(q);
			H(q);
			AssertProb([PauliZ], [q], One, 0.5, "Measuring did not give 50/50 results.", 1e-5);
			Reset(q);
        }
    }

	operation Task12_Test () : Unit {
		for (j in 5 .. 10) {
			using (qs = Qubit[j]) {
				mutable ones = 0;
				Task12(qs);
				for (i in 0 .. Length(qs) - 1) {
					if (M(qs[i]) == One) {
						set ones = ones + 1;
					}
				}
				ResetAll(qs);
				AssertBoolEqual(ones > 0 && ones < Length(qs), true, $"Invalid: saw {ones} one qubits out of {Length(qs)}");

				Task12(qs);
				for (i in 0..Length(qs) - 1) {
					H(qs[i]);
					AssertProb([PauliZ], [qs[i]], One, 0.5, "Measuring did not give 50/50 results.", 1e-5);
				}
				ResetAll(qs);
			}
		}
    }

	operation Task13_Test () : Unit {
		for (i in 1 .. 5) {
			AssertOperationsEqualReferenced(Task13, Task13_Reference, i);
		}
    }
  
	//////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////
	operation GenerateRandomState(N : Int) : (Int[], Int[]) {
		mutable basis = new Int[N];
		mutable state = new Int[N];

		for (i in 0..N- 1) {
			set basis[i] = RandomInt(2);
			set state[i] = RandomInt(2);
		}

		return (basis, state);
	}
	
	operation Task21_Test() : Unit {
		using (qs = Qubit[2]) {
			mutable basis = [0, 0];
			mutable state = [0, 0];
			for (i in 1..16) {
				Task21_PrepareAlice(qs, basis, state);
				Adjoint Task21_PrepareAlice_Reference(qs, basis, state);
				AssertAllZero(qs);
				
				if (i % 4 == 0) {
					set state[(i / 4) % 2] = (state[(i / 4) % 2] + 1) % 2;
				}
				set basis[i % 2] = (basis[i %2] + 1) % 2;
				ResetAll(qs);
			}
		}

		using (qs = Qubit[7]) {
			let basis = [0, 1, 1, 0, 0, 1, 0];
			let state = [1, 1, 0, 1, 0, 0, 1];

			Task21_PrepareAlice(qs, basis, state);
			Adjoint Task21_PrepareAlice_Reference(qs, basis, state);
			AssertAllZero(qs);
			
			ResetAll(qs);
		}
	}

	operation CheckElementsInRange0To1(a : Int[]) : Unit {
		for (i in 0..Length(a) - 1) {
			AssertBoolEqual(a[i] <= 1 && a[i] >= 0, true, $"Value at index {i} is not 0 or 1");
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

	operation Task22_Test() : Unit {
		let N = 7;
		let basis = Task22_ChooseBasis(N);
		AssertIntEqual(N, Length(basis), "Returned array should be of the given length");
		CheckElementsInRange0To1(basis);

		let basis2 = Task22_ChooseBasis(N);
		AssertIntEqual(N, Length(basis), "Returned array should be of the given length");
		CheckElementsInRange0To1(basis2);
		CheckNotEqual(basis, basis2);

		let basis3 = Task22_ChooseBasis(N);
		AssertIntEqual(N, Length(basis), "Returned array should be of the given length");
		CheckElementsInRange0To1(basis3);
		CheckNotEqual(basis, basis3);
		CheckNotEqual(basis2, basis3);
	}

	operation Task23_Test() : Unit {
		let N = 7;
	
		using (qs = Qubit[N]) {
			for (iter in 1..5) {
				let (basis, state) = GenerateRandomState(N);

				Task21_PrepareAlice_Reference(qs, basis, state);
				let result = Task23_Measure(qs, basis);
				
				for (i in 0..N - 1) {
					AssertIntEqual(result[i], state[i], "Measured in wrong basis");
				}
				ResetAll(qs);
			}
		}
	}

	operation CreateMisMatchBasis(basis : Int[], matching : Int[]) : Int[] {
		mutable index = 0;
		mutable result = new Int[Length(basis)];

		for (i in 0..Length(basis) - 1) {
			if (i == matching[index]) {
				set result[i] = basis[i];
				if (index < Length(matching) - 1) {
					set index = index + 1;
				}
			} else {
				set result[i] = (basis[i] + 1) % 2;
			}
		}

		return result;
	}

	operation Task24_Test() : Unit {
		let N = 5;
		let (basis, state) = GenerateRandomState(N);
		let matching = [1, 3, 4];
		let expected = Subarray(matching, state);
		let basis2 = CreateMisMatchBasis(basis, matching);
		let result = Task24_GenerateKey(basis2, basis, state);

		AssertIntEqual(Length(result), Length(expected), $"key should be length {Length(expected)}");
		for (i in 0..Length(expected) - 1) {
			AssertIntEqual(result[i], expected[i], "Unexpected key value");
		}
	}

	operation Task25_Test() : Unit {
		mutable keyA = [0, 1, 1, 0 ,1 ,1];
		mutable keyB = [0, 1, 0, 0, 1, 0];
		AssertBoolEqual(Task25_CheckKeysMatch(keyA, keyB, 0.66), true, "Should return true");
		AssertBoolEqual(Task25_CheckKeysMatch(keyA, keyB, 0.45), true, "Should return true");
		AssertBoolEqual(Task25_CheckKeysMatch(keyA, keyB, 0.75), false, "Should return false");

		set keyB[2] = 1;
		AssertBoolEqual(Task25_CheckKeysMatch(keyA, keyB, 0.75), true, "Should return true");
		AssertBoolEqual(Task25_CheckKeysMatch(keyA, keyB, 1.00), false, "Should return false");
	}

	operation Task26_Test() : Unit {
		using (qs = Qubit[7]) {
			let (basis, state) = GenerateRandomState(7);
			let key = Task26_BB84(qs, basis, state, 0.8);

			AssertBoolEqual(Length(key) != 0, true, "Should not return an empty key");
			ResetAll(qs);
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
				let (basis, state) = GenerateRandomState(7);
				let key = Task32(qs, basis, state, 0.8);
				set emptyKeys = emptyKeys + (Length(key) == 0 ? 1 | 0);

				ResetAll(qs);
			}
		}
		
		AssertBoolEqual(emptyKeys == 0, false, "Should return some empty keys");
		AssertBoolEqual(emptyKeys == 10, false, "Should return some nonempty keys");
    }
}
