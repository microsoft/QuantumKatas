// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GroversAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Random;
    
    
    // ------------------------------------------------------
    // helper wrapper to represent oracle operation on input and output registers as an operation on an array of qubits
    operation QubitArrayWrapperOperation (op : ((Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(Most(qs), Tail(qs));
    }
    
    
    // ------------------------------------------------------
    // helper wrapper to test for operation equality on various register sizes
    operation AssertRegisterOperationsEqual (testOp : (Qubit[] => Unit), refOp : (Qubit[] => Unit is Adj)) : Unit {
        for n in 2 .. 10 {
            AssertOperationsEqualReferenced(n, testOp, refOp);
        }
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T11_Oracle_AllOnes () : Unit {
        let testOp = QubitArrayWrapperOperation(Oracle_AllOnes, _);
        let refOp = QubitArrayWrapperOperation(Oracle_AllOnes_Reference, _);
        AssertRegisterOperationsEqual(testOp, refOp);
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T12_Oracle_AlternatingBits () : Unit {
        let testOp = QubitArrayWrapperOperation(Oracle_AlternatingBits, _);
        let refOp = QubitArrayWrapperOperation(Oracle_AlternatingBits_Reference, _);
        AssertRegisterOperationsEqual(testOp, refOp);
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T13_Oracle_ArbitraryPattern () : Unit {
        for n in 2 .. 10 {
            let pattern = IntAsBoolArray(DrawRandomInt(0, 2^n - 1), n);
            let testOp = QubitArrayWrapperOperation(Oracle_ArbitraryPattern(_, _, pattern), _);
            let refOp = QubitArrayWrapperOperation(Oracle_ArbitraryPattern_Reference(_, _, pattern), _);
            AssertOperationsEqualReferenced(n + 1, testOp, refOp);
        }
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T14_OracleConverter () : Unit {
        for n in 2 .. 10 {
            let pattern = IntAsBoolArray(DrawRandomInt(0, 2^n - 1), n);
            let markingOracle = Oracle_ArbitraryPattern_Reference(_, _, pattern);
            let phaseOracleRef = OracleConverter_Reference(markingOracle);
            let phaseOracleSol = OracleConverter(markingOracle);
            AssertOperationsEqualReferenced(n, phaseOracleSol, phaseOracleRef);
        }
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T21_HadamardTransform () : Unit {
        AssertRegisterOperationsEqual(HadamardTransform, HadamardTransform_Reference);
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T22_ConditionalPhaseFlip () : Unit {
        AssertRegisterOperationsEqual(ConditionalPhaseFlip, ConditionalPhaseFlip_Reference);
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T23_GroverIteration () : Unit {
        for n in 2 .. 10 {
            let pattern = IntAsBoolArray(DrawRandomInt(0, 2^n - 1), n);
            let markingOracle = Oracle_ArbitraryPattern_Reference(_, _, pattern);
            let flipOracle = OracleConverter_Reference(markingOracle);
            let testOp = GroverIteration(_, flipOracle);
            let refOp = GroverIteration_Reference(_, flipOracle);
            AssertOperationsEqualReferenced(n, testOp, refOp);
        }
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T31_GroversSearch () : Unit {
        for n in 2 .. 10 {
            let pattern = IntAsBoolArray(DrawRandomInt(0, 2^n - 1), n);
            let markingOracle = Oracle_ArbitraryPattern_Reference(_, _, pattern);
            let testOp = GroversSearch(_, markingOracle, 4);
            let refOp = GroversSearch_Reference(_, markingOracle, 4);
            AssertOperationsEqualReferenced(n, testOp, refOp);
        }
    }
    
}
