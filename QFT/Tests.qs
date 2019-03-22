// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.QFT {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    open Microsoft.Quantum.Extensions.Diagnostics;
    open Microsoft.Quantum.Extensions.Bitwise;

    function AssertRegisterState(qubits : Qubit[], expected : Complex[], tolerance : Double)
            : Unit {}

    function Pow2(p : Int) : Int {
        return 1 <<< p;
    }

    operation RandomIntPow2_(maxBits : Int) : Int {
        mutable num = 0;
        repeat {
            set num = RandomIntPow2(maxBits);
        } until(num >= 0 && num < Pow2(maxBits))
        fixup {}
        return num;
    }

    operation RandomProb() : Double {
        return ToDouble(RandomIntPow2(4)) / ToDouble(Pow2(4) - 1);
    }

    operation PrepareRandomState(qs : Qubit[]) : (Int, Int, Double) {
        let n = Length(qs);
        let i1 = RandomIntPow2_(n - 1) * 2;
        let i2 = RandomIntPow2_(n - 1) * 2 + 1;
        let ip = RandomProb();
        mutable coeffs = new Double[Pow2(n)];
        set coeffs[i1] = Sqrt(ip);
        set coeffs[i2] = Sqrt(1.0 - ip);
        (StatePreparationPositiveCoefficients(coeffs))(BigEndian(qs));
        return (i1, i2, ip);
    }

    operation AssertState(qs : Qubit[], (i1 : Int, i2 : Int, ip : Double)) : Unit {
        AssertProbIntBE(i1, ip, BigEndian(qs), 1e-5);
        AssertProbIntBE(i2, 1.0 - ip, BigEndian(qs), 1e-5);
    }

    operation T11_Test () : Unit {
        using (qs = Qubit[2]) {
            for (k in 1 .. 10) {
                for (control in 0 .. 1) {
                    if (control == 1) { X(qs[0]); }
                    H(qs[1]);
                    Controlled Rotation([qs[0]], (qs[1], k));
                    Adjoint Controlled Rotation_Reference([qs[0]], (qs[1], k));
                    AssertQubitState((Complex(1.0 / Sqrt(2.0), 0.0), Complex(1.0 / Sqrt(2.0), 0.0)), qs[1], 1e-5);
                    ResetAll(qs);
                }
            }
        }
    }

    operation T12_Test () : Unit {
        let n = 8;
        let time = 10;
        using (qs = Qubit[n]) {
            for (_ in 1 .. time) {
                let s = PrepareRandomState(qs);
                QuantumFT(qs);
                InverseQFT_Reference(qs);
                AssertState(qs, s);
                ResetAll(qs);
            }
        }
    }

    operation T13_Test () : Unit {
        let n = 8;
        let time = 10;
        using (qs = Qubit[n]) {
            for (_ in 1 .. time) {
                let s = PrepareRandomState(qs);
                QuantumFT_Reference(qs);
                InverseQFT(qs);
                AssertState(qs, s);
                ResetAll(qs);
            }
        }
    }

    operation T21_Test () : Unit {
        let n = 8;
        let time = 10;
        using (qs = Qubit[n]) {
            for (_ in 1 .. time) {
                let s = PrepareRandomState(qs);
                PrepareRegisterA(qs);
                InverseQFT_Reference(qs);
                AssertState(qs, s);
                ResetAll(qs);
            }
        }
    }

    operation T22_Test () : Unit {
        let n = 8;
        let time = 10;
        using ((a, b) = (Qubit[n], Qubit[n / 2])) {
            for (_ in 1 .. time) {
                let s1 = PrepareRandomState(a);
                let s2 = PrepareRandomState(b);
                PrepareRegisterA_Reference(a);
                AddRegisterB(a, b);
                InverseRegisterA_Reference(a);
                Adjoint QFTAddition_Reference(a, b);
                AssertState(a, s1);
                AssertState(b, s2);
                ResetAll(a);
                ResetAll(b);
            }
        }
    }

    operation T23_Test () : Unit {
        let n = 8;
        let time = 10;
        using ((a, b) = (Qubit[n], Qubit[n])) {
            for (_ in 1 .. time) {
                let s1 = PrepareRandomState(a);
                let s2 = PrepareRandomState(b);
                PrepareRegisterA_Reference(a);
                AddRegisterB_Reference(a, b);
                InverseRegisterA(a);
                Adjoint QFTAddition_Reference(a, b);
                AssertState(a, s1);
                AssertState(b, s2);
                ResetAll(a);
                ResetAll(b);
            }
        }
    }

    operation T24_Test () : Unit {
        let n = 8;
        let time = 10;
        using ((a, b) = (Qubit[n], Qubit[n])) {
            for (_ in 1 .. time) {
                let s1 = PrepareRandomState(a);
                let s2 = PrepareRandomState(b);
                QFTAddition(a, b);
                Adjoint QFTAddition_Reference(a, b);
                AssertState(a, s1);
                AssertState(b, s2);
                ResetAll(a);
                ResetAll(b);
            }
        }
    }

    operation T25_Test () : Unit {
        let n = 8;
        let time = 10;
        using ((a, b) = (Qubit[n], Qubit[n])) {
            for (_ in 1 .. time) {
                let s1 = PrepareRandomState(a);
                let s2 = PrepareRandomState(b);
                QFTSubtraction(a, b);
                QFTAddition_Reference(a, b);
                AssertState(a, s1);
                AssertState(b, s2);
                ResetAll(a);
                ResetAll(b);
            }
        }
    }

    operation T26_Test () : Unit {
        let n = 4;
        let time = 10;
        using ((a, b, c) = (Qubit[n], Qubit[n], Qubit[2 * n])) {
            for (_ in 1 .. time) {
                let s1 = PrepareRandomState(a);
                let s2 = PrepareRandomState(b);
                QFTMultiplication(a, b, c);
                Adjoint QFTMultiplication(a, b, c);
                AssertProbIntBE(0, 1.0, BigEndian(c), 1e-5);
                AssertState(a, s1);
                AssertState(b, s2);
                ResetAll(a);
                ResetAll(b);
                ResetAll(c);
            }
        }
    }

    operation T31_Test () : Unit {
        let n = 8;
        let time = 10;
        using (qs = Qubit[n]) {
            for (_ in 1 .. time) {
                let s = PrepareRandomState(qs);
                AQFT(3, qs);
                Adjoint AQFT_Reference(3, qs);
                AssertState(qs, s);
                ResetAll(qs);
            }
        }
    }

    operation T41_Test () : Unit {
        let n = 5;
        let time = 3;
        using ((a, b) = (Qubit[n], Qubit[n])) {
            for (_ in 1 .. time) {
                let s1 = PrepareRandomState(a);
                let s2 = PrepareRandomState(b);
                let mul = 17;
                let modulus = 31;
                PowerOfa(mul, modulus, a, b);
                Adjoint PowerOfa_Reference(mul, modulus, a, b);
                AssertState(a, s1);
                AssertState(b, s2);
                ResetAll(a);
                ResetAll(b);
            }
        }
    }

    operation T42_Test () : Unit {
        let n = 3;
        let time = 3;
        using ((a, b, c) = (Qubit[n], Qubit[n], Qubit[n])) {
            for (_ in 1 .. time) {
                let s1 = PrepareRandomState(a);
                let s2 = PrepareRandomState(b);
                let s3 = PrepareRandomState(c);
                let bb = 4;
                let aa = 2;
                let modulus = 5;
                DLOracle(aa, bb, modulus, a, b, c);
                Adjoint DLOracle_Reference(aa, bb, modulus, a, b, c);
                AssertState(a, s1);
                AssertState(b, s2);
                AssertState(c, s3);
                ResetAll(a);
                ResetAll(b);
                ResetAll(c);
            }
        }
    }

    operation DiscreteLogSpecial_N5_Test () : Unit {
        let N = 5; // group (Z/5Z)*
        let a = 2; // 2 is a generator of group (Z/5Z)*
        let b = 3; // 2^3 = 3 in (Z/5Z)*, so log_2(3)=3
        let r = 4; // 𝜑(N)=𝜑(5)=4
        mutable result = 0;
        let answer = 3;
        Message($"Running Shor's Algorithm on N={N}, generator a={a}, element b={b}");
        repeat {
            set result = DiscreteLogarithm(a, b, N, r);
        } until (result == answer) fixup {}
        Message($"log_{a}({b})={result} in group (Z/{N}Z)*");
    }

    // due to larger number of qubits, this test may take a while
    operation DiscreteLogSpecial_N15_Test () : Unit {
        let N = 15; // ambient group (Z/5Z)*
        let a = 7; // ⟨7⟩ generates subgroup {1, 4, 7, 13} in (Z/15Z)*
        let b = 13; // 7^3 = 13 in (Z/15Z)*, so log_7(13)=3
        let r = 4; // size of subgroup ⟨7⟩ is 4
        mutable result = 0;
        let answer = 3;
        Message($"Running Shor's Algorithm on N={N}, generator a={a}, element b={b}");
        repeat {
            set result = DiscreteLogarithm(a, b, N, r);
        } until (result == answer) fixup {}
        Message($"log_{a}({b})={result} in group (Z/{N}Z)*");
    }
    
}
