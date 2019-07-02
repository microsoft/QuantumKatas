// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GraphColoring {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;


    //////////////////////////////////////////////////////////////////
    // Part I. Colors representation and manipulation
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Initialize register to a color
    operation InitializeColor_Reference (C : Int, register : Qubit[]) : Unit is Adj {
        let N = Length(register);
        // Convert C to an array of bits in little endian format
        let binaryC = IntAsBoolArray(C, N);
        // Value "true" corresponds to bit 1 and requires applying an X gate
        ApplyPauliFromBitString(PauliX, true, binaryC, register);
    }


    // Task 1.2. Read color from a register
    operation MeasureColor_Reference (register : Qubit[]) : Int {
        return ResultArrayAsInt(MultiM(register));
    }


    // Task 1.3. Read coloring from a register
    operation MeasureColoring_Reference (K : Int, register : Qubit[]) : Int[] {
        let N = Length(register) / K;
        let colorPartitions = Partitioned(ConstantArray(K - 1, N), register);
        return ForEach(MeasureColor_Reference, colorPartitions);
    }


    // Task 1.4. 2-bit color equality oracle
    operation ColorEqualityOracle_2bit_Reference (c0 : Qubit[], c1 : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        // Small case solution with no extra qubits allocated:
        // iterate over all bit strings of length 2, and do a controlled X on the target qubit
        // with control qubits c0 and c1 in states described by each of these bit strings.
        // For a better solution, see task 1.4.
        for (color in 0..3) {
            let binaryColor = IntAsBoolArray(color, 2);
            (ControlledOnBitString(binaryColor + binaryColor, X))(c0 + c1, target);
        }
    }


    // Task 1.5. N-bit color equality oracle (no extra qubits)
    operation ColorEqualityOracle_Nbit_Reference (c0 : Qubit[], c1 : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        for ((q0, q1) in Zip(c0, c1)) {
            // compute XOR of q0 and q1 in place (storing it in q1)
            CNOT(q0, q1);
        }
        // if all XORs are 0, the bit strings are equal
        (ControlledOnInt(0, X))(c1, target);
        // uncompute
        for ((q0, q1) in Zip(c0, c1)) {
            CNOT(q0, q1);
        }
    }



    //////////////////////////////////////////////////////////////////
    // Part II. Vertex coloring problem
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Classical verification of vertex coloring
    function IsVertexColoringValid_Reference (V : Int, edges: (Int, Int)[], colors: Int[]) : Bool {
        for ((start, end) in edges) {
            if (colors[start] == colors[end]) {
                return false;
            }
        }
        return true;
    }


    // Task 2.2. Oracle for verifying vertex coloring
    operation VertexColoringOracle_Reference (V : Int, edges : (Int, Int)[], colorsRegister : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        let nEdges = Length(edges);
        using (conflicts = Qubit[nEdges]) {
            for (i in 0 .. nEdges-1) {
                let (start, end) = edges[i];
                // Check that endpoints of the edge have different colors:
                // apply ColorEqualityOracle_Nbit_Reference oracle; if the colors are the same the result will be 1, indicating a conflict
                ColorEqualityOracle_Nbit_Reference(colorsRegister[start * 2 .. start * 2 + 1], 
                                                   colorsRegister[end * 2 .. end * 2 + 1], conflicts[i]);
            }

            // If there are no conflicts (all qubits are in 0 state), the vertex coloring is valid
            (ControlledOnInt(0, X))(conflicts, target);

            for (i in 0 .. nEdges-1) {
                let (start, end) = edges[i];
                // Check that endpoints of the edge have different colors:
                // apply ColorEqualityOracle_Nbit_Reference oracle; if the colors are the same the result will be 1, indicating a conflict
                Adjoint ColorEqualityOracle_Nbit_Reference(colorsRegister[start * 2 .. start * 2 + 1], 
                                                           colorsRegister[end * 2 .. end * 2 + 1], conflicts[i]);
            }
        }
    }


    // Task 2.3. Using Grover's search to find vertex coloring
    operation GroversAlgorithm_Reference (V : Int, oracle : ((Qubit[], Qubit) => Unit is Adj)) : Int[] {
        // This task is similar to task 2.2 from SolveSATWithGrover kata, but the percentage of correct solutions is potentially higher.
        mutable coloring = new Int[V];

        // Note that coloring register has the number of qubits that is twice the number of vertices (2 qubits per vertex).
        using ((register, output) = (Qubit[2 * V], Qubit())) {
            mutable correct = false;
            mutable iter = 1;
            repeat {
                Message($"Trying search with {iter} iterations");
                GroversAlgorithm_Loop(register, oracle, iter);
                let res = MultiM(register);
                // to check whether the result is correct, apply the oracle to the register plus ancilla after measurement
                oracle(register, output);
                if (MResetZ(output) == One) {
                    set correct = true;
                    // Read off coloring
                    set coloring = MeasureColoring_Reference(V, register);
                }
                ResetAll(register);
            } until (correct or iter > 10)  // the fail-safe to avoid going into an infinite loop
            fixup {
                set iter += 1;
            }
            if (not correct) {
                fail "Failed to find a coloring";
            }
        }
        return coloring;
    }

    // Grover loop implementation taken from SolveSATWithGrover kata.
    operation OracleConverterImpl (markingOracle : ((Qubit[], Qubit) => Unit is Adj), register : Qubit[]) : Unit is Adj {

        using (target = Qubit()) {
            // Put the target into the |-⟩ state
            X(target);
            H(target);
                
            // Apply the marking oracle; since the target is in the |-⟩ state,
            // flipping the target if the register satisfies the oracle condition will apply a -1 factor to the state
            markingOracle(register, target);
                
            // Put the target back into |0⟩ so we can return it
            H(target);
            X(target);
        }
    }
    
    operation GroversAlgorithm_Loop (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        let phaseOracle = OracleConverterImpl(oracle, _);
        ApplyToEach(H, register);
            
        for (i in 1 .. iterations) {
            phaseOracle(register);
            ApplyToEach(H, register);
            ApplyToEach(X, register);
            Controlled Z(Most(register), Tail(register));
            ApplyToEach(X, register);
            ApplyToEach(H, register);
        }
    }
}