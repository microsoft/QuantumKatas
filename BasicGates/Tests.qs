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

    operation DumpDiffOnOneInput (  testImpl : (Qubit => Unit is Adj+Ctl),
	                                refImpl : (Qubit => Unit is Adj+Ctl)) : Unit {
        using(q = Qubit()){
            
            //Prep a nice state
            let state = ArcCos(0.6);
            StatePrep_A(state,q);
            Message("Start state:");
            DumpMachine(());

            //Implement the reference solution and show result
            Message("The desired state:");
            refImpl(q);
            DumpMachine(());
            //Reset for test implementation
            Reset(q);

            //Prep the state again for test implementation
            StatePrep_A(state,q);
            //Implement test implementation and test dump the result
            testImpl(q);
            Message("The actual state:");
            DumpMachine(());

            Reset(q);
		}
	}

    operation DumpDiffOnOneInputControlled (  testImpl : (Qubit => Unit is Adj+Ctl),
	                                refImpl : (Qubit => Unit is Adj+Ctl)) : Unit {
			using(qs = Qubit[2]){
            
			H(qs[0]);
            //Prep a nice state
            let state = ArcCos(0.6);
            StatePrep_A(state,qs[1]);
            Message("Start state:");
            DumpMachine(());

            
            //Implement the reference solution and show result
            Message("The desired state:");
            Controlled refImpl([qs[0]],qs[1]);
            DumpMachine(());
            //Reset for test implementation
            ResetAll(qs);

            H(qs[0]);
            //Prep the state again for test implementation
            StatePrep_A(state,qs[1]);
            //Implement test implementation and test dump the result
            Controlled testImpl([qs[0]],qs[1]);
            Message("The actual state:");
            DumpMachine(());

            ResetAll(qs);
		}
	} 
    
    // ------------------------------------------------------
    operation T101_StateFlip_Test () : Unit {
        DumpDiffOnOneInput(StateFlip,StateFlip_Reference);
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(StateFlip, _), ArrayWrapperOperation(StateFlip_Reference, _));
    }
    
    
    // ------------------------------------------------------
    operation T102_BasisChange_Test () : Unit {
        DumpDiffOnOneInput(BasisChange,BasisChange_Reference);
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(BasisChange, _), ArrayWrapperOperation(BasisChange_Reference, _));
    }
    
    
    // ------------------------------------------------------
    operation T103_SignFlip_Test () : Unit {
        DumpDiffOnOneInput(SignFlip,SignFlip_Reference);
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(SignFlip, _), ArrayWrapperOperation(SignFlip_Reference, _));
    }
    
    
    // ------------------------------------------------------
    operation T104_AmplitudeChange_Test () : Unit {
        let dumpAlpha = ((2.0 * PI()) * IntAsDouble(6)) / 36.0;
        DumpDiffOnOneInput(AmplitudeChange(dumpAlpha, _),AmplitudeChange_Reference(dumpAlpha, _));

        for (i in 0 .. 36) {
            let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
            AssertOperationsEqualReferenced(2, ArrayWrapperOperation(AmplitudeChange(alpha, _), _), ArrayWrapperOperation(AmplitudeChange_Reference(alpha, _), _));
        }
    }
    
    
    // ------------------------------------------------------
    operation T105_PhaseFlip_Test () : Unit {
        DumpDiffOnOneInput(PhaseFlip,PhaseFlip_Reference);
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(PhaseFlip, _), ArrayWrapperOperation(PhaseFlip_Reference, _));
    }
    
    
    // ------------------------------------------------------
    operation T106_PhaseChange_Test () : Unit {
        let dumpAlpha = ((2.0 * PI()) * IntAsDouble(10)) / 36.0;
        DumpDiffOnOneInput(PhaseChange(dumpAlpha,_),PhaseChange_Reference(dumpAlpha,_));

        for (i in 0 .. 36) {
            let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
            AssertOperationsEqualReferenced(2, ArrayWrapperOperation(PhaseChange(alpha, _), _), ArrayWrapperOperation(PhaseChange_Reference(alpha, _), _));
        }
    }
    
    
    // ------------------------------------------------------
    operation T107_GlobalPhaseChange_Test () : Unit {

        DumpDiffOnOneInputControlled(GlobalPhaseChange,GlobalPhaseChange_Reference);
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

    operation DumpDiffBellStates (  testImpl : (Qubit[] => Unit is Adj),
	                                refImpl : (Qubit[] => Unit is Adj),
                                    startState : Int) : Unit{
        using(qs = Qubit[2]){

            //Prep the bell state and dump this start state
            StatePrep_BellState(qs, startState); 
            Message("Start state:");
            DumpMachine(());

            //Implement and dump the reference state
            refImpl(qs);
            Message("Desired state:");
            DumpMachine(());
            ResetAll(qs);
            
            //Implement and dump the task state
            StatePrep_BellState(qs,startState);
            testImpl(qs);
            Message("The actual state:");
            DumpMachine(());

            ResetAll(qs);
		}                        
	}

        operation DumpDiffBellStatesControlled (testImpl : (Qubit[] => Unit is Adj),
	                                            refImpl : (Qubit[] => Unit is Adj),
                                                startState : Int) : Unit{
        using(qs = Qubit[3]){

            H(qs[0]);
            //Prep the bell state and dump this start state
            StatePrep_BellState(Rest(qs), startState); 
            Message("Start state:");
            DumpMachine(());

            //Implement and dump the reference state
            refImpl(Rest(qs));
            Message("Desired state:");
            DumpMachine(());
            ResetAll(qs);
            
            H(qs[0]);
            //Implement and dump the task state
            StatePrep_BellState(Rest(qs),startState);
            testImpl(Rest(qs));
            Message("The actual state:");
            DumpMachine(());

            ResetAll(qs);
		}                        
	}

   
    // ------------------------------------------------------
    operation T108_BellStateChange1_Test () : Unit {
        DumpDiffBellStates(BellStateChange1,BellStateChange1_Reference,0);
        VerifyBellStateConversion(BellStateChange1, 0, 1);
    }
    
    
    // ------------------------------------------------------
    operation T109_BellStateChange2_Test () : Unit {
        DumpDiffBellStates(BellStateChange2,BellStateChange2_Reference,0);
        VerifyBellStateConversion(BellStateChange2, 0, 2);
    }
    
    
    // ------------------------------------------------------
    operation T110_BellStateChange3_Test () : Unit {
        DumpDiffBellStatesControlled(BellStateChange3,BellStateChange3_Reference,0);
        VerifyBellStateConversion(BellStateChange3, 0, 3);
    }
    
    
    // ------------------------------------------------------
    // prepare state |A⟩ = cos(α) * |0⟩ + sin(α) * |1⟩
    operation StatePrep_A (alpha : Double, q : Qubit) : Unit is Adj {
            Ry(2.0 * alpha, q);
    }
    //Prepare a state for the various dumps
    operation StatePrep_B (qs : Qubit[]) : Unit is Adj {
        let alphas = [5.0,10.0,15.0];
        for(index in 0 .. Length(qs) - 1){
            Ry((2.0 * alphas[index]) + IntAsDouble(index + 1) * 2.0 , qs[index]);
            Rz(2.0 * alphas[index], qs[index]);
		}
    }
    
    operation DumpDiffOnMultiInput (N : Int,
	                                testImpl : (Qubit[] => Unit is Adj),
	                                refImpl : (Qubit[] => Unit is Adj),
                                    stateprep : (Qubit[] => Unit is Adj )) : Unit {

	    using(qs = Qubit[N]){
            stateprep(qs);
            Message("Start state:");
            DumpMachine(());
            //Display the proper solution
            refImpl(qs);
            Message("The desired state:");
            DumpMachine(); 			          
            ResetAll(qs);

            //Display the test implementation
            stateprep(qs);
            testImpl(qs);
            Message("The actual state:");
            DumpMachine(); 
            ResetAll(qs);
		}
	}    

    // ------------------------------------------------------
    operation T201_TwoQubitGate1_Test () : Unit {
        DumpDiffOnMultiInput(2,TwoQubitGate1,TwoQubitGate1_Reference,StatePrep_B);

        // Note that the way the problem is formulated, we can't just compare two unitaries,
        // we need to create an input state |A⟩ and check that the output state is correct
        using (qs = Qubit[2]) {
            for (i in 0 .. 36) {
                let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
                
                within {
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
        DumpDiffOnMultiInput(2,TwoQubitGate2,TwoQubitGate2_Reference,StatePrep_PlusPlus);
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
        DumpDiffOnMultiInput(2,TwoQubitGate3,TwoQubitGate3_Reference,StatePrep_B);
        AssertOperationsEqualReferenced(2, SwapWrapper, TwoQubitGate3_Reference);
        AssertOperationsEqualReferenced(2, TwoQubitGate3, TwoQubitGate3_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T204_ToffoliGate_Test () : Unit {
       DumpDiffOnMultiInput(3,ToffoliGate, ToffoliGate_Reference, StatePrep_B);
        AssertOperationsEqualReferenced(3, ToffoliGate, ToffoliGate_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T205_FredkinGate_Test () : Unit {
        DumpDiffOnMultiInput(3,FredkinGate, FredkinGate_Reference, StatePrep_B);
        AssertOperationsEqualReferenced(3, FredkinGate, FredkinGate_Reference);
    }
}
