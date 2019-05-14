// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MagicSquareGame {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;


    function SignFromBool (input : Bool) : Int {
        return input ? 1 | -1;
    }

    operation T11_ValidMove_Test () : Unit {
        // Try all moves with +1 and -1.
        for (i in 0..1 <<< 3 - 1) {
            let cells = Mapped(SignFromBool, IntAsBoolArray(i, 3));
            Fact(ValidAliceMove(cells) == ValidAliceMove_Reference(cells),
                 $"Incorrect Alice move validity for {cells}");
            Fact(ValidBobMove(cells) == ValidBobMove_Reference(cells),
                 $"Incorrect Bob move validity for {cells}");
        }

        // Moves with numbers other than +1 and -1 should be rejected.
        for (cellsOutOfRange in [[1, -2, 10], [-3, 0, -2], [-1, 2, 1], [2, 3, 4]]) {
            Fact(ValidAliceMove(cellsOutOfRange) == false,
                 $"Invalid Alice move judged valid for {cellsOutOfRange}");
            Fact(ValidBobMove(cellsOutOfRange) == false,
                 $"Invalid Bob move judged valid for {cellsOutOfRange}");
        }
    }


    // ------------------------------------------------------
    operation T12_WinCondition_Test () : Unit {
        // Try all moves with +1 and -1.
        for (i in 0..1 <<< 3 - 1) {
            for (j in 0..1 <<< 3 - 1) {
                for (rowIndex in 0..2) {
                    for (columnIndex in 0..2) {
                        let row = Mapped(SignFromBool, IntAsBoolArray(i, 3));
                        let column = Mapped(SignFromBool, IntAsBoolArray(j, 3));

                        Fact(
                            WinCondition(rowIndex, columnIndex, row, column) ==
                            WinCondition_Reference(rowIndex, columnIndex, row, column),
                            $"Incorrect win condition for rowIndex={rowIndex}, columnIndex={columnIndex}, " +
                            $" row={row}, column={column}");
                    }
                }
            }
        }

        // Moves with numbers other than +1 and -1 should be rejected.
        let aliceOutOfRange = [-1, -1, 7];
        let bobInRange = [-1, 1, 1];
        AssertBoolEqual(
            WinCondition(0, 0, aliceOutOfRange, bobInRange),
            false,
            $"Win condition is wrong for Alice={aliceOutOfRange}, row=0, Bob={bobInRange}, column=0");
    }


    // ------------------------------------------------------
    operation RunTrials (n : Int, moves : ((Int, Int) => (Int[], Int[]))) : Int {
        mutable wins = 0;
        for (i in 1..n) {
            let rowIndex = RandomInt(3);
            let columnIndex = RandomInt(3);
            let (alice, bob) = moves(rowIndex, columnIndex);
            if (WinCondition_Reference(rowIndex, columnIndex, alice, bob)) {
                set wins += 1;
            }
        }
        return wins;
    }

    operation ClassicalRunner (rowIndex : Int, columnIndex : Int) : (Int[], Int[]) {
        return (AliceClassical(rowIndex), BobClassical(columnIndex));
    }

    operation T13_ClassicalStrategy_Test() : Unit {
        let wins = RunTrials(1000, ClassicalRunner);
        Fact(wins >= 850, $"The classical strategy implemented is not optimal: win rate {IntAsDouble(wins) / 1000.}");
    }


    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => Unit),
                                      refImpl : (Qubit[] => Unit is Adj)) : Unit {
        using (qs = Qubit[N]) {
            // apply operation that needs to be tested
            taskImpl(qs);
            
            // apply adjoint reference operation and check that the result is |0^N⟩
            Adjoint refImpl(qs);
            
            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }

    operation T21_CreateEntangledState_Test () : Unit {
        AssertEqualOnZeroState(4, CreateEntangledState, CreateEntangledState_Reference);
    }


    // ------------------------------------------------------
    operation ProductCA (operators : (Qubit[] => Unit is Adj+Ctl)[], qs : Qubit[]) : Unit is Adj+Ctl {
        for (op in operators) {
            op(qs);
        }
    }

    operation MinusI (q : Qubit) : Unit is Adj+Ctl {
        Z(q);
        X(q);
        Z(q);
        X(q);
    }

    function Pairs<'T> (array : 'T[]) : ('T, 'T)[] {
        let N = Length(array);
        let length = N * (N - 1) / 2;
        mutable pairs = new ('T, 'T)[length];
        mutable i = 0;
        for (j in 0..N - 1) {
            for (k in j + 1..N - 1) {
                set pairs w/= i <- (array[j], array[k]);
                set i = i + 1;
            }
        }
        return pairs;
    }

    operation AssertOperationsMutuallyCommute (operations : (Qubit[] => Unit is Adj+Ctl)[]) : Unit {
        for ((a, b) in Pairs(operations)) {
            AssertOperationsEqualReferenced(2, ProductCA([a, b], _), ProductCA([b, a], _));
        }
    }

    operation T22_MagicSquareObservable_Test () : Unit {
        for (row in 0..2) {
            let observables = Mapped(MagicSquareObservable(row, _), RangeAsIntArray(0..2));
            AssertOperationsEqualReferenced(2, ProductCA(observables, _), ApplyToEachA(I, _));
            AssertOperationsMutuallyCommute(observables);
        }
        for (column in 0..2) {
            let observables = Mapped(MagicSquareObservable(_, column), RangeAsIntArray(0..2));
            // TODO: This can't actually tell the difference between I and -I?
            AssertOperationsEqualReferenced(2, ProductCA(observables, _), ApplyToEachA(MinusI, _));
            AssertOperationsMutuallyCommute(observables);
        }
    }


    // ------------------------------------------------------
    operation T23_MeasureOperator_Test () : Unit {
        using (qs = Qubit[2]) {
            for (row in 0..2) {
                for (column in 0..2) {
                    // Use the reference implementation to project the register into an eigenstate.
                    let op = MagicSquareObservable_Reference(row, column);
                    let result = MeasureOperator_Reference(op, qs);

                    // Make sure the task implementation gets the same result. If the
                    // implementation is wrong, this could be non-deterministic, but hopefully it
                    // will fail on at least one of the nine operators.
                    AssertResultEqual(
                        MeasureOperator(op, qs),
                        result,
                        "Operator measurement result is different than the reference result");
                }
            }
            ResetAll(qs);
        }
    }


    // ------------------------------------------------------
    operation QuantumRunner (referee : (((Qubit[] => Int[]), (Qubit[] => Int[])) => (Int[], Int[])),
                             row : Int,
                             column : Int) : (Int[], Int[]) {
        return referee(AliceQuantum(row, _), BobQuantum(column, _));
    }

    operation T24_QuantumStrategy_Test () : Unit {
        let wins = RunTrials(1000, QuantumRunner(PlayQuantumMagicSquare_Reference, _, _));
        Message($"Win rate {IntAsDouble(wins) / 1000.}");
        AssertBoolEqual(wins == 1000, true,
                        "Alice and Bob's quantum strategy is not optimal");
    }


    // ------------------------------------------------------
    operation T25_PlayQuantumMagicSquare_Test () : Unit {
        let wins = RunTrials(1000, QuantumRunner(PlayQuantumMagicSquare, _, _));
        Message($"Win rate {IntAsDouble(wins) / 1000.}");
        AssertBoolEqual(wins == 1000, true,
                        "Alice and Bob's quantum strategy is not optimal");
    }


    // ------------------------------------------------------
    function DrawMagicSquare (alice : Int[], row : Int, bob : Int[], column : Int) : Unit {
        for (i in 0..2) {
            mutable line = new String[3];
            for (j in 0..2) {
                if (i == row and j == column and alice[j] != bob[i]) {
                    set line w/= j <- "±";
                } elif (i == row) {
                    set line w/= j <- alice[j] == 1 ? "+" | (alice[j] == -1 ? "-" | "?");
                } elif (j == column) {
                    set line w/= j <- bob[i] == 1 ? "+" | (bob[i] == -1 ? "-" | "?");
                } else {
                    set line w/= j <- " ";
                }
            }
            Message("-------");
            Message($"|{line[0]}|{line[1]}|{line[2]}|");
        }
        Message("-------");
    }

}
