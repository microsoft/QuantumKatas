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
    //  - Approximate Quantum Fourier Transform,
    //  - Discrete Logarithm

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
            // ...
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
            // ...
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
            // ...
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
            // ...
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
            // ...
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
            // ...
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
            // ...
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
            // ...
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
            // ...
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
            // ...
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part IV. Discrete logarithm
    //////////////////////////////////////////////////////////////////

    // Task 4.1 Power |x⟩|y⟩ → |x⟩|a^x · y mod N⟩
    // Input: integers a and N, registers x and y.
    // Goal: perform the desired operation.
    operation PowerOfa (a : Int, N : Int, x : Qubit[], y : Qubit[]) : Unit {
        body(...) {
            // ...
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 4.2 Oracle U|x1⟩|x2⟩|y⟩ → |x1⟩|x2⟩|y ⊕ f(x1,x2)⟩ where f(x1,x2)=b^x1*a^x2 mod N
    // Input: integers a, b, and N, registers x1, x2, and qs.
    // Goal: perform the desired operation.
    operation DLOracle (a : Int, b : Int, N : Int, x1 : Qubit[], x2 : Qubit[], y : Qubit[]) : Unit {
        // ...
    }

    // Discrete logarithm Algorithm
    // Input: integers a, b, N, r
    // Goal: compute the discrete logarithm log_a(b), returns -1 on failure cases
    operation DiscreteLogarithm (a : Int, b : Int, N : Int, r : Int) : Int {
        mutable appr_slmodr = 0;
        mutable appr_l = 0;
        let t = BitSize(N) * 2 + 1;
        using ((x1, x2, y) = (Qubit[t], Qubit[t], Qubit[t])) {
            ApplyToEach(H, x1);
            ApplyToEach(H, x2);
            DLOracle(a, b, N, x1, x2, y);
            InverseQFT(x1);
            InverseQFT(x2);
            set appr_slmodr = MeasureIntegerBE(BigEndian(x1));
            set appr_l = MeasureIntegerBE(BigEndian(x2));
            ResetAll(x1);
            ResetAll(x2);
            ResetAll(y);
        }
        let (slmodr, _) = (ContinuedFractionConvergent(Fraction(appr_slmodr, t), N))!;
        let (l, _) = (ContinuedFractionConvergent(Fraction(appr_l, t), N))!;
        if (GCD(l, r) != 1) {
            Message($"Algorithm failed due to measure l={l}, no coprime to r={r}");
            return -1;
        }
        let l_inv = InverseMod(l, r);
        let s = slmodr * l_inv % r;
        return s;
    }

    // Discrete logarithm designed for product of distinct Fermat primes
    // so that simulation runtime is tolerable on a personal computer, 
    // we only allow N to be 5 or 15 because when N=17 the program may not finish
    // realistically
    // This function is for demonstration of how Shor's algorithm works, it takes
    // advantage of the fact that 𝜑(N) is a power of 2, and with some modification
    // from the algorihtm, we can use fewer qubits to demonstrate a working version
    // of Shor's algorithm
    operation DiscreteLogarithmSpecial (a : Int, b : Int, N : Int, r : Int) : Int {
        mutable appr_slmodr = 0;
        mutable appr_l = 0;
        mutable slmodr = 0;
        mutable l = 0;
        let t = BitSize(N);
        using ((x1, x2, y) = (Qubit[t], Qubit[t], Qubit[t])) {
            ApplyToEach(H, x1);
            ApplyToEach(H, x2);
            DLOracle_Reference(a, b, N, x1, x2, y);
            InverseQFT_Reference(x1);
            InverseQFT_Reference(x2);
            set appr_slmodr = MeasureIntegerBE(BigEndian(x1));
            set slmodr = appr_slmodr / 2;
            set appr_l = MeasureIntegerBE(BigEndian(x2));
            set l = appr_l / 2;
            ResetAll(x1);
            ResetAll(x2);
            ResetAll(y);
        }
        if (GCD(l, r) != 1) {
            Message($"Algorithm failed due to measure l={l}, no coprime to r={r}");
            return -1;
        }
        let l_inv = InverseMod(l, r);
        let s = slmodr * l_inv % r;
        return s;
    }

}
