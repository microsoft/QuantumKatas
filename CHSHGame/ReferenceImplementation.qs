// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.CHSHGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Primitive;


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


    // Task 2. Measure Alice's qubit
    operation MeasureAliceQubit_Reference (bit : Bool, qubit : Qubit) : Result {
        if (bit) {
            // Measure in sign basis if bit is 1
            return Measure([PauliX], [qubit]);
        } else {
            // Measure in computational basis if bit is 0
            return Measure([PauliZ], [qubit]);
        }
    }


    // Task 3. Rotate Bob's qubit
    operation RotateBobQubit_Reference (clockwise : Bool, qubit : Qubit) : Unit {
        if (clockwise) {
            Ry(-2.0 * PI() / 8.0, qubit);
        } else {
            Ry(2.0 * PI() / 8.0, qubit);
        }
    }


    // Task 4. Measure Bob's qubit
    operation MeasureBobQubit_Reference (bit : Bool, qubit : Qubit) : Result {
        RotateBobQubit_Reference(not bit, qubit);
        return M(qubit);
    }


    // Task 5. Play the CHSH game
    operation PlayQuantumStrategy_Reference (aliceBit : Bool,
                                             bobBit : Bool,
                                             aliceMeasuresFirst : Bool) : Bool {
        mutable aliceResult = Zero;
        mutable bobResult = Zero;

        using ((aliceQubit, bobQubit) = (Qubit(), Qubit())) {
            CreateEntangledPair_Reference([aliceQubit, bobQubit]);

            if (aliceMeasuresFirst) {
                set aliceResult = MeasureAliceQubit_Reference(aliceBit, aliceQubit);
                set bobResult = MeasureBobQubit_Reference(bobBit, bobQubit);
            } else {
                set bobResult = MeasureBobQubit_Reference(bobBit, bobQubit);
                set aliceResult = MeasureAliceQubit_Reference(aliceBit, aliceQubit);
            }

            Reset(aliceQubit);
            Reset(bobQubit);
        }

        return BoolFromResult(aliceResult) != BoolFromResult(bobResult);
    }

}
