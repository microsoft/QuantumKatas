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
        Fact(not WinCondition(0, 0, aliceOutOfRange, bobInRange),
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
    function Pairs<'T> (array : 'T[]) : ('T, 'T)[] {
        let N = Length(array);
        let length = N * (N - 1) / 2;
        mutable pairs = new ('T, 'T)[length];
        mutable i = 0;
        for (j in 0..N - 1) {
            for (k in j + 1..N - 1) {
                set pairs w/= i <- (array[j], array[k]);
                set i += 1;
            }
        }
        return pairs;
    }

    operation ControlledWrapper (op : (Qubit[] => Unit is Adj+Ctl), qs : Qubit[]) : Unit is Adj+Ctl {
        Controlled op([Head(qs)], Rest(qs));
    }

    operation AssertOperationsEqualWithPhase (N : Int, op1 : (Qubit[] => Unit is Adj+Ctl), op2 : (Qubit[] => Unit is Adj+Ctl)) : Unit {
        // To check that the operations don't introduce a phase, compare their controlled versions
        AssertOperationsEqualReferenced(N + 1, ControlledWrapper(op1, _), ControlledWrapper(op2, _));
    }

    // Helper function to checks that each pair of operations in the array commutes (i.e., AB = BA)
    operation AssertOperationsMutuallyCommute (operations : (Qubit[] => Unit is Adj+Ctl)[]) : Unit {
        for ((a, b) in Pairs(operations)) {
            AssertOperationsEqualWithPhase(2, BoundCA([a, b]), BoundCA([b, a]));
        }
    }

    operation MinusI (qs : Qubit[]) : Unit is Adj+Ctl {
        Z(qs[0]);
        X(qs[0]);
        Z(qs[0]);
        X(qs[0]);
        // An alternative approach is to use R(PauliI, 2 * PI(), _)
    }

    function ApplyObservablesImpl (row : Int, column : Int) : (Qubit[] => Unit is Adj+Ctl) {
        return ApplyMagicObservables_Reference(GetMagicObservables(row, column), _);
    }

    operation T22_GetMagicObservables_Test () : Unit {
        // Since there can be multiple magic squares with different observables, 
        // the test checks the listed properties of the return values rather than the values themselves.
        for (row in 0..2) {
            let observables = Mapped(ApplyObservablesImpl(row, _), RangeAsIntArray(0..2));
            // The product of observables in each row should be I.
            AssertOperationsEqualWithPhase(2, BoundCA(observables), ApplyToEachCA(I, _));
            AssertOperationsMutuallyCommute(observables);
        }
        for (column in 0..2) {
            let observables = Mapped(ApplyObservablesImpl(_, column), RangeAsIntArray(0..2));
            // The product of observables in each column should be -I.
            AssertOperationsEqualWithPhase(2, BoundCA(observables), MinusI);
            AssertOperationsMutuallyCommute(observables);
        }
    }


    // ------------------------------------------------------
    operation T23_ApplyMagicObservables_Test () : Unit {
        // Try all pairs of observables and all signs, and check the unitary equality
        for (sign in [-1, 1]) {
            for (obs1 in [PauliI, PauliX, PauliY, PauliZ]) {
                for (obs2 in [PauliI, PauliX, PauliY, PauliZ]) {
                    let obs = (sign, [obs1, obs2]);
                    AssertOperationsEqualWithPhase(2, ApplyMagicObservables(obs, _), ApplyMagicObservables_Reference(obs, _));
                }
            }
        }
    }


    // ------------------------------------------------------
    operation T24_MeasureObservables_Test () : Unit {
        using (qs = Qubit[2]) {
            for (sign in [-1, 1]) {
                for (obs1 in [PauliI, PauliX, PauliY, PauliZ]) {
                for (obs2 in [PauliI, PauliX, PauliY, PauliZ]) {
                    for (i in 1..100) {
                        // Start by preparing the qubits in a uniform superposition with some signs
                        if ((i % 4) / 2 == 1) {
                            X(qs[0]);
                        }
                        if ((i % 4) % 2 == 1) {
                            X(qs[1]);
                        }
                        ApplyToEach(H, qs);
                        // Use the reference implementation of observable measurement to project the register into an eigenstate of the operator
                        let observable = (sign, [obs1, obs2]);
                        let result = MeasureObservable_Reference(observable, qs);

                        // Make sure the task implementation gets the same result. 
                        // If the implementation is wrong, it could pass accidentally,
                        // but with multiple operators and multiple attempts on each this should fail at some point.
                        Fact(MeasureObservable(observable, qs) == result,
                             $"Observable measurement result differs from the reference result for observable {observable}");
                        ResetAll(qs);
                    }
                }
                }
            }
        }
    }


    // ------------------------------------------------------
    operation T25_MeasureOperator_Test () : Unit {
        using (qs = Qubit[2]) {
            for (sign in [-1, 1]) {
                for (obs1 in [PauliI, PauliX, PauliY, PauliZ]) {
                for (obs2 in [PauliI, PauliX, PauliY, PauliZ]) {
                    for (i in 1..100) {
                        // Start by preparing the qubits in a uniform superposition with some signs
                        if ((i % 4) / 2 == 1) {
                            X(qs[0]);
                        }
                        if ((i % 4) % 2 == 1) {
                            X(qs[1]);
                        }
                        ApplyToEach(H, qs);
                        // Use the reference implementation of operator measurement to project the register into an eigenstate of the operator
                        let observable = (sign, [obs1, obs2]);
                        let op = ApplyMagicObservables_Reference(observable, _);
                        let result = MeasureOperator_Reference(op, qs);

                        // Make sure the task implementation gets the same result. 
                        // If the implementation is wrong, it could pass accidentally,
                        // but with multiple operators and multiple attempts on each this should fail at some point.
                        Fact(MeasureOperator(op, qs) == result,
                             $"Operator measurement result differs from the reference result for observable {observable}");
                        ResetAll(qs);
                    }
                }
                }
            }
        }
    }


    // ------------------------------------------------------
    operation QuantumRunner (referee : (((Qubit[] => Int[]), (Qubit[] => Int[])) => (Int[], Int[])),
                             rowIndex : Int,
                             columnIndex : Int) : (Int[], Int[]) {
        return referee(AliceQuantum(rowIndex, _), BobQuantum(columnIndex, _));
    }

    operation T26_QuantumStrategy_Test () : Unit {
        let N = 1000;
        let wins = RunTrials(N, QuantumRunner(PlayQuantumMagicSquare_Reference, _, _));
        Fact(wins == N, $"Alice and Bob's quantum strategy is not optimal: win rate {IntAsDouble(wins) / IntAsDouble(N)}");
    }


    // ------------------------------------------------------
    operation T27_PlayQuantumMagicSquare_Test () : Unit {
        let N = 1000;
        let wins = RunTrials(N, QuantumRunner(PlayQuantumMagicSquare, _, _));
        Message($"Win rate {IntAsDouble(wins) / IntAsDouble(N)}");
        Fact(wins == N, $"Alice and Bob's quantum strategy is not optimal: win rate {IntAsDouble(wins) / IntAsDouble(N)}");
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
