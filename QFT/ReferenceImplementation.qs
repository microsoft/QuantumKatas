// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.QFT {
    
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    // Task 1.1. 1-qubit QFT
    operation OneQubitQFT_Reference (q : Qubit) : Unit is Adj+Ctl {
        H(q);
    }


    // Task 1.2. Rotation gate
    operation Rotation_Reference (q : Qubit, k : Int) : Unit is Adj+Ctl {
        R1Frac(2, k, q);
    }
    

    // Task 1.3. Prepare binary fraction exponent (classical input)
    // Inputs:
    //      1) A qubit in state |ψ⟩ = α |0⟩ + β |1⟩
    //      2) An array of bits [j₁, j₂, ..., jₙ], stored as Int[] (jₖ ∈ {0, 1}).
    // Goal: Change the state of the qubit to α |0⟩ + β · exp(2πi · 0.j₁j₂...jₙ) |1⟩,
    // where 0.j₁j₂...jₙ is a binary fraction, similar to decimal fractions:
    //       0.j₁j₂...jₙ = j₁ / 2¹ + j₂ / 2² + ... + jₙ / 2ⁿ.
    operation BinaryFractionClassical_Reference (q : Qubit, j : Int[]) : Unit is Adj+Ctl {
        for (ind in 0 .. Length(j) - 1) {
            if (j[ind] == 1) {
                Rotation_Reference(q, ind + 1);
            }
        }
    }


    function IntArrayAsInt (j : Int[]) : Int {
        mutable n = 0;
        for (ind in 0 .. Length(j) - 1) {
            set n = n * 2 + j[ind];
        }
        return n;
    }

    operation BinaryFractionClassical_Alternative (q : Qubit, j : Int[]) : Unit is Adj+Ctl {
        // alternatively, we can convert the number to an integer and apply a single R1 rotation
        let num = IntArrayAsInt(j);
        R1(2.0 * PI() * IntAsDouble(num) / IntAsDouble(1 <<< Length(j)), q);
    }


    // Task 1.4. Prepare binary fraction exponent (quantum input)
    // Inputs:
    //      1) A qubit in state |ψ⟩ = α |0⟩ + β |1⟩
    //      2) A register of qubits in state |j₁j₂...jₙ⟩
    // Goal: Change the state of the input 
    //       from (α |0⟩ + β |1⟩) ⊗ |j₁j₂...jₙ⟩
    //         to (α |0⟩ + β · exp(2πi · 0.j₁j₂...jₙ) |1⟩) ⊗ |j₁j₂...jₙ⟩,
    //       where 0.j₁j₂...jₙ is a binary fraction corresponding to the basis state j₁j₂...jₙ of the register.
    operation BinaryFractionQuantum_Reference (q : Qubit, jRegister : Qubit[]) : Unit is Adj+Ctl {
        for (ind in 0 .. Length(jRegister) - 1) {
            Controlled Rotation_Reference([jRegister[ind]], (q, ind + 1));
        }
    }


    // Task 1.5. Prepare binary fraction exponent in place (quantum input)
    // Input: A register of qubits in state |j₁j₂...jₙ⟩
    // Goal: Change the state of the register
    //       from |j₁⟩ ⊗ |j₂...jₙ⟩
    //         to 1/sqrt(2) (|0⟩ + β · exp(2πi · 0.j₁j₂...jₙ) |1⟩) ⊗ |j₂...jₙ⟩.
    operation BinaryFractionQuantumInPlace_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        OneQubitQFT_Reference(register[0]);
        for (ind in 1 .. Length(register) - 1) {
            Controlled Rotation_Reference([register[ind]], (register[0], ind + 1));
        }
    }


    // Task 1.6. Reverse the order of qubits
    // Input: A register of qubits in state |x₁x₂...xₙ⟩
    // Goal: Reverse the order of qubits, i.e., convert the state of the register to |xₙ...x₂x₁⟩
    operation ReverseRegister_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        let N = Length(register);
        for (ind in 0 .. N / 2 - 1) {
            SWAP(register[ind], register[N - 1 - ind]);
        }
    }


    // Task 1.7. Quantum Fourier transform
    // Input: A register of qubits in state |j₁j₂...jₙ⟩
    // Goal: Apply quantum Fourier transform to the input register, i.e.,
    //       transform it to a state 
    //       1/sqrt(2) (|0⟩ + exp(2πi · 0.jₙ) |1⟩) ⊗
    //       1/sqrt(2) (|0⟩ + exp(2πi · 0.jₙ₋₁jₙ) |1⟩) ⊗ ... ⊗
    //       1/sqrt(2) (|0⟩ + exp(2πi · 0.j₁j₂...jₙ₋₁jₙ) |1⟩) ⊗
    operation QuantumFourierTransform_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        let n = Length(register);
        for (i in 0 .. n - 1) {
            BinaryFractionQuantumInPlace_Reference(register[i ...]);
        }
        ReverseRegister_Reference(register);
    }


    // Task 1.8. Inverse QFT
    operation InverseQFT_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        Adjoint QuantumFourierTransform_Reference(register);
    }

}
