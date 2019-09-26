// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Arrays;
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
    operation PrepareAlicesQubits_Reference (qs : Qubit[], bases : Bool[], bits : Bool[]) : Unit is Adj {
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
    operation MeasureBobsQubits_Reference (qs : Qubit[], bases : Bool[]) : Bool[] {
        for (i in 0..Length(qs) - 1) {
            if (bases[i]) {
                H(qs[i]);
            }
        }
        return ResultArrayAsBoolArray(MultiM(qs));
    }


    // Task 2.4. Generate the shared key!
    function GenerateSharedKey_Reference (basesAlice : Bool[], basesBob : Bool[], measurementsBob : Bool[]) : Bool[] {
        // If Alice and Bob used the same basis, they will have the same value of the bit.
        // The shared key consists of those bits.
        mutable key = new Bool[0];
        for ((a, b, bit) in Zip3(basesAlice, basesBob, measurementsBob)) {
            if (a == b) {
                set key += [bit];
            }
        }
        return key;
    }


    // Task 2.5. Was communication secure?
    function CheckKeysMatch_Reference (keyAlice : Bool[], keyBob : Bool[], threshold : Int) : Bool {
        let N = Length(keyAlice);
        mutable count = 0;
        for (i in 0 .. N - 1) {
            if (keyAlice[i] == keyBob[i]) {
                set count += 1;
            }
        }

        return IntAsDouble(count) / IntAsDouble(N) >= IntAsDouble(threshold) / 100.0;
    }


    // Task 2.6. Putting it all together 
    operation T26_BB84Protocol_Reference () : Unit {
        let threshold = 99;

        using (qs = Qubit[20]) {
            // 1. Choose random basis and bits to encode
            let basesAlice = RandomArray_Reference(Length(qs));
            let bitsAlice = RandomArray_Reference(Length(qs));
        
            // 2. Alice prepares her qubits
            PrepareAlicesQubits_Reference(qs, basesAlice, bitsAlice);
        
            // 3. Bob chooses random basis to measure in
            let basesBob = RandomArray_Reference(Length(qs));

            // 4. Bob measures Alice's qubits'
            let bitsBob = MeasureBobsQubits_Reference(qs, basesBob);

            // 5. Generate shared key
            let keyAlice = GenerateSharedKey_Reference(basesAlice, basesBob, bitsAlice);
            let keyBob = GenerateSharedKey_Reference(basesAlice, basesBob, bitsBob);

            // 6. Ensure at least the minimum percentage of bits match
            if (CheckKeysMatch_Reference(keyAlice, keyBob, threshold)) {
                Message($"Successfully generated keys {keyAlice}/{keyBob}");
            }

            ResetAll(qs);
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Eavesdrop!
    operation Eavesdrop_Reference (q : Qubit, basis : Bool) : Bool {
        return ResultAsBool(Measure([basis ? PauliX | PauliZ], [q]));
    }

    
    // Task 3.2. Catch the eavesdropper
    operation T32_BB84ProtocolWithEavesdropper_Reference () : Unit {
        let threshold = 90;

        using (qs = Qubit[20]) {
            // 1. Choose random basis and bits to encode
            let basesAlice = RandomArray_Reference(Length(qs));
            let bitsAlice = RandomArray_Reference(Length(qs));
        
            // 2. Alice prepares her qubits
            PrepareAlicesQubits_Reference(qs, basesAlice, bitsAlice);
        
            // Eve eavesdrops on all qubits, guessing the basis at random
            for (i in 0 .. Length(qs) - 1) {
                let n = Eavesdrop_Reference(qs[i], RandomInt(2) == 1);
            }

            // 3. Bob chooses random basis to measure in
            let basesBob = RandomArray_Reference(Length(qs));

            // 4. Bob measures Alice's qubits'
            let bitsBob = MeasureBobsQubits_Reference(qs, basesBob);

            // 5. Generate shared key
            let keyAlice = GenerateSharedKey_Reference(basesAlice, basesBob, bitsAlice);
            let keyBob = GenerateSharedKey_Reference(basesAlice, basesBob, bitsBob);

            // 6. Ensure at least the minimum percentage of bits match
            if (CheckKeysMatch_Reference(keyAlice, keyBob, threshold)) {
                Message($"Successfully generated keys {keyAlice}/{keyBob}");
            } else {
                Message($"Caught an eavesdropper, discarding the keys {keyAlice}/{keyBob}");
            }

            ResetAll(qs);
        }
    }
}