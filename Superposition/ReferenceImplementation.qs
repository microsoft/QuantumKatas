// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks. 
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Superposition
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;

    // Task 1. Plus state
    // Input: a qubit in |0〉 state (stored in an array of length 1).
    // Goal: create a |+〉 state on this qubit (|+〉 = (|0〉 + |1〉) / sqrt(2)).
    operation PlusState_Reference (qs : Qubit[]) : ()
    {
        body
        {
            H(qs[0]);
        }
        adjoint auto;
    }

    // Task 2. Minus state
    // Input: a qubit in |0〉 state (stored in an array of length 1).
    // Goal: create a |-〉 state on this qubit (|-〉 = (|0〉 - |1〉) / sqrt(2)).
    operation MinusState_Reference (qs : Qubit[]) : ()
    {
        body
        {
            X(qs[0]);
            H(qs[0]);
        }
        adjoint auto;
    }

    // Task 3. Unequal superposition
    // Inputs:
    //      1) a qubit in |0〉 state (stored in an array of length 1).
    //      2) angle alpha, in radians, represented as Double
    // Goal: create a cos(alpha) * |0〉 + sin(alpha) * |1〉 state on this qubit.
    operation UnequalSuperposition_Reference (qs : Qubit[], alpha : Double) : ()
    {
        body
        {
            // Hint: Experiment with rotation gates from Microsoft.Quantum.Primitive
            Ry(2.0 * alpha, qs[0]);
        }
        adjoint auto;
    }

    // Task 4. Bell state
    // Input: two qubits in |00〉 state (stored in an array of length 2).
    // Goal: create a Bell state |Φ⁺〉 = (|00〉 + |11〉) / sqrt(2) on these qubits.
    operation BellState_Reference (qs : Qubit[]) : ()
    {
        body
        {
            H(qs[0]);
            CNOT(qs[0], qs[1]);
        }
        adjoint auto;
    }

    // Task 5. All Bell states
    // Inputs:
    //      1) two qubits in |00〉 state (stored in an array of length 2)
    //      2) an integer index
    // Goal: create one of the Bell states based on the value of index:
    //       0: |Φ⁺〉 = (|00〉 + |11〉) / sqrt(2)
    //       1: |Φ⁻〉 = (|00〉 - |11〉) / sqrt(2)
    //       2: |Ψ⁺〉 = (|01〉 + |10〉) / sqrt(2)
    //       3: |Ψ⁻〉 = (|01〉 - |10〉) / sqrt(2)
    operation AllBellStates_Reference (qs : Qubit[], index : Int) : ()
    {
        body
        {
            H(qs[0]);
            CNOT(qs[0], qs[1]);
            // now we have |00〉 + |11〉 - modify it based on index arg
            if (index % 2 == 1) {
                // negative phase
                Z(qs[1]);
            }
            if (index / 2 == 1) {
                X(qs[1]);
            }
        }
        adjoint auto;
    }

    // Task 6. Greenberger–Horne–Zeilinger state
    // Input: N qubits in |0...0〉 state.
    // Goal: create a GHZ state (|0...0〉 + |1...1〉) / sqrt(2) on these qubits.
    operation GHZ_State_Reference (qs : Qubit[]) : ()
    {
        body
        {
            H(qs[0]);
            for (i in 1 .. Length(qs)-1) {
                CNOT(qs[0], qs[i]);
            }
        }
        adjoint auto;
    }

    // Task 7. Superposition of all basis vectors
    // Input: N qubits in |0...0〉 state.
    // Goal: create an equal superposition of all basis vectors from |0...0〉 to |1...1〉
    // (i.e. state (|0...0〉 + ... + |1...1〉) / sqrt(2^N) ).
    operation AllBasisVectorsSuperposition_Reference (qs : Qubit[]) : ()
    {
        body
        {
            for (i in 0 .. Length(qs)-1) {
                H(qs[i]);
            }
        }
        adjoint auto;
    }

    // Task 8. Superposition of |0...0〉 and given bit string
    // Inputs:
    //      1) N qubits in |0...0〉 state
    //      2) bit string represented as Bool[]
    // Goal: create an equal superposition of |0...0〉 and basis state given by the second bit string.
    // Bit values false and true correspond to |0〉 and |1〉 states.
    // You are guaranteed that the qubit array and the bit string have the same length.
    // You are guaranteed that the first bit of the bit string is true.
    // Example: for bit string = [true; false] the qubit state required is (|00〉 + |10〉) / sqrt(2).
    operation ZeroAndBitstringSuperposition_Reference (qs : Qubit[], bits : Bool[]) : ()
    {
        body
        {
            AssertIntEqual(Length(bits), Length(qs), "Arrays should have the same length");
            AssertBoolEqual(bits[0], true, "First bit of the input bit string should be set to true");

            // Hadamard first qubit
            H(qs[0]);

            // iterate through the bit string and CNOT to qubits corresponding to true bits
            for (i in 1..Length(qs)-1) {
                if (bits[i]) {
                    CNOT(qs[0], qs[i]);
                }
            }
        }
        adjoint auto;
    }

    // Task 9. Superposition of two bit strings
    // Inputs:
    //      1) N qubits in |0...0〉 state
    //      2) two bit string represented as Bool[]s
    // Goal: create an equal superposition of two basis states given by the bit strings.
    // Bit values false and true correspond to |0〉 and |1〉 states.
    // Example: for bit strings [false; true; false] and [false; false; true] 
    // the qubit state required is (|010〉 + |001〉) / sqrt(2).
    // You are guaranteed that the two bit strings will be different.

    // helper function for TwoBitstringSuperposition_Reference
    function FindFirstDiff_Reference (bits1 : Bool[], bits2 : Bool[]) : Int
    {
        mutable firstDiff = -1;
        for (i in 0 .. Length(bits1)-1) {
            if (bits1[i] != bits2[i] && firstDiff == -1) {
                set firstDiff = i;
            }
        }
        return firstDiff;
    }

    operation TwoBitstringSuperposition_Reference (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : ()
    {
        body
        {
            // find the index of the first bit at which the bit strings are different
            let firstDiff = FindFirstDiff_Reference(bits1, bits2);

            // Hadamard corresponding qubit to create superposition
            H(qs[firstDiff]);

            // iterate through the bit strings again setting the final state of qubits
            for (i in 0 .. Length(qs)-1) {
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
        adjoint auto;
    }

    // Task 10. W state on 2^k qubits
    // Input: N = 2^k qubits in |0...0〉 state.
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 4, W state is (|1000〉 + |0100〉 + |0010〉 + |0001〉) / 2.
    operation WState_PowerOfTwo_Reference (qs : Qubit[]) : ()
    {
        body
        {
            let N = Length(qs);
            if (N == 1) {
                // base of recursion: |1〉
                X(qs[0]);
            } else {
                let K = N / 2;
                // create W state on the first K qubits
                WState_PowerOfTwo_Reference(qs[0..K-1]);

                // the next K qubits are in |0...0〉 state
                // allocate ancilla in |+〉 state
                using (anc = Qubit[1]) {
                    H(anc[0]);
                    for (i in 0..K-1) {
                        (Controlled SWAP)(anc, (qs[i], qs[i+K]));
                    }
                    for (i in K..N-1) {
                        CNOT(qs[i], anc[0]);
                    }
                }
            }
        }
        adjoint auto;
    }

    // Task 11. W state on arbitrary number of qubits
    // Input: N qubits in |0...0〉 state (N is not necessarily a power of 2).
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 3, W state is (|100〉 + |010〉 + |001〉) / sqrt(3).

    // general solution based on rotations and recursive application of controlled generation routine
    operation WState_Arbitrary_Reference (qs : Qubit[]) : ()
    {
        body
        {
            let N = Length(qs);
            if (N == 1) {
                // base case of recursion: |1〉
                X(qs[0]);
            } else {
                // |W_N> = |0〉|W_(N-1)> + |1〉|0...0〉
                // do a rotation on the first qubit to split it into |0〉 and |1〉 with proper weights
                // |0〉 -> sqrt((N-1)/N) |0〉 + 1/sqrt(N) |1〉
                let theta = ArcSin(1.0 / Sqrt(ToDouble(N)));
                Ry(2.0 * theta, qs[0]);
                // do a zero-controlled W-state generation for qubits 1..N-1
                X(qs[0]);
                (Controlled WState_Arbitrary_Reference)(qs[0..0], qs[1..N-1]);
                X(qs[0]);
            }
        }
        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // solution based on generation for 2^k and post-selection using measurements
    operation WState_Arbitrary_Postselect (qs : Qubit[]) : ()
    {
        body
        {
            let N = Length(qs);
            if (N == 1) {
                // base case of recursion: |1〉
                X(qs[0]);
            } else {
                // find the smallest power of 2 which is greater than or equal to N
                // as a hack, we know we're not doing it on more than 64 qubits
                mutable P = 1;
                for (i in 1..6) {
                    if (P < N) {
                        set P = P * 2;
                    }
                }

                if (P == N) {
                    // prepare as a power of 2 (previous task)
                    WState_PowerOfTwo_Reference(qs);
                } else {
                    // allocate extra qubits
                    using (ans = Qubit[P-N]) {
                        let all_qubits = qs + ans;
                        repeat {
                            // prepare state W_P on original + ancilla qubits
                            WState_PowerOfTwo_Reference(all_qubits);

                            // measure ancilla qubits; if all of the results are Zero, we get the right state on main qubits
                            mutable allZeros = true;
                            for (i in 0..P-N-1) {
                                set allZeros = allZeros && IsResultZero(M(ans[i]));
                            }
                        } until allZeros
                        fixup {
                            ResetAll(ans);
                        }
                    }
                }
            }
        }
    }
}
