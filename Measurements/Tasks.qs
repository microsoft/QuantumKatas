// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Measurements {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;


    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The "Measurements" quantum kata is a series of exercises designed
    // to get you familiar with programming in Q#.
    // It covers the following topics:
    //  - using single-qubit measurements,
    //  - discriminating orthogonal and nonorthogonal states.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks.

    //////////////////////////////////////////////////////////////////
    // Part I. Discriminating Orthogonal States
    //////////////////////////////////////////////////////////////////

    // Task 1.1. |0⟩ or |1⟩ ?
    // Input: a qubit which is guaranteed to be in either the |0⟩ or the |1⟩ state.
    // Output: true if the qubit was in the |1⟩ state, or false if it was in the |0⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitOne (q : Qubit) : Bool {
        // The operation M will measure a qubit in the Z basis (|0⟩ and |1⟩ basis)
        // and return Zero if the observed state was |0⟩ or One if the state was |1⟩.
        // To answer the question, you need to perform the measurement and check whether the result
        // equals One - either directly or using library function IsResultOne.
        //
        // Replace the returned expression with (M(q) == One).
        // Then rebuild the project and rerun the tests - T101_IsQubitOne_Test should now pass!

        return false;
    }


    // Task 1.2. Set qubit to |0⟩ state
    // Input: a qubit in an arbitrary state.
    // Goal:  change the state of the qubit to |0⟩.
    operation InitializeQubit (q : Qubit) : Unit {
        // ...
    }


    // Task 1.3. |+⟩ or |-⟩ ?
    // Input: a qubit which is guaranteed to be in either the |+⟩ or the |-⟩ state
    //        (|+⟩ = (|0⟩ + |1⟩) / sqrt(2), |-⟩ = (|0⟩ - |1⟩) / sqrt(2)).
    // Output: true if the qubit was in the |+⟩ state, or false if it was in the |-⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitPlus (q : Qubit) : Bool {
        // ...
        return false;
    }


    // Task 1.4. |A⟩ or |B⟩ ?
    // Inputs:
    //      1) angle α, in radians, represented as a Double
    //      2) a qubit which is guaranteed to be in either the |A⟩ or the |B⟩ state, where
    //         |A⟩ =   cos α |0⟩ + sin α |1⟩,
    //         |B⟩ = - sin α |0⟩ + cos α |1⟩.
    // Output: true if the qubit was in the |A⟩ state, or false if it was in the |B⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitA (alpha : Double, q : Qubit) : Bool {
        // ...
        return false;
    }


    // Task 1.5. |00⟩ or |11⟩ ?
    // Input: two qubits (stored in an array of length 2) which are guaranteed to be in either the |00⟩ or the |11⟩ state.
    // Output: 0 if the qubits were in the |00⟩ state,
    //         1 if they were in |11⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation ZeroZeroOrOneOne (qs : Qubit[]) : Int {
        // ...
        return -1;
    }


    // Task 1.6. Distinguish four basis states
    // Input: two qubits (stored in an array) which are guaranteed to be
    //        in one of the four basis states (|00⟩, |01⟩, |10⟩ or |11⟩).
    // Output: 0 if the qubits were in |00⟩ state,
    //         1 if they were in |01⟩ state,
    //         2 if they were in |10⟩ state,
    //         3 if they were in |11⟩ state.
    // In this task and the subsequent ones the order of qubit states
    // in task description matches the order of qubits in the array
    // (i.e., |10⟩ state corresponds to qs[0] in state |1⟩ and qs[1] in state |0⟩).
    // The state of the qubits at the end of the operation does not matter.
    operation BasisStateMeasurement (qs : Qubit[]) : Int {
        // ...
        return -1;
    }


    // Task 1.7. Distinguish two basis states given by bit strings
    // Inputs:
    //      1) N qubits (stored in an array) which are guaranteed to be
    //         in one of the two basis states described by the given bit strings.
    //      2) two bit string represented as Bool[]s.
    // Output: 0 if the qubits were in the basis state described by the first bit string,
    //         1 if they were in the basis state described by the second bit string.
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // The state of the qubits at the end of the operation does not matter.
    // You are guaranteed that both bit strings have the same length as the qubit array,
    // and that the bit strings differ in at least one bit.
    // You can use exactly one measurement.
    // Example: for bit strings [false, true, false] and [false, false, true]
    //          return 0 corresponds to state |010⟩, and return 1 corresponds to state |001⟩.
    operation TwoBitstringsMeasurement (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : Int {
        // ...
        return -1;
    }


    // Task 1.8. Distinguish two superposition states given by two arrays of bit strings - 1 measurement
    // Inputs:
    //      1) N qubits which are guaranteed to be
    //         in one of the two superposition states described by the given arrays of bit strings.
    //      2) two arrays of bit strings represented as Bool[][]s.
    //         The arrays have dimensions M₁ ⨯ N and M₂ ⨯ N respectively, where N is the number of
    //         qubits and M₁ and M₂ are the numbers of bit strings in each array. Note that in general M₁ ≠ M₂.
    //         An array of bit strings [b₁, ..., bₘ] defines a state that is
    //         an equal superposition of all basis states defined by bit strings b₁, ..., bₘ.
    //         For example, an array of bit strings [[false, true, false], [false, true, true]]
    //         defines a superposition state (|010⟩ + |011⟩) / sqrt(2).
    //         
    // Output: 0 if qubits were in the superposition state described by the first array,
    //         1 if they were in the superposition state described by the second array.
    // The state of the qubits at the end of the operation does not matter.
    //
    // You are allowed to use exactly one measurement.
    // You are guaranteed that there exists an index of a qubit Q for which 
    //  - all the bit strings in the first array have the same value in this position (all bits1[j][Q] are the same),
    //  - all the bit strings in the second array have the same value in this position (all bits2[j][Q] are the same),
    //  - these values are different for the first and the second arrays.
    // 
    // Example: for arrays [[false, true, false], [false, true, true]] and [[true, false, true], [false, false, true]]
    //          return 0 corresponds to state (|010⟩ + |011⟩) / sqrt(2), 
    //          return 1 corresponds to state (|101⟩ + |001⟩) / sqrt(2),
    //          and you can distinguish these states perfectly by measuring the second qubit.
    operation SuperpositionOneMeasurement (qs : Qubit[], bits1 : Bool[][], bits2 : Bool[][]) : Int {
        // ...
        return -1;
    }


    // Task 1.9. Distinguish two superposition states given by two arrays of bit strings
    // Inputs:
    //      1) N qubits which are guaranteed to be
    //         in one of the two superposition states described by the given arrays of bit strings.
    //      2) two arrays of bit strings represented as Bool[][]s.
    //         The arrays describe the superposition states in the same way as in the previous task,
    //         i.e., they have dimensions M₁ ⨯ N and M₂ ⨯ N respectively, N being the number of qubits.
    //
    // Output: 0 if qubits were in the superposition state described by the first array,
    //         1 if they were in the superposition state described by the second array.
    // The state of the qubits at the end of the operation does not matter.
    //
    // You can use as many measurements as you wish.
    // The only constraint on the bit strings is that all bit strings in the two arrays are distinct. 
    //
    // Example: for arrays [[false, true, false], [false, false, true]] and [[true, true, true], [false, true, true]]
    //          return 0 corresponds to state (|010⟩ + |001⟩) / sqrt(2), 
    //          return 1 corresponds to state (|111⟩ + |011⟩) / sqrt(2)
    operation SuperpositionMeasurement (qs : Qubit[], bits1 : Bool[][], bits2 : Bool[][]) : Int {
        // ...
        return -1;
    }


    // Task 1.10. |0...0⟩ state or W state ?
    // Input: N qubits (stored in an array) which are guaranteed to be
    //        either in the |0...0⟩ state
    //        or in the W state (https://en.wikipedia.org/wiki/W_state).
    // Output: 0 if the qubits were in the |0...0⟩ state,
    //         1 if they were in the W state.
    // The state of the qubits at the end of the operation does not matter.
    operation AllZerosOrWState (qs : Qubit[]) : Int {
        // ...
        return -1;
    }


    // Task 1.11. GHZ state or W state ?
    // Input: N >= 2 qubits (stored in an array) which are guaranteed to be
    //        either in the GHZ state (https://en.wikipedia.org/wiki/Greenberger%E2%80%93Horne%E2%80%93Zeilinger_state)
    //        or in the W state (https://en.wikipedia.org/wiki/W_state).
    // Output: 0 if the qubits were in the GHZ state,
    //         1 if they were in the W state.
    // The state of the qubits at the end of the operation does not matter.
    operation GHZOrWState (qs : Qubit[]) : Int {
        // ...
        return -1;
    }


    // Task 1.12. Distinguish four Bell states
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four Bell states:
    //         |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
    //         |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
    //         |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
    //         |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
    // Output: 0 if the qubits were in |Φ⁺⟩ state,
    //         1 if they were in |Φ⁻⟩ state,
    //         2 if they were in |Ψ⁺⟩ state,
    //         3 if they were in |Ψ⁻⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation BellState (qs : Qubit[]) : Int {
        // Hint: you need to use 2-qubit gates to solve this task

        // ...
        return -1;
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
    operation TwoQubitState (qs : Qubit[]) : Int {
        // ...
        return -1;
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
    operation TwoQubitStatePartTwo (qs : Qubit[]) : Int {
        // ...
        return -1;
    }


    // Task 1.15**. Distinguish two orthogonal states on three qubits
    // Input: Three qubits (stored in an array) which are guaranteed to be in either one of the
    //        following two states:
    //        1/sqrt(3) ( |100⟩ + ω |010⟩ + ω² |001⟩ ),
    //        1/sqrt(3) ( |100⟩ + ω² |010⟩ + ω |001⟩ ).
    //        Here ω = exp(2π i/3) denotes a primitive 3rd root of unity.
    // Output: 0 if the qubits were in the first superposition,
    //         1 if they were in the second superposition.
    // The state of the qubits at the end of the operation does not matter.
    operation ThreeQubitMeasurement (qs : Qubit[]) : Int {
        // ...
        return -1;
    }


    //////////////////////////////////////////////////////////////////
    // Part II*. Discriminating Nonorthogonal States
    //////////////////////////////////////////////////////////////////

    // The solutions for tasks in this section are validated using the following method.
    // The solution is called on N input states, each of which is picked randomly,
    // with all possible input states equally likely to be generated.
    // The accuracy of state discrimination is estimated as an average of
    // discrimination correctness over all input states.

    // Task 2.1*. |0⟩ or |+⟩ ?
    //           (quantum hypothesis testing or state discrimination with minimum error)
    // Input: a qubit which is guaranteed to be in either the |0⟩ or the |+⟩ state with equal probability.
    // Output: true if qubit was in the |0⟩ state, or false if it was in the |+⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    // Note: in this task you have to get accuracy of at least 80%.
    operation IsQubitPlusOrZero (q : Qubit) : Bool {
        // ...
        return true;
    }


    // Task 2.2**. |0⟩, |+⟩ or inconclusive?
    //             (unambiguous state discrimination)
    // Input: a qubit which is guaranteed to be in either the |0⟩ or the |+⟩ state with equal probability.
    // Output: 0 if qubit was in the |0⟩ state,
    //         1 if it was in the |+⟩ state,
    //         -1 if you can't decide, i.e., an "inconclusive" result.
    // Your solution:
    //  - should never give 0 or 1 answer incorrectly (i.e., identify |0⟩ as 1 or |+⟩ as 0).
    //  - may give an inconclusive (-1) answer in at most 80% of the cases.
    //  - must correctly identify |0⟩ state as 0 in at least 10% of the cases.
    //  - must correctly identify |+⟩ state as 1 in at least 10% of the cases.
    //
    // The state of the qubit at the end of the operation does not matter.
    // You are allowed to use ancilla qubit(s).
    operation IsQubitPlusZeroOrInconclusiveSimpleUSD (q : Qubit) : Int {
        // ...
        return -2;
    }


    // Task 2.3**. Unambiguous state discrimination of 3 non-orthogonal states on one qubit
    //             (a.k.a. the Peres/Wootters game)
    // Input: a qubit which is guaranteed to be in one of the three states with equal probability:
    //        |A⟩ = 1/sqrt(2) (|0⟩ + |1⟩),
    //        |B⟩ = 1/sqrt(2) (|0⟩ + ω |1⟩),
    //        |C⟩ = 1/sqrt(2) (|0⟩ + ω² |1⟩),
    //          where ω = exp(2iπ/3) denotes a primitive, complex 3rd root of unity.
    // Output: 1 or 2 if the qubit was in the |A⟩ state,
    //         0 or 2 if the qubit was in the |B⟩ state,
    //         0 or 1 if the qubit was in the |C⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    // Note: in this task you have to succeed with probability 1, i.e., you are never allowed
    //       to give an incorrect answer.
    operation IsQubitNotInABC (q : Qubit) : Int {
        // ...
        return -1;
    }
}
