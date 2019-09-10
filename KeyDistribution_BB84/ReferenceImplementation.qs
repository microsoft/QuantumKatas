//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////
    
	operation Task11_Reference (qs : Qubit[]) : Unit {
        body (...) {
            for (i in 0 .. Length(qs) - 1) {
                H(qs[i]);
            }
        }
        adjoint auto;
    }

    operation Task12_Reference (q : Qubit) : Unit {
        body (...) {
            H(q);
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////

    operation Task21_ChooseBasis_Reference(N : Int) : Int[] {
        mutable basis = new Int[N];

        for (i in 0..N - 1) {
            set basis w/= i <- RandomInt(2);
        }

        return basis;
    }

	operation Task22_PrepareAlice_Reference(qs : Qubit[], basis : Int[], bits : Int[]) : Unit {
        body(...) {
            for (i in 0..Length(qs) - 1) {
                if (bits[i] == 1) {
                    X(qs[i]);
                }
                if (basis[i] == 1) {
                    H(qs[i]);
                }
            }
        }
        adjoint auto;
    }

    operation Task23_Measure_Reference(qs : Qubit[], basis : Int[]) : Int[] {
        // The following line ensures that the inputs are all the same length
        AssertIntEqual(Length(qs), Length(basis), "Input arrays should be the same length");

        mutable measurements = new Int[Length(qs)];
        for (i in 0..Length(qs) - 1) {
            if (basis[i] == 1) {
                H(qs[i]);
            }
            if (M(qs[i]) == One) {
                set measurements w/= i <- 1;
            }
        }
        return measurements;
    }

    operation Task24_GenerateKey_Reference(bAlice : Int[], bBob : Int[], res : Int[]) : Int[] {
        // The next two lines are to ensure that the inputs are all the same length
        AssertIntEqual(Length(bAlice), Length(bBob), "Input arrays should be the same length");
        AssertIntEqual(Length(bAlice), Length(res), "Input arrays should be the same length");

        mutable count = 0;
        for (i in 0..Length(bAlice) - 1) {
            if (bAlice[i] == bBob[i]) {
                set count = count + 1;
            }
        }

        mutable key = new Int[count];
        mutable index = 0;
        for (i in 0..Length(bAlice) - 1) {
            if (bAlice[i] == bBob[i]) {
                set key w/= index <- res[i];
                set index = index + 1;
            }
        }

        return key;
    }

    operation Task25_CheckKeysMatch_Reference(keyA : Int[], keyB : Int[], p : Double) : Bool {
        // The following line ensures that the inputs are all the same length
        AssertIntEqual(Length(keyA), Length(keyB), "Input arrays should be the same length");

        mutable count = 0.0;
        for (i in 0..Length(keyA) - 1) {
            if (keyA[i] == keyB[i]) {
                set count = count + 1.0;
            }
        }

        return count / ToDouble(Length(keyA)) >= p;
    }

    operation Task26_BB84_Reference(qs : Qubit[],  p : Double) : Int[] {
        // 1. Choose random basis and bits to encode
		let basis = Task21_ChooseBasis_Reference(Length(qs));
		let bits = Task21_ChooseBasis_Reference(Length(qs));
		
		// 2. Alice prepares her qubits
		Task22_PrepareAlice_Reference(qs, basis, bits);
        
		// 3. Bob chooses random basis to measure in
        let bBob = Task21_ChooseBasis_Reference(Length(qs));

		// 4. Bob measures Alice's qubits'
        let mBob = Task23_Measure_Reference(qs, bBob);

		// 5. Generate shared key
        let keyA = Task24_GenerateKey_Reference(basis, bBob, bits);
        let keyB = Task24_GenerateKey_Reference(basis, bBob, mBob);

		// 6. Ensure at least the minimum percentage of bits match
        if (Task25_CheckKeysMatch_Reference(keyA, keyB, p)) {
            return keyA;
        }
        return new Int[0];
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    operation Task31_Reference (q : Qubit, b : Int) : Int {
        mutable res = 0;
        if (b == 0) {
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
    
    operation Task32_Reference (qs : Qubit[],  p : Double) : Int[] {
        let basis = Task21_ChooseBasis_Reference(Length(qs));
		let bits = Task21_ChooseBasis_Reference(Length(qs));
		
		Task22_PrepareAlice_Reference(qs, basis, bits);

        for (i in 0 .. Length(qs) - 1) {
            let n = Task31_Reference(qs[i], RandomInt(2));
        }
        
        let bBob = Task21_ChooseBasis_Reference(Length(qs));

        let mBob = Task23_Measure_Reference(qs, bBob);

        let keyA = Task24_GenerateKey_Reference(basis, bBob, bits);
        let keyB = Task24_GenerateKey_Reference(basis, bBob, mBob);

        if (Task25_CheckKeysMatch_Reference(keyA, keyB, p)) {
            return keyA;
        }
        return new Int[0];
    }
}