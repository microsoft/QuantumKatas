// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SimonsAlgorithm {
    
    open Microsoft.Quantum.Diagnostics;
    
    
    // ------------------------------------------------------
    operation ApplyOracleA (qs : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj)) : Unit
    is Adj {        
        let N = Length(qs);
        oracle(qs[0 .. N - 2], qs[N - 1]);
    }
    
    
    operation ApplyOracleWithOutputArrA (qs : Qubit[], oracle : ((Qubit[], Qubit[]) => Unit is Adj), outputSize : Int) : Unit
    is Adj {
        let N = Length(qs);
        oracle(qs[0 .. (N - 1) - outputSize], qs[N - outputSize .. N - 1]);
    }
    
    
    // ------------------------------------------------------
    operation AssertTwoOraclesAreEqual (
        nQubits : Range, 
        oracle1 : ((Qubit[], Qubit) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit) => Unit is Adj)) : Unit {
        let sol = ApplyOracleA(_, oracle1);
        let refSol = ApplyOracleA(_, oracle2);
        
        for (i in nQubits) {
            AssertOperationsEqualReferenced(i+1, sol, refSol);
        }
    }
    
    
    operation AssertTwoOraclesWithOutputArrAreEqual (
        inputSize : Int, 
        outputSize : Int, 
        oracle1 : ((Qubit[], Qubit[]) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit[]) => Unit is Adj)) : Unit {
        let sol = ApplyOracleWithOutputArrA(_, oracle1, outputSize);
        let refSol = ApplyOracleWithOutputArrA(_, oracle2, outputSize);
        AssertOperationsEqualReferenced(inputSize + outputSize, sol, refSol);
    }
    
    
    // ------------------------------------------------------
    operation Q11_Oracle_CountBits_Test () : Unit {
        AssertTwoOraclesAreEqual(1 .. 10, Oracle_CountBits, Oracle_CountBits_Reference);
    }
    
    
    // ------------------------------------------------------
    operation Q12_Oracle_BitwiseRightShift_Test () : Unit {
        for (n in 2 .. 6) {
            AssertTwoOraclesWithOutputArrAreEqual(n, n, Oracle_BitwiseRightShift, Oracle_BitwiseRightShift_Reference);
        }
    }
    
    
    // ------------------------------------------------------
    operation AssertTwoOraclesWithIntArrAreEqual (A : Int[], oracle1 : ((Qubit[], Qubit, Int[]) => Unit is Adj), oracle2 : ((Qubit[], Qubit, Int[]) => Unit is Adj)) : Unit {
        AssertTwoOraclesAreEqual(Length(A) .. Length(A), oracle1(_, _, A), oracle2(_, _, A));
    }
    
    
    operation Q13_Oracle_OperatorOutput_Test () : Unit {
        // cross-tests
        // the mask for all 1's should behave the same as Oracle_CountBits
        mutable A = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
        let L = Length(A);
        
        for (i in 2 .. L) {
            AssertTwoOraclesAreEqual(i .. i, Oracle_OperatorOutput(_, _, A[0 .. i - 1]), Oracle_OperatorOutput_Reference(_, _, A[0 .. i - 1]));
        }
        
        set A = [1, 1, 0, 0];
        AssertTwoOraclesWithIntArrAreEqual(A, Oracle_OperatorOutput, Oracle_OperatorOutput_Reference);

        set A = [0, 0, 0, 0, 0];
        AssertTwoOraclesWithIntArrAreEqual(A, Oracle_OperatorOutput, Oracle_OperatorOutput_Reference);

        set A = [1, 0, 1, 1, 1];
        AssertTwoOraclesWithIntArrAreEqual(A, Oracle_OperatorOutput, Oracle_OperatorOutput_Reference);

        set A = [0, 1, 0, 0];
        AssertTwoOraclesWithIntArrAreEqual(A, Oracle_OperatorOutput, Oracle_OperatorOutput_Reference);
    }
    
    
    // ------------------------------------------------------
    operation AssertTwoOraclesWithIntMatrixAreEqual (
        A : Int[][], 
        oracle1 : ((Qubit[], Qubit[], Int[][]) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit[], Int[][]) => Unit is Adj)) : Unit {
        let inputSize = Length(A[0]);
        let outputSize = Length(A);
        AssertTwoOraclesWithOutputArrAreEqual(inputSize, outputSize, oracle1(_, _, A), oracle2(_, _, A));
    }
    
    
    operation AssertTwoOraclesWithDifferentOutputsAreEqual (
        inputSize : Int, 
        oracle1 : ((Qubit[], Qubit[]) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit) => Unit is Adj)) : Unit {
        let sol = ApplyOracleWithOutputArrA(_, oracle1, 1);
        let refSol = ApplyOracleA(_, oracle2);
        AssertOperationsEqualReferenced(inputSize + 1, sol, refSol);
    }
    
    
    operation Q14_Oracle_MultidimensionalOperatorOutput_Test () : Unit {
        
        mutable A = [[1, 1], [0, 0]];
        AssertTwoOraclesWithIntMatrixAreEqual(A, Oracle_MultidimensionalOperatorOutput, Oracle_MultidimensionalOperatorOutput_Reference);

        set A = [[1, 0], [0, 1], [1, 1]];
        AssertTwoOraclesWithIntMatrixAreEqual(A, Oracle_MultidimensionalOperatorOutput, Oracle_MultidimensionalOperatorOutput_Reference);

        set A = [[0, 1, 0], [1, 0, 1]];
        AssertTwoOraclesWithIntMatrixAreEqual(A, Oracle_MultidimensionalOperatorOutput, Oracle_MultidimensionalOperatorOutput_Reference);
        
        // cross-test for bitwise right shift oracle
        set A = [[0, 0, 0, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0]];
        AssertTwoOraclesWithOutputArrAreEqual(4, 4, Oracle_MultidimensionalOperatorOutput(_, _, A), Oracle_BitwiseRightShift_Reference);
        
        // cross-test for 1-dimensional output
        mutable B = [1, 0, 1, 0, 1];
        AssertTwoOraclesWithDifferentOutputsAreEqual(5, Oracle_MultidimensionalOperatorOutput(_, _, [B]), Oracle_OperatorOutput_Reference(_, _, B));
        
        // cross-test for bit counting oracle
        set B = [1, 1, 1, 1, 1];
        AssertTwoOraclesWithDifferentOutputsAreEqual(5, Oracle_MultidimensionalOperatorOutput(_, _, [B]), Oracle_CountBits_Reference);
    }
    
    
    operation Q21_StatePrep_Test () : Unit {
        for (N in 1 .. 10) {
            using (qs = Qubit[N]) {
                // apply operation that needs to be tested
                SA_StatePrep(qs[0 .. N - 1]);
                
                // apply adjoint reference operation
                Adjoint SA_StatePrep_Reference(qs[0 .. N - 1]);
                
                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }
    
    
    // ------------------------------------------------------
    operation cs_helper (N : Int, Matrix : Int[][]) : (Int[], ((Qubit[], Qubit[]) => Unit)) {
        let Uf = Oracle_MultidimensionalOperatorOutput_Reference(_, _, Matrix);
        return (Simon_Algorithm(N, Uf), Uf);
    }
    
}
