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
    open Quantum.Kata.Utils;
    

    //////////////////////////////////////////////////////////////////
    // Part I. Colors representation and manipulation
    //////////////////////////////////////////////////////////////////

    @Test("QuantumSimulator")
    operation T11_InitializeColor () : Unit {
        for N in 1 .. 4 {
            use register = Qubit[N];
            for C in 0 .. (1 <<< N) - 1 {
                InitializeColor(C, register);
                let measurementResults = MultiM(register);
                Fact(ResultArrayAsInt(measurementResults) == C, 
                    $"Unexpected initialization result for N = {N}, C = {C} : {measurementResults}");
                ResetAll(register);
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T12_MeasureColor () : Unit {
        for N in 1 .. 4 {
            use register = Qubit[N];
            for C in 0 .. (1 <<< N) - 1 {
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


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T13_MeasureColoring () : Unit {
        for K in 1 .. 3 {
        for N in 1 .. 3 {
            use register = Qubit[N * K];
            for state in 0 .. (1 <<< (N * K)) - 1 {
                // prepare the register in the input state
                let binaryState = IntAsBoolArray(state, N * K);
                ApplyPauliFromBitString(PauliX, true, binaryState, register);

                // call the solution
                let result = MeasureColoring(K, register);

                // get the expected coloring by splitting binaryState into parts and converting them into integers
                let partitions = Chunks(N, binaryState);
                let expectedColors = ForEach(FunctionAsOperation(BoolArrayAsInt), partitions);

                // verify the return value
                Fact(Length(result) == K, $"Unexpected number of colors for N = {N}, K = {K} : {Length(result)}");
                for (expected, actual) in Zipped(expectedColors, result) {
                    Fact(expected == actual, $"Unexpected color for N = {N}, K = {K} : expected {expectedColors}, got {result}");
                }

                // verify that the register remained in the same state
                ApplyPauliFromBitString(PauliX, true, binaryState, register);
                AssertAllZero(register);
            }
        }
        }
    }


    // ------------------------------------------------------
    operation CheckColorEqualityOracle (N : Int, oracle : ((Qubit[], Qubit[], Qubit) => Unit)) : Unit {
        use (register0, register1, target) = (Qubit[N], Qubit[N], Qubit());
        for state in 0 .. (1 <<< (2 * N)) - 1 {
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


    // helper wrapper to represent oracle operation on two input registers of equal size and output register of size 1
    // as an operation on an array of qubits
    operation WrapperOperation (op : ((Qubit[], Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {        
        let N = (Length(qs) - 1) / 2;
        op(qs[0 .. N - 1], qs[N .. 2 * N - 1], qs[2 * N]);
    }

    @Test("QuantumSimulator")
    operation T14_ColorEqualityOracle_2bit () : Unit {
        CheckColorEqualityOracle(2, ColorEqualityOracle_2bit);
        AssertOperationsEqualReferenced(5, WrapperOperation(ColorEqualityOracle_2bit, _),
                                           WrapperOperation(ColorEqualityOracle_2bit_Reference, _));
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T15_ColorEqualityOracle_Nbit () : Unit {
        for N in 1..4 {            
            within {
                AllowAtMostNQubits(2*N+1, "You are not allowed to allocate extra qubits");
            } apply {
                CheckColorEqualityOracle(N, ColorEqualityOracle_Nbit);
            }

            AssertOperationsEqualReferenced(2*N+1, WrapperOperation(ColorEqualityOracle_Nbit, _),
                                                   WrapperOperation(ColorEqualityOracle_Nbit_Reference, _));
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
        return [(3, []),
                (4, [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]),
                (5, [(4, 0), (2, 1), (3, 1), (3, 2)]),
                (5, [(0, 1), (1, 2), (1, 3), (3, 2), (4, 2), (3, 4)]),
                (5, [(0, 1), (0, 2), (0, 4), (1, 2), (1, 3), (2, 3), (2, 4), (3, 4)]),
                (6, [(0, 1), (0, 2), (0, 4), (0, 5), (1, 2), (1, 3), (1, 5), (2, 3), (2, 4), (3, 4), (3, 5), (4, 5)])];
        // Graphs with 6+ vertices can take several minutes to be processed; 
        // in the interest of keeping test runtime reasonable we're limiting most of the testing to graphs with 5 vertices or fewer.
    }

    @Test("QuantumSimulator")
    operation T21_IsVertexColoringValid () : Unit {
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


    operation AssertOracleRecognizesColoring (
        V : Int,
        edges : (Int, Int)[],
        oracle : ((Int, (Int, Int)[],Qubit[], Qubit) => Unit),
        classicalFunction : ((Int, (Int, Int)[], Int[]) -> Bool)
    ) : Unit {
        Message($"Testing V = {V}, edges = {edges}");
        let N = 2 * V;
        use (coloringRegister, target) = (Qubit[N], Qubit());
            // Try all possible colorings of 4 colors on V vertices and check if they are calculated correctly.
            // Hack: fix the color of the first vertex, since all colorings are agnostic to the specific colors used.
        for k in 0 .. (1 <<< (N - 2)) - 1 {
            // Prepare k-th coloring
            let binary = [false, false] + IntAsBoolArray(k, N);
            ApplyPauliFromBitString(PauliX, true, binary, coloringRegister);

            // Read out the coloring (convert one bitmask into V integers) - does not change the state
            let coloring = MeasureColoring_Reference(V, coloringRegister);

            // Apply the oracle
            oracle(V, edges, coloringRegister, target);

            // Check that the oracle result matches the classical result
            let val = classicalFunction(V, edges, coloring);
            // Message($"bitmask = {binary}, coloring = {coloring} - expected answer = {val}");
            AssertQubit(val ? One | Zero, target);
            Reset(target);

            // Check that the coloring qubits are still in the same state
            ApplyPauliFromBitString(PauliX, true, binary, coloringRegister);
            AssertAllZero(coloringRegister);
        }
    }

    @Test("QuantumSimulator")
    operation T22_VertexColoringOracle () : Unit {
        // Run test on all test cases except the last one
        for (V, edges) in Most(ExampleGraphs()) {
            AssertOracleRecognizesColoring(V, edges, VertexColoringOracle, IsVertexColoringValid_Reference);
        }
    }

    @Test("QuantumSimulator")
    operation T23_GroversAlgorithm () : Unit {
        for (V, edges) in ExampleGraphs() {
            Message($"Running on graph V = {V}, edges = {edges}");
            let coloring = GroversAlgorithm(V, VertexColoringOracle_Reference(V, edges, _, _));
            Fact(IsVertexColoringValid_Reference(V, edges, coloring), 
                 $"Got incorrect coloring {coloring}");
            Message($"Got correct coloring {coloring}");
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Weak coloring problem
    //////////////////////////////////////////////////////////////////

    @Test("QuantumSimulator")
    operation T31_DoesEdgeContainVertex () : Unit {
        Fact(DoesEdgeContainVertex((1,2), 1) == true,
             $"Edge (1, 2) should contain vertex 1");
        Fact(DoesEdgeContainVertex((1,2), 2) == true,
             $"Edge (1, 2) should contain vertex 2");
        Fact(DoesEdgeContainVertex((1,2), 3) == false,
             $"Edge (1, 2) should not contain vertex 2");
    }


    @Test("QuantumSimulator")
    operation T32_IsVertexWeaklyColored () : Unit {
        let testCases = Most(ExampleGraphs());
        let colorings = [[0, 0, 0],
                         [3, 2, 0, 0],
                         [1, 0, 1, 2, 1],
                         [0, 0, 1, 1, 1],
                         [0, 1, 1, 1, 1]
                        ];
        let expectedResults = [[true, true, true],
                               [true, true, true, true],
                               [false, true, true, true, false],
                               [false, true, true, true, false],
                               [true, true, true, false, true]
                              ];
        for ((V, edges), coloring, expectedResult) in Zipped3(testCases, colorings, expectedResults) {
            for vertex in 0 .. V - 1 {
                Fact(IsVertexWeaklyColored(V, edges, coloring, vertex) == expectedResult[vertex],
                    $"Vertex = {vertex} judged{(not expectedResult[vertex]) ? "" | " not"} weakly colored for coloring = {coloring}, edges = {edges}");
            }
        }
    }

    @Test("QuantumSimulator")
    operation T33_IsWeakColoringValid () : Unit {
        let testCases = Most(ExampleGraphs());
        // Every coloring would pass on a disconnected graph of 3 vertices
        let exampleColoringForThreeVertices = [[0, 0, 0], [2, 1, 3]];
        // Every coloring  would pass on a fully connected graph of 4 vertices;
        // except for the colorings in which all vertices are of the same color
        let exampleColoringForFourVertices = [[0, 2, 1, 3], [3, 2, 0, 0], [0, 0, 0, 0] ];
        let exampleColoringForFiveVertices = [
            // Graph coloring that fails in all types of graphs, except fully disconnected graphs
            [0, 0, 0, 0, 0],
            // Graph coloring that passes all types of graphs regardless of their structure
            [0, 1, 2, 3, 4],
            // Random coloring that fails the third graph, and passes the fourth and fifth one
            [0, 1, 1, 2, 0],
            // Random coloring that fails the fourth graph, and passes the third and fifth one
            [0, 0, 1, 1, 1]
            // Note any colorings that pass the third or the fourth graph
            // will also pass the fifth graph since fifth graph has all the edges contained
            // in the third and fourth graph
            ];

        let coloringAndVerdicts0 = Zipped(exampleColoringForThreeVertices, [true, true]);
        let coloringAndVerdicts1 = Zipped(exampleColoringForFourVertices, [true, true, false]);
        let coloringAndVerdicts2 = Zipped(exampleColoringForFiveVertices, [false, true, false, true]);
        let coloringAndVerdicts3 = Zipped(exampleColoringForFiveVertices, [false, true, true, false]);
        let coloringAndVerdicts4 = Zipped(exampleColoringForFiveVertices, [false, true, true, true]);

        let fullTestCases = Zipped(testCases, [
                                    coloringAndVerdicts0,
                                    coloringAndVerdicts1,
                                    coloringAndVerdicts2,
                                    coloringAndVerdicts3,
                                    coloringAndVerdicts4
                                    ]);

        for (testCase, coloringAndVerdicts) in fullTestCases {
            let (V, edges) = testCase;
            for (coloring,expectedResult) in coloringAndVerdicts {
                Fact(IsWeakColoringValid(V, edges, coloring) == expectedResult,
                    $"Coloring {coloring} judged {(not expectedResult) ? "" | " not"} weakly colored for graph V = {V}, edges = {edges}");
            }
        }
    }


    @Test("QuantumSimulator")
    operation T34_WeaklyColoredVertexOracle() : Unit {
        for (V, edges) in Most(ExampleGraphs()) {
            for vertex in 0 .. V - 1 {
                AssertOracleRecognizesColoring(V, edges, WeaklyColoredVertexOracle(_, _, _, _, vertex), IsVertexWeaklyColored_Reference(_, _, _, vertex));
            }
        }
    }


    @Test("QuantumSimulator")
    operation T35_WeakColoringOracle () : Unit {
        // Run test on the first three test cases
        for (V, edges) in (ExampleGraphs())[... 3] {
            AssertOracleRecognizesColoring(V, edges, WeakColoringOracle, IsWeakColoringValid_Reference);
        }
    }


    @Test("QuantumSimulator")
    operation T36_GroversAlgorithmForWeakColoring () : Unit {
        for (V, edges) in ExampleGraphs() {
            Message($"Running on graph V = {V}, edges = {edges}");
            let coloring = GroversAlgorithmForWeakColoring(V, WeakColoringOracle_Reference(V, edges, _, _));
            Fact(IsWeakColoringValid_Reference(V, edges, coloring),
                 $"Got incorrect coloring {coloring}");
            Message($"Got correct coloring {coloring}");
        }
    }
}
