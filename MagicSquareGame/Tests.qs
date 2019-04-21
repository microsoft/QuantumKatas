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
                if (not verify(row, col, aliceMoves, bobMoves, true)) {
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

    // Tests that alice and bob obey their placement rules always.
    operation ClassicalSuboptimalPlacement_Test() : Unit {
        let runs = 1000;
        for (i in 0..runs) {
            let row = RandomInt(3);
            let col = RandomInt(3);
            let (aMoves, bMoves) = gameRunnerClassicalSuboptimal(row, col);

            assertPlacement(aMoves, bMoves);
        }
    }

    operation ClassicalOptimalPlacement_Test() : Unit {
        let runs = 1000;
        for (i in 0..runs) {
            let row = RandomInt(3);
            let col = RandomInt(3);
            let (aMoves, bMoves) = gameRunnerClassicalOptimal(row, col);

            assertPlacement(aMoves, bMoves);
        }
    }

    operation ClassicalSuboptimalWinRate_Test() : Unit {
        mutable wins = 0;
        mutable runs = 5000;
        for (i in 0..runs) {
            let row = RandomInt(3);
            let col = RandomInt(3);
            let (aMoves, bMoves) = gameRunnerClassicalSuboptimal(row, col);
            if (verify(row, col, aMoves, bMoves, false)) {
                set wins = wins + 1;
            }
        }

        let rate = ToDouble(wins) / ToDouble(runs);
        Message($"Classical nonoptimal win rate was: {rate}");
        AssertAlmostEqualTol(rate, 0.66666, 0.05);
    }

    operation ClassicalOptimalWinRate_Test() : Unit {
        mutable wins = 0;
        mutable runs = 5000;
        for (i in 0..runs) {
            let row = RandomInt(3);
            let col = RandomInt(3);
            let (aMoves, bMoves) = gameRunnerClassicalOptimal(row, col);
            if (verify(row, col, aMoves, bMoves, false)) {
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
            let victorious = verify(row, col, aliceMoves, bobMoves, true);
            ResetAll(qs);
        }
        return (aliceMoves, bobMoves);
    }

    operation gameRunnerClassicalOptimal (row : Int, col : Int) : (Int[], Int[]) {
        return (AliceStrategyOptimalClassical(row), BobStrategyOptimalClassical(col));
    }

    operation gameRunnerClassicalSuboptimal (row : Int, col : Int) : (Int[], Int[]) {
        return (AliceStrategyClassical(row), BobStrategyClassical(col));
    }

    function verify(row : Int, col : Int, aliceMoves : Int[], bobMoves : Int[], print : Bool) : Bool {
        
        mutable aliceMinuses = 0;
        // check alice has even number of minuses
        for (i in 0..2) {
            if (aliceMoves[i] == -1) {
                set aliceMinuses = aliceMinuses + 1;
            }
        }
        if (aliceMinuses % 2 != 0) {
            if (print) {
                Message("Alice violated number of minuses placed.");
                Message($"Alice's row: {row}");
                Message($"Alice's moves: {aliceMoves}");
                Message($"Bob's col: {col}");
                Message($"Bob's moves: {bobMoves}");
            }
            return false;
        }

        mutable bobMinuses = 0;
        // check bob has odd number minuses
        for (i in 0..2) {
            if (bobMoves[i] == -1) {
                set bobMinuses = bobMinuses + 1;
            }
        }
        if (bobMinuses % 2 == 0) {
            if (print) {
                Message("Bob violated number of minuses placed.");
                Message($"Alice's row: {row}");
                Message($"Alice's moves: {aliceMoves}");
                Message($"Bob's col: {col}");
                Message($"Bob's moves: {bobMoves}");
            }
            return false;
        }

        // check that alice's bth result and bob's ath result are equal
        if (aliceMoves[col] != bobMoves[row]) {
            if (print) {
                Message("Shared tile was not equal.");
                Message($"Alice's row: {row}");
                Message($"Alice's moves: {aliceMoves}");
                Message($"Bob's col: {col}");
                Message($"Bob's moves: {bobMoves}");
            }
            return false;
        }

        return true;
    }

    operation assertPlacement(aMoves : Int[], bMoves : Int[]) : Unit {
        mutable aliceMinuses = 0;
        // check alice has even number of minuses
        for (j in 0..2) {
            if (aMoves[j] == -1) {
                set aliceMinuses = aliceMinuses + 1;
            }
        }
        if (aliceMinuses % 2 != 0) {
            fail "Alice did not place an even number of -1 elements.";
        }

        mutable bobMinuses = 0;
        // check alice has even number of minuses
        for (j in 0..2) {
            if (bMoves[j] == -1) {
                set bobMinuses = bobMinuses + 1;
            }
        }
        if (bobMinuses % 2 != 1) {
            fail "Bob did not place an odd number of -1 elements.";
        }
    }

}
