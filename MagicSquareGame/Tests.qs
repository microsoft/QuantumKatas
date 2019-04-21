// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MagicSquareGame {

    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Testing;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;

    operation T11_ValidMove_Test () : Unit {
        // Try all moves with +1 and -1.
        for (i in 0..1 <<< 3 - 1) {
            let cells = Map(SignFromBool, BoolArrFromPositiveInt(i, 3));
            AssertBoolEqual(
                ValidAliceMove(cells),
                ValidAliceMove_Reference(cells),
                $"Valid Alice move is wrong for {cells}");
            AssertBoolEqual(
                ValidBobMove(cells),
                ValidBobMove_Reference(cells),
                $"Valid Bob move is wrong for {cells}");
        }

        // Moves with numbers other than +1 and -1 should be rejected.
        let cellsOutOfRange = [1, -2, 10];
        AssertBoolEqual(
            ValidAliceMove(cellsOutOfRange),
            false,
            $"Valid Alice move is wrong for {cellsOutOfRange}");
        AssertBoolEqual(
            ValidBobMove(cellsOutOfRange),
            false,
            $"Valid Bob move is wrong for {cellsOutOfRange}");
    }

    function SignFromBool (input : Bool) : Int {
        return input ? 1 | -1;
    }


    // ------------------------------------------------------
    operation T12_WinCondition_Test () : Unit {
        // Try all moves with +1 and -1.
        for (i in 0..1 <<< 3 - 1) {
            for (j in 0..1 <<< 3 - 1) {
                for (row in 0..2) {
                    for (column in 0..2) {
                        let alice = Map(SignFromBool, BoolArrFromPositiveInt(i, 3));
                        let bob = Map(SignFromBool, BoolArrFromPositiveInt(j, 3));

                        AssertBoolEqual(
                            WinCondition(alice, row, bob, column),
                            WinCondition_Reference(alice, row, bob, column),
                            $"Win condition is wrong for Alice={alice}, row={row}, Bob={bob}, column={column}");
                    }
                }
            }
        }

        // Moves with numbers other than +1 and -1 should be rejected.
        let aliceOutOfRange = [-1, -1, 7];
        let bobInRange = [-1, 1, 1];
        AssertBoolEqual(
            WinCondition(aliceOutOfRange, 0, bobInRange, 0),
            false,
            $"Win condition is wrong for Alice={aliceOutOfRange}, row=0, Bob={bobInRange}, column=0");
    }


    // Tests that with the quantum strategy, alice and bob always win.
    operation MerminQuantum_Test () : Unit {
        mutable result = true;
        mutable iters = 0;
        repeat {
            mutable aliceMoves = new Int[3];
            mutable bobMoves = new Int[3];
            let row = RandomInt(3);
            let col = RandomInt(3);
            using (qs = Qubit[4]) {
                CreateAliceAndBobQubits(qs[0..1], qs[2..3]);
                set aliceMoves = PlayAsAlice(row, qs[0], qs[1]);
                set bobMoves = PlayAsBob(col, qs[2], qs[3]);
                if (not WinCondition_Reference(aliceMoves, row, bobMoves, col)) {
                    fail "Alice and bob did not play correctly.";
                }
                ResetAll(qs);
            }
            set iters = iters + 1;
            if (iters > 1000) {
                set result = false;
            }
        } until (not result)
        fixup{}
    }

    operation ClassicalOptimalPlacement_Test() : Unit {
        let runs = 1000;
        for (i in 0..runs) {
            let row = RandomInt(3);
            let col = RandomInt(3);
            let (aMoves, bMoves) = gameRunnerClassicalOptimal(row, col);

            AssertBoolEqual(ValidAliceMove_Reference(aMoves), true, "Alice's move is invalid");
            AssertBoolEqual(ValidBobMove_Reference(bMoves), true, "Bob's move is invalid");
        }
    }

    operation ClassicalOptimalWinRate_Test() : Unit {
        mutable wins = 0;
        mutable runs = 5000;
        for (i in 0..runs) {
            let row = RandomInt(3);
            let col = RandomInt(3);
            let (aMoves, bMoves) = gameRunnerClassicalOptimal(row, col);
            if (WinCondition_Reference(aMoves, row, bMoves, col)) {
                set wins = wins + 1;
            }
        }

        let rate = ToDouble(wins) / ToDouble(runs);
        Message($"Classical optimal win rate was: {rate}");
        AssertAlmostEqualTol(rate, 0.85, 0.05);
    }

    operation StatePrepTest() : Unit {
        AssertOperationsEqualInPlaceCompBasis(CreateEntangledPair, CreateEntangledPair_Reference, 2);
    }

    operation gameRunnerQuantum (row : Int, col : Int) : (Int[], Int[]) {
        mutable aliceMoves = new Int[3];
        mutable bobMoves = new Int[3];
        using (qs = Qubit[4]) {
            CreateAliceAndBobQubits(qs[0..1], qs[2..3]);
            set aliceMoves = PlayAsAlice(row, qs[0], qs[1]);
            set bobMoves = PlayAsBob(col, qs[2], qs[3]);
            let victorious = WinCondition_Reference(aliceMoves, row, bobMoves, col);
            ResetAll(qs);
        }
        return (aliceMoves, bobMoves);
    }

    operation gameRunnerClassicalOptimal (row : Int, col : Int) : (Int[], Int[]) {
        return (AliceStrategyOptimalClassical(row), BobStrategyOptimalClassical(col));
    }

}
