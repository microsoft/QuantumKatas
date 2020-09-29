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
    //  - implementing QFT,
    //  - using it to perform simple state transformations.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    //////////////////////////////////////////////////////////////////
    // Part I. Implementing Quantum Fourier Transform
    //////////////////////////////////////////////////////////////////
    
    // This sequence of tasks uses the implementation of QFT described in Nielsen & Chuang.
    // All numbers in this kata use big endian encoding: most significant bit of the number
    // is stored in the first (leftmost) bit/qubit.

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
    //      2) An array of n bits [j₁, j₂, ..., jₙ], stored as Int[] (jₖ ∈ {0, 1}).
    // Goal: Change the state of the qubit to α |0⟩ + β · exp(2πi · 0.j₁j₂...jₙ) |1⟩,
    // where 0.j₁j₂...jₙ is a binary fraction, similar to decimal fractions:
    //       0.j₁j₂...jₙ = j₁ / 2¹ + j₂ / 2² + ... + jₙ / 2ⁿ.
    operation BinaryFractionClassical (q : Qubit, j : Int[]) : Unit is Adj+Ctl {
        // ...
    }
    

    // Task 1.4. Prepare binary fraction exponent (quantum input)
    // Inputs:
    //      1) A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    //      2) A register of n qubits in state |j₁j₂...jₙ⟩.
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
    // Input: A register of n qubits in state |j₁j₂...jₙ⟩.
    // Goal: Change the state of the register
    //       from |j₁⟩ ⊗ |j₂...jₙ⟩
    //         to 1/sqrt(2) (|0⟩ + exp(2πi · 0.j₁j₂...jₙ) |1⟩) ⊗ |j₂...jₙ⟩.
    // Note: The register of qubits can be in superposition as well; 
    //       the behavior in this case is defined by behavior on the basis states and the linearity of unitary transformations.
    // Hint: This task is very similar to task 1.4, but the digit j₁ is encoded in-place, using task 1.1.
    operation BinaryFractionQuantumInPlace (register : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.6. Reverse the order of qubits
    // Input: A register of n qubits in state |x₁x₂...xₙ⟩.
    // Goal: Reverse the order of qubits, i.e., convert the state of the register to |xₙ...x₂x₁⟩.
    operation ReverseRegister (register : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }
    
    
    // Task 1.7. Quantum Fourier transform
    // Input: A register of n qubits in state |j₁j₂...jₙ⟩.
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
    // Input: A register of n qubits in state |j₁j₂...jₙ⟩.
    // Goal: Apply inverse QFT to the input register,
    //       i.e., transform it to a state 
    //       1/sqrt(2ⁿ) ∑ₖ exp(-2πi · jk / 2ⁿ) |k⟩.
    // Hint: Inverse QFT is literally the inverse transformation of QFT.
    //       Do you know a quantum way to express this?
    operation InverseQFT (register : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Using the Quantum Fourier Transform
    //////////////////////////////////////////////////////////////////
    
    // This section offers you tasks on state preparation and state analysis
    // that can be solved using QFT (or inverse QFT). It is possible to solve them 
    // without QFT, but we recommend that you to try and come up with a QFT-based solution.

    // Task 2.1. Prepare an equal superposition of all basis states
    // Input: A register of n qubits in state |0...0⟩.
    // Goal: Prepare an equal superposition of all basis vectors from |0...0⟩ to |1...1⟩
    //       (i.e., state (|0...0⟩ + ... + |1...1⟩) / sqrt(2ⁿ) ).
    operation PrepareEqualSuperposition (register : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 2.2. Prepare a periodic state
    // Inputs:
    //      1) A register of n qubits in state |0...0⟩.
    //      2) An integer frequency F (0 ≤ F ≤ 2ⁿ-1).
    // Goal: Prepare a periodic state with frequency F on this register:
    //       1 / sqrt(2ⁿ) Σₖ exp(2πi Fk/2ⁿ) |k⟩
    // For example, for n = 2 and F = 1 the goal state is 
    //       1/2 (|0⟩ + i|1⟩ - |2⟩ - i|3⟩).
    // Note: If you're using DumpMachine to debug your solution, 
    //       remember that this kata uses big endian encoding of states,
    //       while DumpMachine uses little endian encoding.
    operation PreparePeriodicState (register : Qubit[], F : Int) : Unit is Adj+Ctl {
        // Hint: Which basis state can be mapped to this state using QFT?
        // ...
    }


    // Task 2.3. Prepare a periodic state with alternating 1 and -1 amplitudes
    // Input: A register of n qubits in state |0...0⟩.
    // Goal: Prepare a periodic state with alternating 1 and -1 amplitudes of basis states:
    //       1 / sqrt(2ⁿ) (|0⟩ - |1⟩ + |2⟩ - |3⟩ + ... - |2ⁿ-1⟩).
    // For example, for n = 2 the goal state is 
    //       1/2 (|0⟩ - |1⟩ + |2⟩ - |3⟩).
    operation PrepareAlternatingState (register : Qubit[]) : Unit is Adj+Ctl {
        // Hint: Which basis state can be mapped to this state using QFT?
        //       Which frequency would allow you to use task 2.2 here?
        // ...
    }


    // Task 2.4. Prepare an equal superposition of all even basis states
    // Input: A register of n qubits in state |0...0⟩.
    // Goal: Prepare an equal superposition of all even basis vectors:
    //       1/sqrt(2ⁿ⁻¹) (|0⟩ + |2⟩ + ... + |2ⁿ-2⟩).
    operation PrepareEqualSuperpositionOfEvenStates (register : Qubit[]) : Unit is Adj+Ctl {
        // Hint: Which superposition of two basis states can be mapped to this state using QFT?
        //       Use the solutions to tasks 2.1 and 2.3 to figure out the answer.
        // ...
    }


    // Task 2.5*. Prepare a square-wave signal
    // Input: A register of n ≥ 2 qubits in state |0...0⟩.
    // Goal: Prepare a periodic state with alternating 1, 1, -1, -1 amplitudes of basis states:
    //       1/sqrt(2ⁿ) (|0⟩ + |1⟩ - |2⟩ - |3⟩ + ... - |2ⁿ-2⟩ - |2ⁿ-1⟩).
    operation PrepareSquareWaveSignal (register : Qubit[]) : Unit is Adj+Ctl {
        // Hint: Which superposition of two basis states can be mapped to this state using QFT?
        //       Remember that sum of two complex amplitudes can be a real number if their imaginary parts cancel out.
        // ...
    }


    // Task 2.6. Get the frequency of a signal
    // Input: A register of n ≥ 2 qubits in state 1/sqrt(2ⁿ) Σₖ exp(2πikF/2ⁿ) |k⟩, 0 ≤ F ≤ 2ⁿ - 1.
    // Goal: Return the frequency F of the "signal" encoded in this state.
    operation Frequency (register : Qubit[]) : Int {
        // ...
        return -1;
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Powers and roots of the QFT
    //////////////////////////////////////////////////////////////////
    
    // Task 3.1. Implement powers of the QFT
    // Inputs:
    //      1) A register of n qubits in an arbitrary state.
    //      2) An integer P (0 ≤ P ≤ 2²⁰ - 1).
    // 
    // Goal: Transform state |x⟩ into state QFTᴾ |x⟩, 
    //       where QFT is the quantum Fourier transform implemented in part I.
    // Note: Your solution has to run fast for any P in the given range!
    operation QFTPower (P : Int, inputRegister : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 3.2. Implement roots of the QFT
    // Inputs:
    //      1) A register of n qubits in an arbitrary state.
    //      2) An integer P (2 ≤ P ≤ 8).
    // Goal: Transform state |x⟩ into state V |x⟩, where Vᴾ = QFT.
    //       In other words, implement a P-th root of the QFT.
    //       You can implement the required unitary up to a global phase.
    operation QFTRoot (P : Int, inputRegister : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }
}
