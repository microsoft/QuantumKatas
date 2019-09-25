// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // "Key Distribution" quantum kata is a series of exercises designed
    // to get you familiar with programming in Q#.
    // It covers the BB84 protocol for quantum key distribution. The BB84 Protocol
    // allows two parties, Alice and Bob, to share a random secret key. 
    
    // Each task is wrapped in one operation preceded by the description 
    // of the task. Each task (except tasks in which you have to write a 
    // test) has a unit test associated with it, which initially fails. 
    // Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    

    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////
	
    // Task 1.1. Diagonal polarization
    // Input: N qubits (stored in an array of length N).
    //        Each qubit is either in |0⟩ or in |1⟩ state.
    // Goal:  Convert the qubits to diagonal polarization:
    //	      if qs[i] was |0⟩, it should become |+⟩ = (|0⟩ + |1⟩) / sqrt(2),
    //	      if qs[i] was |1⟩, it should become |-⟩ = (|0⟩ - |1⟩) / sqrt(2).
    operation DiagonalPolarization (qs : Qubit[]) : Unit {
        // ...
    }


    // Task 1.2. Equal superposition.
    // Input: A qubit in the |0⟩ state.
    // Goal:  Change the qubit state to a superposition state 
    //        that has equal probabilities of measuring 0 and 1.
    // Note that this is not the same as keeping the qubit in the |0⟩ state with 50% probability
    // and converting it to the |1⟩ state with 50% probability!
    operation EqualSuperposition (q : Qubit) : Unit {
        // ...
    }
    

    //////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////
    
	// Task 2.1: Choosing the basis
    // Return a Bool array where the value at each index represents a randomly
    // chosen basis. Values should be either false (0/1 basis) or true (+/- basis)
    // Inputs: 
    //	N: length of output array
    operation Task21_ChooseBasis(N : Int) : Bool[] {
        // ...
        return new Bool[N];
    }


    // Task 2.2: Prepare Alice's qubits
    // Prepare the qubits that Alice will send to Bob
    // Input:
    //	qs: N qubits in the 0 states
    //	basis: A Bool array of length N where the integer at index i indicates
    //	what basis to prepare the i-th qubit in
    //		false: 0/1 (rectangular) basis
    //		true: +/- (diagonal) basis
    //	bits: A Bool array of length N where the value at index i indicates
    //	which bit to encode in the i-th qubit (false = 0, true = 1)
    operation Task22_PrepareAlice(qs : Qubit[], basis : Bool[], bits : Bool[]) : Unit {
        // The next two lines are to ensure that the inputs are all the same length
        Fact(Length(qs) == Length(basis), "Input arrays should be the same length");
        Fact(Length(qs) == Length(bits), "Input arrays should be the same length");

        // ...
    }


    // Task 2.3: Bob measures qubits
    // Measure the given qubits in the bases and return the result of the measurements
    // Inputs:
    //	qs: N qubits in an arbitrary state 
    //	basis: A Bool array of length N where the integer at index i indicates
    //	what basis to measure the i-th qubit in
    //		false: 0/1 (rectangular) basis
    //		true: +/- (diagonal) basis
    // Outputs:
    //	return a bool array of the measurement results (false = Zero, true = One)
    operation Task23_Measure(qs : Qubit[], basis : Bool[]) : Bool[] {
        // The following line ensures that the inputs are all the same length
        Fact(Length(qs) == Length(basis), "Input arrays should be the same length");
        
        // ...
        return new Bool[3];
    }


    // Task 2.4: Generate the key!
    // Given Alice's choice of basis states, Bob's choice of basis states, and Bob's 
    // measurement results, return the shared key that Alice and Bob will use to
    // communicate.
    // Inputs:
    //	bAlice: Alice's basis states
    //	bBob: Bob's basis states
    //	res: Bob's measurement results
    // Output:
    //	return a Bool array representing Alice and Bob's shared key
    operation Task24_GenerateKey(bAlice : Bool[], bBob : Bool[], res : Bool[]) : Bool[] {
        // The next two lines are to ensure that the inputs are all the same length
        Fact(Length(bAlice) == Length(bBob), "Input arrays should be the same length");
        Fact(Length(bAlice) == Length(res), "Input arrays should be the same length");

        // ...
        return new Bool[3];
    }


    // Task 2.5: Was communication secure?
    // Given matching subsets of Alice and Bob's keys (ex: indices 3-10 of Alice's key 
    // and indices 3-10 of Bob's key), check to see if at least a given
    // percentage of these bits match
    // Inputs:
    //	keyA: subset of Alice's key
    //	keyB: subset of Bob's key
    //	p: Minimum percentage of matching bits
    // OUtput:
    //	return true if the percentage of matching bits is greater than or equal
    //	to the minimum percentage and false otherwise
    operation Task25_CheckKeysMatch(keyA : Bool[], keyB : Bool[], p : Double) : Bool {
        // The following line ensures that the inputs are all the same length
        Fact(Length(keyA) == Length(keyB), "Input arrays should be the same length");

        //...
        return false;
    }


    // Task 2.6: Put it all together 
    // Let's implement the entire code flow for Quantum Key Distribution 
    // protocol by following the steps of the BB84 protocol.
    // Steps of BB84 Protocol
    //		1. Alice chooses a random set of bits to encode in her qubits and a random set of 
	//         bases to prepare her qubits in
	//      2. Alice prepares her qubits according to the bits and bases she chose
    //		3. Bob chooses randomly between the rectangular and diagonal bases to measure Alice's 
    //		   qubits in
    //		4. Bob measures Alice's qubits in his chosen bases
    //		5. Alice and Bob compare bases and use the results from the matching bases to create a 
    //		   shared key
    //		6. Alice and Bob check to make sure nobody eavesdropped by comparing a subset of their keys
    //		   and checking to see if more than a certain percentage of the bits match
    // Given a qubit register, implement the steps of the BB84 protocol. For Step 6, check the 
	// percentage on the entire key instead of choosing a subset of indices (in practice only 
	// a subset of indices is chosen to minimize how much information about the key is shared).
    // Inputs:
    //	qs: N qubits in the 0 state
    //	p: Minimum percentage of matching bits
    // Output:
    //	If the percentage of matching bits is below p, return an empty array. Otherwise,
    //	return the shared key
	// Note: This task is open-ended and therefore does not have a test
    operation Task26_BB84(qs : Qubit[], p : Double) : Bool[] {
        // ...
        return new Bool[0];
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    // Task 3.1.
    // Implement an eavesdropper, Eve. Eve will intercept a qubit, q from 
    // the quantum channel that Alice and Bob are using. She will measure 
    // in the basis defined in the basis parameter, basis, (false for rectangular and 
    // true for diagonal), reconstruct the qubit into the original state q, 
    // and return her measurement. Eve hopes that if she properly 
    // reconstructs the qubit after measurement she won't be caught!
    operation Task31 (q : Qubit, basis : Bool) : Int {
        // ...
        return 0;
    }
    

    // Task 3.2.
    // Add an eavesdropper into the BB84 protocol (Task 2.6). 
    // Note that this changes the test for this task: We are able to detect 
    // Eve and therefore we throw out some of our keys!
    operation Task32 (qs : Qubit[], p : Double) : Bool[] {
        // ...
        return new Bool[0];
    }
}
