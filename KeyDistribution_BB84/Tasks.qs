namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    
    
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

    // Task 1.1. 
    // Transform the quibit q in a random state 0 or 1. The qubit is 
    // guaranteed to be in the state |0> and after this operation there 
    // should be a 50% chance of it remaining 0 and a 50% chance of being 
    // |1>
    operation Task11 (q : Qubit) : Unit {
        // ...
    }

    // Task 1.2. 
    // Prepare the bit string of arbitrary length (> 0) such that each 
    // qubit is in a random state 0 or 1. You may assume that all qubits 
    // in qs will be in the state |0>.
    operation Task12 (qs : Qubit[]) : Unit {
        // ...
    }

    // Task 1.3.
    // Prepare qs with a diagonal polarization. Each bit in qs should be 
    // prepared as follows:
    //		if qs[i] is |0>, should become (|0> + |1>)/sqrt(2)
    //		if qs[i] is |1>, should become (|0> - |1>)/sqrt(2)
    // All qubits in qs will be either |0> or |1>.
    operation Task13 (qs : Qubit[]) : Unit {
        // ...
    }
    
    //////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1: Prepare Alice's qubits
    // Prepare the qubits that Alice will send to Bob
    // Input:
    //	qs: N qubits in the 0 states
    //	basis: An Int array of length N where the integer at index i indicates
    //	what basis to prepare the ith qubit in
    //		0: 0/1 (rectangular) basis
    //		1: +/- (diagonal) basis
    //	bits: An Int array of length N where the integer at index i indicates
    //	which bit to encode in the ith qubit
    operation Task21_PrepareAlice(qs : Qubit[], basis : Int[], bits : Int[]) : Unit {
        // The next two lines are to ensure that the inputs are all the same length
        AssertIntEqual(Length(qs), Length(basis), "Input arrays should be the same length");
        AssertIntEqual(Length(qs), Length(bits), "Input arrays should be the same length");

        // ...
    }

    // Task 2.2: Choosing the basis
    // Return an Int array where the value at each index represents a randomly
    // chosen basis. Values should be either 0 (0/1 basis) or 1 (+/- basis)
    // Inputs: 
    //	N: length of output array
    operation Task22_ChooseBasis(N : Int) : Int[] {
        // ...
        return new Int[N];
    }

    // Task 2.3: Bob measures qubits
    // Measure the given qubits in the bases and return the result of the measurements
    // Inputs:
    //	qs: N qubits in an arbitrary state 
    //	basis: An Int array of length N where the integer at index i indicates
    //	what basis to measure the ith qubit in
    //		0: 0/1 (rectangular) basis
    //		1: +/- (diagonal) basis
    // Outputs:
    //	return an Int array of the measurement results
    operation Task23_Measure(qs : Qubit[], basis : Int[]) : Int[] {
        // The following line ensures that the inputs are all the same length
        AssertIntEqual(Length(qs), Length(basis), "Input arrays should be the same length");

        // ...
        return new Int[3];
    }

    // Task 2.4: Generate the key!
    // Given Alice's choice of basis states, Bob's choice of basis states, and Bob's 
    // measurement results, return the shared key that Alice and Bob will use to
    // communicate.
    // Inputs:
    //	bAlice: Alice's basis states
    //	bBob: Bob's basis states
    //	res: Bob's measurement results
    // Ouput:
    //	return an Int array representing Alice and Bob's shared key
    operation Task24_GenerateKey(bAlice : Int[], bBob : Int[], res : Int[]) : Int[] {
        // The next two lines are to ensure that the inputs are all the same length
        AssertIntEqual(Length(bAlice), Length(bBob), "Input arrays should be the same length");
        AssertIntEqual(Length(bAlice), Length(res), "Input arrays should be the same length");

        // ...
        return new Int[3];
    }

    // Task 2.5: Was communication secure?
    // Given matching subsets of Alice and Bob's keys (ex: indicies 3-10 of Alice's key 
    // and indicies 3-10 of Bob's key), check to see if at least a given
    // percentage of these bits match
    // Inputs:
    //	keyA: subset of Alice's key
    //	keyB: subset of Bob's key
    //	p: Minimum percentage of matching bits
    // OUtput:
    //	return true if the percentage of matching bits is greater than or equal
    //	to the minimum percentage and false otherwise
    operation Task25_CheckKeysMatch(keyA : Int[], keyB : Int[], p : Double) : Bool {
        // The following line ensures that the inputs are all the same length
        AssertIntEqual(Length(keyA), Length(keyB), "Input arrays should be the same length");

        //...
        return false;
    }

    // Task 2.6: Put it all together 
    // Let's implement the entire code flow for Quantum Key Distribution 
    // protocol by following the steps of the BB84 protocol.
    // Steps of BB84 Protocol
    //		1. Alice prepares her qubits in the specified bases and states
    //		2. Bob chooses randomly between the rectangular and diagonal bases to measure Alice's 
    //		qubits in
    //		3. Bob measures Alice's qubits in his chosen bases
    //		4. Alice and Bob compare bases and use the results from the matching bases to create a 
    //		shared key
    //		5. Alice and Bob check to make sure nobody evesdropped by comparing a subset of their keys
    //		and checking to see if more than a certain percentage of the bits match
    // Given a qubit register and the states/bases to encode the qubits in, implement the steps of
    // BB84 protocol. For Step 5, check the percentage on the entire key instead of choosing a subset 
    // of indicies (in practice only a subset of indicies is chosen to minimize the how much 
    // information about the key is shared).
    // Inputs:
    //	qs: N qubits in the 0 state
    //	basis: An Int array of length N where the integer at index i indicates
    //	what basis to prepare the ith qubit in
    //		0: 0/1 (rectangular) basis
    //		1: +/- (diagonal) basis
    //	bits: An Int array of length N where the integer at index i indicates
    //	which bit to encode i nthe ith qubit
    //	p: Minimum percentage of matching bits
    // Output:
    //	If the percentage of matching bits is below p, return an empty array. Otherwise,
    //	return the shared key
    operation Task26_BB84(qs : Qubit[], basis : Int[], bits : Int[], p : Double) : Int[] {
        // ...
        return new Int[0];
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    // Task 3.1.
    // Implement an eavsedropper, Eve. Eve will intercept a qubit, q from 
    // the quantum channel that Alice and Bob are using. She will measure 
    // in the basis defined in the basis parameter, b, (0 for rectangular and 
    // 1 for diagonal), reconstruct the qubit into the original state q, 
    // and return her measurement. Eve hopes that if she properly 
    // reconstructs the qubit after measurement she won't be caught!
    operation Task31 (q : Qubit, b : Int) : Int {
        // ...
        return 0;
    }
        
    // Task 3.2.
    // Add an eavesdropper into the BB84 protocol (Task 2.6). 
    // Note that this changes the test for this task: We are able to detect 
    // Eve and therefore we throw out some of our keys!
    operation Task32 (qs : Qubit[], basis : Int[], state : Int[], p : Double) : Int[] {
        // ...
        return new Int[0];
    }
}
