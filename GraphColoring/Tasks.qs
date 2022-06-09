// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.GraphColoring {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The "Graph coloring" quantum kata is a series of exercises designed
    // to teach you the basics of using Grover search to solve constraint
    // satisfaction problems, using graph coloring problem as an example.
    // It covers the following topics:
    //  - writing oracles implementing constraints on graph coloring,
    //  - using Grover's algorithm to solve graph coloring problems with unknown number of solutions.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    // Within each section, tasks are given in approximate order of increasing difficulty;
    // harder ones are marked with asterisks.


    //////////////////////////////////////////////////////////////////
    // Part I. Colors representation and manipulation
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Initialize register to a color
    // Inputs:
    //      1) An integer C (0 ≤ C ≤ 2ᴺ - 1).
    //      2) An array of N qubits in the |0...0⟩ state.
    // Goal: Prepare the array in the basis state which represents the binary notation of C.
    //       Use little-endian encoding (i.e., the least significant bit should be stored in the first qubit).
    // Example: for N = 2 and C = 2 the state should be |01⟩.
    operation InitializeColor (C : Int, register : Qubit[]) : Unit is Adj {
        // ...
    }


    // Task 1.2. Read color from a register
    // Input: An array of N qubits which are guaranteed to be in one of the 2ᴺ basis states.
    // Output: An N-bit integer that represents this basis state, in little-endian encoding.
    //         The operation should not change the state of the qubits.
    // Example: for N = 2 and the qubits in the state |01⟩ return 2 (and keep the qubits in |01⟩).
    operation MeasureColor (register : Qubit[]) : Int {
        // ...
        return -1;
    }


    // Task 1.3. Read coloring from a register
    // Inputs: 
    //      1) The number of elements in the coloring K.
    //      2) An array of K * N qubits which are guaranteed to be in one of the 2ᴷᴺ basis states.
    // Output: An array of K N-bit integers that represent this basis state. 
    //         Integer i of the array is stored in qubits i * N, i * N + 1, ..., i * N + N - 1 in little-endian format.
    //         The operation should not change the state of the qubits.
    // Example: for N = 2, K = 2 and the qubits in the state |0110⟩ return [2, 1].
    operation MeasureColoring (K : Int, register : Qubit[]) : Int[] {
        // ...
        return [];
    }


    // Task 1.4. 2-bit color equality oracle
    // Inputs:
    //      1) an array of 2 qubits in an arbitrary state |c₀⟩ representing the first color,
    //      1) an array of 2 qubits in an arbitrary state |c₁⟩ representing the second color,
    //      3) a qubit in an arbitrary state |y⟩ (target qubit).
    // Goal: Transform state |c₀⟩|c₁⟩|y⟩ into state |c₀⟩|c₁⟩|y ⊕ f(c₀, c₁)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if c₀ and c₁ are in the same state, and 0 otherwise.
    //       Leave the query register in the same state it started in.
    // In this task you are allowed to allocate extra qubits.
    operation ColorEqualityOracle_2bit (c0 : Qubit[], c1 : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.5. N-bit color equality oracle (no extra qubits)
    // This task is the same as task 1.4, but in this task you are NOT allowed to allocate extra qubits.
    operation ColorEqualityOracle_Nbit (c0 : Qubit[], c1 : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }



    //////////////////////////////////////////////////////////////////
    // Part II. Vertex coloring problem
    //////////////////////////////////////////////////////////////////

    // The vertex graph coloring is a coloring of graph vertices which 
    // labels each vertex with one of the given colors so that 
    // no two vertices of the same color are connected by an edge.

    // Task 2.1. Classical verification of vertex coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of V integers, representing the vertex coloring of the graph.
    //         i-th element of the array is the color of the vertex number i.
    // Output: true if the given vertex coloring is valid 
    //         (i.e., no pair of vertices connected by an edge have the same color),
    //         and false otherwise.
    // Example: Graph 0 -- 1 -- 2 would have V = 3 and edges = [(0, 1), (1, 2)].
    //         Some of the valid colorings for it would be [0, 1, 0] and [-1, 5, 18].
    function IsVertexColoringValid (V : Int, edges: (Int, Int)[], colors: Int[]) : Bool {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        Fact(Length(colors) == V, $"The vertex coloring must contain exactly {V} elements, and it contained {Length(colors)}.");

        // ...

        return true;
    }


    // Task 2.2. Oracle for verifying vertex coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of 2V qubits colorsRegister that encodes the color assignments.
    //      4) A qubit in an arbitrary state |y⟩ (target qubit).
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if the given vertex coloring is valid and 0 otherwise.
    //       Leave the query register in the same state it started in.
    //
    // Each color in colorsRegister is represented as a 2-bit integer in little-endian format.
    // See task 1.3 for a more detailed description of color assignments.
    operation VertexColoringOracle (V : Int, edges : (Int, Int)[], colorsRegister : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 2.3. Using Grover's search to find vertex coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) A marking oracle which implements vertex coloring verification, as implemented in task 2.2.
    //
    // Output: A valid vertex coloring for the graph, in a format used in task 2.1.
    operation GroversAlgorithm (V : Int, oracle : ((Qubit[], Qubit) => Unit is Adj)) : Int[] {
        // ...
        return [0, size = V];
    }



    //////////////////////////////////////////////////////////////////
    // Part III. Weak coloring problem
    //////////////////////////////////////////////////////////////////

    // Weak graph coloring is a coloring of graph vertices which 
    // labels each vertex with one of the given colors so that 
    // each vertex is either isolated or is connected by an edge
    // to at least one neighbor of a different color.

    // Task 3.1. Determine if an edge contains the vertex
    // Inputs:
    //      1) An edge denoted by a tuple of integers.
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //      2) An integer denoting the vertex of the graph.
    // Output: true if the edge starts or ends with the vertex provided,
    //         and false otherwise.
    // Examples: edge (0, 1) contains vertex 0, so return true;
    //           edge (0, 1) contains vertex 1, so return true;
    //           edge (2, 3) does not contain vertex 1, so return false.
    function DoesEdgeContainVertex (edge : (Int, Int), vertex : Int) : Bool {
        // ...
        return false;
    }


    // Task 3.2. Determine if a vertex is weakly colored (classical)
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of V integers, representing the vertex coloring of the graph.
    //         i-th element of the array is the color of the vertex number i.
    //      4) A vertex in the graph, indexed 0 through V - 1.
    // Output: true if the vertex is weakly colored
    //         (i.e., it is connected to at least one neighboring vertex of different color),
    //         and false otherwise.
    // Note: An isolated vertex (a vertex without neighbors) is considered to be weakly colored.
    // Example: For vertex 0, in a graph containing edges = [(0, 1), (0, 2), (1, 2)],
    //          and colors = [0, 1, 0], vertex 0 is weakly colored, 
    //          since it has color 0 and is connected to vertex 1 which has color 1.
    function IsVertexWeaklyColored (V : Int, edges : (Int, Int)[], colors : Int[], vertex : Int) : Bool {
        // ...
        return false;
    }


    // Task 3.3. Classical verification of weak coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of V integers, representing the vertex coloring of the graph.
    //         i-th element of the array is the color of the vertex number i.
    // Output: true if the given weak coloring is valid
    //         (i.e., every vertex is isolated or is connected to at least one neighboring vertex of different color),
    //         and false otherwise.
    // Example: Consider a graph with V = 3 and edges = [(0, 1), (0, 2), (1, 2)].
    //          Some of the valid colorings for it would be [0, 1, 0] and [-1, 5, 18].
    function IsWeakColoringValid (V : Int, edges: (Int, Int)[], colors: Int[]) : Bool {
        // ...
        return false;
    }


    // Task 3.4. Oracle for verifying if a vertex is weakly colored
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of 2V qubits colorsRegister that encodes the color assignments.
    //      4) A qubit in an arbitrary state |y⟩ (target qubit).
    //      5) A vertex in the graph, indexed 0 through V - 1.
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if the given weak coloring is valid and 0 otherwise.
    //       Leave the query register in the same state it started in.
    //
    // Each color in colorsRegister is represented as a 2-bit integer in little-endian format.
    // See task 1.3 for a more detailed description of color assignments.
    operation WeaklyColoredVertexOracle (V : Int, edges: (Int, Int)[], colorsRegister : Qubit[], target : Qubit, vertex : Int) : Unit is Adj+Ctl {
        // ...
    }


    // Task 3.5. Oracle for verifying weak coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of 2V qubits colorsRegister that encodes the color assignments.
    //      4) A qubit in an arbitrary state |y⟩ (target qubit).
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if the given weak coloring is valid and 0 otherwise.
    //       Leave the query register in the same state it started in.
    //
    // Each color in colorsRegister is represented as a 2-bit integer in little-endian format.
    // See task 1.3 for a more detailed description of color assignments.
    operation WeakColoringOracle (V : Int, edges : (Int, Int)[], colorsRegister : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 3.6. Using Grover's search to find weak coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) A marking oracle which implements weak coloring verification, as implemented in task 3.5.
    //
    // Output: A valid weak coloring for the graph, in a format used in task 3.3.
    operation GroversAlgorithmForWeakColoring (V : Int, oracle : ((Qubit[], Qubit) => Unit is Adj)) : Int[] {
        // ...
        return [0, size = V];
    }



    //////////////////////////////////////////////////////////////////
    // Part IV. Triangle-free coloring problem
    //////////////////////////////////////////////////////////////////

    // Triangle-free graph coloring is a coloring of graph edges which 
    // labels each edge with one of two colors so that no three edges 
    // of the same color form a triangle.

    // Task 4.1. Convert the list of graph edges into an adjacency matrix
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    // Output: A 2D array of integers representing this graph as an adjacency matrix:
    //         the element [i][j] should be -1 if the vertices i and j are not connected with an edge,
    //         or store the index of the edge if the vertices i and j are connected with an edge.
    //         Elements [i][i] should be -1 unless there is an edge connecting vertex i to itself.
    // Example: Consider a graph with V = 3 and edges = [(0, 1), (0, 2), (1, 2)].
    //         The adjacency matrix for it would be 
    //         [-1,  0,  1],
    //         [ 0, -1,  2],
    //         [ 1,  2, -1].
    function EdgesListAsAdjacencyMatrix (V : Int, edges : (Int, Int)[]) : Int[][] {
        // ...
        return [];
    }


    // Task 4.2. Extract a list of triangles from an adjacency matrix
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An adjacency matrix describing the graph in the format from task 4.1.
    // Output: An array of 3-tuples listing all triangles in the graph, 
    //         that is, all triplets of vertices connected by edges.
    //         Each of the 3-tuples should list the triangle vertices in ascending order,
    //         and the 3-tuples in the array should be sorted in ascending order as well.
    // Example: Consider the adjacency matrix
    //         [-1,  0,  1],
    //         [ 0, -1,  2],
    //         [ 1,  2, -1].
    //         The list of triangles for it would be [(0, 1, 2)].
    function AdjacencyMatrixAsTrianglesList (V : Int, adjacencyMatrix : Int[][]) : (Int, Int, Int)[] {
        // ...
        return [];
    }


    // Task 4.3. Classical verification of triangle-free coloring
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers, representing the edges of the graph (E ≤ 12).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //      3) An array of E integers, representing the edge coloring of the graph.
    //         i-th element of the array is the color of the edge number i, and it is 0 or 1.
    //         The colors of edges in this array are given in the same order as the edges in the "edges" array.
    // Output: true if the given coloring is triangle-free
    //         (i.e., no triangle of edges connecting 3 vertices has all three edges in the same color),
    //         and false otherwise.
    // Example: Consider a graph with V = 3 and edges = [(0, 1), (0, 2), (1, 2)].
    //          Some of the valid colorings for it would be [0, 1, 0] and [-1, 5, 18].
    function IsVertexColoringTriangleFree (V : Int, edges: (Int, Int)[], colors: Int[]) : Bool {
        // ...
        return true;
    }


    // Task 4.4. Oracle to check that three colors don't form a triangle
    //           (f(x) = 1 if at least two of three input bits are different)
    // Inputs:
    //      1) a 3-qubit array `inputs`,
    //      2) a qubit `output`.
    // Goal: Flip the output qubit if and only if at least two of the input qubits are different.
    // For example, for the result of applying the operation to state (|001⟩ + |110⟩ + |111⟩) ⊗ |0⟩
    // will be |001⟩ ⊗ |1⟩ + |110⟩ ⊗ |1⟩ + |111⟩ ⊗ |0⟩.
    operation ValidTriangleOracle (inputs : Qubit[], output : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 4.5. Oracle for verifying triangle-free edge coloring
    //           (f(x) = 1 if the graph edge coloring is triangle-free)
    // Inputs:
    //      1) The number of vertices in the graph V (V ≤ 6).
    //      2) An array of E tuples of integers "edges", representing the edges of the graph (0 ≤ E ≤ V(V-1)/2).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //         The graph is undirected, so the order of the start and the end vertices in the edge doesn't matter.
    //      3) An array of E qubits "colorsRegister" that encodes the color assignments of the edges.
    //         Each color will be 0 or 1 (stored in 1 qubit).
    //         The colors of edges in this array are given in the same order as the edges in the "edges" array.
    //      4) A qubit "target" in an arbitrary state.
    //
    // Goal: Implement a marking oracle for function f(x) = 1 if
    //       the coloring of the edges of the given graph described by this colors assignment is triangle-free, 
    //       i.e., no triangle of edges connecting 3 vertices has all three edges in the same color.
    //
    // In this task you are not allowed to use quantum gates that use more qubits than the number of edges in the graph,
    // unless there are 3 or less edges in the graph. For example, if the graph has 4 edges, you can only use 4-qubit gates or less.
    // You are guaranteed that in tests that have 4 or more edges in the graph the number of triangles in the graph 
    // will be strictly less than the number of edges.
    //
    // Example: a graph with 3 vertices and 3 edges [(0, 1), (1, 2), (2, 0)] has one triangle.
    // The result of applying the operation to state (|001⟩ + |110⟩ + |111⟩)/√3 ⊗ |0⟩ 
    // will be 1/√3|001⟩ ⊗ |1⟩ + 1/√3|110⟩ ⊗ |1⟩ + 1/√3|111⟩ ⊗ |0⟩.
    // The first two terms describe triangle-free colorings, 
    // and the last term describes a coloring where all edges of the triangle have the same color.
    //
    // Hint: Make use of functions and operations you've defined in previous tasks.
    operation TriangleFreeColoringOracle (
        V : Int, 
        edges : (Int, Int)[], 
        colorsRegister : Qubit[], 
        target : Qubit
    ) : Unit is Adj+Ctl {
        // ...
    }
}
