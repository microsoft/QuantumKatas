// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MagicSquareGame {

    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arrays;


    //////////////////////////////////////////////////////////////////
    // Part I. Classical Magic Square
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Validate Alice and Bob's moves
    function ValidAliceMove_Reference (cells : Int[]) : Bool {
        return All(IsPlusOrMinusOne, cells) and Fold(CountMinusSignsFolder, 0, cells) % 2 == 0;
    }

    function ValidBobMove_Reference (cells : Int[]) : Bool {
        return All(IsPlusOrMinusOne, cells) and Fold(CountMinusSignsFolder, 0, cells) % 2 == 1;
    }

    function IsPlusOrMinusOne (input : Int) : Bool {
        return AbsI(input) == 1;
    }

    function CountMinusSignsFolder (count : Int, input : Int) : Int {
        return input < 0 ? count + 1 | count;
    }


    // Task 1.2. Win condition
    function WinCondition_Reference (rowIndex : Int, columnIndex : Int, row : Int[], column : Int[]) : Bool {
        return ValidAliceMove_Reference(row) and 
               ValidBobMove_Reference(column) and 
               row[columnIndex] == column[rowIndex];
    }


    // Task 1.3. Alice and Bob's classical strategy
    // Alice and Bob decide on a magic square to use before the game starts, and will always place
    // the same sign in a given row and column. However, it's not possible to make a magic square
    // that is self-consistent while still following the rules of the game. Alice and Bob will
    // always have different signs in at least one cell, so they can only win at most 89% of the time.
    //
    // Here we use one possible magic square, described at 
    // https://en.wikipedia.org/wiki/Quantum_pseudo-telepathy#The_Mermin-Peres_magic_square_game;
    // other squares that yield the same win rate are possible.
    function AliceClassical_Reference (rowIndex : Int) : Int[] {
        let rows = [[+1, +1, +1],
                    [+1, -1, -1],
                    [-1, +1, -1]];
        return rows[rowIndex];
    }

    function BobClassical_Reference (columnIndex : Int) : Int[] {
        let columns = [[+1, +1, -1],
                       [+1, -1, +1],
                       [+1, -1, +1]];
        return columns[columnIndex];
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum Magic Square
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Entangled state
    operation CreateEntangledState_Reference (qs : Qubit[]) : Unit is Adj {
        // The desired state is equivalent to two Bell pairs split between Alice and Bob.
        for (i in 0..1) {
            H(qs[i]);
            CNOT(qs[i], qs[i + 2]);
        }
    }


    // Task 2.2. Magic square observables
    // This solution uses magic square described in http://edu.itp.phys.ethz.ch/fs13/atqit/sol01.pdf:
    //    X ⊗ X   |   X ⊗ 1   |   1 ⊗ X
    //    Y ⊗ Y   |  -X ⊗ Z   |  -Z ⊗ X
    //    Z ⊗ Z   |   1 ⊗ Z   |   Z ⊗ 1
    function GetMagicObservables_Reference (row : Int, column : Int) : (Int, Pauli[]) {
        return [[(+1, [PauliX, PauliX]), (+1, [PauliX, PauliI]), (+1, [PauliI, PauliX])],
                [(+1, [PauliY, PauliY]), (-1, [PauliX, PauliZ]), (-1, [PauliZ, PauliX])],
                [(+1, [PauliZ, PauliZ]), (+1, [PauliI, PauliZ]), (+1, [PauliZ, PauliI])]] [row][column];
    }


    // Task 2.3. Apply magic square observables
    operation ApplyMagicObservables_Reference (observable : (Int, Pauli[]), qs : Qubit[]) : Unit is Adj+Ctl {
        let (sign, paulis) = observable;
        ApplyPauli(paulis, qs);
        // remember to apply the sign - this will be important when measuring these observables!
        if (sign < 0) {
            R(PauliI, 2.0 * PI(), qs[0]);
        }
    }


    // Task 2.4. Measure observables using joint measurement
    operation MeasureObservable_Reference (observable : (Int, Pauli[]), target : Qubit[]) : Result {
        let (sign, paulis) = observable;
        // Do a joint measurement of the paulis, convert it to +1/-1 eigenvalue, multiply by sign and convert back to Result
        return (sign * (Measure(paulis, target) == Zero ? +1 | -1)) == +1 ? Zero | One;
    }


    // Task 2.5. Measure an operator
    operation MeasureOperator_Reference (op : (Qubit[] => Unit is Ctl), target : Qubit[]) : Result {
        using (q = Qubit()) {
            H(q);
            Controlled op([q], target);
            H(q);
            return MResetZ(q);
        }
    }


    // Task 2.6. Alice and Bob's quantum strategy
    // Note that Alice uses MeasureObservable, while Bob uses ApplyMagicObservables followed by
    // MeasureOperator. These both give the same result; we only show both to demonstrate that they
    // are equivalent. Alice and Bob can choose to use either method without affecting their
    // strategy.
    operation AliceQuantum_Reference(rowIndex : Int, qs : Qubit[]) : Int[] {
        mutable cells = new Int[3];
        for (column in 0..2) {
            // Alice uses joint measurement to measure the qubits in the observable's Pauli bases.
            let obs = GetMagicObservables_Reference(rowIndex, column);
            let result = MeasureObservable_Reference(obs, qs);
            set cells w/= column <- IsResultZero(result) ? 1 | -1;
        }
        return cells;
    }

    operation BobQuantum_Reference(columnIndex : Int, qs : Qubit[]) : Int[] {
        mutable cells = new Int[3];
        for (row in 0..2) {
            // Bob converts the observable into an operator before measuring it.
            let obs = GetMagicObservables_Reference(row, columnIndex);
            let op = ApplyMagicObservables_Reference(obs, _);
            let result = MeasureOperator_Reference(op, qs);
            set cells w/= row <- IsResultZero(result) ? 1 | -1;
        }
        return cells;
    }


    // Task 2.7. Play the magic square game using the quantum strategy
    operation PlayQuantumMagicSquare_Reference (askAlice : (Qubit[] => Int[]), askBob : (Qubit[] => Int[])) : (Int[], Int[]) {
        mutable alice = new Int[3];
        mutable bob = new Int[3];
        using (qs = Qubit[4]) {
            CreateEntangledState_Reference(qs);
            set alice = askAlice(qs[0..1]);
            set bob = askBob(qs[2..3]);
            ResetAll(qs);
        }
        return (alice, bob);
    }

}
