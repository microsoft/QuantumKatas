// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Counting {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Arithmetic;    
    open Microsoft.Quantum.Characterization;
   
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The "Counting" quantum kata is a series of exercises designed
    // to get you familiar with Quantum Counting.
    // It covers the following topics:
    //  - writing oracles for counting,
    //  - performing actual counting.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // Within each section, tasks are given in approximate order of increasing difficulty;
    // harder ones are marked with asterisks.
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Oracle for Counting
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. The Sprinkler oracle
	// Let us consider an example inspired by the sprinkler problem of (Pearl 1988): 
	// we have three Boolean variable, s, r, w representing respectively propositions 
	// “the sprinkler was on”, "ıt rained last night” and “the grass is wet”. 
	// We know that if the sprinkler was on the grass is wet (s → w), 
	// if it rained last night the grass is wet (r → w) 
	// and that the the sprinkler being on and rain last night cannot be true at the same time (s, r →).
	// Transformed in conjunctive normal formal we obtain formula (¬s ∨ w) ∧ (¬r ∨ w) ∧ (¬s ∨ ¬r)
	// Let s,r,w=queryRegister[0],queryRegister[1],queryRegister[2]
	// Hint: to solve this task you also need to use ancilla qubits
	// This formula has 4 models out of 8 possible worlds

	operation Oracle_Sprinkler (queryRegister : Qubit[], target : Qubit, ancilla : Qubit[]) : Unit
    {    
	        body (...) {
			// ...
            }
			adjoint invert;
			controlled auto;
			controlled adjoint auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part I. Counting
    //////////////////////////////////////////////////////////////////
	// Implement counting using operations from ReferenceImplementation.qs
	// - UnitaryPowerImpl, for computing powers of a unitary operation
	// - GroverIteration for the Grover operator
	// - QuantumPhaseEstimation, for estimating the phase
	// Counting should return the number of models, 4 in this case
   operation Counting() : Double {

		// ....
		return 4.0;
    }
    
    
   
    
}
