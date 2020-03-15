// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Superposition {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;


    // ------------------------------------------------------
    // Task 1. Plus state
    // Input: a qubit in the |0⟩ state.
    // Goal: prepare a |+⟩ state on this qubit (|+⟩ = (|0⟩ + |1⟩) / sqrt(2)).
    operation PlusState_Reference (q : Qubit) : Unit is Adj {
        H(q);
    }


    // ------------------------------------------------------
    // Task 2. Minus state
    // Input: a qubit in the |0⟩ state.
    // Goal: prepare a |-⟩ state on this qubit (|-⟩ = (|0⟩ - |1⟩) / sqrt(2)).
    operation MinusState_Reference (q : Qubit) : Unit is Adj {
        X(q);
        H(q);
    }


    // ------------------------------------------------------
    // Task 3. Unequal superposition
    // Inputs:
    //      1) a qubit in the |0⟩ state.
    //      2) angle alpha, in radians, represented as Double
    // Goal: prepare a cos(alpha) * |0⟩ + sin(alpha) * |1⟩ state on this qubit.
    operation UnequalSuperposition_Reference (q : Qubit, alpha : Double) : Unit is Adj {

        // Hint: Experiment with rotation gates from Microsoft.Quantum.Intrinsic
        Ry(2.0 * alpha, q);
    }


    // ------------------------------------------------------
    // Task 4. Superposition of all basis vectors on two qubits
    operation AllBasisVectors_TwoQubits_Reference (qs : Qubit[]) : Unit is Adj {

        // Since a Hadamard gate will change |0⟩ into |+⟩ = (|0⟩ + |1⟩)/sqrt(2)
        // And the desired state is just a tensor product |+⟩|+⟩, we can apply
        // a Hadamard transformation to each qubit.
        H(qs[0]);
        H(qs[1]);
    }


    // ------------------------------------------------------
    // Task 5. Superposition of basis vectors with phases
    operation AllBasisVectorsWithPhases_TwoQubits_Reference (qs : Qubit[]) : Unit is Adj {

        // Question:
        // Is this state separable?

        // Answer:
        // Yes. It is. We can see that:
        // ((|0⟩ - |1⟩) / sqrt(2)) ⊗ ((|0⟩ + i*|1⟩) / sqrt(2)) is equal to the desired
        // state, so we can create it by doing operations on each qubit independently.

        // We can see that the first qubit is in state |-⟩ and the second in state |i⟩,
        // so the transformations that we need are:

        // Qubit 0 is taken into |+⟩ and then z-rotated into |-⟩.
        H(qs[0]);
        Z(qs[0]);

        // Qubit 1 is taken into |+⟩ and then z-rotated into |i⟩.
        H(qs[1]);
        S(qs[1]);
    }


    // ------------------------------------------------------
    // Task 6. Bell state
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal: create a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    operation BellState_Reference (qs : Qubit[]) : Unit is Adj {
        H(qs[0]);
        CNOT(qs[0], qs[1]);
    }


    // ------------------------------------------------------
    // Task 7. All Bell states
    // Inputs:
    //      1) two qubits in |00⟩ state (stored in an array of length 2)
    //      2) an integer index
    // Goal: create one of the Bell states based on the value of index:
    //       0: |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
    //       1: |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
    //       2: |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
    //       3: |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
    operation AllBellStates_Reference (qs : Qubit[], index : Int) : Unit is Adj {

        H(qs[0]);
        CNOT(qs[0], qs[1]);

        // now we have |00⟩ + |11⟩ - modify it based on index arg
        if (index % 2 == 1) {
            // negative phase
            Z(qs[1]);
        }
        if (index / 2 == 1) {
            X(qs[1]);
        }
    }


    // ------------------------------------------------------
    // Task 8. Greenberger–Horne–Zeilinger state
    // Input: N qubits in |0...0⟩ state.
    // Goal: create a GHZ state (|0...0⟩ + |1...1⟩) / sqrt(2) on these qubits.
    operation GHZ_State_Reference (qs : Qubit[]) : Unit is Adj {

        H(qs[0]);

        for (q in Rest(qs)) {
            CNOT(qs[0], q);
        }
    }


    // ------------------------------------------------------
    // Task 9. Superposition of all basis vectors
    // Input: N qubits in |0...0⟩ state.
    // Goal: create an equal superposition of all basis vectors from |0...0⟩ to |1...1⟩
    // (i.e. state (|0...0⟩ + ... + |1...1⟩) / sqrt(2^N) ).
    operation AllBasisVectorsSuperposition_Reference (qs : Qubit[]) : Unit is Adj {

        for (q in qs) {
            H(q);
        }
    }


    // ------------------------------------------------------
    // Task 10. Superposition of all even or all odd numbers
    // Inputs:
    //      1) N qubits in |0...0⟩ state.
    //      2) A boolean isEven.
    // Goal: create a superposition of all even numbers on N qubits if isEven is true,
    //       or a superposition of all odd numbers on N qubits if isEven is false.
    operation EvenOddNumbersSuperposition_Reference (qs : Qubit[], isEven : Bool) : Unit is Adj {
        let N = Length(qs);
        for (i in 0 .. N-2) {
            H(qs[i]);
        }
        // for odd numbers, flip the last bit to 1
        if (not isEven) {
            X(qs[N-1]);
        }
    }


    // ------------------------------------------------------
    // Task 11. |00⟩ + |01⟩ + |10⟩ state
    // Input: 2 qubits in |00⟩ state.
    // Goal: create the state (|00⟩ + |01⟩ + |10⟩) / sqrt(3) on these qubits.
    operation ThreeStates_TwoQubits_Reference (qs : Qubit[]) : Unit is Adj {

        // Follow Niel's answer at https://quantumcomputing.stackexchange.com/a/2313/

        // Rotate first qubit to (sqrt(2) |0⟩ + |1⟩) / sqrt(3) (task 1.4 from BasicGates kata)
        let theta = ArcSin(1.0 / Sqrt(3.0));
        Ry(2.0 * theta, qs[0]);

        // Split the state sqrt(2) |0⟩ ⊗ |0⟩ into |00⟩ + |01⟩
        (ControlledOnInt(0, H))([qs[0]], qs[1]);
    }

    // Alternative solution, based on post-selection
    operation ThreeStates_TwoQubits_Postselection (qs : Qubit[]) : Unit {
        using (ancilla = Qubit()) {
            repeat {
                // Create |00⟩ + |01⟩ + |10⟩ + |11⟩ state
                ApplyToEach(H, qs);
                // Create (|00⟩ + |01⟩ + |10⟩) ⊗ |0⟩ + |11⟩ ⊗ |1⟩
                Controlled X(qs, ancilla);
                let res = MResetZ(ancilla);
            }
            until (res == Zero)
            fixup {
                ResetAll(qs);
            }
        }
    }

    // ------------------------------------------------------
    // Task 12*. Hardy State
    // Input: 2 qubits in |00⟩ state
    // Goal: create the state (3|00⟩ + |01⟩ + |10⟩ + |11⟩) / sqrt(12) on these qubits.
    operation Hardy_State_Reference (qs : Qubit[]) : Unit is Adj {
        // Follow Mariia's answer at https://quantumcomputing.stackexchange.com/questions/6836/how-to-create-quantum-circuits-from-scratch

        // Rotate first qubit to (Sqrt(10.0/12.0) |0⟩ + Sqrt(2.0/12.0) |1⟩)
        let theta = ArcCos(Sqrt(10.0/12.0));
        Ry(2.0 * theta, qs[0]);

        (ControlledOnInt(0, Ry))([qs[0]], (2.0 * ArcCos(3.0/Sqrt(10.0)) , qs[1]));
        (ControlledOnInt(1, Ry))([qs[0]], (2.0 * PI()/4.0 , qs[1]));
    }


    // ------------------------------------------------------
    // Task 13. Superposition of |0...0⟩ and given bit string
    // Inputs:
    //      1) N qubits in |0...0⟩ state
    //      2) bit string represented as Bool[]
    // Goal: create an equal superposition of |0...0⟩ and basis state given by the second bit string.
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // You are guaranteed that the qubit array and the bit string have the same length.
    // You are guaranteed that the first bit of the bit string is true.
    // Example: for bit string = [true, false] the qubit state required is (|00⟩ + |10⟩) / sqrt(2).
    operation ZeroAndBitstringSuperposition_Reference (qs : Qubit[], bits : Bool[]) : Unit is Adj {

        EqualityFactI(Length(bits), Length(qs), "Arrays should have the same length");
        EqualityFactB(bits[0], true, "First bit of the input bit string should be set to true");

        // Hadamard first qubit
        H(qs[0]);

        // iterate through the bit string and CNOT to qubits corresponding to true bits
        for (i in 1 .. Length(qs) - 1) {
            if (bits[i]) {
                CNOT(qs[0], qs[i]);
            }
        }
    }


    // ------------------------------------------------------
    // Task 14. Superposition of two bit strings
    // Inputs:
    //      1) N qubits in |0...0⟩ state
    //      2) two bit string represented as Bool[]s
    // Goal: create an equal superposition of two basis states given by the bit strings.
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // Example: for bit strings [false, true, false] and [false, false, true]
    // the qubit state required is (|010⟩ + |001⟩) / sqrt(2).
    // You are guaranteed that the two bit strings will be different.

    // helper function for TwoBitstringSuperposition_Reference
    function FindFirstDiff_Reference (bits1 : Bool[], bits2 : Bool[]) : Int {
        for (i in 0 .. Length(bits1) - 1) {
            if (bits1[i] != bits2[i]) {
                return i;
            }
        }
        return -1;
    }


    operation TwoBitstringSuperposition_Reference (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : Unit is Adj {

        // find the index of the first bit at which the bit strings are different
        let firstDiff = FindFirstDiff_Reference(bits1, bits2);

        // Hadamard corresponding qubit to create superposition
        H(qs[firstDiff]);

        // iterate through the bit strings again setting the final state of qubits
        for (i in 0 .. Length(qs) - 1) {
            if (bits1[i] == bits2[i]) {
                // if two bits are the same apply X or nothing
                if (bits1[i]) {
                    X(qs[i]);
                }
            } else {
                // if two bits are different, set their difference using CNOT
                if (i > firstDiff) {
                    CNOT(qs[firstDiff], qs[i]);
                    if (bits1[i] != bits1[firstDiff]) {
                        X(qs[i]);
                    }
                }
            }
        }
    }


    // ------------------------------------------------------
    // Task 15*. Superposition of four bit strings
    // Inputs:
    //      1) N qubits in |0...0⟩ state
    //      2) four bit string represented as Bool[][] bits
    //         bits is an array of size 4 x N which describes the bit strings as follows:
    //         bits[i] describes the i-th bit string and has N elements;
    //         bit values false and true correspond to |0⟩ and |1⟩ states.
    //
    // Goal: create an equal superposition of the four basis states given by the bit strings.
    operation FourBitstringSuperposition_Reference (qs : Qubit[], bits : Bool[][]) : Unit is Adj {
        let N = Length(qs);

        using (anc = Qubit[2]) {
            // Put two ancillas into equal superposition of 2-qubit basis states
            ApplyToEachA(H, anc);

            // Set up the right pattern on the main qubits with control on ancillas
            for (i in 0 .. 3) {
                for (j in 0 .. N - 1) {
                    if ((bits[i])[j]) {
                        (ControlledOnInt(i, X))(anc, qs[j]);
                    }
                }
            }

            // Uncompute the ancillas, using patterns on main qubits as control
            for (i in 0 .. 3) {
                if (i % 2 == 1) {
                    (ControlledOnBitString(bits[i], X))(qs, anc[0]);
                }
                if (i / 2 == 1) {
                    (ControlledOnBitString(bits[i], X))(qs, anc[1]);
                }
            }
        }
    }


    // ------------------------------------------------------
    // Task 16. W state on 2ᵏ qubits
    // Input: N = 2ᵏ qubits in |0...0⟩ state.
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 4, W state is (|1000⟩ + |0100⟩ + |0010⟩ + |0001⟩) / 2.
    operation WState_PowerOfTwo_Reference (qs : Qubit[]) : Unit is Adj {

        let N = Length(qs);

        if (N == 1) {
            // base of recursion: |1⟩
            X(qs[0]);
        } else {
            let K = N / 2;

            // create W state on the first K qubits
            WState_PowerOfTwo_Reference(qs[0 .. K - 1]);

            // the next K qubits are in |0...0⟩ state
            // allocate ancilla in |+⟩ state
            using (anc = Qubit()) {
                H(anc);

                for (i in 0 .. K - 1) {
                    Controlled SWAP([anc], (qs[i], qs[i + K]));
                }
                for (i in K .. N - 1) {
                    CNOT(qs[i], anc);
                }
            }
        }
    }


    // ------------------------------------------------------
    // Task 17**. W state on arbitrary number of qubits
    // Input: N qubits in |0...0⟩ state (N is not necessarily a power of 2).
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 3, W state is (|100⟩ + |010⟩ + |001⟩) / sqrt(3).

    // general solution based on rotations and recursive application of controlled generation routine
    operation WState_Arbitrary_Reference (qs : Qubit[]) : Unit is Adj + Ctl {

        let N = Length(qs);

        if (N == 1) {
            // base case of recursion: |1⟩
            X(qs[0]);
        } else {
            // |W_N⟩ = |0⟩|W_(N-1)⟩ + |1⟩|0...0⟩
            // do a rotation on the first qubit to split it into |0⟩ and |1⟩ with proper weights
            // |0⟩ -> sqrt((N-1)/N) |0⟩ + 1/sqrt(N) |1⟩
            let theta = ArcSin(1.0 / Sqrt(IntAsDouble(N)));
            Ry(2.0 * theta, qs[0]);

            // do a zero-controlled W-state generation for qubits 1..N-1
            X(qs[0]);
            Controlled WState_Arbitrary_Reference(qs[0 .. 0], qs[1 .. N - 1]);
            X(qs[0]);
        }
    }


    // Iterative solution (equivalent to the WState_Arbitrary_Reference, but with the recursion unrolled)
    // Circuit for N=4: https://algassert.com/quirk#circuit={%22cols%22:[[1,1,1,%22~95cq%22],[1,1,%22~erlf%22,%22%E2%97%A6%22],[1,%22~809j%22,%22%E2%97%A6%22,%22%E2%97%A6%22],[%22X%22,%22%E2%97%A6%22,%22%E2%97%A6%22,%22%E2%97%A6%22]],%22gates%22:[{%22id%22:%22~809j%22,%22name%22:%22FS_2%22,%22matrix%22:%22{{%E2%88%9A%C2%BD,-%E2%88%9A%C2%BD},{%E2%88%9A%C2%BD,%E2%88%9A%C2%BD}}%22},{%22id%22:%22~erlf%22,%22name%22:%22FS_3%22,%22matrix%22:%22{{%E2%88%9A%E2%85%94,-%E2%88%9A%E2%85%93},{%E2%88%9A%E2%85%93,%E2%88%9A%E2%85%94}}%22},{%22id%22:%22~95cq%22,%22name%22:%22FS_4%22,%22matrix%22:%22{{%E2%88%9A%C2%BE,-%C2%BD},{%C2%BD,%E2%88%9A%C2%BE}}%22}]}
    operation WState_Arbitrary_Iterative (qs : Qubit[]) : Unit is Adj {
        let N = Length(qs);
        FractionSuperposition(N, qs[0]);
        for (i in 1 .. N - 1) {
            (ControlledOnInt(0, FractionSuperposition))(qs[0..i-1], (N-i, qs[i]));
        }
    }

    // Given a qubit in |0⟩ state and a denominator N,
    // transform the qubit to state sqrt((N-1) / N) |0⟩ + sqrt(1/N) |1⟩.
    operation FractionSuperposition(denominator : Int, q : Qubit) : Unit is Adj + Ctl {

        if (denominator == 1) {
            X(q);
        } else {
            // represent the target state as cos(theta) * |0⟩ + sin(theta) * |1⟩, as in task 1.3
            let denom = IntAsDouble(denominator);
            let num = denom - 1.0;
            let theta = ArcCos(Sqrt(num / denom));
            Ry(2.0 * theta, q);
        }
    }


    // solution based on generation for 2ᵏ and post-selection using measurements
    operation WState_Arbitrary_Postselect (qs : Qubit[]) : Unit {
        let N = Length(qs);

        if (N == 1) {
            // base case of recursion: |1⟩
            X(qs[0]);
        } else {
            // find the smallest power of 2 which is greater than or equal to N
            // as a hack, we know we're not doing it on more than 64 qubits
            mutable P = 1;
            for (i in 1 .. 6) {
                if (P < N) {
                    set P *= 2;
                }
            }

            if (P == N) {
                // prepare as a power of 2 (previous task)
                WState_PowerOfTwo_Reference(qs);
            } else {
                // allocate extra qubits
                using (anc = Qubit[P - N]) {
                    let all_qubits = qs + anc;

                    repeat {
                        // prepare state W_P on original + ancilla qubits
                        WState_PowerOfTwo_Reference(all_qubits);

                        // measure ancilla qubits; if all of the results are Zero, we get the right state on main qubits
                        mutable allZeros = true;
                        for (i in 0 .. (P - N) - 1) {
                            if (not IsResultZero(M(anc[i]))) {
                                set allZeros = false;
                            }
                        }
                    }
                    until (allZeros)
                    fixup {
                        ResetAll(anc);
                    }
                }
            }
        }
    }
}
