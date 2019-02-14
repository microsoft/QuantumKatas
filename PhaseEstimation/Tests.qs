// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.PhaseEstimation {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Quantum phase estimation (QPE)
    //////////////////////////////////////////////////////////////////
    
    operation AssertEqualOnZeroState1 (testImpl : (Qubit => Unit), refImpl : (Qubit => Unit : Adjoint)) : Unit {
        using (q = Qubit()) {
            // apply operation that needs to be tested
            testImpl(q);

            // apply adjoint reference operation and check that the result is |0⟩
            Adjoint refImpl(q);
            
            AssertQubit(Zero, q);
        }
    }


    operation T11_Eigenstates_ZST_Test () : Unit {
        for (state in 0..1) {
            AssertEqualOnZeroState1(Eigenstates_ZST(_, state), Eigenstates_ZST_Reference(_, state));
        }
    }


    // ------------------------------------------------------
    // helper wrapper to represent operation on one qubit as an operation on an array of qubits
    operation ArrayWrapperOperation1 (op : (Qubit => Unit : Adjoint, Controlled), qs : Qubit[]) : Unit {
        
        body (...) {
            op(qs[0]);
        }
        
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }


    operation T12_UnitaryPower_Test () : Unit {
        for (U in [Z, S, T]) { 
            for (power in 1..5) {
                AssertOperationsEqualReferenced(ArrayWrapperOperation1(UnitaryPower(U, power), _), 
                                                ArrayWrapperOperation1(UnitaryPower_Reference(U, power), _), 1);
            }
        }
    }


    // ------------------------------------------------------
    operation TestAssertIsEigenstate_True () : Unit {
        // Test state/unitary pairs which are eigenstates (so no exception should be thrown)
        for ((unitary, statePrep) in [(Z, I), (Z, X),
                                      (S, I), (S, X),
                                      (X, H), (X, BindCA([X, H])),
                                      (Y, BindCA([H, S])), (Y, BindCA([X, H, S]))]) {
            AssertIsEigenstate(unitary, statePrep);
        }
    }


    // ------------------------------------------------------
    operation T14_QPE_Test () : Unit {
        AssertAlmostEqualTol(QPE(Z, I, 1), 0.0, 0.25);
        AssertAlmostEqualTol(QPE(Z, X, 1), 0.5, 0.25);

        AssertAlmostEqualTol(QPE(S, I, 2), 0.0, 0.125);
        AssertAlmostEqualTol(QPE(S, X, 2), 0.25, 0.125);

        AssertAlmostEqualTol(QPE(T, I, 3), 0.0,   0.0625);
        AssertAlmostEqualTol(QPE(T, X, 3), 0.125, 0.0625);
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Iterative phase estimation
    //////////////////////////////////////////////////////////////////
    
    operation Test1BitPEOnOnePair(U : (Qubit => Unit : Adjoint, Controlled), P : (Qubit => Unit : Adjoint), expected : Int) : Unit {
        ResetQubitCount();
        ResetOracleCallsCount();

        let actual = SingleBitPE(U, P);
        AssertIntEqual(actual, expected, $"Unexpected return for ({U}, {P}): expected {expected}, got {actual}");
        
        let nq = GetMaxQubitCount();
        AssertIntEqual(nq, 2, $"You are allowed to allocate exactly 2 qubits, and you allocated {nq}");
        
        let nu = GetOracleCallsCount(Controlled U);
        AssertIntEqual(nu, 1, $"You are allowed to call Controlled U exactly once, and you called it {nu} times");
    }

    operation T21_SingleBitPE_Test () : Unit {
        Test1BitPEOnOnePair(Z, I, +1);
        Test1BitPEOnOnePair(Z, X, -1);
        Test1BitPEOnOnePair(X, H, +1);
        Test1BitPEOnOnePair(X, BindCA([X, H]), -1);
    }


    // ------------------------------------------------------
    operation Test2BitPEOnOnePair(U : (Qubit => Unit : Adjoint, Controlled), P : (Qubit => Unit : Adjoint), expected : Double) : Unit {
        ResetQubitCount();

        let actual = TwoBitPE(U, P);
        AssertAlmostEqualTol(actual, expected, 0.001);
        
        let nq = GetMaxQubitCount();
        AssertIntEqual(nq, 2, $"You are allowed to allocate exactly 2 qubits, and you allocated {nq}");
    }

    operation T22_TwoBitPE_Test () : Unit {
        Test2BitPEOnOnePair(Z, I, 0.0);
        Test2BitPEOnOnePair(Z, X, 0.5);
        Test2BitPEOnOnePair(S, X, 0.25);
        Test2BitPEOnOnePair(BindCA([S, Z]), X, 0.75);

        Test2BitPEOnOnePair(X, H, 0.0);
        Test2BitPEOnOnePair(X, BindCA([X, H]), 0.5);
        Test2BitPEOnOnePair(BindCA([H, S, H]), H, 0.0);
        Test2BitPEOnOnePair(BindCA([H, S, H]), BindCA([X, H]), 0.25);
        Test2BitPEOnOnePair(BindCA([H, S, Z, H]), BindCA([X, H]), 0.75);
    }


    // ------------------------------------------------------
    function GetOracleCallsCount<'T> (oracle : 'T) : Int { return 0; }
    
    function ResetOracleCallsCount () : Unit { }

    function GetMaxQubitCount () : Int { return 0; }
    
    function ResetQubitCount () : Unit { }
}
