// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    open Quantum.Kata.Utils;
    

    function ConstantOrBalanced (value : Bool) : String {
        return (value ? "constant" | "balanced");
    }

    
    //////////////////////////////////////////////////////////////////
    // Part I. Classical algorithm
    //////////////////////////////////////////////////////////////////

    // Exercise 1.
    @Test("QuantumSimulator")
    operation T1_ClassicalFunction () : Unit {
        for N in 1 .. 5 {
            for x in 0 .. (1 <<< (N - 1)) - 1 {
                let ret = Function_MostSignificantBit(x, N);
                Fact(ret == 0, $"Unexpected return for x = {x}, N = {N}: expected 0, got {ret}");
            }
            for x in (1 <<< (N - 1))..(1 <<< N) - 1 {
                let ret = Function_MostSignificantBit(x, N);
                Fact(ret == 1, $"Unexpected return for x = {x}, N = {N}: expected 1, got {ret}");
            }
        }
    }


    // Exercise 2.
    operation CheckClassicalAlgorithm (N : Int, f : (Int -> Int), expected : Bool, functionName : String) : Unit {
        Message($"Testing {functionName}...");

        let actual = IsFunctionConstant_Classical(N, f);
        
        // check that the return value is correct
        if (actual != expected) {
            let actualStr = ConstantOrBalanced(actual);
            let expectedStr = ConstantOrBalanced(expected);
            fail $"    identified as {actualStr} but it is {expectedStr}.";
        }

        Message("    correct!");
    }

    @Test("QuantumSimulator")
    operation T2_ClassicalAlgorithm () : Unit {
        CheckClassicalAlgorithm(4, Function_Zero_Reference, true, "f(x) = 0");
        CheckClassicalAlgorithm(4, Function_One_Reference, true, "f(x) = 1");
        CheckClassicalAlgorithm(4, Function_Xmod2_Reference, false, "f(x) = x mod 2");
        CheckClassicalAlgorithm(4, Function_OddNumberOfOnes_Reference, false, "f(x) = (1 if x has odd number of 1s, and 0 otherwise)");
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Single-bit problem
    //////////////////////////////////////////////////////////////////

    // We need to compare phase oracles as their controlled versions to account for the global phase.
    operation ControlledWrapper (qs : Qubit[], phaseOracle : (Qubit => Unit is Adj + Ctl)) : Unit is Adj + Ctl {
        Controlled phaseOracle([qs[0]], qs[1]);
    }

    // Exercise 3.
    @Test("QuantumSimulator")
    operation T3_PhaseOracle_OneMinusX () : Unit {
        AssertOperationsEqualReferenced(2, ControlledWrapper(_, PhaseOracle_OneMinusX), 
                                           ControlledWrapper(_, PhaseOracle_OneMinusX_Reference));
    }

    
    // Exercise 4.
    operation CheckDeutschAlgorithm (oracle : (Qubit => Unit), expected : Bool, functionName : String) : Unit {
        Message($"Testing {functionName}...");

        let actual = DeutschAlgorithm(oracle);
        
        // check that the return value is correct
        if (actual != expected) {
            let actualStr = ConstantOrBalanced(actual);
            let expectedStr = ConstantOrBalanced(expected);
            fail $"    identified as {actualStr} but it is {expectedStr}.";
        }

        let nu = GetOracleCallsCount(oracle);
        if (nu > 1) {
            fail $"    took {nu} oracle calls to decide; you are only allowed to call the oracle once";
        }

        Message("    correct!");
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T4_DeutschAlgorithm () : Unit {
        ResetOracleCallsCount();

        for (oracle, expectedVerdict, name) in [(I, true, "f(x) = 0"), 
                                                (R(PauliI, 2.0 * PI(), _), true, "f(x) = 1"), 
                                                (Z, false, "f(x) = x"), 
                                                (BoundCA([X, Z, X]), false, "f(x) = 1 - x")] {
            CheckDeutschAlgorithm(oracle, expectedVerdict, name);
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Multi-bit problem
    //////////////////////////////////////////////////////////////////
    
    // TODO: switch exercise 5 to a controlled wrapper as well

    // Exercise 5.
    @Test("QuantumSimulator")
    operation T5_MostSignificantBitOracle () : Unit {
        for N in 1 .. 5 {
            AssertOperationsEqualReferenced(N, PhaseOracle_MostSignificantBit, PhaseOracle_MostSignificantBit_Reference);
        }
    }


    // Exercise 6.
    operation CheckQuantumAlgorithm (N : Int, oracle : (Qubit[] => Unit), expected : Bool, functionName : String) : Unit {
        Message($"Testing {functionName}...");

        let actual = DeutschJozsaAlgorithm(N, oracle);
        
        // check that the return value is correct
        if (actual != expected) {
            let actualStr = ConstantOrBalanced(actual);
            let expectedStr = ConstantOrBalanced(expected);
            fail $"    identified as {actualStr} but it is {expectedStr}.";
        }

        let nu = GetOracleCallsCount(oracle);
        if (nu > 1) {
            fail $"    took {nu} oracle calls to decide; you are only allowed to call the oracle once";
        }

        Message("    correct!");
    }

    
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T6_DeutschJozsaAlgorithm () : Unit {
        ResetOracleCallsCount();
        
        CheckQuantumAlgorithm(4, PhaseOracle_Zero_Reference, true, "f(x) = 0");
        CheckQuantumAlgorithm(4, PhaseOracle_One_Reference, true, "f(x) = 1");
        CheckQuantumAlgorithm(4, PhaseOracle_Xmod2_Reference, false, "f(x) = x mod 2");
        CheckQuantumAlgorithm(4, PhaseOracle_OddNumberOfOnes_Reference, false, "f(x) = (1 if x has odd number of 1s, and 0 otherwise)");
    }
}