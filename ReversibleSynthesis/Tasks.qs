// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.ReverSynth {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
 //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // "Reversible Synthesis" quantum kata is a series of exercises designed
    // to get you familiar with the concept of reversible logic synthesis.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task has a unit test associated with it, which initially fails. 
    // Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // All tasks can be done using exclusively CNOT and CCNOT (Toffoli) gates.
    // None of the tasks require measurement.
    // The tests are written so as to fail if qubit state is measured.
    
    // The tasks are given in approximate order of increasing difficulty.
    

    // Task 1. Implementing XOR as a reversible function
    // Inputs:
    //      1) 2 qubits in an arbitrary state |x⟩ (input/control register)
    //      2) a qubit |y⟩ in state |0⟩ (target qubit)
    // Goal: Set the state of the target register to |x0⟩ ⊕ |x1⟩. 
    //       Leave the input register in the same state it started in.
    // Hint: The task can be completed using exclusively CNOT gates. 

    operation XOR (x : Qubit[], y: Qubit) : Unit {
        
        body (...) {

            // ...
        }
        
        adjoint self;
    }

    // Task 2. Implementing AND as a reversible function
    // Inputs:
    //      1) 2 qubits in an arbitrary state |x⟩ (input/control register)
    //      2) a qubit |y⟩ in state |0⟩ (target qubit)
    // Goal: Set the state of the target register to |x0⟩ ∧ |x1⟩. 
    //       Leave the input register in the same state it started in.
    // Hint: The task can be completed using a single CCNOT gate. 

    operation AND (x : Qubit[], y: Qubit) : Unit {
        
        body (...) {

            // ...
        }
        
        adjoint self;
    }

    // Task 3. Implementing a 3-input reversible Majority function (Maj3)
    // Inputs:
    //      1) 3 qubits in an arbitrary state |x⟩ (input/control register)
    //      2) 3 qubits |a⟩ in state |0⟩ (ancillas)
    //      3) a qubit |y⟩ in state |0⟩ (target qubit)
    // Goal: Set the state of the target register to Maj3(|x0⟩,|x1⟩,|x2⟩).
    //       Leave the input register in the same state it started in.
    //       Leave the ancillas in the same state they started in.
    // Hint 1: The task can be completed using multiple CNOT and CCNOT gates. 
    // Hint 2: 3-input Majority function can be expressed as: 
    //      Maj3(|x0⟩,|x1⟩,|x2⟩) = ((|x0⟩ ⊕ |x1⟩) ∧ (|x1⟩ ⊕ |x2⟩)) ⊕ |x1⟩
    // Hint 3: Use the ancillas to perform intermediate computations.
    //       Once the intermediate values are no longer needed, 
    //       uncompute the intermediate values by reapplying the gates in
    //       reverse order. 

    operation Majority_Naive (x : Qubit[], a : Qubit[], y: Qubit) : Unit {
        
        body (...) {

            // ...
     
        }
        
        adjoint self;
    }

    // Task 4. Optimized reversible 3-input Majority function (Maj3)
    // Inputs:
    //      1) 3 qubits in an arbitrary state |x⟩ (input/control register)
    //      2) a qubit |y⟩ in state |0⟩ (target qubit)
    // Goal: Set the state of the target register to Maj3(|x0⟩,|x1⟩,|x2⟩).
    //       Leave the input register in the same state it started in.
    //       Do not use any ancillas.
    // Hint 1: The task can be completed using multiple CNOT and CCNOT gates. 
    // Hint 2: 3-input Majority function can be expressed as: 
    //      Maj3(|x0⟩,|x1⟩,|x2⟩) = ((|x0⟩ ⊕ |x1⟩) ∧ (|x1⟩ ⊕ |x2⟩)) ⊕ |x1⟩
    // Hint 3: Perform intermediate computations on the control lines.
    //       Once the intermediate values are no longer needed, 
    //       uncompute the intermediate values by reapplying the gates in
    //       reverse order.

    operation Majority_Optimized (x : Qubit[], y: Qubit) : Unit {
        
        body (...) {

            // ...
        }
        
        adjoint self;
    }
    
}
