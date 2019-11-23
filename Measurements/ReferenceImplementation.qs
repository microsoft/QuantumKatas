// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Measurements {

    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;


    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Measurements
    //////////////////////////////////////////////////////////////////

    // Task 1.1. |0⟩ or |1⟩ ?
    // Input: a qubit which is guaranteed to be in |0⟩ or |1⟩ state.
    // Output: true if the qubit was in |1⟩ state, or false if it was in |0⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitOne_Reference (q : Qubit) : Bool {
        return M(q) == One;
    }


    // Task 1.2. Set qubit to |0⟩ state
    operation InitializeQubit_Reference (q : Qubit) : Unit {
        if (M(q) == One) {
            X(q);
        }
    }


    // Task 1.3. |+⟩ or |-⟩ ?
    // Input: a qubit which is guaranteed to be in |+⟩ or |-⟩ state
    //        (|+⟩ = (|0⟩ + |1⟩) / sqrt(2), |-⟩ = (|0⟩ - |1⟩) / sqrt(2)).
    // Output: true if the qubit was in |+⟩ state, or false if it was in |-⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitPlus_Reference (q : Qubit) : Bool {
        H(q);
        return M(q) == Zero;
    }


    // Task 1.4. |A⟩ or |B⟩ ?
    // Inputs:
    //      1) angle alpha, in radians, represented as Double
    //      2) a qubit which is guaranteed to be in |A⟩ or |B⟩ state
    //         |A⟩ =   cos(alpha) * |0⟩ + sin(alpha) * |1⟩,
    //         |B⟩ = - sin(alpha) * |0⟩ + cos(alpha) * |1⟩.
    // Output: true if the qubit was in |A⟩ state, or false if it was in |B⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitA_Reference (alpha : Double, q : Qubit) : Bool {
        // |0⟩ is converted into |A⟩ and |1⟩ into |B⟩ by Ry(2.0 * alpha)
        // so |A⟩ is converted into |0⟩ by the opposite rotation
        Ry(-2.0 * alpha, q);
        return M(q) == Zero;
    }


    // Task 1.5. |00⟩ or |11⟩ ?
    // Input: two qubits (stored in an array of length 2) which are guaranteed to be in either the  |00⟩ or the |11⟩ state.
    // Output: 0 if the qubits were in the |00⟩ state,
    //         1 if they were in |11⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation ZeroZeroOrOneOne_Reference (qs : Qubit[]) : Int {
        // it's enough to do one measurement on any qubit
        return M(qs[0]) == Zero ? 0 | 1;
    }


    // Task 1.6. Distinguish four basis states
    // Input: two qubits (stored in an array) which are guaranteed to be
    //        in one of the four basis states (|00⟩, |01⟩, |10⟩ or |11⟩).
    // Output: 0 if qubits were in |00⟩ state,
    //         1 if they were in |01⟩ state,
    //         2 if they were in |10⟩ state,
    //         3 if they were in |11⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation BasisStateMeasurement_Reference (qs : Qubit[]) : Int {
        // Measurement on the first qubit gives the higher bit of the answer, on the second - the lower.
        // You can also use library function MeasureIntegerBE to get the same result.
        let m1 = M(qs[0]) == Zero ? 0 | 1;
        let m2 = M(qs[1]) == Zero ? 0 | 1;
        return m1 * 2 + m2;
    }


    // Task 1.7. Distinguish two basis states given by bit strings
    // Inputs:
    //      1) N qubits (stored in an array) which are guaranteed to be
    //         in one of the two basis states described by the given bit strings.
    //      2) two bit string represented as Bool[]s.
    // Output: 0 if qubits were in the basis state described by the first bit string,
    //         1 if they were in the basis state described by the second bit string.
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // The state of the qubits at the end of the operation does not matter.
    // You are guaranteed that the both bit strings have the same length as the qubit array,
    // and that the bit strings will differ in at least one bit.
    // You can use exactly one measurement.
    // Example: for bit strings [false, true, false] and [false, false, true]
    //          return 0 corresponds to state |010⟩, and return 1 corresponds to state |001⟩.
    function FindFirstDiff_Reference (bits1 : Bool[], bits2 : Bool[]) : Int {
        for (i in 0 .. Length(bits1) - 1) {
            if (bits1[i] != bits2[i]) {
                return i;
            }
        }
        return -1;
    }


    operation TwoBitstringsMeasurement_Reference (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : Int {
        // find the first index at which the bit strings are different and measure it
        let firstDiff = FindFirstDiff_Reference(bits1, bits2);
        let res = M(qs[firstDiff]) == One;

        return res == bits1[firstDiff] ? 0 | 1;
    }


    // Task 1.8. Distinguish two superposition states given by two arrays of bit strings - 1 measurement
    function FindFirstSuperpositionDiff_Reference (bits1 : Bool[][], bits2 : Bool[][], Nqubits : Int) : Int {
        for (i in 0 .. Nqubits - 1) {
            // count the number of 1s in i-th position in bit strings of both arrays
            mutable val1 = 0;
            mutable val2 = 0;
            for (j in 0 .. Length(bits1) - 1) {
                if (bits1[j][i]) {
                    set val1 += 1;
                }
            }
            for (k in 0 .. Length(bits2) - 1) {
                if (bits2[k][i]) {
                    set val2 += 1;
                }
            }
            if ((val1 == Length(bits1) and val2 == 0) or (val1 == 0 and val2 == Length(bits2))) {
                return i;
            }
        }

        return -1;
    }

    operation SuperpositionOneMeasurement_Reference (qs : Qubit[], bits1 : Bool[][], bits2 : Bool[][]) : Int {
        // find the position in which the bit strings of two arrays differ
        let diff = FindFirstSuperpositionDiff_Reference(bits1, bits2, Length(qs));

        let res = ResultAsBool(M(qs[diff]));

        if (res == bits1[0][diff]) {
            return 0;
        }
        else {
            return 1;
        }
    }


    // Task 1.9. Distinguish two superposition states given by two arrays of bit strings

    function AreBitstringsEqual (bits1 : Bool[], bits2 : Bool[]) : Bool {
        for (i in 0.. Length(bits1) - 1) {
            if (bits1[i] != bits2[i]) {
                return false;
            }
        }
        return true;
    }


    operation SuperpositionMeasurement_Reference (qs : Qubit[], bits1 : Bool[][], bits2 : Bool[][]) : Int {
        // measure all qubits and check in which array you can find the resulting bit string
        let meas = ResultArrayAsBoolArray (MultiM(qs));
        for (i in 0 .. Length(bits1) - 1) {
            if (AreBitstringsEqual(bits1[i], meas)) {
                return 0;
            }
        }
        return 1;
    }


    // Alternate reference implementation for task 1.9
    // Slightly more expensive, but uses built-in functions
    operation SuperpositionMeasurement_Alternate (qs : Qubit[], bits1 : Bool[][], bits2 : Bool[][]) : Int {
        // measure all qubits and, treating the result as an integer, check whether it can be found in one of the bit arrays
        let measuredState = ResultArrayAsInt(MultiM(qs));
        for (s in bits1) {
            if (BoolArrayAsInt(s) == measuredState) {
                return 0;
            }
        }
        return 1;
    }


    // Task 1.10. |0...0⟩ state or W state ?
    // Input: N qubits (stored in an array) which are guaranteed to be
    //        either in |0...0⟩ state
    //        or in W state (https://en.wikipedia.org/wiki/W_state).
    // Output: 0 if qubits were in |0...0⟩ state,
    //         1 if they were in W state.
    // The state of the qubits at the end of the operation does not matter.
    operation AllZerosOrWState_Reference (qs : Qubit[]) : Int {
        // measure all qubits; if there is exactly one One, it's W state, if there are no Ones, it's |0...0⟩
        // (and there should never be two or more Ones)
        mutable countOnes = 0;

        for (q in qs) {
            if (M(q) == One) {
                set countOnes += 1;
            }
        }

        if (countOnes > 1) {
            fail "Impossible to get multiple Ones when measuring W state";
        }
        return countOnes == 0 ? 0 | 1;
    }


    // Alternate reference implementation for task 1.10
    operation AllZerosOrWState_Alternate (qs : Qubit[]) : Int {
        // measure all qubits and convert the result into an integer;
        // if we get 0 then the state is |0...0⟩, any non-0 integer indicates W state
        return ResultArrayAsInt(MultiM(qs)) == 0 ? 0 | 1;
    }


    // Task 1.11. GHZ state or W state ?
    // Input: N >= 2 qubits (stored in an array) which are guaranteed to be
    //        either in GHZ state (https://en.wikipedia.org/wiki/Greenberger%E2%80%93Horne%E2%80%93Zeilinger_state)
    //        or in W state (https://en.wikipedia.org/wiki/W_state).
    // Output: 0 if qubits were in GHZ state,
    //         1 if they were in W state.
    // The state of the qubits at the end of the operation does not matter.
    operation GHZOrWState_Reference (qs : Qubit[]) : Int {
        // measure all qubits; if there is exactly one One, it's W state,
        // if there are no Ones or all are Ones, it's GHZ
        // (and there should never be a different number of Ones)
        mutable countOnes = 0;

        for (q in qs) {
            if (M(q) == One) {
                set countOnes += 1;
            }
        }

        let N = Length(qs);
        if (countOnes > 1 and countOnes < N) {
            fail $"Impossible to get {countOnes} Ones when measuring W state or GHZ state on {N} qubits";
        }
        return countOnes == 1 ? 1 | 0;
    }


    // Alternate reference implementation for task 1.11
    operation GHZOrWState_Alternate (qs : Qubit[]) : Int {
        // measure all qubits and convert the measurement results into an integer;
        // measuring GHZ state will produce either a 0...0 result or a 1...1 result, which correspond to integers 0 and 2ᴺ-1, respectively
        let m = ResultArrayAsInt(MultiM(qs));
        return (m == 0 or m == (1 <<< Length(qs))-1) ? 0 | 1;
    }


    // Task 1.12. Distinguish four Bell states
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four Bell states:
    //         |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
    //         |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
    //         |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
    //         |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
    // Output: 0 if qubits were in |Φ⁺⟩ state,
    //         1 if they were in |Φ⁻⟩ state,
    //         2 if they were in |Ψ⁺⟩ state,
    //         3 if they were in |Ψ⁻⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation BellState_Reference (qs : Qubit[]) : Int {
        CNOT(qs[0], qs[1]);
        H(qs[0]);

        // these changes brought the state back to one of the 2-qubit basis states from task 1.6 (but in different order)
        let m1 = M(qs[0]) == Zero ? 0 | 1;
        let m2 = M(qs[1]) == Zero ? 0 | 1;
        return m2 * 2 + m1;
    }


    // Task 1.13. Distinguish four orthogonal 2-qubit states
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four orthogonal states:
    //         |S0⟩ = (|00⟩ + |01⟩ + |10⟩ + |11⟩) / 2
    //         |S1⟩ = (|00⟩ - |01⟩ + |10⟩ - |11⟩) / 2
    //         |S2⟩ = (|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2
    //         |S3⟩ = (|00⟩ - |01⟩ - |10⟩ + |11⟩) / 2
    // Output: 0 if qubits were in |S0⟩ state,
    //         1 if they were in |S1⟩ state,
    //         2 if they were in |S2⟩ state,
    //         3 if they were in |S3⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation TwoQubitState_Reference (qs : Qubit[]) : Int {
        // These states are produced by H ⊗ H, applied to four basis states.
        // To measure them, apply H ⊗ H followed by basis state measurement
        // implemented in BasisStateMeasurement_Reference.
        H(qs[0]);
        H(qs[1]);
        return BasisStateMeasurement_Reference(qs);
    }


    // Task 1.14*. Distinguish four orthogonal 2-qubit states, part two
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four orthogonal states:
    //         |S0⟩ = ( |00⟩ - |01⟩ - |10⟩ - |11⟩) / 2
    //         |S1⟩ = (-|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2
    //         |S2⟩ = (-|00⟩ - |01⟩ + |10⟩ - |11⟩) / 2
    //         |S3⟩ = (-|00⟩ - |01⟩ - |10⟩ + |11⟩) / 2
    // Output: 0 if qubits were in |S0⟩ state,
    //         1 if they were in |S1⟩ state,
    //         2 if they were in |S2⟩ state,
    //         3 if they were in |S3⟩ state.
    // The state of the qubits at the end of the operation does not matter.

    operation TwoQubitStatePartTwo_Reference (qs : Qubit[]) : Int {
        // Try this!
        H(qs[1]);

        // Now, each of the four input states has been converted to a Bell
        // state:
        // |S0⟩ ↦ |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
        // |S1⟩ ↦ |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
        // |S2⟩ ↦ |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
        // |S3⟩ ↦ |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
        // We can refer now to task 1.10 (what follows is an alternate solution
        // to 1.10, with some tweaks to reorder the output values).

        CNOT(qs[0], qs[1]);
        H(qs[0]);

        let m1 = M(qs[0]) == One ? 0 | 1;
        let m2 = M(qs[1]) == One ? 0 | 1;
        return m2 * 2 + m1;
    }

    // Helper function to implement diag(-1, 1, 1, 1) for the alternate solution to 1.14
    operation ApplyDiag (qs : Qubit[]) : Unit {

        body (...) {
            ApplyToEach(X, qs);
            Controlled Z([qs[0]], qs[1]);
            ApplyToEach(X, qs);
        }

        adjoint self;
    }


    // Alternate reference implementation for Task 1.14
    operation TwoQubitStatePartTwo_Alternate (qs : Qubit[]) : Int {

        // Observe that the unitary matrix A formed by the columns |S0⟩, ..., |S3⟩
        // is up to permutations matrices and diagonal +1/-1 matrices equal to the
        // tensor product H ⊗ H when multiplied from the left and the right.
        // Specifically, A = diag(-1, 1, 1, 1) (H ⊗ H) diag(-1, 1, 1, 1) pi,
        // where pi is the permutation (1,2) corresponding to a swap of 2 qubits.

        // Apply permutation pi
        SWAP(qs[0], qs[1]);

        // Apply diag(..) (H ⊗ H) diag(..)
        With(ApplyDiag, ApplyToEach(H, _), qs);
        return BasisStateMeasurement_Reference(qs);
    }



    // Task 1.15**. Distinguish two orthogonal states on three qubits
    operation ThreeQubitMeasurement_Reference (qs : Qubit[]) : Int {

        // We first apply a unitary operation to the input state so that it maps the first state
        // to the W-state (see Task 10 in the "Superposition" kata) 1/sqrt(3) ( |100⟩ + |010⟩ + |001⟩ ).
        // This can be accomplished by a tensor product of the form I₂ ⊗ R ⊗ R², where
        //  - I₂ denotes the 2x2 identity matrix which is applied to qubit 0,
        //  - R is the diagonal matrix diag(1, ω^-1) = diag(1, ω²) which is applied to qubit 1,
        //  - R² = diag(1, ω) which is applied to qubit 2.
        // Note that upon applying the operator I₂ ⊗ R ⊗ R²,
        // the second state gets then mapped to 1/sqrt(3) ( |100⟩ + ω |010⟩ + ω² |001⟩ ).
        //
        // We can now perfectly distinguish these two states by invoking the inverse of the state prep
        // routine for W-states (as in Task 10 of "Superposition") which will map the first state to the
        // state |000⟩ and the second state to some state which is guaranteed to be perpendicular to
        // the state |000⟩, i.e., the second state gets mapped to a superposition that does not involve
        // |000⟩. Now, the two states can be perfectly distinguished (while leaving them intact) by
        // attaching an ancilla qubit, computing the OR function of the three bits (which can be
        // accomplished using a multiply-controlled X gate with inverted inputs) and measuring said
        // ancilla qubit.
        mutable result = 0;

        // rotate qubit 1 by angle - 2π/3 around z-axis
        Rz((4.0 * PI()) / 3.0, qs[1]);

        // rotate qubit 2 by angle - 4π/3 around z-axis
        Rz((8.0 * PI()) / 3.0, qs[2]);

        // Apply inverse state prep of 1/sqrt(3) ( |100⟩ + |010⟩ + |001⟩ )
        Adjoint WState_Arbitrary_Reference(qs);

        // need one qubit to store result of comparison "000" vs "not 000"
        using (anc = Qubit()) {
            // compute the OR function into anc
            (ControlledOnInt(0, X))(qs, anc);
            set result = MResetZ(anc) == One ? 0 | 1;
        }

        // Fix up the state so that it is identical to the input state
        // (this is not required if the state of the qubits after the operation does not matter)

        // Apply state prep of 1/sqrt(3) ( |100⟩ + |010⟩ + |001⟩ )
        WState_Arbitrary_Reference(qs);

        // rotate qubit 1 by angle 2π/3 around z-axis
        Rz((-4.0 * PI()) / 3.0, qs[1]);

        // rotate qubit 2 by angle 4π/3 around z-axis
        Rz((-8.0 * PI()) / 3.0, qs[2]);

        // finally, we return the result
        return result;
    }


    // An alternative solution to task 1.15, using a simpler measurement
    operation ThreeQubitMeasurement_SimpleMeasurement (qs : Qubit[]) : Int {
        // map the first state to 000 state and the second one to something orthogonal to it
        // (as described in reference solution)
        R1(-2.0 * PI() / 3.0, qs[1]);
        R1(-4.0 * PI() / 3.0, qs[2]);
        Adjoint WState_Arbitrary_Reference(qs);

        // measure all qubits: if all of them are 0, we have the first state,
        // if at least one of them is 1, we have the second state
        return MeasureInteger(LittleEndian(qs)) == 0 ? 0 | 1;
    }



    //////////////////////////////////////////////////////////////////
    // Part II*. Discriminating Nonorthogonal States
    //////////////////////////////////////////////////////////////////

    // Task 2.1*. |0⟩ or |+⟩ ?
    //           (quantum hypothesis testing or state discrimination with minimum error)
    // Input: a qubit which is guaranteed to be in |0⟩ or |+⟩ state with equal probability.
    // Output: true if qubit was in |0⟩ state, or false if it was in |+⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    // Note: in this task you have to get accuracy of at least 80%.
    operation IsQubitPlusOrZero_Reference (q : Qubit) : Bool {

        // Let {E_a, E_b} be a measurement with two outcomes a and b, which we identify with
        // the answers, i.e., "a" = "state was |0⟩" and "b = state was |+⟩". Then we define
        // P(a|0) = probability to observe first outcome given that the state was |0⟩
        // P(b|0) = probability to observe second outcome given that the state was |0⟩
        // P(a|+) = probability to observe first outcome given that the state was |+⟩
        // P(b|+) = probability to observe second outcome given that the state was |+⟩
        // The task is to maximize the probability to be correct on a single shot experiment,
        // which is the same as to minimize the probability to be wrong (on a single shot).
        // Assuming uniform prior, i.e., P(+) = P(0) = 1/2, we get
        // P_correct = P(0) P(a|0) + P(+) P(b|+) = 1/2 * (P(a|0) + P(b|+)).
        // Assuming a von Neumann measurement of the form
        // E_a = Ry(2*alpha) * (1,0) = (cos(alpha),  sin(alpha)) and
        // E_b = Ry(2*alpha) * (0,1) = (sin(alpha), -cos(alpha)), we get
        // P(a|0) = |⟨E_a|0⟩|² = cos²(alpha),
        // P(b|+) = |⟨E_b|+⟩|² = 1/2 + cos(alpha) sin(alpha), and
        // P_correct = 1/2 * (1/2 + cos²(alpha) + cos(alpha) sin(alpha)).
        // Maximizing this for alpha, we get max P_success = 1/2 (1 + 1/sqrt(2)) = 0.8535...,
        // which is attained for alpha = π/8.

        // Rotate the input state by π/8 means to apply Ry with angle 2π/8.
        Ry(0.25 * PI(), q);
        return M(q) == Zero;
    }


    // Task 2.2**. |0⟩, |+⟩ or inconclusive?
    //           (unambiguous state discrimination)
    // Input: a qubit which is guaranteed to be in |0⟩ or |+⟩ state with equal probability.
    // Output: 0 if qubit was in |0⟩ state,
    //         1 if it was in |+⟩ state,
    //         -1 if you can't decide, i.e., an "inconclusive" result.
    // Your solution:
    //  - can never give 0 or 1 answer incorrectly (i.e., identify |0⟩ as 1 or |+⟩ as 0).
    //  - must give inconclusive (-1) answer at most 80% of the times.
    //  - must correctly identify |0⟩ state as 0 at least 10% of the times.
    //  - must correctly identify |+⟩ state as 1 at least 10% of the times.
    //
    // The state of the qubit at the end of the operation does not matter.
    // You are allowed to use ancilla qubit(s).
    operation IsQubitPlusZeroOrInconclusiveSimpleUSD_Reference (q : Qubit) : Int {

        // A simple strategy that gives an inconclusive result with probability 0.75
        // and never errs in case it yields a conclusive result can be obtained from
        // randomizing the choice of measurement basis between the computational basis (std)
        // and the Hadamard basis (had). Observe that when measured in the standard basis,
        // the state |0⟩ will always lead to the outcome "0", whereas the state |+⟩
        // will lead to outcomes "0" respectively "1" with probability 1/2. This means
        // that upon measuring "1" we can with certainty conclude that the state was |+⟩.
        // A similar argument applies to the scenario where we measure in the Hadamard
        // basis, where |0⟩ can lead to both outcomes, whereas |+⟩ always leads to "0".
        // Then upon measuring "1" we can with certainty conclude that the state was |0⟩.
        //
        // This leads to the following scenarios (shown are the conditional probabilities
        // of the above scenarios and resulting answers).
        // state | basis | output 0 | output 1 | output -1
        // -----------------------------------------------
        //   |0⟩ |   std |     0    |     0    |     1
        //   |+⟩ |   std |     0    |    1/2   |    1/2
        //   |0⟩ |   had |    1/2   |     0    |    1/2
        //   |+⟩ |   had |     0    |     0    |     1
        let basis = RandomInt(2);

        // randomize over std and had
        if (basis == 0) {

            // use standard basis
            let result = M(q);
            // result is One only if the state was |+⟩
            return result == One ? 1 | -1;
        }
        else {
            // use Hadamard basis
            H(q);
            let result = M(q);
            // result is One only if the state was |0⟩
            return result == One ? 0 | -1;
        }
    }


    // Task 2.3**. Unambiguous state discrimination of 3 non-orthogonal states on one qubit
    //           (a.k.a. the Peres/Wootters game)
    // Input: a qubit which is guaranteed to be in one of the three states with equal probability:
    //        |A⟩ = 1/sqrt(2) (|0⟩ + |1⟩),
    //        |B⟩ = 1/sqrt(2) (|0⟩ + ω |1⟩),
    //        |C⟩ = 1/sqrt(2) (|0⟩ + ω² |1⟩).
    //        where ω = exp(2π/3) denotes a primitive, complex 3rd root of unity.
    // Output: 1 or 2 if qubit was in the |A⟩ state,
    //         0 or 2 if qubit was in the |B⟩ state,
    //         0 or 1 if qubit was in the |C⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    // Note: in this task you have to succeed with probability 1, i.e., your are never allowed
    //       to give an incorrect answer.
    operation IsQubitNotInABC_Reference (q : Qubit) : Int {

        // The key is the observation that the POVM with rank one elements {E_0, E_1, E_2} will do
        // the job, where E_k = |psi_k><psi_k| and |psi_k⟩ = 1/sqrt(2)(|0⟩-ω^k |1⟩) and where
        // k = 0, 1, 2. The remaining task will be to find a von Neumann measurement (on a qubit
        // system) that implements said POVM by means of a quantum circuit. To obtain such a
        // quantum circuit, we observe that all we need is a unitary extension of the matrix
        // formed by A = (psi_0, psi_1, psi_2). In general, such a unitary extension can be
        // found using a Singular Value Decomposition of the matrix. Here we can apply a short cut:
        // The matrix A can be extended (up to a +1/-1 diagonal) to a 3x3 Discrete Fourier Transform.
        // Padded with 1 extra dimension (i.e., a 1x1 block in which we have phase freedom), we obtain
        // a 4x4 unitary. Using the "Rader trick" we can now block decompose the 3x3 DFT and obtain two
        // 2x2 blocks which we can then implement using controlled single qubit gates. We present
        // the final resulting circuit without additional commentary.
        let alpha = ArcCos(Sqrt(2.0 / 3.0));

        using (a = Qubit()) {
            Z(q);
            CNOT(a, q);
            Controlled H([q], a);
            S(a);
            X(q);

            (ControlledOnInt(0, Ry))([a], (-2.0 * alpha, q));
            CNOT(a, q);
            Controlled H([q], a);
            CNOT(a, q);

            // finally, measure in the standard basis
            let res0 = MResetZ(a);
            let res1 = M(q);

            // dispatch on the cases
            if (res0 == Zero and res1 == Zero) {
                return 0;
            }
            elif (res0 == One and res1 == Zero) {
                return 1;
            }
            elif (res0 == Zero and res1 == One) {
                return 2;
            }
            else {
                // this should never occur
                return 3;
            }
        }
    }
}
