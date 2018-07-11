// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks. 
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Measurements
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;    

    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Measurements
    //////////////////////////////////////////////////////////////////

    // Task 1.1. |0〉 or |1〉 ?
    // Input: a qubit which is guaranteed to be in |0〉 or |1〉 state.
    // Output: true if qubit was in |1〉 state, or false if it was in |0〉 state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitOne_Reference (q : Qubit) : Bool
    {
        body
        {
            let res = M(q);
            return res == One;
        }
    }

    // Task 1.2. |+〉 or |-〉 ?
    // Input: a qubit which is guaranteed to be in |+〉 or |-〉 state
    //        (|+〉 = (|0〉 + |1〉) / sqrt(2), |-〉 = (|0〉 - |1〉) / sqrt(2)).
    // Output: true if qubit was in |+〉 state, or false if it was in |-〉 state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitPlus_Reference (q : Qubit) : Bool
    {
        body
        {
            H(q);
            let res = M(q);
            return res == Zero;
        }
    }

    // Task 1.3. |A〉 or |B〉 ?
    // Inputs:
    //      1) angle alpha, in radians, represented as Double
    //      2) a qubit which is guaranteed to be in |A〉 or |B〉 state
    //         |A〉 =   cos(alpha) * |0〉 + sin(alpha) * |1〉, 
    //         |B〉 = - sin(alpha) * |0〉 + cos(alpha) * |1〉.
    // Output: true if qubit was in |A〉 state, or false if it was in |B〉 state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitA_Reference (alpha : Double, q : Qubit) : Bool
    {
        body
        {
            // |0〉 is converted into |A〉 and |1〉 into |B〉 by Ry(2.0 * alpha)
            // so |A〉 is converted into |0〉 by the opposite rotation
            Ry(- 2.0 * alpha, q);
            let res = M(q);
            return res == Zero;
        }
    }

    // Task 1.4. |00〉 or |11〉 ?
    // Input: two qubits (stored in an array) which are guaranteed to be in |00〉 or |11〉 state.
    // Output: 0 if qubits were in |00〉 state,
    //         1 if they were in |11〉 state.
    // The state of the qubits at the end of the operation does not matter.
    operation ZeroZeroOrOneOne_Reference (qs : Qubit[]) : Int
    {
        body
        {
            // it's enough to do one measurement on any qubit
            let res = M(qs[0]);
            if (res == Zero) {
                return 0;
            } else {
                return 1;
            }
        }
    }

    // Task 1.5. Distinguish four basis states
    // Input: two qubits (stored in an array) which are guaranteed to be 
    //        in one of the four basis states (|00〉, |01〉, |10〉 or |11〉).
    // Output: 0 if qubits were in |00〉 state,
    //         1 if they were in |01〉 state,
    //         2 if they were in |10〉 state,
    //         3 if they were in |11〉 state.
    // The state of the qubits at the end of the operation does not matter.
    operation BasisStateMeasurement_Reference (qs : Qubit[]) : Int
    {
        body
        {
            // measurement on the first qubit gives the higher bit of the answer, on the second - the lower
            mutable m1 = 0;
            if (M(qs[0]) == One) {
                set m1 = 1;
            }
            mutable m2 = 0;
            if (M(qs[1]) == One) {
                set m2 = 1;
            }
            return m1 * 2 + m2;
        }
    }

    // Task 1.6. Distinguish two basis states given by bit strings
    // Inputs:
    //      1) N qubits (stored in an array) which are guaranteed to be 
    //         in one of the two basis states described by the given bit strings.
    //      2) two bit string represented as Bool[]s.
    // Output: 0 if qubits were in the basis state described by the first bit string,
    //         1 if they were in the basis state described by the second bit string.
    // Bit values false and true correspond to |0〉 and |1〉 states.
    // The state of the qubits at the end of the operation does not matter.
    // You are guaranteed that the both bit strings have the same length as the qubit array,
    // and that the bit strings will differ in at least one bit.
    // You can use exactly one measurement.
    // Example: for bit strings [false; true; false] and [false; false; true] 
    //          return 0 corresponds to state |010〉, and return 1 corresponds to state |001〉.

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

    operation TwoBitstringsMeasurement_Reference (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : Int
    {
        body
        {
            // find the first index at which the bit strings are different and measure it
            let firstDiff = FindFirstDiff_Reference(bits1, bits2);
            let res = (M(qs[firstDiff]) == One);
            if (res == bits1[firstDiff]) {
                return 0;
            } else {
                return 1;
            }
        }
    }

    // Task 1.7. |0...0〉 state or W state ?
    // Input: N qubits (stored in an array) which are guaranteed to be 
    //        either in |0...0〉 state
    //        or in W state (https://en.wikipedia.org/wiki/W_state).
    // Output: 0 if qubits were in |0...0〉 state,
    //         1 if they were in W state.
    // The state of the qubits at the end of the operation does not matter.
    operation AllZerosOrWState_Reference (qs : Qubit[]) : Int
    {
        body
        {
            // measure all qubits; if there is exactly one One, it's W state, if there are no Ones, it's |0...0〉
            // (and there should never be two or more Ones)
            mutable countOnes = 0;
            for (i in 0..Length(qs)-1) {
                if (M(qs[i]) == One) {
                    set countOnes = countOnes + 1;
                }
            }
            if (countOnes > 1) {
                fail "Impossible to get multiple Ones when measuring W state";
            }
            if (countOnes == 0) {
                return 0;
            }
            return 1;
        }
    }

    // Task 1.8. GHZ state or W state ?
    // Input: N qubits (stored in an array) which are guaranteed to be 
    //        either in GHZ state (https://en.wikipedia.org/wiki/Greenberger%E2%80%93Horne%E2%80%93Zeilinger_state)
    //        or in W state (https://en.wikipedia.org/wiki/W_state).
    // Output: 0 if qubits were in GHZ state,
    //         1 if they were in W state.
    // The state of the qubits at the end of the operation does not matter.
    operation GHZOrWState_Reference (qs : Qubit[]) : Int
    {
        body
        {
            // measure all qubits; if there is exactly one One, it's W state, 
            // if there are no Ones or all are Ones, it's GHZ
            // (and there should never be a different number of Ones)
            let N = Length(qs);
            mutable countOnes = 0;
            for (i in 0..N-1) {
                if (M(qs[i]) == One) {
                    set countOnes = countOnes + 1;
                }
            }
            if (countOnes > 1 && countOnes < Length(qs)) {
                fail $"Impossible to get {countOnes} Ones when measuring W state or GHZ state on {N} qubits";
            }
            if (countOnes == 1) {
                return 1;
            }
            return 0;
        }
    }

    // Task 1.9. Distinguish four Bell states
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four Bell states:
    //         |Φ⁺〉 = (|00〉 + |11〉) / sqrt(2)
    //         |Φ⁻〉 = (|00〉 - |11〉) / sqrt(2)
    //         |Ψ⁺〉 = (|01〉 + |10〉) / sqrt(2)
    //         |Ψ⁻〉 = (|01〉 - |10〉) / sqrt(2)
    // Output: 0 if qubits were in |Φ⁺〉 state,
    //         1 if they were in |Φ⁻〉 state,
    //         2 if they were in |Ψ⁺〉 state,
    //         3 if they were in |Ψ⁻〉 state.
    // The state of the qubits at the end of the operation does not matter.
    operation BellState_Reference (qs : Qubit[]) : Int
    {
        body
        {
            H(qs[0]);
            H(qs[1]);
            CNOT(qs[1], qs[0]);
            H(qs[1]);
            mutable m1 = 0;
            if (M(qs[0]) == One) {
                set m1 = 1;
            }
            mutable m2 = 0;
            if (M(qs[1]) == One) {
                set m2 = 1;
            }
            return m2 * 2 + m1;
        }
    }

    // Task 1.10*. Distinguish four orthogonal 2-qubit states
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four orthogonal states:
    //         |S0〉 = (|00〉 + |01〉 + |10〉 + |11〉) / 2
    //         |S1〉 = (|00〉 - |01〉 + |10〉 - |11〉) / 2
    //         |S2〉 = (|00〉 + |01〉 - |10〉 - |11〉) / 2
    //         |S3〉 = (|00〉 - |01〉 - |10〉 + |11〉) / 2
    // Output: 0 if qubits were in |S0〉 state,
    //         1 if they were in |S1〉 state,
    //         2 if they were in |S2〉 state,
    //         3 if they were in |S3〉 state.
    // The state of the qubits at the end of the operation does not matter.
    operation TwoQubitState_Reference (qs : Qubit[]) : Int
    {
        body
        {
            // These states are produced by H ⊗ H, applied to four basis states.
            // To measure them, apply H ⊗ H followed by basis state measurement 
            // implemented in BasisStateMeasurement_Reference.
            H(qs[0]);
            H(qs[1]);
            return BasisStateMeasurement_Reference(qs);
        }
    }
    
    // Task 1.11**. Distinguish four orthogonal 2-qubit states, part two
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four orthogonal states:
    //         |S0〉 = ( |00〉 - |01〉 - |10〉 - |11〉) / 2
    //         |S1〉 = (-|00〉 + |01〉 - |10〉 - |11〉) / 2
    //         |S2〉 = (-|00〉 - |01〉 + |10〉 - |11〉) / 2
    //         |S3〉 = (-|00〉 - |01〉 - |10〉 + |11〉) / 2
    // Output: 0 if qubits were in |S0〉 state,
    //         1 if they were in |S1〉 state,
    //         2 if they were in |S2〉 state,
    //         3 if they were in |S3〉 state.
    // The state of the qubits at the end of the operation does not matter.
    
    // Helper function to implement diag(-1, 1, 1, 1)
    operation ApplyDiag (qs : Qubit[]) : () 
    {
        body
        {
            ApplyToEach(X, qs); 
            (Controlled Z)([qs[0]], qs[1]);             
            ApplyToEach(X, qs); 
        }
        adjoint self
    }
    
    // The actual reference implementation for Task 1.11
    operation TwoQubitStatePartTwo_Reference (qs : Qubit[]) : Int
    {
        body
        {
            // Observe that the unitary matrix A formed by the columns |S0〉, ..., |S3〉
            // is up to permutations matrices and diagonal +1/-1 matrices equal to the 
            // tensor product H ⊗ H when multiplied from the left and the right. 
            // Specifically, A = diag(-1, 1, 1, 1) (H ⊗ H) diag(-1, 1, 1, 1) pi, 
            // where pi is the permutation (1,2) corresponding to a swap of 2 qubits. 
            SWAP(qs[0], qs[1]); // pi
            With(ApplyDiag, ApplyToEach(H, _), qs); // diag(..) (H ⊗ H) diag(..)			
            return BasisStateMeasurement_Reference(qs);			
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II*. Discriminating Nonorthogonal States
    //////////////////////////////////////////////////////////////////

    // Task 2.1*. |0〉 or |+〉 ?
    //           (quantum hypothesis testing or state discrimination with minimum error)
    // Input: a qubit which is guaranteed to be in |0〉 or |+〉 state with equal probability.
    // Output: true if qubit was in |0〉 state, or false if it was in |+〉 state.
    // The state of the qubit at the end of the operation does not matter.
    // Note: in this task you have to get accuracy of at least 80%.
    operation IsQubitPlusOrZero_Reference (q : Qubit) : Bool
    {
        body
        {
            // Let {E_a, E_b} be a measurement with two outcomes a and b, which we identify with 
            // the answers, i.e., "a" = "state was |0〉" and "b = state was |+〉". Then we define
            // P(a|0) = probability to observe first outcome given that the state was |0〉
            // P(b|0) = probability to observe second outcome given that the state was |0〉
            // P(a|+) = probability to observe first outcome given that the state was |+〉
            // P(b|+) = probability to observe second outcome given that the state was |+〉
            // the task is to maximize the probability to be correct on a single shot experiment
            // which is the same as to minimize the probability to be wrong (on a single shot).
            // Assuming uniform prior, i.e., P(+) = P(0) = 1/2, we get 
            // P_correct = P(0) P(a|0) + P(+) P(b|+). Assuming a von Neumann measurement of the 
            // form E_a = Ry(2*alpha) * (1,0) = (cos(alpha), sin(alpha)) and 
            // E_b = Ry(2*alpha) * (0,1) = (sin(alpha), -cos(alpha)), we get that 
            // P_correct = 1/2 + cos²(alpha) + cos(alpha) sin(alpha). Maximizing this for alpha, 
            // we get max P_success = 1/2 (1 + 1/sqrt(2)) = 0.8535.., which is attained for alpha = π/8. 

            // Rotate the input state by π/8 means to apply Ry with angle 2π/8.  
            Ry(0.25*PI(), q);
            return (M(q) == Zero);
        }
    }

    // Task 2.2**. |0〉, |+〉 or inconclusive?
    //           (unambiguous state discrimination)
    // Input: a qubit which is guaranteed to be in |0〉 or |+〉 state with equal probability.
    // Output: 0 if qubit was in |0〉 state,
    //         1 if it was in |+〉 state,
    //         -1 if you can't decide, i.e., an "inconclusive" result.
    // Your solution:
    //  - can never give 0 or 1 answer incorrectly (i.e., identify |0〉 as 1 or |+〉 as 0).
    //  - must give inconclusive (-1) answer at most 80% of the times. 
    //  - must correctly identify |0〉 state as 0 at least 10% of the times.
    //  - must correctly identify |1〉 state as 1 at least 10% of the times.
    //
    // The state of the qubit at the end of the operation does not matter.
    // You are allowed to use ancilla qubit(s). 
    operation IsQubitPlusZeroOrInconclusiveSimpleUSD_Reference (q : Qubit) : Int
    {
        body
        {
            // A simple strategy that gives an inconclusive result with probability 0.75 
            // and never errs in case it yields a conclusive result can be obtained from 
            // randomizing the choice of measurement basis between the computational basis (std)
            // and the Hadamard basis (had). Observe that when measured in the standard basis, 
            // the state |0〉 will always lead to the outcome "0", whereas the state |+〉 
            // will lead to outcomes "0" respectively "1" with probability 1/2. This means
            // that upon measuring "1" we can with certainty conclude that the state was |+〉. 
            // A similar argument applies to the scenario where we measure in the Hadamard 
            // basis, where |0〉 can lead to both outcomes, whereas |+〉 always leads to "0". 
            // Then upon measuring "1" we can with certainty conclude that the state was |0〉.
            //
            // This leads to the following scenarios (shown are the conditional probabilities 
            // of the above scenarios and resulting answers).
            // state | basis | output 0 | output 1 | output -1 
            // -----------------------------------------------
            //   |0〉 |   std |     0    |     0    |     1
            //   |+〉 |   std |     0    |    1/2   |    1/2 
            //   |0〉 |   had |    1/2   |     0    |    1/2
            //   |+〉 |   had |     0    |     0    |     1
            
            mutable output = 0; 
            let basis = RandomInt(2); 
            // randomize over std and had
            
            if (basis == 0) { 
                // use standard basis
                let result = M(q); 				
                if (result == One) { 
                    // this can only arise if the state was |+〉
                    set output = 1; 
                } 				
                else { 
                    set output = -1; 
                }
            }
            else { 
                // use Hadamard basis
                H(q);
                let result = M(q); 
                if (result == One) { 
                    // this can only arise if the state was |0〉
                    set output = 0; 
                } 				
                else { 
                    set output = -1; 
                }
            }
            return output;
        }
    }
}
