// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.JointMeasurements {
    
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    open Quantum.Kata.Utils;
    
    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return
    operation DistinguishStates_MultiQubit (Nqubit : Int, Nstate : Int, statePrep : ((Qubit[], Int, Double) => Unit is Adj), testImpl : (Qubit[] => Int), preserveState : Bool) : Unit {
        let nTotal = 100;
        mutable nOk = 0;
        
        using (qs = Qubit[Nqubit]) {
            for (i in 1 .. nTotal) {
                // get a random integer to define the state of the qubits
                let state = RandomInt(Nstate);
                
                // get a random rotation angle to define the exact state of the qubits
                let alpha = RandomReal(5) * PI();
                
                // do state prep: convert |0...0⟩ to outcome with return equal to state
                statePrep(qs, state, alpha);
                
                // get the solution's answer and verify that it's a match
                let ans = testImpl(qs);
                if (ans == state) {
                    set nOk += 1;
                }
                
                if (preserveState) {
                    // check that the state of the qubit after the operation is unchanged
                    Adjoint statePrep(qs, state, alpha);
                    AssertAllZero(qs);
                } else {
                    // we're not checking the state of the qubit after the operation
                    ResetAll(qs);
                }
            }
        }
        
        EqualityFactI(nOk, nTotal, $"{nTotal - nOk} test runs out of {nTotal} returned incorrect state.");
    }
    
    
    // ------------------------------------------------------
    operation StatePrep_ParityMeasurement (qs : Qubit[], state : Int, alpha : Double) : Unit is Adj {
        
        // prep cos(alpha) * |0..0⟩ + sin(alpha) * |1..1⟩
        Ry(2.0 * alpha, qs[0]);
        for (i in 1 .. Length(qs) - 1) {
            CNOT(qs[0], qs[i]);
        }
            
        if (state == 1) {
            // flip the state of the first half of the qubits
            for (i in 0 .. Length(qs) / 2 - 1) {
                X(qs[i]);
            }
        }
    }
    
    
    // ------------------------------------------------------
    operation T01_SingleQubitMeasurement_Test () : Unit {
        DistinguishStates_MultiQubit(2, 2, StatePrep_ParityMeasurement, SingleQubitMeasurement, false);
    }
    
    
    // ------------------------------------------------------
    operation T02_ParityMeasurement_Test () : Unit {
        DistinguishStates_MultiQubit(2, 2, StatePrep_ParityMeasurement, ParityMeasurement, true);
    }
    
    
    // ------------------------------------------------------
    operation T03_GHZOrGHZWithX_Test () : Unit {
        DistinguishStates_MultiQubit(4, 2, StatePrep_ParityMeasurement, GHZOrGHZWithX, true);
    }
    
    
    // ------------------------------------------------------
    operation StatePrep_WState_Arbitrary (qs : Qubit[]) : Unit is Adj + Ctl {
        
        let N = Length(qs);
            
        if (N == 1) {
            // base case of recursion: |1⟩
            X(qs[0]);
        }
        else {
            // |W_N⟩ = |0⟩|W_(N-1)⟩ + |1⟩|0...0⟩
            // do a rotation on the first qubit to split it into |0⟩ and |1⟩ with proper weights
            // |0⟩ -> sqrt((N-1)/N) |0⟩ + 1/sqrt(N) |1⟩
            let theta = ArcSin(1.0 / Sqrt(IntAsDouble(N)));
            Ry(2.0 * theta, qs[0]);
                
            // do a zero-controlled W-state generation for qubits 1..N-1
            (ControlledOnInt(0, StatePrep_WState_Arbitrary))([qs[0]], qs[1 .. N - 1]);
        }
    }
    
    
    operation StatePrep_GHZOrWState (qs : Qubit[], state : Int, alpha : Double) : Unit is Adj {
        
        if (state == 0) {
            StatePrep_ParityMeasurement(qs, 0, alpha);
        } else {
            StatePrep_WState_Arbitrary(qs);
        }
    }
    
    
    operation T04_GHZOrWState_Test () : Unit {
        for (i in 1 .. 5) {
            DistinguishStates_MultiQubit(2 * i, 2, StatePrep_GHZOrWState, GHZOrWState, true);
        }
    }
    
    
    // ------------------------------------------------------
    operation StatePrep_DifferentBasis (qs : Qubit[], state : Int, alpha : Double) : Unit is Adj {
        
        // prep cos(alpha) * |00⟩ + sin(alpha) * |11⟩
        Ry(2.0 * alpha, qs[0]);
        CNOT(qs[0], qs[1]);
            
        if (state == 1) {
            X(qs[1]);
        }
            
        // convert to X basis
        ApplyToEachA(H, qs);
    }
    
    
    operation T05_DifferentBasis_Test () : Unit {
        DistinguishStates_MultiQubit(2, 2, StatePrep_DifferentBasis, DifferentBasis, true);
    }
    
    
    // ------------------------------------------------------
    // prepare state |A⟩ = cos(α) * |0⟩ + sin(α) * |1⟩
    operation StatePrep_A (alpha : Double, q : Qubit) : Unit is Adj {        
        Ry(2.0 * alpha, q);
    }
    
    
    // ------------------------------------------------------
    // An operation to fine-tune universal CounterSimulator
    // for the purposes of the last two tasks: prohibiting all multi-qubit operations,
    // except the two that are allowed to be used for solving this task
    operation GetMultiQubitNonMeasurementOpCount () : Int {
        return GetMultiQubitOpCount() - GetOracleCallsCount(Measure) - GetOracleCallsCount(MeasureAllZ);
    }
    
    
    // ------------------------------------------------------
    operation T06_ControlledX_Test () : Unit {
        // Note that the way the problem is formulated, we can't just compare two unitaries,
        // we need to create an input state |A⟩ and check that the output state is correct
        using (qs = Qubit[2]) {
            
            for (i in 0 .. 36) {
                let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
                
                // prepare A state
                StatePrep_A(alpha, qs[0]);
                
                ResetOracleCallsCount();

                // apply operation that needs to be tested
                ControlledX(qs);
                
                // the 1 in the following condition is the task operation itself being called
                Fact(GetMultiQubitNonMeasurementOpCount() <= 1, 
                     "You are not allowed to use multi-qubit gates in this task.");

                // apply adjoint reference operation and adjoint of state prep
                CNOT(qs[0], qs[1]);
                Adjoint StatePrep_A(alpha, qs[0]);
                
                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }
    
    
    // ------------------------------------------------------
    operation CNOTWrapper (qs : Qubit[]) : Unit is Adj {
        CNOT(qs[0], qs[1]);
    }
    
    
    operation T07_ControlledX_General_Test () : Unit {
        // In this task the gate is supposed to work on all inputs, so we can compare the unitary to CNOT.
        AssertOperationsEqualReferenced(2, CNOTWrapper, ControlledX_General_Reference);
        AssertOperationsEqualReferenced(2, ControlledX_General, ControlledX_General_Reference);

        // Check that the implementation of ControlledX_General doesn't call multi-qubit gates (other than itself)
        using (qs = Qubit[2]) {
            // prepare a non-trivial input state
            ApplyToEach(H, qs);

            ResetOracleCallsCount();
            
            ControlledX_General(qs);

            // the 1 in the following condition is the task operation itself being called
            Fact(GetMultiQubitNonMeasurementOpCount() <= 1, 
                 "You are not allowed to use multi-qubit gates in this task.");
 
            // apply adjoint reference operation and adjoint of state prep
            CNOT(qs[0], qs[1]);
            ApplyToEach(H, qs);

            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }
    
}
