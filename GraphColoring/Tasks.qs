namespace Quantum.Kata.GraphColoring {
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Diagnostics;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The "Graph coloring" quantum kata is a series of exercises designed
    // to teach you the basics of using Grover search to solve constraint
    // satisfaction problems, specifically graph coloring.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.


    //////////////////////////////////////////////////////////////////
    // Part I. Building marking oracles for classical functions
    //////////////////////////////////////////////////////////////////


    // Task 1.1. The AND oracle: f(x) = x₀ ∧ ... ∧ xₙ
    // Inputs:
    //      1) n qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a qubit in an arbitrary state |y⟩ (target qubit)
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       i.e., flip the target state if all qubits of the query register are in the |1⟩ state,
    //       and leave it unchanged otherwise.
    //       Leave the query register in the same state it started in.
    operation Task11 (queryRegister : Qubit[], target : Qubit) : Unit {
        
        body (...) {
            // ...
        }
        
        adjoint auto;
    }


    // Task 1.2. The OR oracle: f(x) = x₀ ∨ ...  ∨ xₙ
    // Inputs:
    //      1) n qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a qubit in an arbitrary state |y⟩ (target qubit)
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       i.e., flip the target state if at least one qubit of the query register is in the |1⟩ state,
    //       and leave it unchanged otherwise.
    //       Leave the query register in the same state it started in.
    operation Task12 (queryRegister : Qubit[], target : Qubit) : Unit {
        
        body (...) {
            // ...
        }
        
        adjoint auto;
    }

    // Task 1.3. "Qubit Pairs Match" oracle
    // Inputs:
    //      1) 2 qubits in an arbitrary state |x₀⟩ (input/query register)
    //      2) 2 qubits in an arbitrary state |x₁⟩ (input/query register)
    //      3) a qubit in an arbitrary state |y⟩ (target qubit)
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if x₀ and x₁ share the same state.
    //       Leave the query register in the same state it started in.
    operation Task13 (queryRegister0 : Qubit[], queryRegister1 : Qubit[], target : Qubit) : Unit {

        body (...) {
            // ...
        }

        adjoint auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Steps Towards Implementing the Graph Coloring Oracle
    //////////////////////////////////////////////////////////////////

    // Task 2.1. "One Qubit Pair Match" oracle
    // Inputs:
    //      1) 2 qubits in an arbitrary state |x₀⟩ (input/query register)
    //      2) 2 qubits in an arbitrary state |x₁⟩ (input/query register)
    //      3) 2 qubits in an arbitrary state |x₂⟩ (input/query register)
    //      4) a qubit in an arbitrary state |y⟩ (target qubit)
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if for x₀, x₁, and x₂, a pair of those qubits share the same state.
    //       Leave the query register in the same state it started in.
    operation Task21 (queryRegister0 : Qubit[], queryRegister1 : Qubit[], queryRegister2 : Qubit[], target : Qubit) : Unit {

        body (...) {
            // ...
        }

        adjoint auto;
    }

    // Task 2.2. "No Qubit Pair Match" oracle
    // Inputs:
    //      1) 2 qubits in an arbitrary state |x₀⟩ (input/query register)
    //      2) 2 qubits in an arbitrary state |x₁⟩ (input/query register)
    //      3) 2 qubits in an arbitrary state |x₂⟩ (input/query register)
    //      4) a qubit in an arbitrary state |y⟩ (target qubit)
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if for x₀, x₁, and x₂, no pairs of those qubits share the same state.
    //       Leave the query register in the same state it started in.
    operation Task22 (queryRegister0 : Qubit[], queryRegister1 : Qubit[], queryRegister2 : Qubit[], target : Qubit) : Unit {

        body (...) {
            // ...
        }

        adjoint auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part III.  Implementing the Graph Coloring Oracle
    //////////////////////////////////////////////////////////////////

    // Task 3.1. "Graph Coloring" oracle
    // Inputs:
    //      1) an array containing pairs of ints representing the list of edges between nodes
    //      2) the number of nodes in the graph
    //      3) a register of qubits numbering twice the number of nodes encoding the color assignments
    //      4) a qubit in an arbitrary state |y⟩ (target qubit)
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if no edges in the graph have its end nodes having the same color.
    //       Leave the query register in the same state it started in.
    //
    // Here, we represent the encoding of colors with 2 qubits, with 00, 01, 10, 11 being our colors.
    // Thus, each node is represented by 2 qubits in the register, with node n having 2*n and 2*n+1
    // as its qubit color encoding. Nodes are numbered 0 .. numNodes - 1 with each entry in the edge
    // list showing which nodes are connected in the graph. For instance, the graph 0 -- 1 -- 2 would
    // have an edgeList of [(0, 1), (1, 2)] and 3 as its numNodes. Note that pairs of nodes in the
    // edgeList do not have to be in any order.
    operation Task31 (edgeList : (Int, Int)[], numNodes : Int, queryRegister : Qubit[], target : Qubit) : Unit {

        body (...) {
            // ...
        }

        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 3.2. "Graph Coloring" oracle generator
    // Inputs:
    //      1) an array containing pairs of ints representing the list of edges between nodes
    //      2) the number of nodes in the graph
    //
    // Output: A marking oracle that takes a register and a target qubit and flips the target
    //         if the register encodes a color assignment that leads to no edge having its
    //         attached nodes have the same color.
    //
    // Essentially, it is returning the oracle in Task 3.1., but for a particular graph.
    operation Task32 (edgeList : (Int, Int)[], numNodes : Int) : ((Qubit[], Qubit) => Unit : Adjoint) {

        body (...) {
            return Task11;
        }

    }

    //////////////////////////////////////////////////////////////////
    // Part IV. Using Grover's search algorithm
    //////////////////////////////////////////////////////////////////


    // Task 4. Using Grover's search to find color assignments
    // Inputs:
    //      1) an array containing pairs of ints representing the list of edges between nodes
    //      2) the number of nodes in the graph
    //
    // Output: a color assignment for the graph that has no edge having its nodes share the same color.
    //         Note that we are returning an interger array corresponding to the measured qubit encoding.
    //
    // Hint, use the provided GroversSearch operation and the "Graph Coloring" oracle generator.
    operation Task4 (edgeList : (Int, Int)[], numNodes : Int) : Int[] {

        body (...) {
            return new Int[numNodes];
        }

    }


    // The following functions are taken from the Grover's search Kata
    operation GroversSearch (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit : Adjoint), iterations : Int) : Unit {
        body (...) {
            let phaseOracle = OracleConverter(oracle);
            HadamardTransform(register);
            
            for (i in 1 .. iterations) {
                GroverIteration(register, phaseOracle);
            }
        }
        adjoint invert;
    }

    operation GroverIteration (register : Qubit[], oracle : (Qubit[] => Unit : Adjoint)) : Unit {
        body (...) {
            oracle(register);
            HadamardTransform(register);
            ConditionalPhaseFlip(register);
            HadamardTransform(register);
        }
        adjoint invert;
    }

    function OracleConverter (markingOracle : ((Qubit[], Qubit) => Unit : Adjoint)) : (Qubit[] => Unit : Adjoint) {
        return OracleConverterImpl(markingOracle, _);
    }

    operation OracleConverterImpl (markingOracle : ((Qubit[], Qubit) => Unit : Adjoint), register : Qubit[]) : Unit {
        body (...) {
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
        adjoint invert;
    }

    operation HadamardTransform (register : Qubit[]) : Unit {
        body (...) {
            ApplyToEachA(H, register);
        }
        adjoint invert;
    }

    operation ConditionalPhaseFlip (register : Qubit[]) : Unit {
        body (...) {
            // Define a marking oracle which detects an all zero state
            let allZerosOracle = Oracle_ArbitraryPattern(_, _, new Bool[Length(register)]);
            
            // Convert it into a phase-flip oracle and apply it
            let flipOracle = OracleConverter(allZerosOracle);
            flipOracle(register);
        }
        adjoint self;
    }
    
    operation PhaseFlip_ControlledZ (register : Qubit[]) : Unit {
        body (...) {
            // Alternative solution, described at https://quantumcomputing.stackexchange.com/questions/4268/how-to-construct-the-inversion-about-the-mean-operator/4269#4269
            ApplyToEachA(X, register);
            Controlled Z(Most(register), Tail(register));
            ApplyToEachA(X, register);
        }
        adjoint self;
    }

    operation Oracle_ArbitraryPattern(queryRegister : Qubit[], target : Qubit, pattern : Bool[]) : Unit {
        
        body (...) {
            (ControlledOnBitString(pattern, X))(queryRegister, target);
        }
        
        adjoint invert;
    }
    


}