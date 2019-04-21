// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MagicSquareGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;


    //////////////////////////////////////////////////////////////////
    // Part I. Classical Magic Square
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Validate Alice and Bob's moves
    function ValidAliceMove_Reference (cells : Int[]) : Bool {
        return ForAll(IsPlusOrMinusOne, cells) and Fold(CountMinusSignsFolder, 0, cells) % 2 == 0;
    }

    function ValidBobMove_Reference (cells : Int[]) : Bool {
        return ForAll(IsPlusOrMinusOne, cells) and Fold(CountMinusSignsFolder, 0, cells) % 2 == 1;
    }

    function IsPlusOrMinusOne (input : Int) : Bool {
        return input == 1 or input == -1;
    }

    function CountMinusSignsFolder (count : Int, input : Int) : Int {
        return input < 0 ? count + 1 | count;
    }


    // Task 1.2. Win condition
    function WinCondition_Reference (alice : Int[], row : Int, bob : Int[], column : Int) : Bool {
        return ValidAliceMove_Reference(alice) and ValidBobMove_Reference(bob) and alice[column] == bob[row];
    }


    // Task 1.3. Alice and Bob's classical strategy
    // Alice and Bob decide on a magic square to use before the game starts, and will always place
    // the same sign in a given row and column. However, it's not possible to make a magic square
    // that is self-consistent while still following the rules of the game. Alice and Bob will
    // always have different signs in at least one cell, so they can only win at most 8/9 of the
    // time.
    //
    // Here we use only one possible magic square; other squares that yield the same win rate are
    // also possible.
    function AliceClassical_Reference (row : Int) : Int[] {
        let rows = [[1, 1, 1],
                    [1, -1, -1],
                    [-1, 1, -1]];
        return rows[row];
    }

    function BobClassical_Reference (column : Int) : Int[] {
        let columns = [[1, 1, -1],
                       [1, -1, 1],
                       [1, -1, 1]];
        return columns[column];
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum Magic Square
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Entangled state
    operation CreateEntangledState_Reference (qs : Qubit[]) : Unit {
        body (...) {
            // The desired state is equivalent to two Bell pairs split between Alice and Bob.
            for (i in 0..Length(qs) / 2 - 1) {
                H(qs[i]);
                CNOT(qs[i], qs[i + 2]);
            }
        }
        adjoint auto;
    }


    // Task 2.2. Magic square observables
    function MagicSquareObservable_Reference (row : Int, column : Int) : (Qubit[] => Unit : Adjoint, Controlled) {
        return MagicSquareObservableImpl_Reference(row, column, _);
    }

    operation MagicSquareObservableImpl_Reference (row : Int, column : Int, qs : Qubit[]) : Unit {
        body (...) {
            if (row == 0 and column == 0) {
                ApplyToEachCA(X, qs);
            } elif (row == 0 and column == 1) {
                X(qs[0]);
            } elif (row == 0 and column == 2) {
                X(qs[1]);
            } elif (row == 1 and column == 0) {
                ApplyToEachCA(Y, qs);
            } elif (row == 1 and column == 1) {
                MinusX(qs[0]);
                Z(qs[1]);
            } elif (row == 1 and column == 2) {
                Z(qs[0]);
                MinusX(qs[1]);
            } elif (row == 2 and column == 0) {
                ApplyToEachCA(Z, qs);
            } elif (row == 2 and column == 1) {
                Z(qs[1]);
            } elif (row == 2 and column == 2) {
                Z(qs[0]);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation MinusX(q : Qubit) : Unit {
        body (...) {
            Z(q);
            X(q);
            Z(q);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }


    // Task 2.3. Measure an operator
    operation MeasureOperator_Reference (op : (Qubit[] => Unit : Controlled), target : Qubit[]) : Result {
        mutable result = Zero;
        using (q = Qubit()) {
            H(q);
            Controlled op([q], target);
            H(q);
            set result = M(q);
            Reset(q);
        }
        return result;
    }


    operation PlayAsAlice_Reference(row : Int, q0 : Qubit, q1 : Qubit) : Int[] {
        mutable cells = new Int[3];
        for (column in 0..2) {
            let result = MeasureOperator_Reference(MagicSquareObservable_Reference(row, column), [q0, q1]);
            set cells[column] = IsResultZero(result) ? 1 | -1;
        }
        return cells;
    }

    operation PlayAsBob_Reference(column : Int, q0 : Qubit, q1 : Qubit) : Int[] {
        mutable cells = new Int[3];
        for (row in 0..2) {
            let result = MeasureOperator_Reference(MagicSquareObservable_Reference(row, column), [q0, q1]);
            set cells[row] = IsResultZero(result) ? 1 | -1;
        }
        return cells;
    }

}
