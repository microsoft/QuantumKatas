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


    // ------------------------------------------------------
    operation RunTrials (n : Int, moves : ((Int, Int) => (Int[], Int[]))) : Int {
        mutable wins = 0;
        for (i in 1..n) {
            let row = RandomInt(3);
            let column = RandomInt(3);
            let (alice, bob) = moves(row, column);
            if (WinCondition_Reference(alice, row, bob, column)) {
                set wins = wins + 1;
            }
        }
        return wins;
    }

    operation ClassicalRunner (row : Int, column : Int) : (Int[], Int[]) {
        return (AliceClassical(row), BobClassical(column));
    }

    operation T13_ClassicalStrategy_Test() : Unit {
        let wins = RunTrials(1000, ClassicalRunner);
        Message($"Win rate {ToDouble(wins) / 1000.}");
        AssertBoolEqual(wins >= 850, true,
                        "Alice and Bob's classical strategy is not optimal");
    }


    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => Unit),
                                      refImpl : (Qubit[] => Unit : Adjoint)) : Unit {
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
    operation ProductCA (operators : (Qubit[] => Unit : Adjoint, Controlled)[], qs : Qubit[]) : Unit {
        body (...) {
            for (op in operators) {
                op(qs);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation MinusI (q : Qubit) : Unit {
        body (...) {
            Z(q);
            X(q);
            Z(q);
            X(q);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    function Pairs<'T> (array : 'T[]) : ('T, 'T)[] {
        let length = Factorial(Length(array)) / (2 * Factorial(Length(array) - 2));
        mutable pairs = new ('T, 'T)[length];
        mutable i = 0;
        for (j in 0..Length(array) - 1) {
            for (k in j + 1..Length(array) - 1) {
                set pairs[i] = (array[j], array[k]);
                set i = i + 1;
            }
        }
        return pairs;
    }

    function Factorial (n : Int) : Int {
        if (n < 1) {
            return 1;
        } else {
            return n * Factorial(n - 1);
        }
    }

    operation AssertOperationsMutuallyCommute (operations : (Qubit[] => Unit : Adjoint, Controlled)[]) : Unit {
        for ((a, b) in Pairs(operations)) {
            AssertOperationsEqualReferenced(ProductCA([a, b], _), ProductCA([b, a], _), 2);
        }
    }

    operation T22_MagicSquareObservable_Test () : Unit {
        for (row in 0..2) {
            let observables = Map(MagicSquareObservable(row, _), IntArrayFromRange(0..2));
            AssertOperationsEqualReferenced(ProductCA(observables, _), ApplyToEachA(I, _), 2);
            AssertOperationsMutuallyCommute(observables);
        }
        for (column in 0..2) {
            let observables = Map(MagicSquareObservable(_, column), IntArrayFromRange(0..2));
            // TODO: This can't actually tell the difference between I and -I?
            AssertOperationsEqualReferenced(ProductCA(observables, _), ApplyToEachA(MinusI, _), 2);
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
        Message($"Win rate {ToDouble(wins) / 1000.}");
        AssertBoolEqual(wins == 1000, true,
                        "Alice and Bob's quantum strategy is not optimal");
    }


    // ------------------------------------------------------
    operation T24_PlayQuantumMagicSquare_Test () : Unit {
        let wins = RunTrials(1000, QuantumRunner(PlayQuantumMagicSquare, _, _));
        Message($"Win rate {ToDouble(wins) / 1000.}");
        AssertBoolEqual(wins == 1000, true,
                        "Alice and Bob's quantum strategy is not optimal");
    }


    // ------------------------------------------------------
    function DrawMagicSquare (alice : Int[], row : Int, bob : Int[], column : Int) : Unit {
        for (i in 0..2) {
            mutable line = new String[3];
            for (j in 0..2) {
                if (i == row and j == column and alice[j] != bob[i]) {
                    set line[j] = "±";
                } elif (i == row) {
                    set line[j] = alice[j] == 1 ? "+" | (alice[j] == -1 ? "-" | "?");
                } elif (j == column) {
                    set line[j] = bob[i] == 1 ? "+" | (bob[i] == -1 ? "-" | "?");
                } else {
                    set line[j] = " ";
                }
            }
            Message("-------");
            Message($"|{line[0]}|{line[1]}|{line[2]}|");
        }
        Message("-------");
    }

}
