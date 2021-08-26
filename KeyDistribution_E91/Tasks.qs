// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

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
    // Goal: Create entangled pairs |Ψ⟩ = 1/√2 (|01⟩ + |10⟩) out of corresponding qubits of
    //        Alice's and Bob's qubits.
    operation EntangledPairs (qsAlice : Qubit[], qsBob : Qubit[]) : Unit {
        // ...
        Fact(Length(qsAlice) == Length(qsBob), "Alice and Bob should have the same number of qubits");

        for i in 0 .. Length(qsAlice) - 1 {
            H(qsAlice[i]);
            CNOT(qsAlice[i], qsBob[i]);
            X(qsAlice[i]);
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. E91 Protocol
    //////////////////////////////////////////////////////////////////


    // Task 2.1 Rotate and Measure
    // Inputs:
    //     1) "q": the qubit to be measured,
    //     2) "rotationMultiplier": an integer to me multiplied by π/4 to calculate 
    //                              the rotation angle,
    // Goal: Rotate PauliZ basis and measure q in that new basis.
    operation RotateAndMeasure(q : Qubit, rotationMultiplier: Int) : Result {

        // Bases obtained for the different values of  rotation multiplier are:
        // 0 -> X
        // 1 -> X+Z
        // 2 -> Z
        // 3 -> Z-X

        if rotationMultiplier == 0 {
            H(q);
        } elif rotationMultiplier == 1 {
            within {
                H(q);
            } apply {
                T(q);
            }
        } elif rotationMultiplier == 2 {
            I(q);
        } elif rotationMultiplier == 3 {
            within {
                H(q);
            } apply {
                Adjoint T(q);
            }
        }
        return M(q);
    }

    // Task 2.2 Measure Qubit Arrays
    // Inputs:
    //     1) "qs": An array of qubits to be measured,
    //     2) "basisDist": A DiscreteDistribution of possible rotation mutlipliers.
    // Goal: Measure qubits from qs in bases constructed with rotation multipliers that
    //       are choosen randomly from basisDist.
    operation MeasureQubitArray (qs: Qubit[], basisDist: DiscreteDistribution) : (Int[], Result[]) {
        mutable results = new Result[0];
        mutable bases = new Int[0];
        
        for i in 0 .. Length(qs) - 1 {
            let basis = basisDist::Sample();

            set bases += [basis];
            set results += [RotateAndMeasure(qs[i], basis)];
        }

        return (bases, results);

    }

    // Task 2.3 Generate the shared key
    // Inputs:
    //     1) "basesAlice": Alice's measurement bases multipliers,
    //     2) "basesBob": Bob's measurement bases multipliers,
    //     3) "results": Either Alice's or Bob's measurement outcomes
    // Goal: Using both Alice's and Bob's bases of measurement, construct the shared key that
    //       will be used by either one of them.
    function GenerateSharedKey (basesAlice: Int[], basesBob: Int[], results: Result[]) : Bool[] {
        mutable key = new Bool[0];
        for (a, b, r) in Zipped3(basesAlice, basesBob, results) {
            if a == b {
                set key += [ResultAsBool(r)];
            }
        }
        
        return key;
    }


    // Task 2.4 Putting it all together 
    // Goal: Implement the entire BB84 protocol using tasks 1.1 - 2.3
    //       and following the comments in the operation template.
    // 
    // This is an open-ended task and is not covered by a test; 
    // you can run T26_BB84Protocol to run your code.

    @Test("QuantumSimulator")
    operation E91_Protocol () : Unit {

        // Basis distributions for Alice and Bob
        let basisDistAlice = DiscreteUniformDistribution(0, 2);
        let basisDistBob = DiscreteUniformDistribution(1, 3);

        use (qsAlice, qsBob) = (Qubit[10] ,Qubit[10]) {
            
            // Entangled pair preparation
            EntangledPairs(qsAlice, qsBob);

            // Measurements by Alice and Bob
            let (basesAlice, resAlice) = MeasureQubitArray(qsAlice, basisDistAlice);
            let (basesBob, resBob) = MeasureQubitArray(qsBob, basisDistBob);

            // Keys generated by Alice and Bob
            let keyAlice = GenerateSharedKey(basesAlice, basesBob, resAlice);
            let keyBob = GenerateSharedKey(basesAlice, basesBob, resBob);

            // TODO: Add correlation check

        }
    }

    // TODO: Simulate eavesdropper case
}