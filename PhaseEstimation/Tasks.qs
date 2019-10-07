// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.PhaseEstimation {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The "Phase estimation" quantum kata is a series of exercises designed
    // to teach you the basics of phase estimation algorithms.
    // It covers the following topics:
    //  - quantum phase estimation,
    //  - iterative phase estimation,
    //  - preparing necessary inputs to phase estimation routines and applying them.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // Within each section, tasks are given in approximate order of increasing difficulty;
    // harder ones are marked with asterisks.
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Quantum phase estimation (QPE)
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. Inputs to QPE: eigenstates of Z/S/T gates.
    // Inputs:
    //      1) a qubit in |0⟩ state.
    //      2) an integer indicating which eigenstate to prepare.
    // Goal: 
    //      Prepare one of the eigenstates of Z gate (which are the same as eigenstates of S or T gates):
    //      eigenstate |0⟩ if state = 0, or eigenstate |1⟩ if state = 1.
    operation Eigenstates_ZST (q : Qubit, state : Int) : Unit
    is Adj {
        // ...
    }


    // Task 1.2. Inputs to QPE: powers of Z/S/T gates.
    // Inputs:
    //      1) a single-qubit unitary U.
    //      2) a positive integer power.
    // Output:
    //      A single-qubit unitary equal to U raised to the given power.
    function UnitaryPower (U : (Qubit => Unit is Adj + Ctl), power : Int) : (Qubit => Unit is Adj + Ctl) {
        // Hint: Remember that you can define auxiliary operations.

        // ...

        // Currently this function returns the input unitary for the sake of being able to compile the code.
        // You will need to return your own unitary instead of U.
        return U;
    }


    // Task 1.3. Validate inputs to QPE
    // Inputs:
    //      1) a single-qubit unitary U.
    //      2) a single-qubit state |ψ⟩ represented by a unitary P such that |ψ⟩ = P|0⟩
    //         (i.e., applying the unitary P to state |0⟩ prepares state |ψ⟩).
    // Goal:
    //      Assert that the given state is an eigenstate of the given unitary,
    //      i.e., do nothing if it is, and throw an exception if it is not.
    operation AssertIsEigenstate (U : (Qubit => Unit), P : (Qubit => Unit is Adj)) : Unit {
        // ...
    }


    // Task 1.4. QPE for single-qubit unitaries
    // Inputs: 
    //      1) a single-qubit unitary U.
    //      2) a single-qubit eigenstate of U |ψ⟩ represented by a unitary P such that |ψ⟩ = P|0⟩
    //         (i.e., applying the unitary P to state |0⟩ prepares state |ψ⟩).
    //      3) an integer n.
    // Output:
    //      The phase of the eigenvalue that corresponds to the eigenstate |ψ⟩, with n bits of precision.
    //      The phase should be between 0 and 1.
    operation QPE (U : (Qubit => Unit is Adj + Ctl), P : (Qubit => Unit is Adj), n : Int) : Double {
        // ...
        return -1.0;
    }


    // Task 1.5. Test your QPE implementation
    // Goal: Use your QPE implementation from task 1.4 to run quantum phase estimation 
    //       on several simple unitaries and their eigenstates.
    // This task is not covered by a test and allows you to experiment with running the algorithm.
    operation T15_E2E_QPE_Test () : Unit {
        // ...
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Iterative phase estimation
    //////////////////////////////////////////////////////////////////
    
    // Unlike quantum phase estimation, which is a single algorithm, 
    // iterative phase estimation is a whole class of algorithms based on the same idea:
    // treating phase estimation as a classical algorithm which learns the phase via a sequence of measurements
    // (the measurement performed on each iteration can depend on the outcomes of previous iterations).

    // A typical circuit for one iteration has the following structure:
    //
    //                 ┌───┐  ┌───┐       ┌───┐  ┌───┐
    // control:    |0>─┤ H ├──┤ R ├───┬───┤ H ├──┤ M ╞══
    //                 └───┘  └───┘┌──┴──┐└───┘  └───┘
    // eigenstate: |ψ>─────────────┤  Uᴹ ├──────────────
    //                             └─────┘
    // 
    // (R is a rotation gate, and M is a power of the unitary U;
    //  both depend on the current information about the phase).
    //
    // The result of the measurement performed on the top qubit defines the next iteration.


    // Task 2.1. Single-bit phase estimation
    // Inputs:
    //      1) a single-qubit unitary U that is guaranteed to have an eigenvalue +1 or -1 
    //         (with eigenphases 0.0 or 0.5, respectively).
    //      2) a single-qubit eigenstate of U |ψ⟩ represented by a unitary P such that |ψ⟩ = P|0⟩
    //         (i.e., applying the unitary P to state |0⟩ prepares state |ψ⟩).
    // Output:
    //      The eigenvalue which corresponds to the eigenstate |ψ⟩ (+1 or -1).
    //
    // You are allowed to allocate exactly two qubits and call Controlled U exactly once.
    operation SingleBitPE (U : (Qubit => Unit is Adj + Ctl), P : (Qubit => Unit is Adj)) : Int {
        // Note: It is possible to use the QPE implementation from task 1.4 to solve this task, 
        // but we suggest you implement the circuit by hand for the sake of learning.

        // ...
        return 0;
    }


    // Task 2.2. Two bit phase estimation
    // Inputs:
    //      1) a single-qubit unitary U that is guaranteed to have an eigenvalue +1, i, -1 or -i
    //         (with eigenphases 0.0, 0.25, 0.5 or 0.75, respectively).
    //      2) a single-qubit eigenstate of U |ψ⟩ represented by a unitary P such that |ψ⟩ = P|0⟩
    //         (i.e., applying the unitary P to state |0⟩ prepares state |ψ⟩).
    // Output:
    //      The eigenphase which corresponds to the eigenstate |ψ⟩ (0.0, 0.25, 0.5 or 0.75).
    // The returned value has to be accurate within the absolute error of 0.001.
    //
    // You are allowed to allocate exactly two qubits and call Controlled U multiple times.
    operation TwoBitPE (U : (Qubit => Unit is Adj + Ctl), P : (Qubit => Unit is Adj)) : Double {
        // Hint: Start by applying the same circuit as in task 2.1.
        //       What are the possible outcomes for each eigenvalue?
        //       What eigenvalues you can and can not distinguish using this circuit?

        // ...

        // Hint 2: What eigenvalues you can and can not distinguish using this circuit?
        //         What circuit you can apply to distinguish them?

        // ...
        return -1.0;
    }


    // To be continued...
}
