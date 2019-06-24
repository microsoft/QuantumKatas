// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.ReverSynth {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    
    // 3-bit vectors (classical 3-bit states)
    function inputBits () : Bool[][] {
        return [[false, false, false],
                [true,  false, false],
                [false, true,  false],
                [true,  true,  false],
                [false, false, true],
                [true,  false, true],
                [false, true,  true],
                [true,  true,  true]];
    }

    // majority-3 output values
    function outputBits () : Bool[] {
        return [false, false, false, true, false, true, true, true]; 
    }

    // Preparing input state 
    operation SetInputState (ind : Int, q : Qubit[]) : Unit {
        
        body (...) {
            let inputs = inputBits();
            for (j in 0 .. (Length(q) - 1)) {
                if (inputs[ind][j]){
                    X(q[j]);
                }
            }
        }
        
        adjoint self;
    }

    // Inverting output state 
    operation SetOutputState (ind : Int, q : Qubit) : Unit {
        
        body (...) {
            let inputs = outputBits();
            if (inputs[ind]){
                X(q);
            } 
        }
        
        adjoint self;
    }
    

    operation T1_XOR_Full_Test () : Unit {

        using (qs = Qubit[3]) {
            for (i in 0 .. 3) {

            	// prepare state
                SetInputState(i, qs[0..1]);

                // apply operation under test
                XOR(qs[0..1], qs[2]);

                // apply adjoint reference operation and adjoint of state prep
                Adjoint  XOR_Reference(qs[0..1], qs[2]);
                Adjoint SetInputState(i, qs[0..1]);

                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }

    operation T2_AND_Full_Test () : Unit {

        using (qs = Qubit[3]) {
             for (i in 0 .. 3) {

             	// prepare state
                SetInputState(i, qs[0..1]);

                // apply operation under test
                AND(qs[0..1], qs[2]);

                // apply adjoint reference operation and adjoint of state prep
                Adjoint  AND_Reference(qs[0..1], qs[2]);
                Adjoint SetInputState(i, qs[0..1]);

                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }

    
    operation T3_Majority_Naive_Intermediate_Test () : Unit {

        using (qs = Qubit[8]) {
            for (i in 0 .. 7) {
            	
            	// prepare state
                SetInputState(i, qs[0..2]);

                // apply operation under test
                Majority_Naive(qs[0..2], qs[3..6], qs[7]);

                // uncompute input bits and function output
                // ancillas should be in |0⟩ state already
                Adjoint SetInputState(i, qs[0..2]);
                SetOutputState(i, qs[7]);

                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
                
            } 
        }
    }


    operation T4_Majority_Naive_Full_Test () : Unit {

        using (qs = Qubit[8]) {
            for (i in 0 .. 7) {

            	// prepare state
                SetInputState(i, qs[0..2]);

                // apply operation under test
                Majority_Naive(qs[0..2], qs[3..6], qs[7]);

                // apply adjoint reference operation and adjoint of state prep
                Adjoint  Majority_Naive_Reference(qs[0..2], qs[3..6], qs[7]);
                Adjoint SetInputState(i, qs[0..2]);

                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }



    operation T5_Majority_Optimized_Intermediate_Test () : Unit {

        using (qs = Qubit[4]) {
            for (i in 0 .. 7) {

            	// prepare state
                SetInputState(i, qs[0..2]);

                // apply operation under test
                Majority_Optimized(qs[0..2], qs[3]);

                // uncompute input bits and function output
                // ancillas should be in |0⟩ state already
                Adjoint SetInputState(i, qs[0..2]);
                SetOutputState(i, qs[3]);

                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }



    operation T6_Majority_Optimized_Full_Test () : Unit {

        using (qs = Qubit[4]) {
            for (i in 0 .. 7) {

                // prepare state
                SetInputState(i, qs[0..2]);

                // apply operation under test
                Majority_Optimized(qs[0..2], qs[3]);

                // apply adjoint reference operation and adjoint of state prep
                Adjoint  Majority_Optimized_Reference(qs[0..2], qs[3]);
                Adjoint SetInputState(i, qs[0..2]);

                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }
}
