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

        for mutliplier in 0 .. 3 {
            let res = RotateAndMeasure_Reference(q, mutliplier);
            within {
                Ry(IntAsDouble(mutliplier) * PI() / 4.0, q);
            } apply {
                AssertQubitWithinTolerance(res, q, 1e-5);
            }
            Reset(q);
        }
        
    }


    operation randomList<'T>(values: 'T[], count : Int) : 'T[] {
        let dist = DiscreteUniformDistribution(0,Length(values)-1);
        mutable outList = new 'T[0];

        for _ in 1 .. count {
            set outList += [values[dist::Sample()]];
        }
        return outList;
    }

    @Test("QuantumSimulator")
    operation T22_MeasureQubitArray() : Unit {
        let basisList = [0, 1, 2, 3];
        use qs = Qubit[5];

        let (bs, rs) = MeasureQubitArray_Reference(qs, basisList);

        for (q, b, r) in Zipped3(qs, bs, rs) {
            Message($"b = {b}, m = {r}");
            DumpMachine();
            within {
                Ry(IntAsDouble(b) * PI() / 4.0, q);
            } apply {
                AssertQubitWithinTolerance(r, q, 1e-5);
            }
            Reset(q);
        }

    }

    @Test("QuantumSimulator")
    function T23_GenerateSharedKey() : Unit {
        // ...
    }


    @Test("QuantumSimulator")
    function T24_CorrelationCheck() : Unit {
        // ...
    }

    @Test("QuantumSimulator")
    operation T31_Eavesdrop() : Unit {
        // ...
    }

}
