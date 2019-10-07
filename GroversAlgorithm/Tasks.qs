// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.GroversAlgorithm {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The "Grover's Search" quantum kata is a series of exercises designed
    // to get you familiar with Grover's search algorithm.
    // It covers the following topics:
    //  - writing oracles for Grover's search,
    //  - performing steps of the algorithm, and
    //  - putting it all together: Grover's search algorithm.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // Within each section, tasks are given in approximate order of increasing difficulty;
    // harder ones are marked with asterisks.
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Oracles for Grover's Search
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. The |11...1⟩ oracle
    // Inputs:
    //      1) N qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a qubit in an arbitrary state |y⟩ (target qubit)
    // Goal: Flip the state of the target qubit (i.e., apply an X gate to it)
    //       if the query register is in the |11...1⟩ state,
    //       and leave it unchanged if the query register is in any other state.
    //       Leave the query register in the same state it started in.
    // Example:
    //       If the query register is in state |00...0⟩, leave the target qubit unchanged.
    //       If the query register is in state |10...0⟩, leave the target qubit unchanged.
    //       If the query register is in state |11...1⟩, flip the target qubit.
    //       If the query register is in state (|00...0⟩ + |11...1⟩) / sqrt(2), and the target is in state |0⟩,
    //       the joint state of the query register and the target qubit should be (|00...00⟩ + |11...11⟩) / sqrt(2).
    operation Oracle_AllOnes (queryRegister : Qubit[], target : Qubit) : Unit {
        
        body (...) {
            // ...
        }
        
        adjoint self;
    }
    
    
    // Task 1.2. The |1010...⟩ oracle
    // Inputs:
    //      1) N qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a qubit in an arbitrary state |y⟩ (target qubit)
    // Goal:  Flip the state of the target qubit if the query register is in the |1010...⟩ state;
    //        that is, the state with alternating 1 and 0 values, with any number of qubits in the register.
    //        Leave the state of the target qubit unchanged if the query register is in any other state.
    //        Leave the query register in the same state it started in.
    // Example:
    //        If the register is in state |0000000⟩, leave the target qubit unchanged.
    //        If the register is in state |10101⟩, flip the target qubit.
    operation Oracle_AlternatingBits (queryRegister : Qubit[], target : Qubit) : Unit {
        
        body (...) {
            // ...
        }
        
        adjoint self;
    }
    
    
    // Task 1.3. Arbitrary bit pattern oracle
    // Inputs:
    //      1) N qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a qubit in an arbitrary state |y⟩ (target qubit)
    //      3) a bit pattern of length N represented as Bool[]
    // Goal:  Flip the state of the target qubit if the query register is in the state described by the given bit pattern
    //        (true represents qubit state One, and false represents Zero).
    //        Leave the state of the target qubit unchanged if the query register is in any other state.
    //        Leave the query register in the same state it started in.
    // Example:
    //        If the bit pattern is [true, false], you need to flip the target qubit if and only if the qubits are in the |10⟩ state.
    operation Oracle_ArbitraryPattern (queryRegister : Qubit[], target : Qubit, pattern : Bool[]) : Unit {
        
        body (...) {
            // The following line enforces the constraint on the input arrays.
            // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
            EqualityFactI(Length(queryRegister), Length(pattern), "Arrays should have the same length");

            // ...
        }
        
        adjoint self;
    }
    
    
    // Task 1.4*. Oracle converter
    // Input:  A marking oracle: an oracle that takes a register and a target qubit and
    //         flips the target qubit if the register satisfies a certain condition
    // Output: A phase-flipping oracle: an oracle that takes a register and
    //         flips the phase of the register if it satisfies this condition
    //
    // Note: Grover's algorithm relies on the search condition implemented as a phase-flipping oracle,
    // but it is often easier to write a marking oracle for a given condition. This transformation
    // allows to convert one type of oracle into the other. The transformation is described at
    // https://en.wikipedia.org/wiki/Grover%27s_algorithm, section "Description of Uω".
    function OracleConverter (markingOracle : ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        
        // Hint: Remember that you can define auxiliary operations.
        
        // ...
        
        // Currently this function returns a no-op operation for the sake of being able to compile the code.
        // You will need to remove ApplyToEachA and return your own oracle instead.
        return ApplyToEachA(I, _);
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part II. The Grover iteration
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1. The Hadamard transform
    // Input: A register of N qubits in an arbitrary state
    // Goal:  Apply the Hadamard transform to each of the qubits in the register.
    //
    // Note:  If the register started in the |0...0⟩ state, this operation
    //        will prepare an equal superposition of all 2^N basis states.
    operation HadamardTransform (register : Qubit[]) : Unit
    is Adj {
        // ...
    }
    
    
    // Task 2.2. Conditional phase flip
    // Input: A register of N qubits in an arbitrary state.
    // Goal:  Flip the sign of the state of the register if it is not in the |0...0⟩ state.
    // Example:
    //        If the register is in state |0...0⟩, leave it unchanged.
    //        If the register is in any other basis state, multiply its phase by -1.
    // Note: This operation implements operator 2|0...0⟩⟨0...0| - I.
    operation ConditionalPhaseFlip (register : Qubit[]) : Unit
    is Adj {
    
        // Hint 1: Note that quantum states are defined up to a global phase.
        // Thus the state obtained as a result of this operation is the same
        // as the state obtained by flipping the sign of only the |0...0⟩ state.
            
        // Hint 2: You can use the same trick as in the oracle converter task.
            
        // ...
    }
    
    
    // Task 2.3. The Grover iteration
    // Inputs:
    //      1) N qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a phase-flipping oracle that takes an N-qubit register and flips
    //         the phase of the state if the register is in the desired state.
    // Goal:  Perform one Grover iteration.
    operation GroverIteration (register : Qubit[], oracle : (Qubit[] => Unit is Adj)) : Unit
    is Adj {
        
        // Hint: A Grover iteration consists of 4 steps:
        //    1) apply the oracle
        //    2) apply the Hadamard transform
        //    3) perform a conditional phase shift
        //    4) apply the Hadamard transform again
            
        // ...
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part III. Putting it all together: Grover's search algorithm
    //////////////////////////////////////////////////////////////////
    
    // Task 3.1. Grover's search
    // Inputs:
    //      1) N qubits in the |0...0⟩ state,
    //      2) a marking oracle, and
    //      3) the number of Grover iterations to perform.
    // Goal: Use Grover's algorithm to leave the register in the state that is marked by the oracle as the answer
    //       (with high probability).
    //
    // Note: The number of iterations is passed as a parameter because it is defined by the nature of the problem
    // and is easier to configure/calculate outside the search algorithm itself (for example, in the driver).
    operation GroversSearch (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        // ...
    }
    
    
    // Task 3.2. Using Grover's search
    // Goal: Use your implementation of Grover's algorithm from task 3.1 and the oracles from part 1
    //       to find the marked elements of the search space.
    // This task is not covered by a test and allows you to experiment with running the algorithm.
    operation E2E_GroversSearch_Test () : Unit {

        // Hint 1: To check whether the algorithm found the correct answer (i.e., an answer marked as 1 by the oracle), 
        // you can apply the oracle once more to the register after you've measured it and an ancilla qubit,
        // which will calculate the function of the answer found by the algorithm.

        // Hint 2: Experiment with the number of iterations to see how it affects
        // the probability of the algorithm finding the correct answer.

        // Hint 3: You can use the Message function to write the results to the console.

        // ...
    }
    
}
