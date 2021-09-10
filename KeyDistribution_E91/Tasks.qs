// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

namespace Quantum.Kata.KeyDistributionE91 {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Random;



    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////
	
    // Task 1.1. Entangled Pairs
    // Inputs:
    //      1) "qsAlice": an array of N qubits in the |0⟩ states,
    //	    2) "qsBob": an array of N qubits in the |0⟩ states,
    // Goal: Create entangled pairs |Ψ⟩ = 1/√2 (|00⟩ + |11⟩) out of corresponding qubits of
    //        Alice's and Bob's qubits.
    operation EntangledPairs (qsAlice : Qubit[], qsBob : Qubit[]) : Unit {
        Fact(Length(qsAlice) == Length(qsBob), "Alice and Bob should have the same number of qubits");
        // ...

    }


    //////////////////////////////////////////////////////////////////
    // Part II. E91 Protocol
    //////////////////////////////////////////////////////////////////

    // Task 2.1 Rotate and Measure
    // One of the essential steps of E91 protocol is conducting measurement operations.
    // In Z-X plane, Alice measures her qubit in either one of Z, (Z+X)/√2 or X basis whereas
    // Bob measures his qubit in either one of (Z+X)/√2, X or (X-Z)/√2 basis. 
    // Inputs:
    //     1) "q": the qubit to be measured,
    //     2) "rotationMultiplier": an integer to me multiplied by π/4 to  
    //                              compute the rotation angle in Z-X plane,
    // Output: Result of the measurement
    // Goal: Rotate PauliZ basis and measure q in that new basis.
    operation RotateAndMeasure(q : Qubit, rotationMultiplier: Int) : Result {
        // ...

        return Zero;
    }

    // Task 2.2 Measure Qubit Arrays
    // Now that you have a way of measuring a qubit in a given direction, it's time to 
    // measure either Alice's or Bob's qubits in random bases selected from their respective
    // basis sets.
    // Inputs:
    //     1) "qs": An array of qubits to be measured,
    //     2) "basisListt": A list of 3 possible rotation mutlipliers.
    // Outputs:
    //     1) List of generated basis choices,
    //     2) List of measurement results.
    // Goal: Measure qubits from qs in bases constructed using rotation multipliers that
    //       are choosen randomly from basisList.
    operation MeasureQubitArray (qs: Qubit[], basisList: Int[]) : (Int[], Result[]) {
        let results = new Result[0];
        let bases = new Int[0];
        // ...

        return (bases, results);

    }

    // Task 2.3 Generate the shared key
    // After both Alice and Bob make their measurements and share their choices of bases, it
    // is possible to select compatible measurements and create a key out of these. You 
    // should compute that key for either Alice or Bob.
    // Inputs:
    //     1) "basesAlice": Alice's measurement bases multipliers,
    //     2) "basesBob": Bob's measurement bases multipliers,
    //     3) "results": Either Alice's or Bob's measurement outcomes.
    // Output: A Bool array whose elements are the bits of shared key. 
    function GenerateSharedKey (basesAlice: Int[], basesBob: Int[], results: Result[]) : Bool[] {
        let key = new Bool[0];
        // ...

        return key;
    }

    // Task 2.4 CHSH Correlation Check
    // Non-compatible measurements were not useful for creating secret keys, but they are very
    // for detecting an eavesdropper. Quantum mechanics tells us that the CHSH correlation value
    //     S = E(0, 1) - E(0, 3) + E(2, 1) + E(2, 3)
    // should be 2√2 when there is no eavesdropper and is less than √2 when someone is manipulating
    // the communication. The expectation value E(i, j) is the average value of outcomes when Alice
    // measures on a basis with rotation multiplier i and Bob measures on a basis with rotation 
    // multiplier j. You should remember that when computing measurement outcomes, you should 
    // use actual eigenvalues which are +1 for Zero and -1 for One.
    //
    // Inputs:
    //     1) "basesAlice": Alice's measurement bases multipliers,
    //     2) "basesBob": Bob's measurement bases multipliers,
    //     3) "resAlice": Alice's measurement outcomes,
    //     4) "resBob": Bob's measurement outcomes.
    // Output: CHSH correlation value.
    function CorrelationCheck(basesAlice: Int[], basesBob: Int[], resAlice: Result[], resBob: Result[]) : Double {
        // ...

        return 0.0;
    }

    // Task 2.5 Putting it all together 
    // Goal: Implement the entire BB84 protocol using tasks 1.1 - 2.3
    //       and following the comments in the operation template.
    // 
    // This is an open-ended task and is not covered by a test; 
    // you can run T26_BB84Protocol to run your code.
    @Test("QuantumSimulator")
    operation T25_E91Protocol () : Unit {

        // 1. Alice and Bob choose basis multipliers

        // 2. Alice and Bob are distributed arrays of entangled pairs

        // 3. Measurements by Alice and Bob

        // 4. Keys generated by Alice and Bob

        // 5. Compute the CHSH correlation value
        
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Eavesdrop!
    // In this task you will try to implement an eavesdropper, Eve. 
    // Eave will intercept the qubits before they are measured by Alice or Bob. Eve uses
    // one of Alice's and Bob's compatible basis, (Z+X)/√2 and X, for her measurement. This
    // way, she might be able to place some known values into Bob's and Alice's keys. 
    //
    // Inputs:
    //      1) "qAlice": a qubit that Alice will use,
    //      2) "qAlice": Bob's corresponding qubit,
    //      3) "basis": Eve's guess of the basis she should use for measuring.
    // Output: the bits encoded in given qubits.
    operation Eavesdrop (qAlice : Qubit, qBob : Qubit, basis : Int) : (Result, Result) {
        Fact(basis == 1 or basis == 2, "Eve should measure in one of Alice's and Bob's compatible basis");
        // ...

        return (Zero, Zero);
    }

    // Task 3.2. Catch the eavesdropper
    // Add an eavesdropper into the BB84 protocol from task 2.5.
    // Note that we should be able to detect Eve with a CHSH correlation check.
    //
    // This is an open-ended task and is not covered by a test; 
    // you can run T32_E91ProtocolWithEavesdropper() to run your code.
    @Test("QuantumSimulator")
    operation T32_E91ProtocolWithEavesdropper() : Unit {
        // 1. Alice and Bob choose basis multipliers

        // 2. Alice and Bob are distributed arrays of entangled pairs

        // Eve eavesdrops on all qubits, guessing the basis at random

        // 3. Measurements by Alice and Bob

        // 4. Keys generated by Alice and Bob

        // 5. Compute the CHSH correlation value

    }
}