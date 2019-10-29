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
    operation AssertEqualOnZeroState (N : Int, testImpl : (Qubit[] => Unit), refImpl : (Qubit[] => Unit is Adj), verbose : Bool) : Unit {
        using (qs = Qubit[N]) {
            
			if (verbose)
			{
			    Message("The desired state:");
				refImpl(qs);
				DumpMachine(());
				ResetAll(qs);
			}

			// apply operation that needs to be tested
			testImpl(qs);

			if (verbose)
			{
				Message("The actual state:");
				DumpMachine(());
			}

            // apply adjoint reference operation and check that the result is |0⟩
            Adjoint refImpl(qs);

            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);

			if (verbose)
			{
				Message("Passed");
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
        AssertEqualOnZeroState(1, ArrayWrapperOperation(PlusState, _), ArrayWrapperOperationA(PlusState_Reference, _), true);
    }


    // ------------------------------------------------------
    operation T02_MinusState_Test () : Unit {
        AssertEqualOnZeroState(1, ArrayWrapperOperation(MinusState, _), ArrayWrapperOperationA(MinusState_Reference, _), true);
    }


    // ------------------------------------------------------
    operation T03_UnequalSuperposition_Test () : Unit {
        // cross-test
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.0), _), ApplyToEachA(I, _), true);
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.5 * PI()), _), ApplyToEachA(X, _), true);
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.5 * PI()), _), ApplyToEachA(Y, _), true);
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.25 * PI()), _), ArrayWrapperOperationA(PlusState_Reference, _), true);
        AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, 0.75 * PI()), _), ArrayWrapperOperationA(MinusState_Reference, _), true);

        for (i in 1 .. 36) {
            let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
            AssertEqualOnZeroState(1, ArrayWrapperOperation(UnequalSuperposition(_, alpha), _), ArrayWrapperOperationA(UnequalSuperposition_Reference(_, alpha), _), false);
        }
    }


    // ------------------------------------------------------
    operation T04_AllBasisVectors_TwoQubits_Test () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, AllBasisVectors_TwoQubits, AllBasisVectors_TwoQubits_Reference, true);
    }


    // ------------------------------------------------------
    operation T05_AllBasisVectorsWithPhases_TwoQubits_Test () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, AllBasisVectorsWithPhases_TwoQubits, AllBasisVectorsWithPhases_TwoQubits_Reference, true);
    }


    // ------------------------------------------------------
    operation T06_BellState_Test () : Unit {
        AssertEqualOnZeroState(2, BellState, BellState_Reference, true);
    }


    // ------------------------------------------------------
    operation T07_AllBellStates_Test () : Unit {
        for (i in 0 .. 3) {
            AssertEqualOnZeroState(2, AllBellStates(_, i), AllBellStates_Reference(_, i), true);
        }
    }


    // ------------------------------------------------------
    operation T08_GHZ_State_Test () : Unit {
        // for N = 1 it's just |+⟩
        AssertEqualOnZeroState(1, GHZ_State, ArrayWrapperOperationA(PlusState_Reference, _), true);

        // for N = 2 it's Bell state
        AssertEqualOnZeroState(2, GHZ_State, BellState_Reference, true);

        for (n in 3 .. 9) {
            AssertEqualOnZeroState(n, GHZ_State, GHZ_State_Reference, false);
        }
    }


    // ------------------------------------------------------
    operation T09_AllBasisVectorsSuperposition_Test () : Unit {
        // for N = 1 it's just |+⟩
        AssertEqualOnZeroState(1, AllBasisVectorsSuperposition, ArrayWrapperOperationA(PlusState_Reference, _), true);

        for (n in 2 .. 9) {
            AssertEqualOnZeroState(n, AllBasisVectorsSuperposition, AllBasisVectorsSuperposition_Reference, false);
        }
    }


    // ------------------------------------------------------
    operation T10_EvenOddNumbersSuperposition_Test () : Unit {
        for (n in 1 .. 9) {
		    let verbose = (n <= 3);
            AssertEqualOnZeroState(n, EvenOddNumbersSuperposition(_, true), EvenOddNumbersSuperposition_Reference(_, true), verbose);
            AssertEqualOnZeroState(n, EvenOddNumbersSuperposition(_, false), EvenOddNumbersSuperposition_Reference(_, false), verbose);
        }
    }


    // ------------------------------------------------------
    operation T11_ThreeStates_TwoQubits_Test () : Unit {
        AssertEqualOnZeroState(2, ThreeStates_TwoQubits, ThreeStates_TwoQubits_Reference, true);
    }

    
    // ------------------------------------------------------
    operation T12_Hardy_State_Test () : Unit {
        AssertEqualOnZeroState(2, Hardy_State, Hardy_State_Reference, true);
    }

    // ------------------------------------------------------
    operation T13_ZeroAndBitstringSuperposition_Test () : Unit {
        // compare with results of previous operations
        AssertEqualOnZeroState(1, ZeroAndBitstringSuperposition(_, [true]), ArrayWrapperOperationA(PlusState_Reference, _), true);
        AssertEqualOnZeroState(2, ZeroAndBitstringSuperposition(_, [true, true]), BellState_Reference, true);
        AssertEqualOnZeroState(3, ZeroAndBitstringSuperposition(_, [true, true, true]), GHZ_State_Reference, true);

        mutable b = [true, false];
        AssertEqualOnZeroState(2, ZeroAndBitstringSuperposition(_, b), ZeroAndBitstringSuperposition_Reference(_, b), true);

        set b = [true, false, true];
        AssertEqualOnZeroState(3, ZeroAndBitstringSuperposition(_, b), ZeroAndBitstringSuperposition_Reference(_, b), false);

        set b = [true, false, true, true, false, false];
        AssertEqualOnZeroState(6, ZeroAndBitstringSuperposition(_, b), ZeroAndBitstringSuperposition_Reference(_, b), false);
    }


    // ------------------------------------------------------
    operation T14_TwoBitstringSuperposition_Test () : Unit {
        // compare with results of previous operations
        AssertEqualOnZeroState(1, TwoBitstringSuperposition(_, [true], [false]), ArrayWrapperOperationA(PlusState_Reference, _), true);
        AssertEqualOnZeroState(2, TwoBitstringSuperposition(_, [false, false], [true, true]), BellState_Reference, true);
        AssertEqualOnZeroState(3, TwoBitstringSuperposition(_, [true, true, true], [false, false, false]), GHZ_State_Reference, false);

        // compare with reference implementation
        // diff in first position
        mutable b1 = [false, true];
        mutable b2 = [true, false];
        AssertEqualOnZeroState(2, TwoBitstringSuperposition(_, b1, b2), TwoBitstringSuperposition_Reference(_, b1, b2), true);

        set b1 = [true, true, false];
        set b2 = [false, true, true];
        AssertEqualOnZeroState(3, TwoBitstringSuperposition(_, b1, b2), TwoBitstringSuperposition_Reference(_, b1, b2), false);

        // diff in last position
        set b1 = [false, true, true, false];
        set b2 = [false, true, true, true];
        AssertEqualOnZeroState(4, TwoBitstringSuperposition(_, b1, b2), TwoBitstringSuperposition_Reference(_, b1, b2), false);

        // diff in the middle
        set b1 = [true, false, false, false];
        set b2 = [true, false, true, true];
        AssertEqualOnZeroState(4, TwoBitstringSuperposition(_, b1, b2), TwoBitstringSuperposition_Reference(_, b1, b2), false);
    }


    // ------------------------------------------------------
    operation T15_FourBitstringSuperposition_Test () : Unit {

        // cross-tests
        mutable bits = [[false, false], [false, true], [true, false], [true, true]];
        AssertEqualOnZeroState(2, FourBitstringSuperposition(_, bits), ApplyToEachA(H, _), true);
        set bits = [[false, false, false, true], [false, false, true, false], [false, true, false, false], [true, false, false, false]];
        AssertEqualOnZeroState(4, FourBitstringSuperposition(_, bits), WState_Arbitrary_Reference, false);

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

            AssertEqualOnZeroState(N, FourBitstringSuperposition(_, bits), FourBitstringSuperposition_Reference(_, bits), false);
        }
    }


    // ------------------------------------------------------
    operation T16_WState_PowerOfTwo_Test () : Unit {
        // separate check for N = 1 (return must be |1⟩)
        using (qs = Qubit[1]) {
            WState_PowerOfTwo(qs);
            Assert([PauliZ], qs, One, "");
            X(qs[0]);
        }

        AssertEqualOnZeroState(2, WState_PowerOfTwo, TwoBitstringSuperposition_Reference(_, [false, true], [true, false]), true);
        AssertEqualOnZeroState(4, WState_PowerOfTwo, WState_PowerOfTwo_Reference, false);
        AssertEqualOnZeroState(8, WState_PowerOfTwo, WState_PowerOfTwo_Reference, false);
        AssertEqualOnZeroState(16, WState_PowerOfTwo, WState_PowerOfTwo_Reference, false);
    }


    // ------------------------------------------------------
    operation T17_WState_Arbitrary_Test () : Unit {
        // separate check for N = 1 (return must be |1⟩)
        using (qs = Qubit[1]) {
            WState_Arbitrary_Reference(qs);
            Assert([PauliZ], qs, One, "");
            X(qs[0]);
        }

        // cross-tests
        AssertEqualOnZeroState(2, WState_Arbitrary, TwoBitstringSuperposition_Reference(_, [false, true], [true, false]), true);
        AssertEqualOnZeroState(2, WState_Arbitrary, WState_PowerOfTwo_Reference, true);
        AssertEqualOnZeroState(4, WState_Arbitrary, WState_PowerOfTwo_Reference, false);
        AssertEqualOnZeroState(8, WState_Arbitrary, WState_PowerOfTwo_Reference, false);
        AssertEqualOnZeroState(16, WState_Arbitrary, WState_PowerOfTwo_Reference, false);

        for (i in 2 .. 16) {
            AssertEqualOnZeroState(i, WState_Arbitrary, WState_Arbitrary_Reference, false);
        }
    }
}
