// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Testing;

    // ------------------------------------------------------
    operation ApplyOracle (qs : Qubit[], oracle : ((Qubit[], Qubit) => ())) : ()
    {
        body
        {
            let N = Length(qs);
            oracle(qs[0..N-2], qs[N-1]);
        }
    }

    // ------------------------------------------------------
    operation ApplyOracleA (qs : Qubit[], oracle : ((Qubit[], Qubit) => () : Adjoint)) : ()
    {
        body
        {
            let N = Length(qs);
            oracle(qs[0..N-2], qs[N-1]);
        }
        adjoint auto;
    }

    // ------------------------------------------------------
    operation AssertTwoOraclesAreEqual (nQubits : Range, 
            oracle1 : ((Qubit[], Qubit) => ()), 
            oracle2 : ((Qubit[], Qubit) => () : Adjoint)) : ()
    {
        body
        {
            let sol = ApplyOracle(_, oracle1);
            let refSol = ApplyOracleA(_, oracle2);
            for (i in nQubits) {
                AssertOperationsEqualReferenced(sol, refSol, i+1);
            }
        }
    }
    
    // ------------------------------------------------------
    operation T11_Oracle_Zero_Test () : ()
    {
        body
        {
            AssertTwoOraclesAreEqual(1..10, Oracle_Zero, Oracle_Zero_Reference);
        }
    }

    // ------------------------------------------------------
    operation T12_Oracle_One_Test () : ()
    {
        body
        {
            AssertTwoOraclesAreEqual(1..10, Oracle_One, Oracle_One_Reference);
        }
    }

    // ------------------------------------------------------
    operation T13_Oracle_Kth_Qubit_Test () : ()
    {
        body
        {
            let maxQ = 6;
            // loop over index of the qubit to be used
            for (k in 0..maxQ-1) {
                // number of qubits to try is from k+1 to 6
                AssertTwoOraclesAreEqual(k+1..maxQ, Oracle_Kth_Qubit(_, _, k), Oracle_Kth_Qubit_Reference(_, _, k));
            }
        }
    }

    // ------------------------------------------------------
    operation T14_Oracle_OddNumberOfOnes_Test () : ()
    {
        body
        {
            // cross-test: for 1 qubit it's the same as Kth_Qubit for k = 0
            AssertTwoOraclesAreEqual(1..1, Oracle_OddNumberOfOnes, Oracle_Kth_Qubit_Reference(_, _, 0));

            AssertTwoOraclesAreEqual(1..10, Oracle_OddNumberOfOnes, Oracle_OddNumberOfOnes_Reference);
        }
    }

    // ------------------------------------------------------
    operation AssertTwoOraclesWithIntAreEqual (r : Int[],  
            oracle1 : ((Qubit[], Qubit, Int[]) => ()), 
            oracle2 : ((Qubit[], Qubit, Int[]) => () : Adjoint)) : ()
    {
        body
        {
            AssertTwoOraclesAreEqual(Length(r)..Length(r), oracle1(_, _, r), oracle2(_, _, r));
        }
    }

    operation T15_Oracle_ProductFunction_Test () : ()
    {
        body
        {
            // cross-tests
            // the mask for all 1's corresponds to Oracle_OddNumberOfOnes
            mutable r = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            let L = Length(r);
            for (i in 2..L) {
                AssertTwoOraclesAreEqual(i..i, Oracle_ProductFunction(_, _, r[0..i-1]), Oracle_OddNumberOfOnes_Reference);
            }

            // the mask with all 0's corresponds to Oracle_Zero
            for (i in 0..L-1) {
                set r[i] = 0;
            }
            for (i in 2..L) {
                AssertTwoOraclesAreEqual(i..i, Oracle_ProductFunction(_, _, r[0..i-1]), Oracle_Zero_Reference);
            }

            // the mask with only the K-th element set to 1 corresponds to Oracle_Kth_Qubit
            for (i in 0..L-1) {
                set r[i] = 1;
                AssertTwoOraclesAreEqual(L..L, Oracle_ProductFunction(_, _, r), Oracle_Kth_Qubit_Reference(_, _, i));
                set r[i] = 0;
            }

            set r = [1; 0; 1; 0; 1; 0];
            AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);

            set r = [1; 0; 0; 1];
            AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);

            set r = [0; 0; 1; 1; 1];
            AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);
        }
    }

    operation T16_Oracle_ProductWithNegationFunction_Test () : ()
    {
        body
        {
            // cross-tests
            // the mask for all 1's corresponds to Oracle_OddNumberOfOnes
            mutable r = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            let L = Length(r);
            for (i in 2..L) {
                AssertTwoOraclesAreEqual(i..i, Oracle_ProductWithNegationFunction(_, _, r[0..i-1]), Oracle_OddNumberOfOnes_Reference);
            }

            set r = [1; 0; 1; 0; 1; 0];
            AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductWithNegationFunction, Oracle_ProductWithNegationFunction_Reference);

            set r = [1; 0; 0; 1];
            AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductWithNegationFunction, Oracle_ProductWithNegationFunction_Reference);

            set r = [0; 0; 1; 1; 1];
            AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductWithNegationFunction, Oracle_ProductWithNegationFunction_Reference);
        }
    }

    operation T17_Oracle_HammingWithPrefix_Test () : ()
    {
        body
        {
            mutable prefix = [1];
            AssertTwoOraclesAreEqual(1..10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));

            set prefix = [1; 0];
            AssertTwoOraclesAreEqual(2..10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));

            set prefix = [0; 0; 0];
            AssertTwoOraclesAreEqual(3..10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));
        }
    }

    operation T18_Oracle_MajorityFunction_Test () : ()
    {
        body
        {
            AssertTwoOraclesAreEqual(3..3, Oracle_MajorityFunction, Oracle_MajorityFunction_Reference);
        }
    }

    // ------------------------------------------------------
    operation T21_BV_StatePrep_Test () : ()
    {
        body
        {
            for (N in 1..10) {
                using (qs = Qubit[N+1])
                {
                    // apply operation that needs to be tested
                    BV_StatePrep(qs[0..N-1], qs[N]);

                    // apply adjoint reference operation
                    (Adjoint BV_StatePrep_Reference)(qs[0..N-1], qs[N]);

                    // assert that all qubits end up in |0〉 state
                    AssertAllZero(qs);
                }
            }
        }
    }

    // ------------------------------------------------------
    function AssertOracleCallsCount<'T>(count: Int, oracle: 'T) : () { }
    
    // ------------------------------------------------------
    function ResetOracleCallsCount() : () { }

    // ------------------------------------------------------
    function AssertIntArrayEqual (actual : Int[], expected : Int[], message : String) : () {
        let n = Length(actual); 
        if (n != Length(expected)) {
            fail message;
        }
        for (idx in 0..(n-1)) {
            if( actual[idx] != expected[idx] ) {
                fail message;
            }
        }    
    }

    // ------------------------------------------------------
    function IntArrFromPositiveInt (n : Int, bits : Int) : Int[] {
        let rbool = BoolArrFromPositiveInt(n, bits);
        mutable r = new Int[bits];
        for (i in 0..bits-1) {
            if (rbool[i]) {
                set r[i] = 1;
            }
        }
        return r;
    }

    // ------------------------------------------------------
    operation AssertBVAlgorithmWorks (r : Int[]) : ()
    {
        body
        {
            let oracle = Oracle_ProductFunction_Reference(_, _, r);
            AssertIntArrayEqual(BV_Algorithm(Length(r), oracle), r, "Bernstein-Vazirani algorithm failed");
            AssertOracleCallsCount(1, oracle);
        }
    }

    operation T22_BV_Algorithm_Test () : ()
    {
        body
        {
            ResetOracleCallsCount();

            // test BV the way we suggest the learner to test it:
            // apply the algorithm to reference oracles and check that the output is as expected
            for (bits in 1..4) {
                for (n in 0..2^bits-1) {
                    let r = IntArrFromPositiveInt(n, bits);
                    AssertBVAlgorithmWorks(r);
                }
            }
            AssertBVAlgorithmWorks([1; 1; 1; 0; 0]);
            AssertBVAlgorithmWorks([1; 0; 1; 0; 1; 0]);
        }
    }

    // ------------------------------------------------------
    operation AssertDJAlgorithmWorks(oracle: ((Qubit[], Qubit) => ()), expected : Bool, msg: String) : ()
    {
        body
        {
            AssertBoolEqual(DJ_Algorithm(4, oracle), expected, msg);
            AssertOracleCallsCount(1, oracle);
        }
    }

    operation T31_DJ_Algorithm_Test () : ()
    {
        body
        {
            ResetOracleCallsCount();

            // test DJ the way we suggest the learner to test it:
            // apply the algorithm to reference oracles and check that the output is as expected
            AssertBoolEqual(DJ_Algorithm(4, Oracle_Zero_Reference), true, "f(x) = 0 not identified as constant");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_One_Reference), true, "f(x) = 1 not identified as constant");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_Kth_Qubit_Reference(_, _, 1)), false, "f(x) = x_k not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_OddNumberOfOnes_Reference), false, "f(x) = sum of x_i not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_ProductFunction_Reference(_, _, [1; 0; 1; 1])), false, "f(x) = sum of r_i x_i not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_ProductWithNegationFunction_Reference(_, _, [1; 0; 1; 1])), false, "f(x) = sum of r_i x_i + (1 - r_i)(1 - x_i) not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_HammingWithPrefix_Reference(_, _, [0; 1])), false, "f(x) = sum of x_i + 1 if prefix equals given not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(3, Oracle_MajorityFunction_Reference), false, "f(x) = majority function not identified as balanced");
        }
    }

    // ------------------------------------------------------
    operation AssertNonameAlgorithmWorks (r : Int[]) : ()
    {
        body
        {
            let givenOracle = Oracle_ProductWithNegationFunction_Reference(_, _, r);
            let res = Noname_Algorithm(Length(r), givenOracle);

            // check that the oracle was called once (later it will be called again by test harness)
            AssertOracleCallsCount(1, givenOracle);

            // check that the oracle obtained from r 
            // is equivalent to the oracle obtained from return value
            AssertIntEqual(Length(res), Length(r), "Returned bit vector must have the same length as the oracle input.");
            let resOracle = Oracle_ProductWithNegationFunction_Reference(_, _, res);
            AssertTwoOraclesAreEqual(Length(r)..Length(r), givenOracle, resOracle);
        }
    }

    operation CallNonameAlgoOnInt (n : Int, bits : Int) : () 
    {
        body
        {
            let r = IntArrFromPositiveInt(n, bits);
            AssertNonameAlgorithmWorks(r);
        }
    }

    operation T41_Noname_Algorithm_Test () : ()
    {
        body
        {
            ResetOracleCallsCount();

            // apply the algorithm to reference oracles and check that the output is as expected
            // test all bit vectors of length 1..4
            for (bits in 1..4) {
                for (n in 0..2^bits-1) {
                    CallNonameAlgoOnInt(n, bits);
                }
            }
            // and a couple of random ones
            AssertNonameAlgorithmWorks([1; 1; 1; 0; 0]);
            AssertNonameAlgorithmWorks([1; 0; 1; 0; 1; 0]);
        }
    }
}