// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.QFT {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Bitwise;

    //////////////////////////////////////////////////////////////////
    // Part I. Implementing Quantum Fourier Transform
    //////////////////////////////////////////////////////////////////

    operation ArrayWrapperControlledOperation (op : (Qubit => Unit is Adj+Ctl), register : Qubit[]) : Unit is Adj+Ctl {
        Controlled op([register[0]], register[1]);
    }

    @Test("QuantumSimulator")
    operation T11_OneQubitQFT () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperControlledOperation(OneQubitQFT, _), 
                                           ArrayWrapperControlledOperation(OneQubitQFT_Reference, _));
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T12_Rotation () : Unit {
        // several hardcoded tests for small values of k
        // k = 0: α |0⟩ + β · exp(2πi) |1⟩ = α |0⟩ + β |1⟩ - identity
        AssertOperationsEqualReferenced(2, ArrayWrapperControlledOperation(Rotation(_, 0), _), 
                                           ArrayWrapperControlledOperation(I, _));

        // k = 1: α |0⟩ + β · exp(2πi/2) |1⟩ = α |0⟩ - β |1⟩ - Z
        AssertOperationsEqualReferenced(2, ArrayWrapperControlledOperation(Rotation(_, 1), _), 
                                           ArrayWrapperControlledOperation(Z, _));

        // k = 2: α |0⟩ + β · exp(2πi/4) |1⟩ = α |0⟩ + iβ |1⟩ - S
        AssertOperationsEqualReferenced(2, ArrayWrapperControlledOperation(Rotation(_, 2), _), 
                                           ArrayWrapperControlledOperation(S, _));

        // k = 3: α |0⟩ + β · exp(2πi/8) |1⟩ - T
        AssertOperationsEqualReferenced(2, ArrayWrapperControlledOperation(Rotation(_, 3), _), 
                                           ArrayWrapperControlledOperation(T, _));

        // general case
        for k in 4 .. 10 {
            AssertOperationsEqualReferenced(2, ArrayWrapperControlledOperation(Rotation(_, k), _), 
                                               ArrayWrapperControlledOperation(Rotation_Reference(_, k), _));
        }
    }


    // ------------------------------------------------------
    function IntAsIntArray (j : Int, nBits : Int) : Int[] {
        mutable bits = [0, size = nBits];
        for ind in 0 .. nBits - 1 {
            set bits w/= ind <- ((j &&& (1 <<< (nBits - 1 - ind))) > 0 ? 1 | 0);
        }
        return bits;
    }

    @Test("QuantumSimulator")
    operation T13_BinaryFractionClassical () : Unit {
        for n in 1 .. 5 {
            for exponent in 0 .. (1 <<< n) - 1 {
                let bits = IntAsIntArray(exponent, n);
                Message($"{n}-bit {exponent} = {bits}");
                AssertOperationsEqualReferenced(2, ArrayWrapperControlledOperation(BinaryFractionClassical(_, bits), _), 
                                                   ArrayWrapperControlledOperation(BinaryFractionClassical_Reference(_, bits), _));

                // compare it to the single-rotation solution for good measure
                AssertOperationsEqualReferenced(2, ArrayWrapperControlledOperation(BinaryFractionClassical(_, bits), _), 
                                                   ArrayWrapperControlledOperation(BinaryFractionClassical_Alternative(_, bits), _));
            }
        }
    }


    // ------------------------------------------------------
    operation Task14InputWrapper (op : ((Qubit, Qubit[]) => Unit is Adj+Ctl), qs : Qubit[]) : Unit is Adj+Ctl {
        Controlled op([qs[0]], (qs[1], qs[2 ...]));
    }

    @Test("QuantumSimulator")
    operation T14_BinaryFractionQuantum () : Unit {
        for n in 1 .. 5 {
            AssertOperationsEqualReferenced(n + 2, Task14InputWrapper(BinaryFractionQuantum, _), 
                                                   Task14InputWrapper(BinaryFractionQuantum_Reference, _));
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T15_BinaryFractionQuantumInPlace () : Unit {
        for n in 1 .. 6 {
            AssertOperationsEqualReferenced(n, BinaryFractionQuantumInPlace, 
                                               BinaryFractionQuantumInPlace_Reference);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T16_ReverseRegister () : Unit {
        for n in 1 .. 6 {
            AssertOperationsEqualReferenced(n, ReverseRegister, 
                                               ReverseRegister_Reference);
            AssertOperationsEqualReferenced(n, ReverseRegister, 
                                               SwapReverseRegister);
        }
    }


    // ------------------------------------------------------
    operation HWrapper (register : Qubit[]) : Unit is Adj+Ctl {
        H(register[0]);
    }

    operation LibraryQFTWrapper (register : Qubit[]) : Unit is Adj+Ctl {
        QFT(BigEndian(register));
    }

    @Test("QuantumSimulator")
    operation T17_QuantumFourierTransform () : Unit {
        AssertOperationsEqualReferenced(1, QuantumFourierTransform, HWrapper);

        for n in 1 .. 5 {
            AssertOperationsEqualReferenced(n, QuantumFourierTransform, 
                                               QuantumFourierTransform_Reference);
            AssertOperationsEqualReferenced(n, QuantumFourierTransform, 
                                               LibraryQFTWrapper);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T18_InverseQFT () : Unit {
        AssertOperationsEqualReferenced(1, InverseQFT, HWrapper);

        for n in 1 .. 5 {
            AssertOperationsEqualReferenced(n, InverseQFT, 
                                               InverseQFT_Reference);
            AssertOperationsEqualReferenced(n, InverseQFT, 
                                               Adjoint LibraryQFTWrapper);
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Using the Quantum Fourier Transform
    //////////////////////////////////////////////////////////////////

    operation AssertEqualOnZeroState (N : Int, 
                                      testImpl : (Qubit[] => Unit), 
                                      refImpl : (Qubit[] => Unit is Adj)) : Unit {
        use qs = Qubit[N];
        // apply operation that needs to be tested
        testImpl(qs);

        // apply adjoint reference operation and check that the result is |0⟩
        Adjoint refImpl(qs);

        // assert that all qubits end up in |0⟩ state
        AssertAllZero(qs);
    }

    @Test("QuantumSimulator")
    operation T21_PrepareEqualSuperposition () : Unit {
        for N in 1 .. 5 {
            AssertEqualOnZeroState(N, PrepareEqualSuperposition, PrepareEqualSuperposition_Reference);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T22_PreparePeriodicState () : Unit {
        for N in 1 .. 5 {
            // cross-test: for F = 0 it's the same as equal superposition of states
            AssertEqualOnZeroState(N, PreparePeriodicState(_, 0), PrepareEqualSuperposition_Reference);

            for F in 1 .. (1 <<< N - 1) {
                AssertEqualOnZeroState(N, PreparePeriodicState(_, F), PreparePeriodicState_Reference(_, F));
            }
        }
    }
    

    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T23_PrepareAlternatingState () : Unit {
        for N in 1 .. 5 {
            AssertEqualOnZeroState(N, PrepareAlternatingState, PrepareAlternatingState_Reference);
        }
    }
    

    // ------------------------------------------------------
    operation ApplyHToMostWrapper (register : Qubit[]) : Unit is Adj+Ctl {
        ApplyToEachCA(H, Most(register));
    }

    @Test("QuantumSimulator")
    operation T24_PrepareEqualSuperpositionOfEvenStates () : Unit {
        for N in 1 .. 5 {
            // cross-test: we already know how to prepare a superposition of even states
            AssertEqualOnZeroState(N, ApplyHToMostWrapper, PrepareEqualSuperpositionOfEvenStates_Reference);
            AssertEqualOnZeroState(N, PrepareEqualSuperpositionOfEvenStates, PrepareEqualSuperpositionOfEvenStates_Reference);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T25_PrepareSquareWaveSignal () : Unit {
        for N in 2 .. 5 {
            AssertEqualOnZeroState(N, PrepareSquareWaveSignal, PrepareSquareWaveSignal_Reference);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T26_Frequency () : Unit {
        for N in 2 .. 5 {
            use register = Qubit[N];
            for F in 0 .. (1 <<< N - 1) {
                // Prepare input state 
                PreparePeriodicState_Reference(register, F);
                // Feed it to the solution
                let FRet = Frequency(register);
                if (FRet != F) {
                    fail $"Expected frequency {F}, returned frequency {FRet} (n = {N})";
                }
                ResetAll(register);
            }
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Powers and roots of the QFT
    //////////////////////////////////////////////////////////////////
    
    // slow brute-force implementation of QFT integer power to test on small cases
    internal operation QFTPower_Slow (P : Int, inputRegister : Qubit[]) : Unit is Adj {
        for _ in 1 .. P {
            QFT(BigEndian(inputRegister));
        }
    }

    @Test("QuantumSimulator")
    operation T31_QFTPower () : Unit {
        // small tests: check correctness of our approach on small-ish powers on 4-qubit register
        for p in 0 .. 20 {
            let testOp = QFTPower_Reference(p, _); 
            let refOp  = QFTPower_Slow(p, _); 
            AssertOperationsEqualReferenced(4, testOp, refOp);
        }

        // large tests: check speed and correctness both
        for n in 1 .. 9 {
            let power = (2 <<< (n + 10)) - 1;
            let testOp = QFTPower(power, _); 
            let refOp  = QFTPower_Reference(power, _); 
              
            AssertOperationsEqualReferenced(n, testOp, refOp);
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T32_QFTRoot () : Unit {
        for n in 2 .. 8 {
            for p in 2 .. 8 {
                let testOp = QFTRoot(p, _); 

                // we only compare the solution's powers to the QFT (big endian), 
                // not the solution to reference solution, since we're accepting any root
                AssertOperationsEqualReferenced(
                    n, OperationPow(testOp, p), QuantumFourierTransform_Reference
                );
            }
        }
    }
}
