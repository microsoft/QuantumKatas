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
    open Microsoft.Quantum.Random;

    open Quantum.Kata.Utils;


    //////////////////////////////////////////////////////////////////

    // "Framework" operation for testing single-qubit tasks for distinguishing states of one qubit
    // with Bool return
    operation DistinguishTwoStates (statePrep : ((Qubit, Int) => Unit), testImpl : (Qubit => Bool), stateName : String[]) : Unit {
        let nTotal = 100;
        let nStates = 2;
        mutable misclassifications = new Int[nStates];
        
        using (q = Qubit()) {
            for (i in 1 .. nTotal) {
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

                // we're not checking the state of the qubit after the operation
                Reset(q);
            }
        }
        
        mutable totalMisclassifications = 0;
        for (i in 0 .. nStates - 1) {
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
    operation StatePrep_IsQubitZero (q : Qubit, state : Int) : Unit {
        if (state == 0) {
            // convert |0⟩ to |1⟩
            X(q);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T1_IsQubitZero () : Unit {
        DistinguishTwoStates(StatePrep_IsQubitZero, IsQubitZero, ["|1⟩", "|0⟩"]);
    }



    // ------------------------------------------------------
    // Exercise 3. Distinguish |+❭ and |-❭ using Measure operation
    // ------------------------------------------------------
    operation StatePrep_IsQubitPlus (q : Qubit, state : Int) : Unit {
        if (state == 0) {
            // convert |0⟩ to |-⟩
            X(q);
            H(q);
        } else {
            // convert |0⟩ to |+⟩
            H(q);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T3_IsQubitPlus () : Unit {
        DistinguishTwoStates(StatePrep_IsQubitPlus, IsQubitPlus, ["|-⟩", "|+⟩"]);
    }

    // ------------------------------------------------------
    // Exercise 5. Distinguishing specific orthogonal states in Q#
    // ------------------------------------------------------

    // |\psi + ⟩ =   0.6 * |0⟩ + 0.8 * |1⟩,
    // |\psi + ⟩ =   -0.8 * |0⟩ + 0.6 * |1⟩.
    operation StatePrep_IsQubitPsiPlus (q : Qubit, state : Int) : Unit {
        if (state == 0) {
            // convert |0⟩ to |psi -⟩
            X(q);
            Ry(2.0 * ArcTan2(0.8, 0.6), q);
        } else {
            // convert |0⟩ to |psi +⟩
            Ry(2.0 * ArcTan2(0.8, 0.6), q);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T5_IsQubitSpecificState () : Unit {
        // cross-test
        // alpha = 0.0 or PI() => !isQubitOne
        // alpha = PI() / 2.0 => isQubitOne
        DistinguishTwoStates(StatePrep_IsQubitPsiPlus, IsQubitSpecificState, 
            ["|psi-⟩", "|psi+⟩"]);
    }
    

    // ------------------------------------------------------
    // Exercise 6. |A❭ and |B❭?
    // ------------------------------------------------------
    
    // |A⟩ =   cos(alpha) * |0⟩ - i sin(alpha) * |1⟩,
    // |B⟩ = - i sin(alpha) * |0⟩ + cos(alpha) * |1⟩.
    operation StatePrep_IsQubitA (alpha : Double, q : Qubit, state : Int) : Unit {
        if (state == 0) {
            // convert |0⟩ to |B⟩
            X(q);
            Rx(2.0 * alpha, q);
        } else {
            // convert |0⟩ to |A⟩
            Rx(2.0 * alpha, q);
        }
    }

    
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T5_IsQubitA () : Unit {
        
        for (i in 0 .. 10) {
            let alpha = (PI() * IntAsDouble(i)) / 10.0;
            DistinguishTwoStates(StatePrep_IsQubitA(alpha, _, _), IsQubitA(alpha, _), 
                [$"|B⟩=(-i sin({i}π/10)|0⟩ + cos({i}π/10)|1⟩)", $"|A⟩=(cos({i}π/10)|0⟩ + i sin({i}π/10)|1⟩)"]);
        }
    }

    
}