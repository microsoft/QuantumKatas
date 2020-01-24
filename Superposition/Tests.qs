// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Superposition {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;


    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, 
                                      testImpl : (Qubit[] => Unit), 
                                      refImpl : (Qubit[] => Unit is Adj), 
                                      verbose : Bool,
                                      testStr : String) : Unit {
        using (qs = Qubit[N]) {
            if (verbose) {
                if (testStr != "") {
                    Message($"The desired state for {testStr}");
                } else {
                    Message("The desired state:");
                }
                refImpl(qs);
                DumpMachine(());
                ResetAll(qs);
            }

            // apply operation that needs to be tested
            testImpl(qs);

            if (verbose) {
                Message("The actual state:");
                DumpMachine(());
            }

            // apply adjoint reference operation and check that the result is |0⟩
            Adjoint refImpl(qs);

            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);

            if (verbose) {
                Message("Test case passed");
            }
        }
    }


    // ------------------------------------------------------
    operation ArrayWrapperOperation (op : (Qubit => Unit), qs : Qubit[]) : Unit {
        op(qs[0]);
    }

    operation ArrayWrapperOperationA (op : (Qubit => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(qs[0]);
    }


    operation T01_PlusState_Test () : Unit {
        AssertEqualOnZeroState(1, ArrayWrapperOperation(PlusState, _), ArrayWrapperOperationA(PlusState_Reference, _), true, "");
    }


    // ------------------------------------------------------
    operation T02_MinusState_Test () : Unit {
        AssertEqualOnZeroState(1, ArrayWrapperOperation(MinusState, _), ArrayWrapperOperationA(MinusState_Reference, _), true, "");
    }


    // ------------------------------------------------------
    operation T03_UnequalSuperposition_Test () : Unit {
        // cross-test
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.5 * PI()), _), ApplyToEachA(X, _), true, "α = 0.5 π");
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.25 * PI()), _), ArrayWrapperOperationA(PlusState_Reference, _), true, "α = 0.25 π");
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.75 * PI()), _), ArrayWrapperOperationA(MinusState_Reference, _), true, "α = 0.75 π");

        Message("Testing on hidden test cases...");
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.0), _), ApplyToEachA(I, _), false, "");

        for (i in 1 .. 36) {
            let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
            AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, alpha), _), ArrayWrapperOperationA(UnequalSuperposition_Reference(_, alpha), _), false, "");
        }
    }


    // ------------------------------------------------------
    operation T04_AllBasisVectors_TwoQubits_Test () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, AllBasisVectors_TwoQubits, AllBasisVectors_TwoQubits_Reference, true, "");
    }


    // ------------------------------------------------------
    operation T05_AllBasisVectorsWithPhases_TwoQubits_Test () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, AllBasisVectorsWithPhases_TwoQubits, AllBasisVectorsWithPhases_TwoQubits_Reference, true, "");
    }


    // ------------------------------------------------------
    operation T06_BellState_Test () : Unit {
        AssertEqualOnZeroState(2, BellState, BellState_Reference, true, "");
    }


    // ------------------------------------------------------
    operation T07_AllBellStates_Test () : Unit {
        for (i in 0 .. 3) {
            AssertEqualOnZeroState(2, AllBellStates(_, i), AllBellStates_Reference(_, i), true, $"index = {i}");
        }
    }


    // ------------------------------------------------------
    operation T08_GHZ_State_Test () : Unit {
        // for N = 1 it's just |+⟩
        AssertEqualOnZeroState(1, GHZ_State, ArrayWrapperOperationA(PlusState_Reference, _), true, "N = 1");

        // for N = 2 it's Bell state
        AssertEqualOnZeroState(2, GHZ_State, BellState_Reference, true, "N = 2");

        Message("Testing on hidden test cases...");
        for (n in 3 .. 9) {
            AssertEqualOnZeroState(n, GHZ_State, GHZ_State_Reference, false, "");
        }
    }


    // ------------------------------------------------------
    operation T09_AllBasisVectorsSuperposition_Test () : Unit {
        // for N = 1 it's just |+⟩
        AssertEqualOnZeroState(1, AllBasisVectorsSuperposition, ArrayWrapperOperationA(PlusState_Reference, _), true, "N = 1");

        AssertEqualOnZeroState(2, AllBasisVectorsSuperposition, AllBasisVectorsSuperposition_Reference, true, "N = 2");

        Message("Testing on hidden test cases...");
        for (n in 3 .. 8) {
            AssertEqualOnZeroState(n, AllBasisVectorsSuperposition, AllBasisVectorsSuperposition_Reference, false, "");
        }
    }


    // ------------------------------------------------------
    operation T10_EvenOddNumbersSuperposition_Test () : Unit {
        for (n in 1 .. 2) {
            for (isEven in [false, true]) {
                AssertEqualOnZeroState(n, EvenOddNumbersSuperposition(_, isEven), EvenOddNumbersSuperposition_Reference(_, isEven), true, $"N = {n}, isEven = {isEven}");
            }
        }

        Message("Testing on hidden test cases...");
        for (n in 3 .. 8) {
            for (isEven in [false, true]) {
                AssertEqualOnZeroState(n, EvenOddNumbersSuperposition(_, isEven), EvenOddNumbersSuperposition_Reference(_, isEven), false, "");
            }
        }
    }


    // ------------------------------------------------------
    operation T11_ThreeStates_TwoQubits_Test () : Unit {
        AssertEqualOnZeroState(2, ThreeStates_TwoQubits, ThreeStates_TwoQubits_Reference, true, "");
    }

    
    // ------------------------------------------------------
    operation T12_Hardy_State_Test () : Unit {
        AssertEqualOnZeroState(2, Hardy_State, Hardy_State_Reference, true, "");
    }

    // ------------------------------------------------------
    operation T13_ZeroAndBitstringSuperposition_Test () : Unit {
        // compare with results of previous operations
        mutable b = [true];
        AssertEqualOnZeroState(Length(b), ZeroAndBitstringSuperposition(_, b), 
                                          ArrayWrapperOperationA(PlusState_Reference, _), true, $"bits = {b}");

        set b = [true, true];
        AssertEqualOnZeroState(Length(b), ZeroAndBitstringSuperposition(_, b), 
                                          BellState_Reference, true, $"bits = {b}");

        set b = [true, false];
        AssertEqualOnZeroState(Length(b), ZeroAndBitstringSuperposition(_, b), 
                                          ZeroAndBitstringSuperposition_Reference(_, b), true, $"bits = {b}");

        Message("Testing on hidden test cases...");
        set b = [true, true, true];
        AssertEqualOnZeroState(Length(b), ZeroAndBitstringSuperposition(_, b), 
                                          GHZ_State_Reference, false, "");

        set b = [true, false, true];
        AssertEqualOnZeroState(Length(b), ZeroAndBitstringSuperposition(_, b), 
                                          ZeroAndBitstringSuperposition_Reference(_, b), false, "");

        set b = [true, false, true, true, false, false];
        AssertEqualOnZeroState(Length(b), ZeroAndBitstringSuperposition(_, b), 
                                          ZeroAndBitstringSuperposition_Reference(_, b), false, "");
    }


    // ------------------------------------------------------
    operation T14_TwoBitstringSuperposition_Test () : Unit {
        // open tests
        // diff in the first position
        mutable b1 = [true];
        mutable b2 = [false];
        AssertEqualOnZeroState(Length(b1), TwoBitstringSuperposition(_, b1, b2), 
                                           ArrayWrapperOperationA(PlusState_Reference, _), 
                                           true, $"bits1 = {b1}, bits2 = {b2}");

        // diff in both positions
        set b1 = [false, true];
        set b2 = [true, false];
        AssertEqualOnZeroState(Length(b1), TwoBitstringSuperposition(_, b1, b2), 
                                           AllBellStates_Reference(_, 2), 
                                           true, $"bits1 = {b1}, bits2 = {b2}");

        Message("Testing on hidden test cases...");
        // compare with results of previous operations
        set b1 = [false, false];
        set b2 = [true, true];
        AssertEqualOnZeroState(Length(b1), TwoBitstringSuperposition(_, b1, b2), 
                                           BellState_Reference, false, "");

        set b1 = [true, true, true];
        set b2 = [false, false, false];
        AssertEqualOnZeroState(Length(b1), TwoBitstringSuperposition(_, b1, b2), 
                                           GHZ_State_Reference, false, "");

        // compare with reference implementation
        // diff in the first position
        set b1 = [true, true, false];
        set b2 = [false, true, true];
        AssertEqualOnZeroState(Length(b1), TwoBitstringSuperposition(_, b1, b2), 
                                           TwoBitstringSuperposition_Reference(_, b1, b2), false, "");

        // diff in the middle
        set b1 = [true, false, false];
        set b2 = [true, true, false];
        AssertEqualOnZeroState(Length(b1), TwoBitstringSuperposition(_, b1, b2), 
                                           TwoBitstringSuperposition_Reference(_, b1, b2), false, "");

        // diff in the last position
        set b1 = [false, true, true, false];
        set b2 = [false, true, true, true];
        AssertEqualOnZeroState(Length(b1), TwoBitstringSuperposition(_, b1, b2), 
                                           TwoBitstringSuperposition_Reference(_, b1, b2), false, "");
    }


    // ------------------------------------------------------
    operation T15_FourBitstringSuperposition_Test () : Unit {

        // cross-tests
        mutable bits = [[false, false], [false, true], [true, false], [true, true]];
        AssertEqualOnZeroState(2, FourBitstringSuperposition(_, bits), ApplyToEachA(H, _), true, $"bits = {bits}");

        Message("Testing on hidden test cases...");
        set bits = [[false, false, false, true], [false, false, true, false], [false, true, false, false], [true, false, false, false]];
        AssertEqualOnZeroState(4, FourBitstringSuperposition(_, bits), WState_Arbitrary_Reference, false, "");

        // random tests
        for (N in 3 .. 10) {
            // generate 4 distinct numbers corresponding to the bit strings
            mutable numbers = new Int[4];

            repeat {
                mutable ok = true;
                for (i in 0 .. 3) {
                    set numbers w/= i <- RandomInt(1 <<< N);
                    for (j in 0 .. i - 1) {
                        if (numbers[i] == numbers[j]) {
                            set ok = false;
                        }
                    }
                }
            }
            until (ok)
            fixup { }

            // convert numbers to bit strings
            for (i in 0 .. 3) {
                set bits w/= i <- IntAsBoolArray(numbers[i], N);
            }

            AssertEqualOnZeroState(N, FourBitstringSuperposition(_, bits), FourBitstringSuperposition_Reference(_, bits), false, "");
        }
    }


    // ------------------------------------------------------
    operation T16_WState_PowerOfTwo_Test () : Unit {
        // separate check for N = 1 (return must be |1⟩)
        AssertEqualOnZeroState(1, WState_PowerOfTwo, ApplyToEachA(X, _), true, "N = 1");

        AssertEqualOnZeroState(2, WState_PowerOfTwo, TwoBitstringSuperposition_Reference(_, [false, true], [true, false]), true, "N = 2");

        Message("Testing on hidden test cases...");
        AssertEqualOnZeroState(4, WState_PowerOfTwo, WState_PowerOfTwo_Reference, false, "");
        AssertEqualOnZeroState(8, WState_PowerOfTwo, WState_PowerOfTwo_Reference, false, "");
        AssertEqualOnZeroState(16, WState_PowerOfTwo, WState_PowerOfTwo_Reference, false, "");
    }


    // ------------------------------------------------------
    operation T17_WState_Arbitrary_Test () : Unit {
        // separate check for N = 1 (return must be |1⟩)
        AssertEqualOnZeroState(1, WState_Arbitrary, ApplyToEachA(X, _), true, "N = 1");

        // cross-tests for powers of 2
        AssertEqualOnZeroState(2, WState_Arbitrary, WState_PowerOfTwo_Reference, true, "N = 2");

        Message("Testing on hidden test cases...");
        for (n in [4, 8, 16]) {
            AssertEqualOnZeroState(n, WState_Arbitrary, WState_PowerOfTwo_Reference, false, "");
        }

        for (i in 2 .. 16) {
            AssertEqualOnZeroState(i, WState_Arbitrary, WState_Arbitrary_Reference, false, "");
        }
    }
}
