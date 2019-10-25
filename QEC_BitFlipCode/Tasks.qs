// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.QEC_BitFlipCode {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The "Quantum error correction - bit-flip code" quantum kata is
    // a series of exercises designed to get you familiar with
    // quantum error correction (QEC) and programming in Q#.
    // It introduces you to the simplest of QEC codes - the three-qubit bit-flip code,
    // which encodes each logical qubit in three physical qubits
    // and protects against single bit-flip error (equivalent to applying an X gate).
    // In practice quantum systems can have other types of errors,
    // which will be considered in the following katas on quantum error correction.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks.
    
    
    // Task 1. Parity Measurements
    //
    // Input: three qubits (stored as an array of length 3) in an unknown basis state
    //        or in a superposition of basis states of the same parity.
    // Output: the parity of this state, encoded as a value of Result type: 
    //         Zero for parity 0 and One for parity 1.
    //         The parity of basis state |x₀x₁x₂⟩ is defined as (x₀ ⊕ x₁ ⊕ x₂).
    // After applying the operation the state of the qubits should not change.
    // You can use exactly one measurement.
    // 
    // Example:
    // |000⟩, |101⟩ and |011⟩ all have parity 0, while |010⟩ and |111⟩ have parity 1.
    operation MeasureParity (register : Qubit[]) : Result {
        // Fill in your code here and change the return statement.
        // ...
        return Zero;
    }
    
    
    // Task 2. Encoding Codewords
    //
    // Input: three qubits in the state |ψ⟩ ⊗ |00⟩, where |ψ⟩ = α |0⟩ + β |1⟩ is
    //        the state of the first qubit, i.e., register[0].
    // Goal: create a state |̅ψ⟩ ≔ α |000⟩ + β |111⟩ on these qubits.
    operation Encode (register : Qubit[]) : Unit {
        // ...
    }
    
    
    // Task 3. Error Detection I
    //
    // Input: three qubits that are either in the state  |̅ψ⟩ ≔ α |000⟩ + β |111⟩
    //        or in the state X𝟙𝟙|̅ψ⟩ = α |100⟩ + β |011⟩.
    // Note that the second state is the first state with X applied to the first qubit,
    // which corresponds to an X error happening on the first qubit.
    // Output: Zero if the input is |̅ψ⟩ (state without the error),
    //         One if the input is X𝟙𝟙|̅ψ⟩ (state with the error).
    // After applying the operation the state of the qubits should not change.
    operation DetectErrorOnLeftQubit (register : Qubit[]) : Result {
        // ...
        return Zero;
    }
    
    
    // Task 4. Error Correction I
    //
    // Input: three qubits that are either in the state  |̅ψ⟩ ≔ α |000⟩ + β |111⟩
    //        or in the state X𝟙𝟙|̅ψ⟩ = α |100⟩ + β |011⟩.
    // Goal: make sure that the qubits are returned to the state |̅ψ⟩
    //       (i.e., determine whether an X error has occurred, and if so, fix it).
    operation CorrectErrorOnLeftQubit (register : Qubit[]) : Unit {
        // Hint: you can use task 3 to figure out which state you are given.
        // ...
    }
    
    
    // Task 5. Error Detection II
    //
    // Input: three qubits that are either in the state |̅ψ⟩ ≔ α |000⟩ + β |111⟩
    //        or in one of the states X𝟙𝟙|̅ψ⟩, 𝟙X𝟙|̅ψ⟩ or 𝟙𝟙X|̅ψ⟩
    //        (i.e., state |̅ψ⟩ with an X error applied to one of the qubits).
    // Goal: determine whether an X error has occurred, and if so, on which qubit.
    // Error | Output
    // ======+=======
    // None  | 0
    // X𝟙𝟙   | 1
    // 𝟙X𝟙   | 2
    // 𝟙𝟙X   | 3
    // After applying the operation the state of the qubits should not change.
    operation DetectErrorOnAnyQubit (register : Qubit[]) : Int {
        // ...
        return -1;
    }
    
    
    // Task 6. Error Correction II
    //
    // Input: three qubits that are either in the state |̅ψ⟩ ≔ α |000⟩ + β |111⟩
    //        or in one of the states X𝟙𝟙|̅ψ⟩, 𝟙X𝟙|̅ψ⟩ or 𝟙𝟙X|̅ψ⟩
    //        (i.e., the qubits start in state |̅ψ⟩ with an X error possibly applied to one of the qubits).
    // Goal: make sure that the qubits are returned to the state |̅ψ⟩
    //       (i.e., determine whether an X error has occurred on any qubit, and if so, fix it).
    operation CorrectErrorOnAnyQubit (register : Qubit[]) : Unit {
        // ...
    }
    
    
    //////////////////////////////////////////////////////////////////
    // All the tasks in this kata have been dealing with X errors on single qubit.
    // The bit-flip code doesn't allow one to detect or correct a Z error or multiple X errors.
    // Indeed, a Z error on a logical state |ψ⟩ = α |0⟩ + β |1⟩ encoded using the bit-flip code
    // would convert the state |̅ψ⟩ ≔ α |000⟩ + β |111⟩ into α |000⟩ - β |111⟩,
    // which is a correct code word for logical state α |0⟩ - β |1⟩.
    // Two X errors (say, on qubits 1 and 2) would convert |̅ψ⟩ to α |110⟩ + β |001⟩,
    // which is a code word for logical state β |0⟩ + α |1⟩ with one X error on qubit 3.
    //////////////////////////////////////////////////////////////////
    
    // Task 7. Logical X Gate
    //
    // Input: three qubits that are either in the state |̅ψ⟩ ≔ α |000⟩ + β |111⟩
    //        or in one of the states X𝟙𝟙|̅ψ⟩, 𝟙X𝟙|̅ψ⟩ or 𝟙𝟙X|̅ψ⟩
    //        (i.e., state |̅ψ⟩ with an X error applied to one of the qubits).
    // Goal: apply a logical X operator, i.e., convert the qubits to the state
    //       ̅X |̅ψ⟩ = β |000⟩ + α |111⟩ or one of the states that can be represented as
    //       ̅X |̅ψ⟩ with an X error applied to one of the qubits (for example, β |010⟩ + α |101⟩).
    // If the state has an error, you can fix it, but this is not necessary.
    operation LogicalX (register : Qubit[]) : Unit {
        // ...
    }
    
    
    // Task 8. Logical Z Gate
    //
    // Input: three qubits that are either in the state |̅ψ⟩ ≔ α |000⟩ + β |111⟩
    //        or in one of the states X𝟙𝟙|̅ψ⟩, 𝟙X𝟙|̅ψ⟩ or 𝟙𝟙X|̅ψ⟩
    //        (i.e., state |̅ψ⟩ with an X error applied to one of the qubits).
    // Goal: apply a logical Z operator, i.e., convert the qubits to the state
    //       ̅Z |̅ψ⟩ = α |000⟩ - β |111⟩ or one of the states that can be represented as
    //       ̅Z |̅ψ⟩ with an X error applied to one of the qubits (for example, α |010⟩ - β |101⟩).
    // If the state has an error, you can fix it, but this is not necessary.
    operation LogicalZ (register : Qubit[]) : Unit {
        // ...
    }
    
}
