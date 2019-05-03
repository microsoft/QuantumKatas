// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SimonsAlgorithm {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Oracles
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. f(x) = x₀ ⊕ ... ⊕ xₙ₋₁ (parity of the number of bits set to 1)
    operation Oracle_CountBits_Reference (x : Qubit[], y : Qubit) : Unit
    is Adj {
        
        let N = Length(x);

        for (i in 0 .. N - 1) {
            CNOT(x[i], y);
        }
    }
    
    
    // Task 1.2. Bitwise right shift
    operation Oracle_BitwiseRightShift_Reference (x : Qubit[], y : Qubit[]) : Unit
    is Adj {
        
        let N = Length(x);

        for (i in 1 .. N - 1) {
            CNOT(x[i - 1], y[i]);
        }
    }
    
    
    // Task 1.3. Linear operator
    operation Oracle_OperatorOutput_Reference (x : Qubit[], y : Qubit, A : Int[]) : Unit
    is Adj {
        
        let N = Length(x);
            
        for (i in 0 .. N - 1) {
            if (A[i] == 1) {
                CNOT(x[i], y);
            }
        }
    }
    
    
    // Task 1.4. Multidimensional linear operator
    operation Oracle_MultidimensionalOperatorOutput_Reference (x : Qubit[], y : Qubit[], A : Int[][]) : Unit
    is Adj {
        
        let N1 = Length(y);
        let N2 = Length(x);
            
        for (i in 0 .. N1 - 1) {
            for (j in 0 .. N2 - 1) {
                if ((A[i])[j] == 1) {
                    CNOT(x[j], y[i]);
                }
            }
        }
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part II. Simon's Algorithm
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1. State preparation for Simon's algorithm
    operation SA_StatePrep_Reference (query : Qubit[]) : Unit
    is Adj {        
        ApplyToEachA(H, query);
    }
    
    
    // Task 2.2. Quantum part of Simon's algorithm
    operation Simon_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit[]) => Unit)) : Int[] {
                
        // allocate input and answer registers with N qubits each
        using ((x, y) = (Qubit[N], Qubit[N])) {
            // prepare qubits in the right state
            SA_StatePrep_Reference(x);
            
            // apply oracle
            Uf(x, y);
            
            // apply Hadamard to each qubit of the input register
            ApplyToEach(H, x);
            
            // measure all qubits of the input register;
            // the result of each measurement is converted to an Int
            mutable j = new Int[N];
            for (i in 0 .. N - 1) {
                if (M(x[i]) == One) {
                    set j w/= i <- 1;
                }
            }
            
            // before releasing the qubits make sure they are all in |0⟩ states
            ResetAll(x);
            ResetAll(y);
            return j;
        }
    }
    
}
