// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Measurements
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;

    //////////////////////////////////////////////////////////////////

    // "Framework" operation for testing single-qubit tasks for distinguishing states of one qubit
    // with Bool return
    operation DistinguishTwoStates_OneQubit (
        statePrep : ((Qubit, Int) => ()),
        testImpl : (Qubit => Bool)
        ) : ()
    {
        body
        {
            let nTotal = 100;
            mutable nOk = 0;
            using (qs = Qubit[1]) 
            {
                for (i in 1..nTotal) 
                {
                    // get a random bit to define whether qubit will be in a state corresponding to true return (1) or to false one (0)
                    // state = 0 false return
                    // state = 1 true return
                    let state = RandomIntPow2(1);

                    // do state prep: convert |0〉 to outcome with false return or to outcome with true return depending on state
                    statePrep(qs[0], state);
        
                    // get the solution's answer and verify that it's a match
                    let ans = testImpl(qs[0]);
                    if (ans == (state == 1)) {
                        set nOk = nOk + 1;
                    }

                    // we're not checking the state of the qubit after the operation
                    Reset(qs[0]);
                }
            }
            AssertIntEqual(nOk, nTotal, $"{nTotal - nOk} test runs out of {nTotal} returned incorrect state.");
        }
    }

    // ------------------------------------------------------
    operation StatePrep_IsQubitOne (q : Qubit, state : Int) : () {
        body {
            if (state == 0) {
                // convert |0〉 to |0〉
            } else {
                // convert |0〉 to |1〉
                X(q);
            }
        }
    }

    operation T101_IsQubitOne_Test () : ()
    {
        body
        {
            DistinguishTwoStates_OneQubit(StatePrep_IsQubitOne, IsQubitOne);
        }
    }

    // ------------------------------------------------------
    operation StatePrep_IsQubitPlus (q : Qubit, state : Int) : () {
        body {
            if (state == 0) {
                // convert |0〉 to |-〉
                X(q);
                H(q);
            } else {
                // convert |0〉 to |+〉
                H(q);
            }
        }
    }

    operation T102_IsQubitPlus_Test () : ()
    {
        body
        {
            DistinguishTwoStates_OneQubit(StatePrep_IsQubitPlus, IsQubitPlus);
        }
    }

    // ------------------------------------------------------
    // |A〉 =   cos(alpha) * |0〉 + sin(alpha) * |1〉, 
    // |B〉 = - sin(alpha) * |0〉 + cos(alpha) * |1〉.
    operation StatePrep_IsQubitA (alpha : Double, q : Qubit, state : Int) : () {
        body {
            if (state == 0) {
                // convert |0〉 to |B〉
                X(q);
                Ry(2.0 * alpha, q);
            } else {
                // convert |0〉 to |A〉
                Ry(2.0 * alpha, q);
            }
        }
    }

    operation T103_IsQubitA_Test () : ()
    {
        body
        {
            // cross-test
            // alpha = 0.0 or PI() => !isQubitOne
            // alpha = PI() / 2.0 => isQubitOne
            DistinguishTwoStates_OneQubit(StatePrep_IsQubitOne, IsQubitA(PI() / 2.0, _));
            // alpha = PI() / 4.0 => isQubitPlus
            DistinguishTwoStates_OneQubit(StatePrep_IsQubitPlus, IsQubitA(PI() / 4.0, _));

            for (i in 0..10) {
                let alpha = PI() * ToDouble(i) / 10.0;
                DistinguishTwoStates_OneQubit(StatePrep_IsQubitA(alpha, _, _), IsQubitA(alpha, _));
            }
        }
    }

    // ------------------------------------------------------

    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return
    operation DistinguishStates_MultiQubit (
        Nqubit : Int,
        Nstate : Int,
        statePrep : ((Qubit[], Int) => ()),
        testImpl : (Qubit[] => Int)
        ) : ()
    {
        body
        {
            let nTotal = 100;
            mutable nOk = 0;
            using (qs = Qubit[Nqubit]) 
            {
                for (i in 1..nTotal) 
                {
                    // get a random integer to define the state of the qubits
                    let state = RandomInt(Nstate);

                    // do state prep: convert |0...0〉 to outcome with return equal to state
                    statePrep(qs, state);
        
                    // get the solution's answer and verify that it's a match
                    let ans = testImpl(qs);
                    if (ans == state) {
                        set nOk = nOk + 1;
                    }

                    // we're not checking the state of the qubit after the operation
                    ResetAll(qs);
                }
            }
            AssertIntEqual(nOk, nTotal, $"{nTotal - nOk} test runs out of {nTotal} returned incorrect state.");
        }
    }

    // ------------------------------------------------------
    operation StatePrep_ZeroZeroOrOneOne (qs : Qubit[], state : Int) : () {
        body {
            if (state == 1) {
                // |11〉
                X(qs[0]);
                X(qs[1]);
            }
        }
    }

    operation T104_ZeroZeroOrOneOne_Test () : () {
        body {
            DistinguishStates_MultiQubit(2, 2, StatePrep_ZeroZeroOrOneOne, ZeroZeroOrOneOne);
        }
    }

    // ------------------------------------------------------
    operation StatePrep_BasisStateMeasurement (qs : Qubit[], state : Int) : () {
        body {
            if (state / 2 == 1) {
                // |10〉 or |11〉
                X(qs[0]);
            }
            if (state % 2 == 1) {
                // |01〉 or |11〉
                X(qs[1]);
            }
        }
    }

    operation T105_BasisStateMeasurement_Test () : () {
        body {
            DistinguishStates_MultiQubit(2, 4, StatePrep_BasisStateMeasurement, BasisStateMeasurement);
        }
    }

    // ------------------------------------------------------
    operation StatePrep_Bitstring (qs : Qubit[], bits : Bool[]) : () {
        body {
            for (i in 0..Length(qs)-1) {
                if (bits[i]) {
                    X(qs[i]);
                }
            }
        }
    }

    operation StatePrep_TwoBitstringsMeasurement (qs : Qubit[], bits1 : Bool[], bits2 : Bool[], state : Int) : () {
        body {
            if (state == 0) {
                StatePrep_Bitstring(qs, bits1);
            } else {
                StatePrep_Bitstring(qs, bits2);
            }
        }
    }

    operation T106_TwoBitstringsMeasurement_Test () : () {
        body {
            for (i in 1..1) {
                let b1 = [false; true];
                let b2 = [true; false];
                DistinguishStates_MultiQubit(2, 2, StatePrep_TwoBitstringsMeasurement(_, b1, b2, _), TwoBitstringsMeasurement(_, b1, b2));
            }
            for (i in 1..1) {
                let b1 = [true; true; false];
                let b2 = [false; true; true];
                DistinguishStates_MultiQubit(3, 2, StatePrep_TwoBitstringsMeasurement(_, b1, b2, _), TwoBitstringsMeasurement(_, b1, b2));
            }
            for (i in 1..1) {
                let b1 = [false; true; true; false];
                let b2 = [false; true; true; true];
                DistinguishStates_MultiQubit(4, 2, StatePrep_TwoBitstringsMeasurement(_, b1, b2, _), TwoBitstringsMeasurement(_, b1, b2));
            }
            for (i in 1..1) {
                let b1 = [true; false; false; false];
                let b2 = [true; false; true; true];
                DistinguishStates_MultiQubit(4, 2, StatePrep_TwoBitstringsMeasurement(_, b1, b2, _), TwoBitstringsMeasurement(_, b1, b2));
            }
        }
    }

    // ------------------------------------------------------
    operation WState_Arbitrary_Reference (qs : Qubit[]) : ()
    {
        body
        {
            let N = Length(qs);
            if (N == 1) {
                // base case of recursion: |1〉
                X(qs[0]);
            } else {
                // |W_N> = |0〉|W_(N-1)> + |1〉|0...0〉
                // do a rotation on the first qubit to split it into |0〉 and |1〉 with proper weights
                // |0〉 -> sqrt((N-1)/N) |0〉 + 1/sqrt(N) |1〉
                let theta = ArcSin(1.0 / Sqrt(ToDouble(N)));
                Ry(2.0 * theta, qs[0]);
                // do a zero-controlled W-state generation for qubits 1..N-1
                X(qs[0]);
                (Controlled WState_Arbitrary_Reference)(qs[0..0], qs[1..N-1]);
                X(qs[0]);
            }
        }
        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    operation StatePrep_AllZerosOrWState (qs : Qubit[], state : Int) : () {
        body {
            if (state == 1) {
                // prep W state
                WState_Arbitrary_Reference(qs);
            }
        }
    }

    operation T107_AllZerosOrWState_Test () : () {
        body {
            for (i in 2..6) {
                DistinguishStates_MultiQubit(i, 2, StatePrep_AllZerosOrWState, AllZerosOrWState);
            }
        }
    }

    // ------------------------------------------------------
    operation GHZ_State_Reference (qs : Qubit[]) : ()
    {
        body
        {
            H(qs[0]);
            for (i in 1 .. Length(qs)-1) {
                CNOT(qs[0], qs[i]);
            }
        }
        adjoint auto;
    }

    operation StatePrep_GHZOrWState (qs : Qubit[], state : Int) : () {
        body {
            if (state == 0) {
                // prep GHZ state
                GHZ_State_Reference(qs);
            } else {
                // prep W state
                WState_Arbitrary_Reference(qs);
            }
        }
    }

    operation T108_GHZOrWState_Test () : () {
        body {
            for (i in 2..6) {
                DistinguishStates_MultiQubit(i, 2, StatePrep_GHZOrWState, GHZOrWState);
            }
        }
    }

    // ------------------------------------------------------
    // 0 - |Φ⁺〉 = (|00〉 + |11〉) / sqrt(2)
    // 1 - |Φ⁻〉 = (|00〉 - |11〉) / sqrt(2)
    // 2 - |Ψ⁺〉 = (|01〉 + |10〉) / sqrt(2)
    // 3 - |Ψ⁻〉 = (|01〉 - |10〉) / sqrt(2)
    operation StatePrep_BellState (qs : Qubit[], state : Int) : () {
        body {
            H(qs[0]);
            CNOT(qs[0], qs[1]);
            // now we have |00〉 + |11〉 - modify it based on state arg
            if (state % 2 == 1) {
                // negative phase
                Z(qs[1]);
            }
            if (state / 2 == 1) {
                X(qs[1]);
            }
        }
    }

    operation T109_BellState_Test () : () {
        body {
            DistinguishStates_MultiQubit(2, 4, StatePrep_BellState, BellState);
        }
    }

    // ------------------------------------------------------
    // 0 - (|00〉 + |01〉 + |10〉 + |11〉) / 2
    // 1 - (|00〉 - |01〉 + |10〉 - |11〉) / 2
    // 2 - (|00〉 + |01〉 - |10〉 - |11〉) / 2
    // 3 - (|00〉 - |01〉 - |10〉 + |11〉) / 2
    operation StatePrep_TwoQubitState (qs : Qubit[], state : Int) : () {
        body {
            // start with state prep of basis vectors
            StatePrep_BasisStateMeasurement(qs, state);
            H(qs[0]);
            H(qs[1]);
        }
    }
    
    // ------------------------------------------------------
    // 0 - ( |00〉 - |01〉 - |10〉 - |11〉) / 2
    // 1 - (-|00〉 + |01〉 - |10〉 - |11〉) / 2
    // 2 - (-|00〉 - |01〉 + |10〉 - |11〉) / 2
    // 3 - (-|00〉 - |01〉 - |10〉 + |11〉) / 2
    operation StatePrep_TwoQubitStatePartTwo (qs : Qubit[], state : Int) : () {
        body {
            // start with state prep of basis vectors
            StatePrep_BasisStateMeasurement(qs, state);            
            // now apply all gates for unitary in reference impl (in reverse + adjoint)
            ApplyToEach(X, qs); 
            (Controlled Z)([qs[0]], qs[1]);             
            ApplyToEach(X, qs); 
            ApplyToEach(H, qs); 
            ApplyToEach(X, qs); 
            (Controlled Z)([qs[0]], qs[1]);             
            ApplyToEach(X, qs); 			
            SWAP(qs[0], qs[1]); 
        }
    }

    operation T110_TwoQubitState_Test () : () {
        body {
            DistinguishStates_MultiQubit(2, 4, StatePrep_TwoQubitState, TwoQubitState);
        }
    }

    operation T111_TwoQubitStatePartTwo_Test () : () {
        body {
            DistinguishStates_MultiQubit(2, 4, StatePrep_TwoQubitStatePartTwo, TwoQubitStatePartTwo);
        }
    }

    //////////////////////////////////////////////////////////////////

    operation StatePrep_IsQubitZeroOrPlus (q : Qubit, state : Int) : () {
        body {
            if (state == 0) {
                // convert |0〉 to |0〉
            } else {
                // convert |0〉 to |+〉
                H(q);
            }
        }
    }


    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return. Framework tests against a threshold parameter for the fraction of runs that must succeed.
    operation DistinguishStates_MultiQubit_Threshold (
        Nqubit : Int,
        Nstate : Int,
        threshold : Double, 
        statePrep : ((Qubit, Int) => ()),
        testImpl : (Qubit => Bool)
        ) : ()
    {
        body
        {
            let nTotal = 1000;
            mutable nOk = 0;
            using (qs = Qubit[Nqubit]) 
            {
                for (i in 1..nTotal) 
                {
                    // get a random integer to define the state of the qubits
                    let state = RandomInt(Nstate);

                    // do state prep: convert |0〉 to outcome with return equal to state
                    statePrep(qs[0], state);
                    // get the solution's answer and verify that it's a match
                    let ans = testImpl(qs[0]);
                    if (ans == (state == 0)) {
                        set nOk = nOk + 1;
                    }

                    // we're not checking the state of the qubit after the operation
                    ResetAll(qs);
                }
            }
            if (ToDouble(nOk) < threshold * ToDouble(nTotal)) {
                fail $"{nTotal - nOk} test runs out of {nTotal} returned incorrect state which does not meet the required threshold of at least {threshold*100}%.";
            }
        }
    }

    
    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return. Framework tests against a threshold parameter for the fraction of runs that must succeed.
    // Framework tests in the USD scenario, i.e., it is allowed to respond "inconclusive" (with some probability)
    // up to given threshold, but it is never allowed to err if an actual conclusive response is given. 
    operation USD_DistinguishStates_MultiQubit_Threshold (
        Nqubit : Int,
        Nstate : Int,
        thresholdInconcl : Double, 
        thresholdConcl : Double,		
        statePrep : ((Qubit, Int) => ()),
        testImpl : (Qubit => Int)
        ) : ()
    {
        body
        {
            let nTotal = 10000;
            mutable nInconc = 0; // counts total inconclusive answers
            mutable nConclOne = 0; // counts total conclusive |0〉 state identifications
            mutable nConclPlus = 0; // counts total conclusive |+> state identifications

            using (qs = Qubit[Nqubit]) 
            {
                for (i in 1..nTotal) 
                {
                    // get a random integer to define the state of the qubits
                    let state = RandomInt(Nstate);
                    // do state prep: convert |0〉 to outcome with return equal to state
                    statePrep(qs[0], state);
                    // get the solution's answer and verify that it's a match
                    let ans = testImpl(qs[0]);
                    // check that the answer is actually in allowed range
                    if (ans < -1 || ans > 1) {
                        fail $"state {state} led to invalid response {ans}.";
                    }
                    // keep track of the number of inconclusive answers given
                    if (ans == -1) {
                        set nInconc = nInconc + 1;
                    }
                    if (ans == 0 && state == 0) {
                        set nConclOne = nConclOne + 1;
                    }
                    if (ans == 1 && state == 1) {
                        set nConclPlus = nConclPlus + 1;
                    }
                    // check if upon conclusive result the answer is actually correct
                    if ((ans == 0) && (state == 1) || (ans == 1) && (state == 0)) {
                        fail $"state {state} led to incorrect conclusive response {ans}.";
                    }
                    // we're not checking the state of the qubit after the operation
                    ResetAll(qs);
                }
            }
            if (ToDouble(nInconc) > thresholdInconcl * ToDouble(nTotal)) {
                fail $"{nInconc} test runs out of {nTotal} returned inconclusive which does not meet the required threshold of at most {thresholdInconcl*100}%.";
            }
            if (ToDouble(nConclOne) < thresholdConcl * ToDouble(nTotal)) {
                fail $"Only {nConclOne} test runs out of {nTotal} returned conclusive |0〉 which does not meet the required threshold of at least {thresholdConcl*100}%.";
            }
            if (ToDouble(nConclPlus) < thresholdConcl * ToDouble(nTotal)) {
                fail $"Only {nConclPlus} test runs out of {nTotal} returned conclusive |+> which does not meet the required threshold of at least {thresholdConcl*100}%.";
            }
        }
    }

    operation T201_IsQubitZeroOrPlus_Test () : () {
        body {
            DistinguishStates_MultiQubit_Threshold(1, 2, 0.8, StatePrep_IsQubitZeroOrPlus, IsQubitPlusOrZero);
        }
    }

    operation T202_IsQubitZeroOrPlusSimpleUSD_Test () : () {
        body {
            USD_DistinguishStates_MultiQubit_Threshold(1, 2, 0.8, 0.1, StatePrep_IsQubitZeroOrPlus, IsQubitPlusZeroOrInconclusiveSimpleUSD);
        }
    }
}