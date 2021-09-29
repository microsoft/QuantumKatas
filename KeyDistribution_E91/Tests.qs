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
            "Generated array length does not match the input length"
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
        let N = 5;
        let basesArray = RandomBasesArray_Reference([1, 2, 3, 4], N);

        use qs = Qubit[N];
        let results = MeasureQubitArray_Reference(qs, basesArray);

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
    function T24_GenerateSharedKey() : Unit {
        // ...
    }


    @Test("QuantumSimulator")
    function T31_CorrelationCheck() : Unit {
        // ...
    }

    @Test("QuantumSimulator")
    operation T32_Eavesdrop() : Unit {
        // ...
    }

}
