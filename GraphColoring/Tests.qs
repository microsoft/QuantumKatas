// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GraphColoring {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    

    //////////////////////////////////////////////////////////////////
    // Part I. Colors representation and manipulation
    //////////////////////////////////////////////////////////////////

    operation T11_InitializeColor_Test () : Unit {
        for (N in 1 .. 4) {
            using (register = Qubit[N]) {
                for (C in 0 .. (1 <<< N) - 1) {
                    InitializeColor(C, register);
                    let measurementResults = MultiM(register);
                    Fact(ResultArrayAsInt(measurementResults) == C, 
                        $"Unexpected initialization result for N = {N}, C = {C} : {measurementResults}");
                    ResetAll(register);
                }
            }
        }
    }


    // ------------------------------------------------------
    operation T12_MeasureColor_Test () : Unit {
        for (N in 1 .. 4) {
            using (register = Qubit[N]) {
                for (C in 0 .. (1 <<< N) - 1) {
                    // prepare the register in the input state
                    InitializeColor_Reference(C, register);

                    // call the solution and verify its return value
                    let result = MeasureColor(register);
                    Fact(result == C, $"Unexpected measurement result for N = {N}, C = {C} : {result}");

                    // verify that the register remained in the same state
                    Adjoint InitializeColor_Reference(C, register);
                    AssertAllZero(register);
                }
            }
        }
    }


    // ------------------------------------------------------
    operation T13_MeasureColoring_Test () : Unit {
        for (K in 1 .. 3) {
        for (N in 1 .. 3) {
            using (register = Qubit[N * K]) {
                for (state in 0 .. (1 <<< (N * K)) - 1) {
                    // prepare the register in the input state
                    let binaryState = IntAsBoolArray(state, N * K);
                    ApplyPauliFromBitString(PauliX, true, binaryState, register);

                    // call the solution
                    let result = MeasureColoring(K, register);

                    // get the expected coloring by splitting binaryState into parts and converting them into integers
                    let partitions = Partitioned(ConstantArray(K - 1, N), binaryState);
                    let expectedColors = ForEach(FunctionAsOperation(BoolArrayAsInt), partitions);

                    // verify the return value
                    Fact(Length(result) == K, $"Unexpected number of colors for N = {N}, K = {K} : {Length(result)}");
                    for ((expected, actual) in Zip(expectedColors, result)) {
                        Fact(expected == actual, $"Unexpected color for N = {N}, K = {K} : expected {expectedColors}, got {result}");
                    }

                    // verify that the register remained in the same state
                    ApplyPauliFromBitString(PauliX, true, binaryState, register);
                    AssertAllZero(register);
                }
            }
        }
        }
    }


    // ------------------------------------------------------
    operation CheckColorEqualityOracle (N : Int, oracle : ((Qubit[], Qubit[], Qubit) => Unit)) : Unit {
        using ((register0, register1, target) = (Qubit[N], Qubit[N], Qubit())) {
            for (state in 0 .. (1 <<< (2 * N)) - 1) {
                // prepare the register in the input state
                InitializeColor_Reference(state, register0 + register1);

                // apply the oracle
                oracle(register0, register1, target);

                // check that the result is what we'd expect
                let expectedEquality = (state >>> N) == (state % (1 <<< N));
                AssertQubit(expectedEquality ? One | Zero, target);
                Reset(target);

                // verify that the input registers remained in the same state
                Adjoint InitializeColor_Reference(state, register0 + register1);
                AssertAllZero(register0);
                AssertAllZero(register1);
            }
        }
    }


    // helper wrapper to represent oracle operation on two input registers of equal size and output register of size 1
    // as an operation on an array of qubits
    operation WrapperOperation (op : ((Qubit[], Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {        
        let N = (Length(qs) - 1) / 2;
        op(qs[0..N-1], qs[N..2*N-1], qs[2*N]);
    }


    operation T14_ColorEqualityOracle_2bit_Test () : Unit {
        CheckColorEqualityOracle(2, ColorEqualityOracle_2bit);
        AssertOperationsEqualReferenced(5, WrapperOperation(ColorEqualityOracle_2bit, _),
                                           WrapperOperation(ColorEqualityOracle_2bit_Reference, _));
    }


    // ------------------------------------------------------
    operation T15_ColorEqualityOracle_Nbit_Test () : Unit {
        for (N in 1..4) {
            CheckColorEqualityOracle(N, ColorEqualityOracle_Nbit);
            AssertOperationsEqualReferenced(2*N+1, WrapperOperation(ColorEqualityOracle_Nbit, _),
                                                   WrapperOperation(ColorEqualityOracle_Nbit_Reference, _));
            // TODO: verify that the oracle doesn't allocate extra qubits
        }
    }



    //////////////////////////////////////////////////////////////////
    // Part II. Vertex coloring problem
    //////////////////////////////////////////////////////////////////

    // Hardcoded graphs used for testing the vertex coloring problem:
    //  - trivial graph with zero edges
    //  - complete graph with 4 vertices (4-colorable)
    //  - disconnected graph
    //  - random connected graph with more edges and vertices (3-colorable)
    //  - regular-ish graph with 5 vertices (3-colorable, as shown at https://en.wikipedia.org/wiki/File:3-coloringEx.svg without one vertex)
    //  - 6-vertex graph from https://en.wikipedia.org/wiki/File:3-coloringEx.svg
    function ExampleGraphs () : (Int, (Int, Int)[])[] {
        return [(3, new (Int, Int)[0]),
                (4, [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]),
                (5, [(4, 0), (2, 1), (3, 1), (3, 2)]),
                (5, [(0, 1), (1, 2), (1, 3), (3, 2), (4, 2), (3, 4)]),
                (5, [(0, 1), (0, 2), (0, 4), (1, 2), (1, 3), (2, 3), (2, 4), (3, 4)]),
                (6, [(0, 1), (0, 2), (0, 4), (0, 5), (1, 2), (1, 3), (1, 5), (2, 3), (2, 4), (3, 4), (3, 5), (4, 5)])];
        // Graphs with 6+ vertices can take several minutes to be processed; 
        // in the interest of keeping test runtime reasonable we're limiting most of the testing to graphs with 5 vertices or fewer.
    }


    operation T21_IsVertexColoringValid_Test () : Unit {
        let testCases = ExampleGraphs();

        let (V0, edges0) = testCases[0];
        Fact(IsVertexColoringValid(V0, edges0, [0, 0, 0]) == true, 
             $"Coloring [0, 0, 0] judged incorrect for graph V = {V0}, edges = {edges0}");
        Fact(IsVertexColoringValid(V0, edges0, [2, 1, 3]) == true, 
             $"Coloring [2, 1, 3] judged incorrect for graph V = {V0}, edges = {edges0}");

        let (V1, edges1) = testCases[1];
        Fact(IsVertexColoringValid(V1, edges1, [0, 2, 1, 3]) == true, 
             $"Coloring [0, 2, 1, 3] judged incorrect for graph V = {V1}, edges = {edges1}");
        Fact(IsVertexColoringValid(V1, edges1, [3, 0, 1, 2]) == true, 
             $"Coloring [3, 0, 1, 2] judged incorrect for graph V = {V1}, edges = {edges1}");
        Fact(IsVertexColoringValid(V1, edges1, [0, 2, 1, 0]) == false, 
             $"Coloring [0, 2, 1, 0] judged correct for graph V = {V1}, edges = {edges1}");

        let (V2, edges2) = testCases[2];
        // note that in this task the coloring does not have to be limited to numbers 0 .. 3, like in the next task
        Fact(IsVertexColoringValid(V2, edges2, [0, 1, 2, 3, 4]) == true, 
             $"Coloring [0, 1, 2, 3, 4] judged incorrect for graph V = {V2}, edges = {edges2}");
        Fact(IsVertexColoringValid(V2, edges2, [0, 2, 1, 0, 3]) == true, 
             $"Coloring [0, 2, 1, 0, 3] judged incorrect for graph V = {V2}, edges = {edges2}");
        Fact(IsVertexColoringValid(V2, edges2, [1, 0, 1, 2, 1]) == false, 
             $"Coloring [1, 0, 1, 2, 1] judged correct for graph V = {V2}, edges = {edges2}");
        Fact(IsVertexColoringValid(V2, edges2, [0, 0, 0, 0, 0]) == false, 
             $"Coloring [0, 0, 0, 0, 0] judged correct for graph V = {V2}, edges = {edges2}");

        let (V3, edges3) = testCases[3];
        Fact(IsVertexColoringValid(V3, edges3, [0, 1, 0, 2, 1]) == true, 
             $"Coloring [0, 1, 0, 2, 1] judged incorrect for graph V = {V3}, edges = {edges3}");
        Fact(IsVertexColoringValid(V3, edges3, [0, 2, 0, 1, 3]) == true, 
             $"Coloring [0, 2, 0, 1, 3] judged incorrect for graph V = {V3}, edges = {edges3}");
        Fact(IsVertexColoringValid(V3, edges3, [0, 1, 0, 1, 2]) == false, 
             $"Coloring [0, 1, 0, 1, 2] judged correct for graph V = {V3}, edges = {edges3}");

        let (V4, edges4) = testCases[4];
        Fact(IsVertexColoringValid(V4, edges4, [1, 2, 3, 1, 2]) == true, 
             $"Coloring [1, 2, 3, 1, 2] judged incorrect for graph V = {V4}, edges = {edges4}");
        Fact(IsVertexColoringValid(V4, edges4, [1, 2, 3, 4, 1]) == false, 
             $"Coloring [1, 2, 3, 4, 1] judged correct for graph V = {V4}, edges = {edges4}");
    }


    // ------------------------------------------------------
    operation QubitArrayWrapperOperation (op : ((Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {        
        op(Most(qs), Tail(qs));
    }


    operation AssertOracleRecognizesColoring (V : Int, edges : (Int, Int)[], oracle : ((Int, (Int, Int)[], Qubit[], Qubit) => Unit)) : Unit {
        // Message($"Testing V = {V}, edges = {edges}");
        let N = 2 * V;
        using ((coloringRegister, target) = (Qubit[N], Qubit())) {
            // Try all possible colorings of 4 colors on V vertices and check if they are calculated correctly.
            // Hack: fix the color of the first vertex, since all colorings are agnostic to the specific colors used.
            for (k in 0 .. (1 <<< (N - 2)) - 1) {
                // Prepare k-th coloring
                let binary = [false, false] + IntAsBoolArray(k, N);
                ApplyPauliFromBitString(PauliX, true, binary, coloringRegister);

                // Read out the coloring (convert one bitmask into V integers) - does not change the state
                let coloring = MeasureColoring_Reference(V, coloringRegister);

                // Apply the oracle
                oracle(V, edges, coloringRegister, target);

                // Check that the oracle result matches the classical result
                let val = IsVertexColoringValid_Reference(V, edges, coloring);
                // Message($"bitmask = {binary}, coloring = {coloring} - expected answer = {val}");
                AssertQubit(val ? One | Zero, target);
                Reset(target);

                // Check that the coloring qubits are still in the same state
                ApplyPauliFromBitString(PauliX, true, binary, coloringRegister);
                AssertAllZero(coloringRegister);
            }
        }
    }


    operation T22_VertexColoringOracle_Test () : Unit {
        for ((V, edges) in Most(ExampleGraphs())) {
            AssertOracleRecognizesColoring(V, edges, VertexColoringOracle);
        }
    }


    operation T23_GroversAlgorithm_Test () : Unit {
        for ((V, edges) in ExampleGraphs()) {
            Message($"Running on graph V = {V}, edges = {edges}");
            let coloring = GroversAlgorithm(V, VertexColoringOracle_Reference(V, edges, _, _));
            Fact(IsVertexColoringValid_Reference(V, edges, coloring), 
                 $"Got incorrect coloring {coloring}");
            Message($"Got correct coloring {coloring}");
        }
    }
}