// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SingleQubitSystemMeasurements {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Random;


    //////////////////////////////////////////////////////////////////

    // "Framework" operation for testing single-qubit tasks for distinguishing states of one qubit
    // with Bool return
    operation DistinguishTwoStates (statePrep : ((Qubit, Int) => Unit is Adj), testImpl : (Qubit => Bool), stateName : String[], checkFinalState : Bool) : Unit {
        let nTotal = 100;
        let nStates = 2;
        mutable misclassifications = new Int[nStates];
        
        use q = Qubit();
        for i in 1 .. nTotal {
            // get a random bit to define whether qubit will be in a state corresponding to true return (1) or to false one (0)
            // state = 0 false return
            // state = 1 true return
            let state = DrawRandomInt(0, 1);

            // do state prep: convert |0⟩ to outcome with false return or to outcome with true return depending on state
            statePrep(q, state);

            // get the solution's answer and verify if NOT a match, then differentiate what kind of mismatch
            let ans = testImpl(q);
            if (ans != (state == 1)) {
                set misclassifications w/= state <- misclassifications[state] + 1;
            }
                
            // If the final state is to be verified, check if it matches the measurement outcome
            if (checkFinalState) {
                Adjoint statePrep(q, state);
                AssertQubit(Zero, q);
            } else {
                Reset(q);
            }
        }
        
        mutable totalMisclassifications = 0;
        for i in 0 .. nStates - 1 {
            if (misclassifications[i] != 0) {
                set totalMisclassifications += misclassifications[i];
                Message($"Misclassified {stateName[i]} as {stateName[1 - i]} in {misclassifications[i]} test runs.");   
            }
        }
        
        // This check will tell the total number of failed classifications
        Fact(totalMisclassifications == 0, $"{totalMisclassifications} test runs out of {nTotal} returned incorrect state (see output for details).");
    }

    // ------------------------------------------------------
    // Exercise 2. Distinguish |0❭ and |1❭
    // ------------------------------------------------------
    operation StatePrep_IsQubitZero (q : Qubit, state : Int) : Unit is Adj {
        if (state == 0) {
            // convert |0⟩ to |1⟩
            X(q);
        }
    }

    @Test("QuantumSimulator")
    operation T2_IsQubitZero () : Unit {
        DistinguishTwoStates(StatePrep_IsQubitZero, IsQubitZero, ["|1⟩", "|0⟩"], false);
    }



    // ------------------------------------------------------
    // Exercise 3. Distinguish |+❭ and |-❭ using Measure operation
    // ------------------------------------------------------
    operation StatePrep_IsQubitMinus (q : Qubit, state : Int) : Unit is Adj {
        if (state == 1) {
            // convert |0⟩ to |-⟩
            X(q);
            H(q);
        } else {
            // convert |0⟩ to |+⟩
            H(q);
        }
    }

    @Test("QuantumSimulator")
    operation T3_IsQubitMinus () : Unit {
        DistinguishTwoStates(StatePrep_IsQubitMinus, IsQubitMinus, ["|+⟩", "|-⟩"], false);
    }

    // ------------------------------------------------------
    // Exercise 5. Distinguish specific orthogonal states
    // ------------------------------------------------------

    // |ψ₊⟩ =   0.6 * |0⟩ + 0.8 * |1⟩,
    // |ψ₋⟩ =  -0.8 * |0⟩ + 0.6 * |1⟩.
    operation StatePrep_IsQubitPsiPlus (q : Qubit, state : Int) : Unit is Adj {
        if (state == 0) {
            // convert |0⟩ to |ψ₋⟩
            X(q);
            Ry(2.0 * ArcTan2(0.8, 0.6), q);
        } else {
            // convert |0⟩ to |ψ₊⟩
            Ry(2.0 * ArcTan2(0.8, 0.6), q);
        }
    }

    @Test("QuantumSimulator")
    operation T5_IsQubitPsiPlus () : Unit {
        DistinguishTwoStates(StatePrep_IsQubitPsiPlus, IsQubitPsiPlus, 
            ["|ψ₋⟩", "|ψ₊⟩"], false);
    }
    

    // ------------------------------------------------------
    // Exercise 6. Distinguish states |A❭ and |B❭
    // ------------------------------------------------------
    
    // |A⟩ =   cos(alpha) * |0⟩ - i sin(alpha) * |1⟩,
    // |B⟩ = - i sin(alpha) * |0⟩ + cos(alpha) * |1⟩.
    operation StatePrep_IsQubitA (alpha : Double, q : Qubit, state : Int) : Unit is Adj {
        if (state == 0) {
            // convert |0⟩ to |B⟩
            X(q);
            Rx(2.0 * alpha, q);
        } else {
            // convert |0⟩ to |A⟩
            Rx(2.0 * alpha, q);
        }
    }

    
    @Test("QuantumSimulator")
    operation T6_IsQubitA () : Unit {
        for i in 0 .. 10 {
            let alpha = (PI() * IntAsDouble(i)) / 10.0;
            DistinguishTwoStates(StatePrep_IsQubitA(alpha, _, _), IsQubitA(alpha, _), 
                [$"|B⟩ = -i sin({i}π/10)|0⟩ + cos({i}π/10)|1⟩", $"|A⟩ = cos({i}π/10)|0⟩ + i sin({i}π/10)|1⟩"], false);
        }
    }


    // ------------------------------------------------------
    // Exercise 7. Measure state in {|A❭, |B❭} basis
    // ------------------------------------------------------
    
    // |A⟩ =   cos(alpha) * |0⟩ - i sin(alpha) * |1⟩,
    // |B⟩ = - i sin(alpha) * |0⟩ + cos(alpha) * |1⟩.

    // Wrapper function to convert the Result output of MeasureInABBasis to a bool type
    operation IsResultZero( MeasurementOperation : (Qubit => Result), givenQubit : Qubit) : Bool {
        mutable isZero = false;
        if (MeasurementOperation(givenQubit) == Zero) {
            set isZero = true;
        }
        return isZero;
    }

    // We can use the StatePrep_IsQubitA operation for the testing
    @Test("QuantumSimulator")
    operation T7_MeasureInABBasis () : Unit {
        for i in 0 .. 10 {
            let alpha = (PI() * IntAsDouble(i)) / 10.0;
            DistinguishTwoStates(StatePrep_IsQubitA(alpha, _, _), IsResultZero(MeasureInABBasis(alpha, _),_), 
                [$"|B⟩=(-i sin({i}π/10)|0⟩ + cos({i}π/10)|1⟩)", $"|A⟩=(cos({i}π/10)|0⟩ + i sin({i}π/10)|1⟩)"], true);
        }
    }
    
}