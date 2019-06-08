// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GraphColoring {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    

    //////////////////////////////////////////////////////////////////
    // Here are several examples of how you can run and test
    // your solutions to the programming assignments in Q#.
    //////////////////////////////////////////////////////////////////

    operation T11_Test () : Unit {
        using ((register, target) = (Qubit[5], Qubit())) {
            Task11(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);


            X(register[0]);
            Task11(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);

            X(register[1]);
            X(register[2]);
            X(register[4]);
            Task11(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);

            X(register[0]);
            X(register[1]);
            X(register[2]);
            X(register[3]);
            X(register[4]);
            Task11(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);

            X(register[0]);
            X(register[1]);
            X(register[2]);
            X(register[3]);
            X(register[4]);
            X(target);
            Task11(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);
        }
    }

    operation T12_Test () : Unit {
        using ((register, target) = (Qubit[5], Qubit())) {
            Task12(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);


            X(register[0]);
            Task12(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);

            X(register[1]);
            X(register[2]);
            X(register[4]);
            Task12(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);

            X(register[0]);
            X(register[1]);
            X(register[2]);
            X(register[3]);
            X(register[4]);
            Task12(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);

            X(register[0]);
            X(register[1]);
            X(register[2]);
            X(register[3]);
            X(register[4]);
            X(target);
            Task12(register, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[2], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[3], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[4], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(register);
            Reset(target);
        }
    }

    operation T13_Test () : Unit {
        using ((r1, r2, target) = (Qubit[2], Qubit[2], Qubit())) {
            Task13(r1, r2, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            Task13(r1, r2, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            Reset(target);

            X(r1[1]);
            X(r2[1]);
            Task13(r1, r2, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            Reset(target);

            X(r1[0]);
            X(r1[1]);
            X(r2[0]);
            X(r2[1]);
            Task13(r1, r2, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            Reset(target);


            X(r1[0]);
            X(r1[1]);
            X(r2[0]);
            X(r2[1]);
            X(target);
            Task13(r1, r2, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            Reset(target);

            X(r1[0]);
            X(r1[1]);
            X(r2[1]);
            Task13(r1, r2, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            Reset(target);

            X(r1[0]);
            X(r2[1]);
            Task13(r1, r2, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            Reset(target);

            X(r1[0]);
            Task13(r1, r2, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            Reset(target);
        }
    }

    operation T21_Test () : Unit {
        using ((r1, r2, r3, target) = (Qubit[2], Qubit[2], Qubit[2], Qubit())) {
            Task21(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            X(r3[0]);
            Task21(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            X(r3[0]);
            X(r1[1]);
            X(r2[1]);
            X(r3[1]);
            Task21(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            X(r3[0]);
            X(r1[1]);
            X(r2[1]);
            X(r3[1]);
            X(target);
            Task21(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r2[0]);
            Task21(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[1]);
            X(r2[0]);
            Task21(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            Task21(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);
        }
    }

    operation T22_Test () : Unit {
        using ((r1, r2, r3, target) = (Qubit[2], Qubit[2], Qubit[2], Qubit())) {
            Task22(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            X(r3[0]);
            Task22(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            X(r3[0]);
            X(r1[1]);
            X(r2[1]);
            X(r3[1]);
            Task22(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            X(r3[0]);
            X(r1[1]);
            X(r2[1]);
            X(r3[1]);
            X(target);
            Task22(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r2[0]);
            Task22(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[1]);
            X(r2[0]);
            Task22(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r1[1]);
            X(r2[0]);
            X(r3[1]);
            X(target);
            Task22(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);

            X(r1[0]);
            X(r2[0]);
            Task22(r1, r2, r3, target);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r1[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r1[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), r2[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r2[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[0], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), r3[1], 1e-5);
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
            ResetAll(r1);
            ResetAll(r2);
            ResetAll(r3);
            Reset(target);
        }
    }


    operation T31_Test () : Unit {
        // Allocate a qubit which you'll pass to the operation
        let orc = gen_Task31([(0, 1), (1, 3), (1, 4), (2, 3), (4, 3), (5, 3), (3, 6), (6, 4), (4, 5)], 7);

        using ((register, target) = (Qubit[14], Qubit())) {
            Test_Assignment(orc, [0, 1, 0, 2, 0, 1, 1], 1, register, target);

            X(target);
            Test_Assignment(orc, [0, 1, 0, 2, 0, 1, 1], 0, register, target);

            Test_Assignment(orc, [0, 1, 2, 2, 0, 1, 1], 0, register, target);

            X(target);
            Test_Assignment(orc, [0, 1, 2, 2, 0, 1, 1], 1, register, target);
        }
    }

    operation T32_Test () : Unit {
        // Allocate a qubit which you'll pass to the operation
        let orc = Task32([(0, 1), (1, 3), (1, 4), (2, 3), (4, 3), (5, 3), (3, 6), (6, 4), (4, 5)], 7);

        using ((register, target) = (Qubit[14], Qubit())) {
            Test_Assignment(orc, [0, 1, 0, 2, 0, 1, 1], 1, register, target);

            X(target);
            Test_Assignment(orc, [0, 1, 0, 2, 0, 1, 1], 0, register, target);

            Test_Assignment(orc, [0, 1, 2, 2, 0, 1, 1], 0, register, target);

            X(target);
            Test_Assignment(orc, [0, 1, 2, 2, 0, 1, 1], 1, register, target);
        }
    }

    operation T4_Test () : Unit {
        // Allocate a qubit which you'll pass to the operation
        let edgeList = [(0, 1), (1, 3), (1, 4), (2, 3), (4, 3), (5, 3), (3, 6), (6, 4), (4, 5)];
        let numNodes = 7;

        mutable success = false;
        for (i in 0 .. 9) {
            let ret = Task4(edgeList, numNodes);
            if (Verify_Assignment(ret, edgeList, numNodes)) {
                set success = true;
            }
        }

        AssertBoolEqual(success, true, "Grover's Search failed to find a valid color assignment");
    }

    function Verify_Assignment(assignments : Int[], edgeList : (Int, Int)[], numNodes : Int) : Bool {
        if (Length(assignments) != numNodes) {
            return false;
        }
        for (i in 0 .. Length(assignments) - 1) {
            let (j, k) = edgeList[i];
            if (assignments[j] == assignments[k]) {
                return false;
            }
        }
        return true;
    }

    operation Test_Assignment(orc : ((Qubit[], Qubit) => Unit is Adj), assignment : Int[], outState : Int, register : Qubit[], target : Qubit) : Unit {
        Assign_Colors(register, assignment);
        orc(register, target);

        Assert_Colors(register, assignment);
        if (outState == 0) {
            AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), target, 1e-5);
        } elif (outState == 1) {
            AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), target, 1e-5);
        } else {
            fail "Desired output state must be 0 or 1";
        }

        ResetAll(register);
        Reset(target);
    }

    operation Assign_Colors(register : Qubit[], assignments : Int[]) : Unit {
        if (Length(register) != Length(assignments) * 2) {
            fail "Number of assignments need to match number of nodes";
        }

        for (i in 0 .. Length(assignments) - 1) {
            if (assignments[i] == 0) {
                //Don't do anything
            } elif (assignments[i] == 1) {
                X(register[i * 2 + 1]);
            } elif (assignments[i] == 2) {
                X(register[i * 2]);
            } elif (assignments[i] == 3) {
                X(register[i * 2]);
                X(register[i * 2 + 1]);
            } else {
                fail "Color Assignments need to be from 0 - 3";
            }
        }
    }

    operation Assert_Colors(register : Qubit[], assignments : Int[]) : Unit {
        AssertIntEqual(Length(register), Length(assignments) * 2, "Number of assignments need to match number of nodes");

        for (i in 0 .. Length(assignments) - 1) {
            if (assignments[i] == 0) {
                AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[i * 2], 1e-5);
                AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[i * 2 + 1], 1e-5);
            } elif (assignments[i] == 1) {
                AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[i * 2], 1e-5);
                AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[i * 2 + 1], 1e-5);
            } elif (assignments[i] == 2) {
                AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[i * 2], 1e-5);
                AssertQubitIsInStateWithinTolerance((Complex(1.0, 0.0), Complex(0.0, 0.0)), register[i * 2 + 1], 1e-5);
            } elif (assignments[i] == 3) {
                AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[i * 2], 1e-5);
                AssertQubitIsInStateWithinTolerance((Complex(0.0, 0.0), Complex(1.0, 0.0)), register[i * 2 + 1], 1e-5);
            } else {
                fail "Color Assignments need to be from 0 - 3";
            }
        }
    }

    operation gen_Task31 (edgeList : (Int, Int)[], numNodes : Int) : ((Qubit[], Qubit) => Unit is Adj) {
        return Task31(edgeList, numNodes, _, _);
    }
}