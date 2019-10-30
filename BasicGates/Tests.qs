// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.BasicGates {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    
    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Gates
    //////////////////////////////////////////////////////////////////

    // The tests in part I are written to test controlled versions of operations instead of plain ones.
    // This is done to verify that the tasks don't add a global phase to the implementations.
    // Global phase is not relevant physically, but it can be very confusing for a beginner to consider R1 vs Rz,
    // so the tests use controlled version of the operations which converts the global phase into a relative phase
    // and makes it possible to detect.

    // ------------------------------------------------------
    // Helper wrapper to represent controlled variant of operation on one qubit 
    // as an operation on an array of two qubits
    operation ArrayWrapperOperation (op : (Qubit => Unit is Adj+Ctl), qs : Qubit[]) : Unit is Adj+Ctl {
        Controlled op([qs[0]], qs[1]);
    }
    
    
    // ------------------------------------------------------
    operation T101_StateFlip_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(StateFlip, _), ArrayWrapperOperation(StateFlip_Reference, _));
    }
    
    
    // ------------------------------------------------------
    operation T102_BasisChange_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(BasisChange, _), ArrayWrapperOperation(BasisChange_Reference, _));
    }
    
    
    // ------------------------------------------------------
    operation T103_SignFlip_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(SignFlip, _), ArrayWrapperOperation(SignFlip_Reference, _));
    }
    
    
    // ------------------------------------------------------
    operation T104_AmplitudeChange_Test () : Unit {
        for (i in 0 .. 36) {
            let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
            AssertOperationsEqualReferenced(2, ArrayWrapperOperation(AmplitudeChange(alpha, _), _), ArrayWrapperOperation(AmplitudeChange_Reference(alpha, _), _));
        }
    }
    
    
    // ------------------------------------------------------
    operation T105_PhaseFlip_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(PhaseFlip, _), ArrayWrapperOperation(PhaseFlip_Reference, _));
    }
    
    
    // ------------------------------------------------------
    operation T106_PhaseChange_Test () : Unit {
        for (i in 0 .. 36) {
            let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
            AssertOperationsEqualReferenced(2, ArrayWrapperOperation(PhaseChange(alpha, _), _), ArrayWrapperOperation(PhaseChange_Reference(alpha, _), _));
        }
    }
    
    
    // ------------------------------------------------------
    operation T107_GlobalPhaseChange_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(GlobalPhaseChange, _), ArrayWrapperOperation(GlobalPhaseChange_Reference, _));
    }
    

    // ------------------------------------------------------
    // 0 - |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
    // 1 - |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
    // 2 - |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
    // 3 - |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
    operation StatePrep_BellState (qs : Qubit[], state : Int) : Unit is Adj+Ctl {
        
        H(qs[0]);
        CNOT(qs[0], qs[1]);
            
        // now we have |00⟩ + |11⟩ - modify it based on state arg
        if (state % 2 == 1) {
            // negative phase
            Z(qs[1]);
        }
            
        if (state / 2 == 1) {
            X(qs[1]);
        }
    }
    
    
    // ------------------------------------------------------
    operation VerifyBellStateConversion (testOp : (Qubit[] => Unit is Adj+Ctl), startState : Int, targetState : Int) : Unit {
        // (note the use of controlled versions of operations to keep track of the phase potentially acquired by testOp)
        using (qs = Qubit[3]) {
            H(qs[0]);

            // prepare Bell state startState
            Controlled StatePrep_BellState([qs[0]], (Rest(qs), startState));
            
            // apply operation that needs to be tested
            Controlled testOp([qs[0]], Rest(qs));
            
            // verify the result by applying adjoint of state prep for target state
            Controlled Adjoint StatePrep_BellState([qs[0]], (Rest(qs), targetState));
            
            H(qs[0]);

            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }

    

    // ------------------------------------------------------
    operation T108_BellStateChange1_Test () : Unit {
        VerifyBellStateConversion(BellStateChange1, 0, 1);
    }
    
    
    // ------------------------------------------------------
    operation T109_BellStateChange2_Test () : Unit {
        VerifyBellStateConversion(BellStateChange2, 0, 2);
    }
    
    
    // ------------------------------------------------------
    operation T110_BellStateChange3_Test () : Unit {
        VerifyBellStateConversion(BellStateChange3, 0, 3);
    }
    
    
    // ------------------------------------------------------
    // prepare state |A⟩ = cos(α) * |0⟩ + sin(α) * |1⟩
    operation StatePrep_A (alpha : Double, q : Qubit) : Unit is Adj {
        Ry(2.0 * alpha, q);
    }
    
    
    // ------------------------------------------------------
    operation T201_TwoQubitGate1_Test () : Unit {
        
        // Note that the way the problem is formulated, we can't just compare two unitaries,
        // we need to create an input state |A⟩ and check that the output state is correct
        using (qs = Qubit[2]) {
            for (i in 0 .. 36) {
                let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
                
                within {
                    // prepare A state
                    StatePrep_A(alpha, qs[0]);
                }
                apply {
                    // apply operation that needs to be tested
                    TwoQubitGate1(qs);

                    // apply adjoint reference operation
                    Adjoint TwoQubitGate1_Reference(qs);
                }
                
                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }
    
    
    // ------------------------------------------------------
    // prepare state |+⟩ ⊗ |+⟩ = (|00⟩ + |01⟩ + |10⟩ + |11⟩) / 2.
    operation StatePrep_PlusPlus (qs : Qubit[]) : Unit is Adj {
        ApplyToEachA(H, qs);
    }
    
    
    // ------------------------------------------------------
    operation T202_TwoQubitGate2_Test () : Unit {
        using (qs = Qubit[2]) {
            // prepare |+⟩ ⊗ |+⟩ state
            StatePrep_PlusPlus(qs);
            
            // apply operation that needs to be tested
            TwoQubitGate2(qs);
            
            // apply adjoint reference operation and adjoint of state prep
            Adjoint TwoQubitGate2_Reference(qs);
            Adjoint StatePrep_PlusPlus(qs);
            
            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }
    
    
    // ------------------------------------------------------
    operation SwapWrapper (qs : Qubit[]) : Unit is Adj {
        SWAP(qs[0], qs[1]);
    }
    
    
    operation T203_TwoQubitGate3_Test () : Unit {
        AssertOperationsEqualReferenced(2, SwapWrapper, TwoQubitGate3_Reference);
        AssertOperationsEqualReferenced(2, TwoQubitGate3, TwoQubitGate3_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T204_ToffoliGate_Test () : Unit {
        AssertOperationsEqualReferenced(3, ToffoliGate, ToffoliGate_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T205_FredkinGate_Test () : Unit {
        AssertOperationsEqualReferenced(3, FredkinGate, FredkinGate_Reference);
    }
    
}
