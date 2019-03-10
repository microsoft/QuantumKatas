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

    //////////////////////////////////////////////////////////////////
    // Part I. Quantum Fourier Estimation (QFT)
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1 Rotation Gate
    operation Rotation (q : Qubit, k : Int) : Unit {
        body(...) {
            R1Frac(2, k, q);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }
    
    // Task 1.2 QFT
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
    operation InverseQFT (qs : Qubit[]) : Unit {
        body(...) {
            Adjoint QuantumFT(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part II. QFT Addition
    //////////////////////////////////////////////////////////////////

    // Task 2.1 Prepare Register |a⟩
    operation PrepareRegisterA (qs : Qubit[]) : Unit {
        body(...) {
            QuantumFT_Reference(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.2 Rotation from Register |b⟩
    operation AddRegisterB (a : Qubit[], b : Qubit[]) : Unit {
        body(...) {
            let n = Length(a);
            for (i in 0 .. n - 1) {
                for (j in n - 1 - i .. n - 1) {
                    Controlled Rotation_Reference([b[j]], (a[i], j - (n - 1 - i) + 1));
                }
            }
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.3 Inverse Register |a⟩
    operation InverseRegisterA (qs : Qubit[]) : Unit {
        body(...) {
            Adjoint PrepareRegisterA(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.4 Complete QFT Addition
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
    operation QFTSubtraction (a : Qubit[], b : Qubit[]) : Unit {
        body(...) {
            Adjoint QFTAddition(a, b);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

}
