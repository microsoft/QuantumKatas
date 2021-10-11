// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.KeyDistributionE91 {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Random;


    //////////////////////////////////////////////////////////////////
    // Part I. Preparation
    //////////////////////////////////////////////////////////////////

    @Test("QuantumSimulator")
    operation T11_EntangledPairst() : Unit {
        use qsAlice = Qubit[2];
        use qsBob = Qubit[2];

        EntangledPairs(qsAlice, qsBob);
        Adjoint EntangledPairs_Reference(qsAlice, qsBob);

        AssertAllZero(qsAlice + qsBob);
    }
    

    //////////////////////////////////////////////////////////////////
    // Part II. E91 Protocol
    //////////////////////////////////////////////////////////////////

    @Test("QuantumSimulator")
    operation T21_RotateAndMeasure() : Unit {
        use q = Qubit();

        for basisIndex in 1..4 {
            let res = RotateAndMeasure(q, basisIndex);
            let rotationAngle = PI() * IntAsDouble(basisIndex - 1) / 4.0;
            within {
                Ry(rotationAngle, q);
            } apply {
                AssertQubitWithinTolerance(res, q, 1e-5);
            }
            Reset(q);
        }
    }

    @Test("QuantumSimulator")
    operation T22_RandomBasesArray() : Unit {
        let N = 5;
        let basesIndices = [1,2,3];

        let basesArray = RandomBasesArray(basesIndices, N);
        EqualityFactI(
            Length(basesArray), N,
            $"Generated array should be of length {N}"
            );

        for i in basesArray {
            mutable indexInRange = false;
            for j in basesIndices { 
                if i == j {
                    set indexInRange = true;
                }
            }
            Fact(
                indexInRange, 
                $"element {i} is not a member of bases array {basesIndices}"
                );
        }
    }

    @Test("QuantumSimulator")
    operation T23_MeasureQubitArray() : Unit {
        let N = 10;

        let basesArray = RandomBasesArray_Reference([1, 2, 3, 4], N);
        use qs = Qubit[N];

        let results = MeasureQubitArray(qs, basesArray);

        for (q, b, r) in Zipped3(qs, basesArray, results) {
            // At this point, qubit should be projected onto an
            // eigenstate of b. 
            let rotationAngle = PI() * IntAsDouble(b - 1) / 4.0;

            within {
                Ry(rotationAngle, q);
            } apply {
                AssertQubitWithinTolerance(r, q, 1e-4);   
            }
        }
        ResetAll(qs);
    }

    @Test("QuantumSimulator")
    operation T24_GenerateSharedKey() : Unit {
        let N = 10;

        mutable basesAlice = new Int[0];
        mutable basesBob = new Int[0];
        mutable results = new Result[0];
        
        for _ in 1..N {
            set basesAlice += [DrawRandomInt(1,3)];
            set basesBob += [DrawRandomInt(2,4)];
            set results += [BoolAsResult(DrawRandomBool(0.5))];
        }

        let actual = GenerateSharedKey(basesAlice, basesBob, results);
        let expected = GenerateSharedKey_Reference(basesAlice, basesBob, results);


        AllEqualityFactB(
            actual, expected, 
            $"Generated key {actual} does not match the expected value {expected}."
        );
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Eavesdropping
    //////////////////////////////////////////////////////////////////

    @Test("QuantumSimulator")
    operation T31_CorrelationValue() : Unit {
        let N = 10;
        use (qsAlice, qsBob) = (Qubit[N] ,Qubit[N]);
        EntangledPairs_Reference(qsAlice, qsBob);

        for (qAlice, qBob) in Zipped(qsAlice, qsBob) {
            let _ = Eavesdrop_Reference(qAlice, qBob, DrawRandomInt(2,3));
        }

        let basesAlice = RandomBasesArray_Reference([1,2,3], N);
        let basesBob = RandomBasesArray_Reference([2,3,4], N);

        let resultsAlice = MeasureQubitArray_Reference(qsAlice, basesAlice);
        let resultsBob = MeasureQubitArray_Reference(qsBob, basesBob);

        let actual = CorrelationValue(basesAlice, basesBob, resultsAlice, resultsBob);
        let expected = CorrelationValue_Reference(basesAlice, basesBob, resultsAlice, resultsBob);
        
        Fact(actual == expected, $"Correlation value {actual} does not match the expected value {expected}.");

        ResetAll(qsAlice + qsBob);
    }

    @Test("QuantumSimulator")
    operation T32_Eavesdrop() : Unit {
        for basisIndex in 2..3 {
            use (qAlice, qBob) = (Qubit(), Qubit());
            EntangledPairs_Reference([qAlice], [qBob]);
            
            let (r1, r2) = Eavesdrop(qAlice, qBob, basisIndex);
            
            // Make sure entanglement was not disturbed until measurement
            Fact(r1 == r2, "Measurement outcomes do not match for given qubits.");

            for q in [qAlice, qBob] {
                let rotationAngle = PI() * IntAsDouble(basisIndex - 1) / 4.0;

                // Make sure of the wavefunction collapse
                within {
                    Ry(rotationAngle, q);
                } apply {
                    AssertQubitWithinTolerance(r1, q, 1e-5);
                }
            }
    
            ResetAll([qAlice, qBob]);
        }        
    }

}
