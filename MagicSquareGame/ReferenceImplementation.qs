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

    // These first two are not required in the kata; However, it is interesting
    // to compare their performance against other implementations.
    operation AliceStrategyClassicalRandom_Reference(row : Int) : Int[] {
        // Just randomly place in a way which satisfies! Alice must place an even number
        // of minus ones.
        let possible = [[1, 1, 1],
                        [-1, 1, -1],
                        [-1, -1, 1],
                        [1, -1, -1]];
        return possible[RandomInt(4)];
    }

    operation BobStrategyClassicalRandom_Reference(col : Int) : Int[] {
        // Just randomly place in a way which satisfies! Bob must place an odd number
        // of minus ones.
        let possible = [[-1, -1, -1],
                        [1, -1, 1],
                        [1, 1, -1],
                        [-1, 1, 1]];
        return possible[RandomInt(4)];
    }

    // Come up with some classical strategy which wins about
    // 66% of the time. You can assume bob will use BobStrategyClassical,
    // and should implement them together. You must abide by alice's placement rules.
    operation AliceStrategyClassical_Reference(row : Int) : Int[] {
        // With this arrangement, they will lose if column 1 is selected, and win otherwise.
        return [1, 1, 1];
    }

    // Come up with some classical strategy which wins about
    // 66 % of the time. You can assume alice will use AliceStrategyClassical,
    // and should implement them together. You must abide by bob's placement rules.
    operation BobStrategyClassical_Reference(col : Int) : Int[] {
        // With this arrangement, they will lose if column 1 is selected, and win otherwise.
        return [-1, 1, 1];
    }

    // Come up with some classical strategy which wins about
    // 85 % of the time. You can assume bob will use BobStrategyOptimalClassical,
    // and should implement them together. You must abide by alice's placement rules.
    operation AliceStrategyOptimalClassical_Reference(row : Int) : Int[] {
        // this is one of many possible square layouts.
        // The key is that there is only one row, column combination such
        // that alice and bob can't come up with an answer.
        // Here, row 3 and column 3 cannot win.
        if (row == 0) {
            return [1, 1, 1];
        } elif (row == 1) {
            return [1, -1, -1];
        } else {
            return [-1, 1, -1];
        }
    }

    // Come up with some classical strategy which wins about
    // 85% of the time. You can assume alice will use AliceStrategyOptimalClassical,
    // and should implement them together. You must abide by bob's placement rules.
    operation BobStrategyOptimalClassical_Reference(col : Int) : Int[] {
        // See Alice's strategy for explanation.
        if (col == 0) {
            return [1, 1, -1];
        } elif (col == 1) {
            return [1, -1, 1];
        } else {
            return [1, -1, 1];
        }
    }

    // Task 1. Entangled pair
    operation CreateEntangledPair_Reference (qs : Qubit[]) : Unit {
        body (...) {
            // The easiest way to create an entangled pair is to start with
            // applying a Hadamard transformation to one of the qubits:
            H(qs[0]);

            // This has left us in state:
            // ((|0⟩ + |1⟩) / sqrt(2)) ⊗ |0⟩

            // Now, if we flip the second qubit conditioned on the state
            // of the first one, we get that the states of the two qubits will always match.
            CNOT(qs[0], qs[1]);
            // So we ended up in the state:
            // (|00⟩ + |11⟩) / sqrt(2)
            //
            // Which is the required Bell pair |Φ⁺⟩
        }

        adjoint invert;
    }


    // Task 2. Two entangled pairs shared between Alice and Bob
    operation CreateAliceAndBobQubits_Reference (aliceQubits : Qubit[], bobQubits : Qubit[])
            : Unit {
        // This is simply creating two pairs of entanglements.
        CreateEntangledPair_Reference([aliceQubits[0], bobQubits[0]]);
        CreateEntangledPair_Reference([aliceQubits[1], bobQubits[1]]);
    }

    // Task 3. Create the observable corresponding to a specific square
    operation CreateSquareObservable_Reference (row : Int, column : Int) : (Qubit[] => Unit : Controlled) {
        return SquareObservable_Reference(row, column, _);
    }

    operation CreateSquareObservable_Reference_Wrong (row : Int, column : Int) : (Qubit[] => Unit : Controlled) {
        return SquareObservable_Reference_Wrong_2(row, column, _);
    }

    operation MeasureObservable_Reference(  q0 : Qubit, 
                                            q1 : Qubit, 
                                            Observable : (Qubit[] => Unit : Controlled)) : Int {
        // Alternatively, one could use the MeasureWithScratch library
        // operation. This would require you to only use Pauli type gates,
        // which would require some adaptation to be able to use something
        // similar to MinusX.
        mutable result = -99;
        using (ancilla = Qubit()) {
            H(ancilla);
            Controlled Observable([ancilla], [q0, q1]);
            H(ancilla);
            let aliceState = M(ancilla);
            if (aliceState == One) {
                set result = -1;
            } else {
                set result = 1;
            }
            Reset(ancilla);
        }
        return result;
    }

    operation SquareObservable_Reference (row : Int, column : Int, qubits : Qubit[]) : Unit {
        body (...) {
            if (row == 0 && column == 0) {
                ApplyToEachCA(X, qubits);
            } elif (row == 0 && column == 1) {
                X(qubits[0]);
                // I
            } elif (row == 0 && column == 2) {
                // I
                X(qubits[1]);
            } elif (row == 1 && column == 0) {
                ApplyToEachCA(Y, qubits);
            } elif (row == 1 && column == 1) {
                MinusX(qubits[0]);
                Z(qubits[1]);
            } elif (row == 1 && column == 2) {
                Z(qubits[0]);
                MinusX(qubits[1]);
            } elif (row == 2 && column == 0) {
                ApplyToEachCA(Z, qubits);
            } elif (row == 2 && column == 1) {
                // I
                Z(qubits[1]);
            } elif (row == 2 && column == 2) {
                Z(qubits[0]);
                // I
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation PlayAsAlice_Reference(row : Int, q0 : Qubit, q1 : Qubit) : Int[] {
        mutable result = new Int[3];

        for (i in 0..2) {
            set result[i] = MeasureObservable_Reference(q0, q1, SquareObservable_Reference(row, i, _));
        }

        return result;
    }

    operation PlayAsBob_Reference(col : Int, q0 : Qubit, q1 : Qubit) : Int[] {
        mutable result = new Int[3];

        for (i in 0..2) {
            set result[i] = MeasureObservable_Reference(q0, q1, CreateSquareObservable_Reference(i, col));
        }

        return result;
    }

    operation PlayAsAlice_Reference_Wrong(row : Int, q0 : Qubit, q1 : Qubit) : Int[] {
        mutable result = new Int[3];

        for (i in 0..2) {
            set result[i] = MeasureObservable_Reference(q0, q1, CreateSquareObservable_Reference_Wrong(row, i));
        }

        return result;
    }

    operation PlayAsBob_Reference_Wrong(col : Int, q0 : Qubit, q1 : Qubit) : Int[] {
        mutable result = new Int[3];

        for (i in 0..2) {
            set result[i] = MeasureObservable_Reference(q0, q1, CreateSquareObservable_Reference_Wrong(i, col));
        }

        return result;
    }


    /// Helpers

    operation MinusX(q : Qubit) : Unit {
        body(...) {
            X(q);
            Z(q);
            X(q);
            Z(q);
            X(q);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // WRONG implementation
    operation SquareObservable_Reference_Wrong_1 (row : Int, column : Int, qubits : Qubit[]) : Unit {
        body (...) {
            if (row == 0 && column == 0) {
                Z(qubits[1]);
            } elif (row == 0 && column == 1) {
                Z(qubits[0]);
            } elif (row == 0 && column == 2) {
                ApplyToEachC(Z, qubits);
            } elif (row == 1 && column == 0) {
                X(qubits[0]);
            } elif (row == 1 && column == 1) {
                X(qubits[1]);
            } elif (row == 1 && column == 2) {
                ApplyToEachC(X, qubits);
            } elif (row == 2 && column == 0) {
                X(qubits[0]);
                Z(qubits[1]);
            } elif (row == 2 && column == 1) {
                Z(qubits[0]);
                X(qubits[1]);
            } elif (row == 2 && column == 2) {
                ApplyToEachC(Y, qubits);
            }
        }
        controlled auto;
    }

    operation SquareObservable_Reference_Wrong_2 (row : Int, column : Int, qubits : Qubit[]) : Unit {
        body (...) {
            if (row == 0 && column == 0) {
                ApplyToEachCA(X, qubits);
            } elif (row == 0 && column == 1) {
                X(qubits[0]);
                // I
            } elif (row == 0 && column == 2) {
                // I
                X(qubits[1]);
            } elif (row == 1 && column == 0) {
                ApplyToEachCA(Y, qubits);
            } elif (row == 1 && column == 1) {
                X(qubits[0]);
                Z(qubits[1]);
            } elif (row == 1 && column == 2) {
                Z(qubits[0]);
                X(qubits[1]);
            } elif (row == 2 && column == 0) {
                ApplyToEachCA(Z, qubits);
            } elif (row == 2 && column == 1) {
                // I
                Z(qubits[1]);
            } elif (row == 2 && column == 2) {
                Z(qubits[0]);
                // I
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}
