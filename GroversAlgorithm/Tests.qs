// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GroversAlgorithm
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;

    // ------------------------------------------------------
    // helper wrapper to represent oracle operation on input and output registers as an operation on an array of qubits
    operation QubitArrayWrapperOperation (op : ((Qubit[], Qubit) => () : Adjoint), qs : Qubit[]) : ()
    {
        body
        {
            op(Most(qs), Tail(qs));
        }
        adjoint auto;
    }

    // ------------------------------------------------------
    // helper wrapper to test for operation equality on various register sizes
    operation AssertRegisterOperationsEqual (testOp : ((Qubit[]) => ()), refOp : ((Qubit[]) => () : Adjoint)) : ()
    {
        body
        {
            for (n in 2..10) {
                AssertOperationsEqualReferenced(testOp, refOp, n);
            }
        }
    }

    // ------------------------------------------------------
    operation T11_Oracle_AllOnes_Test () : ()
    {
        body
        {
            let testOp = QubitArrayWrapperOperation(Oracle_AllOnes, _);
            let refOp = QubitArrayWrapperOperation(Oracle_AllOnes_Reference, _);
            AssertRegisterOperationsEqual(testOp, refOp);
        }
    }

    // ------------------------------------------------------
    operation T12_Oracle_AlternatingBits_Test () : ()
    {
        body
        {
            let testOp = QubitArrayWrapperOperation(Oracle_AlternatingBits, _);
            let refOp = QubitArrayWrapperOperation(Oracle_AlternatingBits_Reference, _);
            AssertRegisterOperationsEqual(testOp, refOp);
        }
    }

    // ------------------------------------------------------
    operation T13_Oracle_ArbitraryPattern_Test () : ()
    {
        body
        {
            for (n in 2..10) {
                let pattern = BoolArrFromPositiveInt(RandomIntPow2(n), n);
                let testOp = QubitArrayWrapperOperation(Oracle_ArbitraryPattern(_, _, pattern), _);
                let refOp = QubitArrayWrapperOperation(Oracle_ArbitraryPattern_Reference(_, _, pattern), _);
                AssertOperationsEqualReferenced(testOp, refOp, n+1);
            }
        }
    }

    // ------------------------------------------------------
    operation T14_OracleConverter_Test () : ()
    {
        body
        {
            for (n in 2..10) {
                let pattern = BoolArrFromPositiveInt(RandomIntPow2(n), n);
                let markingOracle = Oracle_ArbitraryPattern_Reference(_, _, pattern);
                let phaseOracleRef = OracleConverter_Reference(markingOracle);
                let phaseOracleSol = OracleConverter(markingOracle);
                AssertOperationsEqualReferenced(phaseOracleSol, phaseOracleRef, n);
            }
        }
    }

    // ------------------------------------------------------
    operation T21_HadamardTransform_Test () : ()
    {
        body
        {
            AssertRegisterOperationsEqual(HadamardTransform, HadamardTransform_Reference);
        }
    }

    // ------------------------------------------------------
    operation T22_ConditionalPhaseFlip_Test () : ()
    {
        body
        {
            AssertRegisterOperationsEqual(ConditionalPhaseFlip, ConditionalPhaseFlip_Reference);
        }
    }

    // ------------------------------------------------------
    operation T23_GroverIteration_Test () : ()
    {
        body
        {
            for (n in 2..10) {
                let pattern = BoolArrFromPositiveInt(RandomIntPow2(n), n);
                let markingOracle = Oracle_ArbitraryPattern_Reference(_, _, pattern);
                let flipOracle = OracleConverter_Reference(markingOracle);
                let testOp = GroverIteration(_, flipOracle);
                let refOp = GroverIteration_Reference(_, flipOracle);
                AssertOperationsEqualReferenced(testOp, refOp, n);
            }
        }
    }

    // ------------------------------------------------------
    operation T31_GroversSearch_Test () : ()
    {
        body
        {
            for (n in 2..10) {
                let pattern = BoolArrFromPositiveInt(RandomIntPow2(n), n);
                let markingOracle = Oracle_ArbitraryPattern_Reference(_, _, pattern);
                let testOp = GroversSearch(_, markingOracle, 4);
                let refOp = GroversSearch_Reference(_, markingOracle, 4);
                AssertOperationsEqualReferenced(testOp, refOp, n);
            }
        }
    }
}