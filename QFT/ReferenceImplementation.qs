// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.QFT {
    
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    //////////////////////////////////////////////////////////////////
    // Part I. Implementing Quantum Fourier Transform
    //////////////////////////////////////////////////////////////////

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
        for ind in 0 .. Length(j) - 1 {
            if (j[ind] == 1) {
                Rotation_Reference(q, ind + 1);
            }
        }
    }


    function IntArrayAsInt (j : Int[]) : Int {
        mutable n = 0;
        for ind in 0 .. Length(j) - 1 {
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
        for ind in 0 .. Length(jRegister) - 1 {
            Controlled Rotation_Reference([jRegister[ind]], (q, ind + 1));
        }
    }


    // Task 1.5. Prepare binary fraction exponent in place (quantum input)
    // Input: A register of qubits in state |j₁j₂...jₙ⟩
    // Goal: Change the state of the register
    //       from |j₁⟩ ⊗ |j₂...jₙ⟩
    //         to 1/sqrt(2) (|0⟩ + exp(2πi · 0.j₁j₂...jₙ) |1⟩) ⊗ |j₂...jₙ⟩.
    operation BinaryFractionQuantumInPlace_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        OneQubitQFT_Reference(register[0]);
        for ind in 1 .. Length(register) - 1 {
            Controlled Rotation_Reference([register[ind]], (register[0], ind + 1));
        }
    }


    // Task 1.6. Reverse the order of qubits
    // Input: A register of qubits in state |x₁x₂...xₙ⟩
    // Goal: Reverse the order of qubits, i.e., convert the state of the register to |xₙ...x₂x₁⟩.
    operation ReverseRegister_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        let N = Length(register);
        for ind in 0 .. N / 2 - 1 {
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
        for i in 0 .. n - 1 {
            BinaryFractionQuantumInPlace_Reference(register[i ...]);
        }
        ReverseRegister_Reference(register);
    }


    // Task 1.8. Inverse QFT
    operation InverseQFT_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        Adjoint QuantumFourierTransform_Reference(register);
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Using the Quantum Fourier Transform
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Prepare an equal superposition of all basis states
    operation PrepareEqualSuperposition_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        // We get equal superposition of all basis states 
        // if we apply QFT to the |0...0⟩ state
        QFT(BigEndian(register));
    }


    // Task 2.2. Prepare a periodic state
    // 1 / sqrt(2ⁿ) Σₖ exp(2πi Fk/2ⁿ) |k⟩
    operation PreparePeriodicState_Reference (register : Qubit[], F : Int) : Unit is Adj+Ctl {
        // Prepare state |F⟩ (in big endian notation)
        // IntAsBoolArray gets bits in little endian notation, so need to reverse
        let bitsBE = Reversed(IntAsBoolArray(F, Length(register)));
        ApplyPauliFromBitString(PauliX, true, bitsBE, register);

        QFT(BigEndian(register));
    }
    

    // Task 2.3. Prepare a periodic state with alternating 1 and -1 amplitudes
    // 1 / sqrt(2ⁿ) (|0⟩ - |1⟩ + |2⟩ - |3⟩ + ... - |2ⁿ-1⟩).
    operation PrepareAlternatingState_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        // Prepare state |2ⁿ⁻¹⟩ = |10...0⟩
        // which corresponds to 1 / sqrt(2ⁿ) Σₖ exp(2πi k/2) |k⟩, amplitudes +1 for even k and -1 for odd k
        X(Head(register));

        QFT(BigEndian(register));
    }


    // Task 2.4. Prepare an equal superposition of all even basis states
    // 1/sqrt(2ⁿ⁻¹) (|0⟩ + |2⟩ + ... + |2ⁿ-2⟩).
    operation PrepareEqualSuperpositionOfEvenStates_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        // Prepare superposition |0⟩ + |2ⁿ⁻¹⟩ = |0...00⟩ + |0..01⟩
        H(Head(register));

        QFT(BigEndian(register));
    }


    // Task 2.5*. Prepare a square-wave signal
    // 1/sqrt(2ⁿ) (|0⟩ + |1⟩ - |2⟩ - |3⟩ + ... - |2ⁿ-2⟩ - |2ⁿ-1⟩).
    operation PrepareSquareWaveSignal_Reference (register : Qubit[]) : Unit is Adj+Ctl {
        // Following https://oreilly-qc.github.io?p=7-3
        // Prepare superposition exp(-iπ/4)|2ⁿ⁻²⟩ + exp(iπ/4)|-2ⁿ⁻²⟩
        let n = Length(register);
        X(register[1]);
        // |010...0⟩
        H(register[0]);
        // |010...0⟩ + |110...0⟩
        T(register[0]);
        within { X(register[0]); }
        apply { Adjoint T(register[0]); }

        QFT(BigEndian(register));
    }


    // Task 2.6. Get the frequency of a signal
    // Input: A register of n ≥ 2 qubits in state 1/sqrt(2ⁿ) Σₖ exp(2πikF/2ⁿ) |k⟩, 0 ≤ F ≤ 2ⁿ - 1.
    // Goal: Return the frequency F of the "signal" encoded in this state.
    operation Frequency_Reference (register : Qubit[]) : Int {
        Adjoint QFT(BigEndian(register));
        let bitsBE = MultiM(register);
        return ResultArrayAsInt(Reversed(bitsBE));
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Powers and roots of the QFT
    //////////////////////////////////////////////////////////////////
    
    // Task 3.1. Implement powers of the QFT
    operation QFTPower_Reference (P : Int, inputRegister : Qubit[]) : Unit is Adj+Ctl {
        // Use the fact that QFT⁴ = I
        for _ in 1 .. (P % 4) {
            QuantumFourierTransform_Reference(inputRegister);
        }
    }


    // Task 3.2. Implement roots of the QFT
    // Follow p.16 of https://arxiv.org/pdf/quant-ph/0309121.pdf
    internal operation Circ (qs : LittleEndian, alpha : Double) : Unit is Adj + Ctl {
        within {
            Adjoint QFTLE(qs);
        } apply {
            ApplyDiagonalUnitary(
                [0.0, -alpha, -2.0*alpha, alpha],
                qs
            );
        }
    }


    operation QFTRoot_Reference (P : Int, inputRegister : Qubit[]) : Unit is Adj+Ctl {
        use aux = Qubit[2];
        let Q = QuantumFourierTransform_Reference;
        let Q2 = OperationPowCA(Q, 2);
        within {
            ApplyToEachCA(H, aux);
            Controlled Adjoint Q([aux[0]], inputRegister);
            Controlled Adjoint Q2([aux[1]], inputRegister);
        } apply {
            Circ(LittleEndian(aux), PI() / (2.0 * IntAsDouble(P))); 
        }
    }

}
