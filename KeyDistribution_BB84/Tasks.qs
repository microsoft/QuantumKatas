// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

namespace Quantum.Kata.KeyDistribution {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // The **Quantum Key Distribution** kata is a series of exercises 
    // designed to teach you about a neat quantum technology where you
    // can use qubits to exchange secure cryptographic keys. In 
    // particular, you will work through implementing and testing a 
    // quantum key distribution protocol called BB84. 
    
    // Background
    // What does a key distribution protocol look like in general? 
    // Normally there are two parties, commonly referred to as Alice 
    // and Bob, who want to share a random, secret string of bits 
    // called a _key_. This key can then be used for a variety of 
    // different cryptographic protocols like encryption or authentication. 
    // Quantum versions of key exchange protocols look very similar, 
    // and utilize qubits as a way to securely transmit the bit string. 
    // Alice and Bob have two connections, one quantum channel and 
    // one bidirectional classical channel. In this kata you will 
    // simulate what happens on the quantum channel by preparing 
    // and measuring a sequence of qubits and then perform classical 
    // operations to transform the measurement results to a usable, 
    // binary key.

    // There are a variety of different quantum key distribution protocols, 
    // however the most common is called BB84 after the initials of the 
    // authors and the year it was published. 
    // It is used in many existing commercial quantum key distribution 
    // devices that implement BB84 with single photons as the qubits. 
 
    // Each task is wrapped in one operation preceded by the description 
    // of the task. Each task (except tasks in which you have to write a 
    // test) has a unit test associated with it, which initially fails. 
    // Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////
	
    // Task 1.1. Diagonal Basis
    // Try your hand at converting qubits from the computational basis 
    // to the diagonal basis.
    // Input: N qubits (stored in an array of length N).
    //        Each qubit is either in |0⟩ or in |1⟩ state.
    // Goal:  Convert the qubits to diagonal polarization:
    //	      if qs[i] was in state |0⟩, it should become |+⟩ = (|0⟩ + |1⟩) / sqrt(2),
    //	      if qs[i] was in state |1⟩, it should become |-⟩ = (|0⟩ - |1⟩) / sqrt(2).
    operation DiagonalBasis (qs : Qubit[]) : Unit {
        // ...
    }


    // Task 1.2. Equal superposition
    // Input: A qubit in the |0⟩ state.
    // Goal:  Change the qubit state to a superposition state 
    //        that has equal probabilities of measuring 0 and 1.
    // Note: This is not the same as keeping the qubit in the |0⟩ state with 50% probability
    // and converting it to the |1⟩ state with 50% probability!
    operation EqualSuperposition (q : Qubit) : Unit {
        // ...
    }
    

    //////////////////////////////////////////////////////////////////
    // Part II. BB84 Protocol
    //////////////////////////////////////////////////////////////////
    
	// Task 2.1. Generate random array
    // You saw in part I that Alice has to make two random choices per 
    // qubit she prepares, one for which basis to prepare in, and the 
    // other for what bit value she wants to send.
    // Bob will also need one random bit value to decide what basis he 
    // will be measuring each qubit in.
    // To make this easier for later steps, you will need a way of 
    // generating random boolean values for both Alice and Bob to use.
    // Input:  An integer N.
    // Output: A Bool array of length N, where each element is chosen at random. 
    // 
    // Note: This will be used by both Alice and Bob to choose either the sequence 
    //       of bits to send or the sequence of bases (false indicates |0⟩/|1⟩ basis, 
    //       and true indicates |+⟩/|-⟩ basis) to use when encoding/measuring the bits.
    operation RandomArray (N : Int) : Bool[] {
        // ...
        return new Bool[N];
    }


    // Task 2.2. Prepare Alice's qubits
    // Now that you have a way of generating the random inputs needed 
    // for Alice and Bob, it's time for Alice to use the random bits 
    // to prepare her sequence of qubits to send to Bob.
    // Inputs:
    //      1) "qs": an array of N qubits in the |0⟩ states,
    //	    2) "bases": a Bool array of length N;
    //         bases[i] indicates the basis to prepare the i-th qubit in:
    //         - false: use |0⟩/|1⟩ (computational) basis
    //         - true: use |+⟩/|-⟩ (Hadamard/diagonal) basis
    //      3) "bits": a Bool array of length N;
    //         bits[i] indicates the bit to encode in the i-th qubit: false = 0, true = 1.
    // Goal: Prepare the qubits in the described state.
    operation PrepareAlicesQubits (qs : Qubit[], bases : Bool[], bits : Bool[]) : Unit {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        Fact(Length(qs) == Length(bases), "Input arrays should have the same length");
        Fact(Length(qs) == Length(bits), "Input arrays should have the same length");

        // ...
    }


    // Task 2.3. Measure Bob's qubits
    // Bob now has an incoming stream of qubits that he needs to measure by 
    // randomly choosing a basis to measure in for each qubit.
    // Inputs:
    //      1) "qs": an array of N qubits;
    //         each qubit is in one of the following states: |0⟩, |1⟩, |+⟩ or |-⟩.
    //	    2) "bases": a Bool array of length N;
    //         bases[i] indicates the basis used to prepare the i-th qubit:
    //         - false: use |0⟩/|1⟩ (computational) basis
    //         - true: use |+⟩/|-⟩ (Hadamard/diagonal) basis
    // Output: Measure each qubit in the corresponding basis and return an array of results 
    //         (encoding measurement result Zero as false and One as true).
    // Note: The state of the qubits at the end of the operation does not matter.
    operation MeasureBobsQubits (qs : Qubit[], bases : Bool[]) : Bool[] {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        Fact(Length(qs) == Length(bases), "Input arrays should have the same length");
        
        // ...
        return new Bool[0];
    }


