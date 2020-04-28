// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.QFT {
    
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The "QFT (Quantum Fourier Transform)" quantum kata is a series of
    // exercises designed to teach you the basics of Quantum Fourier Transform.
    // It covers the following topics:
    //  - implementing QFT.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    //////////////////////////////////////////////////////////////////
    // Part I. Implementing Quantum Fourier Transform
    //////////////////////////////////////////////////////////////////
    
    // This sequence of tasks uses the implementation of QFT described in Nielsen & Chuang.

    // Task 1.1. 1-qubit QFT
    // Input: A qubit in state |ψ⟩ = x₀ |0⟩ + x₁ |1⟩.
    // Goal:  Apply QFT to this qubit, i.e., transform it to a state
    //        1/sqrt(2) ((x₀ + x₁)|0⟩ + (x₀ - x₁)|1⟩).
    // In other words, transform a basis state |j⟩ into a state 1/sqrt(2) (|0⟩ + exp(2πi·j/2)|1⟩).
    operation OneQubitQFT (q : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.2. Rotation gate
    // Inputs:
    //      1) A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    //      2) An integer k ≥ 0.
    // Goal: Change the state of the qubit to α |0⟩ + β · exp(2πi / 2ᵏ) |1⟩.
    // Note: Be careful about not introducing an extra global phase! 
    //       This is going to be important in the later tasks.
    operation Rotation (q : Qubit, k : Int) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.3. Prepare binary fraction exponent (classical input)
    // Inputs:
    //      1) A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    //      2) An array of bits [j₁, j₂, ..., jₙ], stored as Int[] (jₖ ∈ {0, 1}).
    // Goal: Change the state of the qubit to α |0⟩ + β · exp(2πi · 0.j₁j₂...jₙ) |1⟩,
    // where 0.j₁j₂...jₙ is a binary fraction, similar to decimal fractions:
    //       0.j₁j₂...jₙ = j₁ / 2¹ + j₂ / 2² + ... + jₙ / 2ⁿ.
    operation BinaryFractionClassical (q : Qubit, j : Int[]) : Unit is Adj+Ctl {
        // ...
    }
    

    // Task 1.4. Prepare binary fraction exponent (quantum input)
    // Inputs:
    //      1) A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    //      2) A register of qubits in state |j₁j₂...jₙ⟩.
    // Goal: Change the state of the input 
    //       from (α |0⟩ + β |1⟩) ⊗ |j₁j₂...jₙ⟩
    //         to (α |0⟩ + β · exp(2πi · 0.j₁j₂...jₙ) |1⟩) ⊗ |j₁j₂...jₙ⟩,
    //       where 0.j₁j₂...jₙ is a binary fraction corresponding to the basis state j₁j₂...jₙ of the register.
    // Note: The register of qubits can be in superposition as well; 
    //       the behavior in this case is defined by behavior on the basis states and the linearity of unitary transformations.
    operation BinaryFractionQuantum (q : Qubit, jRegister : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.5. Prepare binary fraction exponent in place (quantum input)
    // Input: A register of qubits in state |j₁j₂...jₙ⟩.
    // Goal: Change the state of the register
    //       from |j₁⟩ ⊗ |j₂...jₙ⟩
    //         to 1/sqrt(2) (|0⟩ + β · exp(2πi · 0.j₁j₂...jₙ) |1⟩) ⊗ |j₂...jₙ⟩.
    // Note: The register of qubits can be in superposition as well; 
    //       the behavior in this case is defined by behavior on the basis states and the linearity of unitary transformations.
    // Hint: This task is very similar to task 1.6, but the digit j₁ is encoded in-place, using task 1.1.
    operation BinaryFractionQuantumInPlace (register : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.6. Reverse the order of qubits
    // Input: A register of qubits in state |x₁x₂...xₙ⟩.
    // Goal: Reverse the order of qubits, i.e., convert the state of the register to |xₙ...x₂x₁⟩
    operation ReverseRegister (register : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }
    
    
    // Task 1.7. Quantum Fourier transform
    // Input: A register of qubits in state |j₁j₂...jₙ⟩.
    // Goal: Apply quantum Fourier transform to the input register, 
    //       i.e., transform it to a state 
    //       1/sqrt(2ⁿ) ∑ₖ exp(2πi · jk / 2ⁿ) |k⟩ =
    //     = 1/sqrt(2) (|0⟩ + exp(2πi · 0.jₙ) |1⟩) ⊗
    //     ⊗ 1/sqrt(2) (|0⟩ + exp(2πi · 0.jₙ₋₁jₙ) |1⟩) ⊗ ... ⊗
    //     ⊗ 1/sqrt(2) (|0⟩ + exp(2πi · 0.j₁j₂...jₙ₋₁jₙ) |1⟩)
    //
    // Note: The register of qubits can be in superposition as well; 
    //       the behavior in this case is defined by behavior on the basis states and the linearity of unitary transformations.
    // Note: You can do this with a library call, but we recommend
    //       implementing the algorithm yourself for learning purposes, using the previous tasks. 
    //
    // Hint: Consider preparing a different state first and transforming it to the goal state:
    //       1/sqrt(2) (|0⟩ + exp(2πi · 0.j₁j₂...jₙ₋₁jₙ) |1⟩) ⊗ ... ⊗
    //     ⊗ 1/sqrt(2) (|0⟩ + exp(2πi · 0.jₙ₋₁jₙ) |1⟩) ⊗
    //     ⊗ 1/sqrt(2) (|0⟩ + exp(2πi · 0.jₙ) |1⟩) ⊗
    operation QuantumFourierTransform (register : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.8. Inverse QFT
    // Input: A register of qubits in state |j₁j₂...jₙ⟩.
    // Goal: Apply inverse QFT to the input register,
    //       i.e., transform it to a state 
    //       1/sqrt(2ⁿ) ∑ₖ exp(-2πi · jk / 2ⁿ) |k⟩.
    // Hint: Inverse QFT is literally the inverse transformation of QFT.
    //       Do you know a quantum way to express this?
    operation InverseQFT (register : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }

}
