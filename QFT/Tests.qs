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

    function AssertRegisterState(qubits : Qubit[], expected : Complex[], tolerance : Double)
            : Unit {}

    function Pow2(p : Int) : Int {
        return Round(PowD(2.0, ToDouble(p)));
    }

    operation RandomIntPow2_(maxBits : Int) : Int {
        mutable num = 0;
        repeat {
            set num = RandomIntPow2(maxBits);
        } until(num >= 0 && num < Pow2(maxBits))
        fixup {}
        return num;
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
                let j = RandomIntPow2_(n);
                mutable coeffs = new Double[Pow2(n)];
                set coeffs[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs))(BigEndian(qs));
                QuantumFT(qs);
                InverseQFT_Reference(qs);
                AssertProbIntBE(j, 1.0, BigEndian(qs), 1e-5);
                ResetAll(qs);
            }
        }
    }

    operation T13_Test () : Unit {
        let n = 8;
        let time = 10;
        using (qs = Qubit[n]) {
            for (_ in 1 .. time) {
                let j = RandomIntPow2_(n);
                mutable coeffs = new Double[Pow2(n)];
                set coeffs[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs))(BigEndian(qs));
                QuantumFT_Reference(qs);
                InverseQFT(qs);
                AssertProbIntBE(j, 1.0, BigEndian(qs), 1e-5);
                ResetAll(qs);
            }
        }
    }

    operation T21_Test () : Unit {
        let n = 8;
        let time = 10;
        using (qs = Qubit[n]) {
            for (_ in 1 .. time) {
                let j = RandomIntPow2_(n);
                mutable coeffs = new Double[Pow2(n)];
                set coeffs[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs))(BigEndian(qs));
                PrepareRegisterA(qs);
                InverseQFT_Reference(qs);
                AssertProbIntBE(j, 1.0, BigEndian(qs), 1e-5);
                ResetAll(qs);
            }
        }
    }

    operation T22_Test () : Unit {
        let n = 8;
        let time = 10;
        using ((a, b) = (Qubit[n], Qubit[n / 2])) {
            for (_ in 1 .. time) {
                let i = RandomIntPow2_(n);
                let j = RandomIntPow2_(n / 2);
                mutable coeffs_a = new Double[Pow2(n)];
                mutable coeffs_b = new Double[Pow2(n / 2)];
                set coeffs_a[i] = 1.0;
                set coeffs_b[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs_a))(BigEndian(a));
                (StatePreparationPositiveCoefficients(coeffs_b))(BigEndian(b));
                PrepareRegisterA_Reference(a);
                AddRegisterB(a, b);
                InverseRegisterA_Reference(a);
                AssertProbIntBE((i + j) % Pow2(n), 1.0, BigEndian(a), 1e-5);
                AssertProbIntBE(j, 1.0, BigEndian(b), 1e-5);
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
                let i = RandomIntPow2_(n);
                let j = RandomIntPow2_(n);
                mutable coeffs_a = new Double[Pow2(n)];
                mutable coeffs_b = new Double[Pow2(n)];
                set coeffs_a[i] = 1.0;
                set coeffs_b[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs_a))(BigEndian(a));
                (StatePreparationPositiveCoefficients(coeffs_b))(BigEndian(b));
                PrepareRegisterA_Reference(a);
                AddRegisterB_Reference(a, b);
                InverseRegisterA(a);
                AssertProbIntBE((i + j) % Pow2(n), 1.0, BigEndian(a), 1e-5);
                AssertProbIntBE(j, 1.0, BigEndian(b), 1e-5);
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
                let i = RandomIntPow2_(n);
                let j = RandomIntPow2_(n);
                mutable coeffs_a = new Double[Pow2(n)];
                mutable coeffs_b = new Double[Pow2(n)];
                set coeffs_a[i] = 1.0;
                set coeffs_b[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs_a))(BigEndian(a));
                (StatePreparationPositiveCoefficients(coeffs_b))(BigEndian(b));
                QFTAddition(a, b);
                AssertProbIntBE((i + j) % Pow2(n), 1.0, BigEndian(a), 1e-5);
                AssertProbIntBE(j, 1.0, BigEndian(b), 1e-5);
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
                let i = RandomIntPow2_(n);
                let j = RandomIntPow2_(n);
                mutable coeffs_a = new Double[Pow2(n)];
                mutable coeffs_b = new Double[Pow2(n)];
                set coeffs_a[i] = 1.0;
                set coeffs_b[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs_a))(BigEndian(a));
                (StatePreparationPositiveCoefficients(coeffs_b))(BigEndian(b));
                QFTSubtraction(a, b);
                AssertProbIntBE(i - j < 0 ? i - j + Pow2(n) | i - j, 1.0, BigEndian(a), 1e-5);
                AssertProbIntBE(j, 1.0, BigEndian(b), 1e-5);
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
                let i = RandomIntPow2_(n);
                let j = RandomIntPow2_(n);
                mutable coeffs_a = new Double[Pow2(n)];
                mutable coeffs_b = new Double[Pow2(n)];
                set coeffs_a[i] = 1.0;
                set coeffs_b[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs_a))(BigEndian(a));
                (StatePreparationPositiveCoefficients(coeffs_b))(BigEndian(b));
                QFTMultiplication(a, b, c);
                AssertProbIntBE(i * j, 1.0, BigEndian(c), 1e-5);
                AssertProbIntBE(i, 1.0, BigEndian(a), 1e-5);
                AssertProbIntBE(j, 1.0, BigEndian(b), 1e-5);
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
                let j = RandomIntPow2_(n);
                mutable coeffs = new Double[Pow2(n)];
                set coeffs[j] = 1.0;
                (StatePreparationPositiveCoefficients(coeffs))(BigEndian(qs));
                AQFT(3, qs);
                Adjoint AQFT_Reference(3, qs);
                AssertProbIntBE(j, 1.0, BigEndian(qs), 1e-5);
                ResetAll(qs);
            }
        }
    }
    
}
