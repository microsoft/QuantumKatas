// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Superposition
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;

    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, testImpl : (Qubit[] => ()), refImpl : (Qubit[] => () : Adjoint)) : ()
    {
        body
        {
            using (qs = Qubit[N])
            {
                // apply operation that needs to be tested
                testImpl(qs);

                // apply adjoint reference operation and check that the result is |0〉
                (Adjoint refImpl)(qs);

                // assert that all qubits end up in |0〉 state
                AssertAllZero(qs);
            }
        }
    }

    // ------------------------------------------------------
    operation T01_PlusState_Test () : ()
    {
        body
        {
            AssertEqualOnZeroState(1, PlusState, PlusState_Reference);
        }
    }

    // ------------------------------------------------------
    operation T02_MinusState_Test () : ()
    {
        body
        {
            AssertEqualOnZeroState(1, MinusState, MinusState_Reference);
        }
    }

    // ------------------------------------------------------
    operation T03_UnequalSuperposition_Test () : ()
    {
        body
        {
            // cross-test
            AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.0), ApplyToEachA(I, _));
            AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.5 * PI()), ApplyToEachA(X, _));
            AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.5 * PI()), ApplyToEachA(Y, _));
            AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.25 * PI()), PlusState_Reference);
            AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.75 * PI()), MinusState_Reference);

            for (i in 1..36) {
                let alpha = 2.0 * PI() * ToDouble(i) / 36.0;
                AssertEqualOnZeroState(1, UnequalSuperposition(_, alpha), UnequalSuperposition_Reference(_, alpha));
            }
        }
    }

    // ------------------------------------------------------
    operation T04_BellState_Test () : ()
    {
        body
        {
            AssertEqualOnZeroState(2, BellState, BellState_Reference);
        }
    }

    // ------------------------------------------------------
    operation T05_AllBellStates_Test () : ()
    {
        body
        {
            for (i in 0..3) {
                AssertEqualOnZeroState(2, AllBellStates(_, i), AllBellStates_Reference(_, i));
            }
        }
    }

    // ------------------------------------------------------
    operation T06_GHZ_State_Test () : ()
    {
        body
        {
            // for N = 1 it's just |+〉
            AssertEqualOnZeroState(1, GHZ_State, PlusState_Reference);
            // for N = 2 it's Bell state
            AssertEqualOnZeroState(2, GHZ_State, BellState_Reference);
            for (n in 3..9) {
                AssertEqualOnZeroState(n, GHZ_State, GHZ_State_Reference);
            }
        }
    }

    // ------------------------------------------------------
    operation T07_AllBasisVectorsSuperposition_Test () : ()
    {
        body
        {
            // for N = 1 it's just |+〉
            AssertEqualOnZeroState(1, AllBasisVectorsSuperposition, PlusState_Reference);

            for (n in 2..9) {
                AssertEqualOnZeroState(n, AllBasisVectorsSuperposition, AllBasisVectorsSuperposition_Reference);
            }
        }
    }

    // ------------------------------------------------------
    operation T08_ZeroAndBitstringSuperposition_Test () : ()
    {
        body
        {
            // compare with results of previous operations
            AssertEqualOnZeroState(1, ZeroAndBitstringSuperposition(_, [true]), PlusState_Reference);
            AssertEqualOnZeroState(2, ZeroAndBitstringSuperposition(_, [true; true]), BellState_Reference);
            AssertEqualOnZeroState(3, ZeroAndBitstringSuperposition(_, [true; true; true]), GHZ_State_Reference);

            if (true) {
                let b = [true; false];
                AssertEqualOnZeroState(2, ZeroAndBitstringSuperposition(_, b),
                                ZeroAndBitstringSuperposition_Reference(_, b));
            }
            if (true) {
                let b = [true; false; true];
                AssertEqualOnZeroState(3, ZeroAndBitstringSuperposition(_, b),
                                ZeroAndBitstringSuperposition_Reference(_, b));
            }
            if (true) {
                let b = [true; false; true; true; false; false];
                AssertEqualOnZeroState(6, ZeroAndBitstringSuperposition(_, b),
                                ZeroAndBitstringSuperposition_Reference(_, b));
            }
        }
    }

    // ------------------------------------------------------
    operation T09_TwoBitstringSuperposition_Test () : ()
    {
        body
        {
            // compare with results of previous operations
            AssertEqualOnZeroState(1, TwoBitstringSuperposition(_, [true], [false]), PlusState_Reference);
            AssertEqualOnZeroState(2, TwoBitstringSuperposition(_, [false; false], [true; true]), BellState_Reference);
            AssertEqualOnZeroState(3, TwoBitstringSuperposition(_, [true; true; true], [false; false; false]), GHZ_State_Reference);

            // compare with reference implementation
            // diff in first position
            for (i in 1..1)
            {
                let b1 = [false; true];
                let b2 = [true; false];
                AssertEqualOnZeroState(2, TwoBitstringSuperposition(_, b1, b2),
                                TwoBitstringSuperposition_Reference(_, b1, b2));
            }
            for (i in 1..1)
            {
                let b1 = [true; true; false];
                let b2 = [false; true; true];
                AssertEqualOnZeroState(3, TwoBitstringSuperposition(_, b1, b2),
                                TwoBitstringSuperposition_Reference(_, b1, b2));
            }
            // diff in last position
            for (i in 1..1)
            {
                let b1 = [false; true; true; false];
                let b2 = [false; true; true; true];
                AssertEqualOnZeroState(4, TwoBitstringSuperposition(_, b1, b2),
                                TwoBitstringSuperposition_Reference(_, b1, b2));
            }
            // diff in the middle
            for (i in 1..1)
            {
                let b1 = [true; false; false; false];
                let b2 = [true; false; true; true];
                AssertEqualOnZeroState(4, TwoBitstringSuperposition(_, b1, b2),
                                TwoBitstringSuperposition_Reference(_, b1, b2));
            }
        }
    }

    // ------------------------------------------------------
    operation T10_WState_PowerOfTwo_Test () : ()
    {
        body
        {
            // separate check for N = 1 (return must be |1〉)
            using (qs = Qubit[1]) {
                WState_PowerOfTwo(qs);
                Assert([PauliZ], qs, One, "");
                X(qs[0]);
            }

            AssertEqualOnZeroState(2, WState_PowerOfTwo, TwoBitstringSuperposition_Reference(_, [false; true], [true; false]));
            AssertEqualOnZeroState(4, WState_PowerOfTwo, WState_PowerOfTwo_Reference);
            AssertEqualOnZeroState(8, WState_PowerOfTwo, WState_PowerOfTwo_Reference);
            AssertEqualOnZeroState(16, WState_PowerOfTwo, WState_PowerOfTwo_Reference);
        }
    }

    // ------------------------------------------------------
    operation T11_WState_Arbitrary_Test () : ()
    {
        body
        {
            // separate check for N = 1 (return must be |1〉)
            using (qs = Qubit[1]) {
                WState_Arbitrary_Reference(qs);
                Assert([PauliZ], qs, One, "");
                X(qs[0]);
            }

            // cross-tests
            AssertEqualOnZeroState(2, WState_Arbitrary, TwoBitstringSuperposition_Reference(_, [false; true], [true; false]));

            AssertEqualOnZeroState(2, WState_Arbitrary, WState_PowerOfTwo_Reference);
            AssertEqualOnZeroState(4, WState_Arbitrary, WState_PowerOfTwo_Reference);
            AssertEqualOnZeroState(8, WState_Arbitrary, WState_PowerOfTwo_Reference);
            AssertEqualOnZeroState(16, WState_Arbitrary, WState_PowerOfTwo_Reference);

            for (i in 2..16) {
                AssertEqualOnZeroState(i, WState_Arbitrary, WState_Arbitrary_Reference);
            }
        }
    }
}