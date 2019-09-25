// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. Diagonal polarization
	operation DiagonalPolarization_Reference (qs : Qubit[]) : Unit is Adj {
        ApplyToEachA(H, qs);
    }


    // Task 1.2. Equal superposition.
    operation EqualSuperposition_Reference (q : Qubit) : Unit {
        // The easiest way to do this is to convert the state of the qubit to |+⟩
        H(q);
        // Other possible solutions include X(q); H(q); to prepare |-⟩ state,
        // and anything that adds any relative phase to one of the states.
    }

    //////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////

	// Task 2.1. Generate random array
    operation RandomArray_Reference (N : Int) : Bool[] {
        mutable array = new Bool[N];

        for (i in 0 .. N - 1) {
            set array w/= i <- RandomInt(2) == 1;
        }

        return array;
    }


    // Task 2.2. Prepare Alice's qubits
	operation PrepareAlicesQubits_Reference(qs : Qubit[], bases : Bool[], bits : Bool[]) : Unit is Adj {
        for (i in 0..Length(qs) - 1) {
            if (bits[i]) {
                X(qs[i]);
            }
            if (bases[i]) {
                H(qs[i]);
            }
        }
    }


    // Task 2.3. Measure Bob's qubits
    operation MeasureBobsQubits_Reference(qs : Qubit[], bases : Bool[]) : Bool[] {
        for (i in 0..Length(qs) - 1) {
            if (bases[i]) {
                H(qs[i]);
            }
        }
        return ResultArrayAsBoolArray(MultiM(qs));
    }


    operation Task24_GenerateKey_Reference(bAlice : Bool[], bBob : Bool[], res : Bool[]) : Bool[] {
        // The next two lines are to ensure that the inputs are all the same length
        Fact(Length(bAlice) == Length(bBob), "Input arrays should be the same length");
        Fact(Length(bAlice) == Length(res), "Input arrays should be the same length");

        mutable count = 0;
        for (i in 0..Length(bAlice) - 1) {
            if (bAlice[i] == bBob[i]) {
                set count = count + 1;
            }
        }

        mutable key = new Bool[count];
        mutable index = 0;
        for (i in 0..Length(bAlice) - 1) {
            if (bAlice[i] == bBob[i]) {
                set key w/= index <- res[i];
                set index = index + 1;
            }
        }

        return key;
    }


    operation Task25_CheckKeysMatch_Reference(keyA : Bool[], keyB : Bool[], p : Double) : Bool {
        // The following line ensures that the inputs are all the same length
        Fact(Length(keyA) == Length(keyB), "Input arrays should be the same length");

        mutable count = 0.0;
        for (i in 0..Length(keyA) - 1) {
            if (keyA[i] == keyB[i]) {
                set count = count + 1.0;
            }
        }

        return count / IntAsDouble(Length(keyA)) >= p;
    }


    operation Task26_BB84_Reference(qs : Qubit[],  p : Double) : Bool[] {
        // 1. Choose random basis and bits to encode
		let basis = RandomArray_Reference(Length(qs));
		let bits = RandomArray_Reference(Length(qs));
		
		// 2. Alice prepares her qubits
		PrepareAlicesQubits_Reference(qs, basis, bits);
        
		// 3. Bob chooses random basis to measure in
        let bBob = RandomArray_Reference(Length(qs));

		// 4. Bob measures Alice's qubits'
        let mBob = MeasureBobsQubits_Reference(qs, bBob);

		// 5. Generate shared key
        let keyA = Task24_GenerateKey_Reference(basis, bBob, bits);
        let keyB = Task24_GenerateKey_Reference(basis, bBob, mBob);

		// 6. Ensure at least the minimum percentage of bits match
        if (Task25_CheckKeysMatch_Reference(keyA, keyB, p)) {
            return keyA;
        }
        return new Bool[0];
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    operation Task31_Reference (q : Qubit, basis : Bool) : Int {
        mutable res = 0;
        if (not basis) {
            // Measure in the rectangular basis
            set res = M(q) == Zero ? 0 | 1;
        } else {
            // Measure in the diagonal basis
            H(q);
            set res = M(q) == Zero ? 0 | 1;
            H(q);
        }
        return res;
    }

    
    operation Task32_Reference (qs : Qubit[],  p : Double) : Bool[] {
        let basis = RandomArray_Reference(Length(qs));
		let bits = RandomArray_Reference(Length(qs));
		
		PrepareAlicesQubits_Reference(qs, basis, bits);

        for (i in 0 .. Length(qs) - 1) {
            let n = Task31_Reference(qs[i], RandomInt(2) == 1);
        }
        
        let bBob = RandomArray_Reference(Length(qs));

        let mBob = MeasureBobsQubits_Reference(qs, bBob);

        let keyA = Task24_GenerateKey_Reference(basis, bBob, bits);
        let keyB = Task24_GenerateKey_Reference(basis, bBob, mBob);

        if (Task25_CheckKeysMatch_Reference(keyA, keyB, p)) {
            return keyA;
        }
        return new Bool[0];
    }
}