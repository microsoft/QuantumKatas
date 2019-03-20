// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.QFT {
    
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    // Task 1.1 Rotation Gate
    operation Rotation_Reference (q : Qubit, k : Int) : Unit {
        body(...) {
            R1Frac(2, k, q);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }
    
    // Task 1.2 QFT
    operation QuantumFT_Reference (qs : Qubit[]) : Unit {
        body(...) {
            let n = Length(qs);
            for (i in 0 .. n - 1) {
                H(qs[i]);
                for (j in i + 1 .. n - 1) {
                    Controlled Rotation_Reference([qs[j]], (qs[i], j - i + 1));
                }
            }
            SwapReverseRegister(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 1.3 Inverse QFT
    operation InverseQFT_Reference (qs : Qubit[]) : Unit {
        body(...) {
            Adjoint QuantumFT_Reference(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.1 Prepare Register |a⟩
    operation PrepareRegisterA_Reference (qs : Qubit[]) : Unit {
        body(...) {
            QuantumFT_Reference(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.2 Rotation from Register |b⟩
    operation AddRegisterB_Reference (a : Qubit[], b : Qubit[]) : Unit {
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
    operation InverseRegisterA_Reference (qs : Qubit[]) : Unit {
        body(...) {
            Adjoint PrepareRegisterA_Reference(qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.4 Complete QFT Addition
    operation QFTAddition_Reference (a : Qubit[], b : Qubit[]) : Unit {
        body(...) {
            PrepareRegisterA_Reference(a);
            AddRegisterB_Reference(a, b);
            InverseRegisterA_Reference(a);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.5 Complete QFT Subtraction
    operation QFTSubtraction_Reference (a : Qubit[], b : Qubit[]) : Unit {
        body(...) {
            Adjoint QFTAddition_Reference(a, b);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 3.1 AQFT
    operation AQFT_Reference (t : Int, qs : Qubit[]) : Unit {
        body(...) {
            let n = Length(qs);
            for (i in 0 .. n - 1) {
                for (j in i - 1 .. -1 .. MaxI(0, i - t + 1)) {
                    Controlled Rotation_Reference([qs[i]], (qs[j], i - j + 1));
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
