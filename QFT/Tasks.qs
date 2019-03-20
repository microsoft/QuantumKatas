// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.QFT {
    
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Diagnostics;
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The "QFT (Quantum Fourier Transform)" quantum kata is a series of
    // exercises designed to teach you the basics of Quantum Fourier Transform.
    // It covers the following topics:
    //  - Basic Quantum Fourier Transform,
    //  - Ancillary Qubit Free Quantum Addition,
    //  - Approximate Quantum Fourier Transform

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    //////////////////////////////////////////////////////////////////
    // Part I. Quantum Fourier Transform (QFT)
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1 Rotation Gate
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩ and an integer k.
    // Goal:  Change the state of the qubit to α |0⟩ + β * e^{2πi / 2^k} |1⟩.
    operation Rotation (q : Qubit, k : Int) : Unit {
        body(...) {
            R1Frac(2, k, q);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }
    
    // Task 1.2 QFT
    // Input: A quantum register in big endian format.
    // Goal: Run QFT on the input register.
    // Though you might be able to do this with 1 library call, we recommned
    // implementing QFT yourself for learning purposes. Hint: the rotation
    // gate you implemented in Task 1.1 might help.
    operation QuantumFT (qs : Qubit[]) : Unit {
        body(...) {
            let n = Length(qs);
            for (i in 0 .. n - 1) {
                H(qs[i]);
                for (j in i + 1 .. n - 1) {
                    Controlled Rotation([qs[j]], (qs[i], j - i + 1));
                }
            }
            SwapReverseRegister(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 1.3 Inverse QFT
    // Input: A quantum register in big endian format. 
    // Goal: Run inverse QFT on the input register.
    operation InverseQFT (qs : Qubit[]) : Unit {
        body(...) {
            Adjoint QuantumFT(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part II. QFT Addition & Multiplication
    //////////////////////////////////////////////////////////////////

    // Task 2.1 Prepare Register |a⟩
    // Input: a quantum register with n qubits, representing the first number we
    // are trying to add.
    // Goal: For each k-th qubit in a, prepare it into (|0⟩ + e^{2πi0.a[0]a[1]...a[k]} |1⟩) / sqrt(2).
    operation PrepareRegisterA (a : Qubit[]) : Unit {
        body(...) {
            QuantumFT_Reference(a);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.2 Rotation from Register |b⟩
    // Input: 2 quantum registers with n qubits in Big Endian. a is the first number we try to add
    // prepared by Task 2.1, and the second is the raw state of the second number in addition.
    // Note that register |b⟩ is guaranteed to have size less than or equal to size of |a⟩.
    // Goal: For each k-th qubit in a, rotate it into (|0⟩ + e^{2πi(0.a[0]a[1]...a[k] + 0.b[0]b[1]...b[k])} |1⟩) / sqrt(2).
    operation AddRegisterB (a : Qubit[], b : Qubit[]) : Unit {
        body(...) {
            let n = Length(a);
            let m = Length(b);
            for (i in 0 .. n - 1) {
                for (j in MaxI(0, m - 1 - i) .. m - 1) {
                    Controlled Rotation_Reference([b[j]], (a[i], j - (m - 1 - i) + 1));
                }
            }
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.3 Inverse Register |a⟩
    // Input: The resulting state of by Task 2.2
    // Goal: Retrieve the addition result by inverse QFT
    operation InverseRegisterA (a : Qubit[]) : Unit {
        body(...) {
            Adjoint PrepareRegisterA(a);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.4 Complete QFT Addition
    // Input: 2 n-qubit quantum register numbers a and b, in big endian.
    // Goal: Change a to the binary representation of (a + b) mod 2^n, in big endian,
    // without using any extra qubibt and state of register b should remain
    // the same after the opperation
    operation QFTAddition (a : Qubit[], b : Qubit[]) : Unit {
        body(...) {
            PrepareRegisterA(a);
            AddRegisterB(a, b);
            InverseRegisterA(a);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.5 Complete QFT Subtraction
    // Input: 2 n-qubit quantum register numbers a and b, in big endian.
    // Goal: Change a to the binary representation of (a - b) mod 2^n, in big endian,
    // without using any extra qubit and state of register b should remain
    // the same after the opperation
    operation QFTSubtraction (a : Qubit[], b : Qubit[]) : Unit {
        body(...) {
            Adjoint QFTAddition(a, b);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.6 Complete QFT Multiplication
    // Input: two multiplier registers and an initially zero result register. The
    // result register has sum of the sizes of mulitplier registers.
    // Goal: Perform |a⟩|b⟩|0⟩ → |a⟩|b⟩|a * b⟩
    operation QFTMultiplication (a : Qubit[], b : Qubit[], c : Qubit[]) : Unit {
        body(...) {
            PrepareRegisterA(c);
            for (i in 0 .. Length(b) - 1) {
                Controlled AddRegisterB([b[Length(b) - 1 - i]], (c[i .. Length(c) - 1], a));
            }
            InverseRegisterA(c);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part III. AQFT
    //////////////////////////////////////////////////////////////////

    // Task 3.1 AQFT
    // Input: t is the threshold of rotation, qs is a quantum register in big endian format.
    // Goal: Perform ordinary QFT but prune any rotation e^{2πi / 2^k} with k > t.
    operation AQFT (t : Int, qs : Qubit[]) : Unit {
        body(...) {
            let n = Length(qs);
            for (i in 0 .. n - 1) {
                for (j in i - 1 .. -1 .. MaxI(0, i - t + 1)) {
                    Controlled Rotation([qs[i]], (qs[j], i - j + 1));
                }
                H(qs[i]);
            }
            SwapReverseRegister(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

}