    // Task 2.4. Generate the shared key!
    // Now, Alice has a list of the bit values she sent as well as what basis
    // she prepared each qubit in, and Bob has a list of bases he used to 
    // measure each qubit. To figure out the shared key, they need to 
    // figure out when they both used the same basis, and toss the data from 
    // qubits where they used different bases. If Alice and Bob did not use 
    // the same basis to prepare and measure the qubits in, the measurement 
    // results Bob got will be just random with 50% probability for both the 
    // "Zero" and "One" outcomes.
    // Inputs:
    //      1) "basesAlice" and "basesBob": Bool arrays of length N 
    //         describing Alice's and Bobs's choice of bases, respectively;
    //      2) "measurementsBob": a Bool array of length N describing Bob's measurement results.
    // Output: a Bool array representing the shared key generated by the protocol.
    // Note: You don't need to know both Alice's and Bob's bits to figure 
    //       out the shared key!
    function GenerateSharedKey (basesAlice : Bool[], basesBob : Bool[], measurementsBob : Bool[]) : Bool[] {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        Fact(Length(basesAlice) == Length(basesBob), "Input arrays should have the same length");
        Fact(Length(basesAlice) == Length(measurementsBob), "Input arrays should have the same length");

        // ...
        return new Bool[0];
    }


    // Task 2.5. Check if error rate was low enough
    // The main trace eavesdroppers can leave on a key exchange is to introduce
    // more errors into the transmission. Alice and Bob should have characterized
    // the error rate of their channel before launching the protocol, and need to make sure when exchanging 
    // the key that there were not more errors than they expected. The "errorRate" 
    // parameter represents their earlier characterization of their channel.
    // Inputs:
    //      1) "keyAlice" and "keyBob": Bool arrays of equal length N describing 
    //         the versions of the shared key obtained by Alice and Bob, respectively,
    //      2) "errorRate": an integer between 0 and 50 - the percentage of the bits 
    //         that did not match in Alice's and Bob's channel characterization.
    // Output: "true" if the percentage of errors is less than or equal to the error rate, 
    //          and "false" otherwise.
    function CheckKeysMatch (keyAlice : Bool[], keyBob : Bool[], errorRate : Int) : Bool {
        // The following lines enforce the constraints on the input that you are given.
        // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
        Fact(Length(keyAlice) == Length(keyBob), "Input arrays should have the same length");

        // ...
        return false;
    }


    // Task 2.6. Putting it all together 
    // Goal: Implement the entire BB84 protocol using tasks 2.1 - 2.5
    //       and following the comments in the operation template.
    // 
    // This is an open-ended task and is not covered by a test; 
    // you can run T26_BB84Protocol_Test to run your code.
    operation T26_BB84Protocol_Test () : Unit {
        // 1. Alice chooses a random set of bits to encode in her qubits 
        //    and a random set of bases to prepare her qubits in.
        // ...

        // 2. Alice allocates qubits, encodes them using her choices and sends them to Bob.
        //    (Note that you can not reflect "sending the qubits to Bob" in Q#)
        // ...

        // 3. Bob chooses a random set of bases to measure Alice's qubits in.
        // ...

        // 4. Bob measures Alice's qubits in his chosen bases.
        // ...

        // 5. Alice and Bob compare their chosen bases and use the bits in the matching positions to create a shared key.
        // ...

        // 6. Alice and Bob check to make sure nobody eavesdropped by comparing a subset of their keys
        //    and verifying that more than a certain percentage of the bits match.
        // For this step, you can check the percentage of matching bits using the entire key 
        // (in practice only a subset of indices is chosen to minimize the number of discarded bits).
        // ...

        // If you've done everything correctly, the generated keys will always match, since there is no eavesdropping going on.
        // In the next section you will explore the effects introduced by eavesdropping.
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Eavesdrop!
    // In this task you will try to implement an eavesdropper, Eve. 
    // Eve will intercept a qubit from the quantum channel that Alice and Bob are using. 
    // She will measure it in either the |0⟩/|1⟩ basis or the |+⟩/|-⟩ basis, and 
    // prepare a new qubit in the state she measured. Then she will send the 
    // new qubit back to the channel. 
    // Eve hopes that if she got lucky with her measurement, that when Bob 
    // measures the qubit he doesn't get an error so she won't be caught!
    //
    // Inputs:
    //      1) "q": a qubit in one of the following states: |0⟩, |1⟩, |+⟩ or |-⟩,
    //      2) "basis": Eve's guess of the basis she should use for measuring.
    //         Recall that false indicates |0⟩/|1⟩ basis and true indicates |+⟩/|-⟩ basis.
    // Output: the bit encoded in the qubit (false for |0⟩/|+⟩ states, true for |1⟩/|-⟩ states).
    // Note: In this task you are guaranteed that the basis you're given matches 
    //       the one in which the qubit is encoded, that is, if you are given a qubit in state
    //       |0⟩ or |1⟩, you will be given basis = false, and if you are given a qubit in state
    //       |+⟩ or |-⟩, you will be given basis = true. This is different from a real
    //       eavesdropping scenario, in which you have to guess the basis yourself.

    operation Eavesdrop (q : Qubit, basis : Bool) : Bool {
        // ...
        return false;
    }
    

    // Task 3.2. Catch the eavesdropper
    // Add an eavesdropper into the BB84 protocol from task 2.6.
    // Note that now we should be able to detect Eve and therefore we have to discard some of our key bits!
    //
    // This is an open-ended task and is not covered by a test; 
    // you can run T32_BB84ProtocolWithEavesdropper_Test to run your code.
    operation T32_BB84ProtocolWithEavesdropper_Test () : Unit {
        // ...
    }
}
