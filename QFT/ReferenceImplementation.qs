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
    
    // Task 2.6 Complete QFT Multiplication
    operation QFTMultiplication_Reference (a : Qubit[], b : Qubit[], c : Qubit[]) : Unit {
        body(...) {
            ApplyToEachCA(H, c);
            for (i in 0 .. Length(b) - 1) {
                Controlled AddRegisterB_Reference([b[Length(b) - 1 - i]], (c[i .. Length(c) - 1], a));
            }
            InverseRegisterA_Reference(c);
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

    // Task 4.1 Power |x⟩|y⟩ → |x⟩|a^x · y mod N⟩
    operation PowerOfa_Reference (a : Int, N : Int, x : Qubit[], y : Qubit[]) : Unit {
        body(...) {
            let y_LE = BigEndianToLittleEndian(BigEndian(y));
            let oracle = ModularMultiplyByConstantLE(a, N, _);
            for (p in 0 .. Length(x) - 1) {
                Controlled (OperationPowCA(oracle, 1 <<< p))([x[Length(x) - 1 - p]], y_LE);
            }
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 4.2 Oracle U|x1⟩|x2⟩|y⟩ → |x1⟩|x2⟩|y ⊕ f(x1,x2)⟩ where f(x1,x2)=b^x1*a^x2 mod N
    operation OracleFunc (a : Int, b : Int, N : Int, x1 : Qubit[], x2 : Qubit[], qs : Qubit[]) : Unit {
        body(...) {
            X(qs[Length(qs) - 1]);
            PowerOfa(b, N, x1, qs);
            PowerOfa(a, N, x2, qs);
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    operation DLOracle_Reference (a : Int, b : Int, N : Int, x1 : Qubit[], x2 : Qubit[], y : Qubit[]) : Unit {
        body(...) {
            using (qs = Qubit[Length(y)]) {
                OracleFunc(a, b, N, x1, x2, qs);
                for (i in 0 .. Length(qs) - 1) {
                    CNOT(qs[i], y[i]);
                }
                Adjoint OracleFunc(a, b, N, x1, x2, qs);
            }
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

}
