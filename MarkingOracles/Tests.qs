// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MarkingOracles {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Random;

    // ------------------------------------------------------
    // The operation that runs the oracle on every bit string and compares the results with those of a classical function
    // (also checks that there are no measurements)
    operation AssertOracleImplementsFunction (N : Int, oracle : ((Qubit[], Qubit) => Unit), f : (Bool[] -> Bool)) : Unit {
        let size = 1 <<< N;
        use (qs, target) = (Qubit[N], Qubit());
        for k in 0 .. size - 1 {
            // Prepare k-th bit vector
            let binary = IntAsBoolArray(k, N);
            
            //Message($"{k}/{N} = {binary}");
            // binary is little-endian notation, so the second vector tried has qubit 0 in state 1 and the rest in state 0
            ApplyPauliFromBitString(PauliX, true, binary, qs);
            
            // Apply the operation and check that it doesn't use measurements
            within {
                AllowAtMostNCallsCA(0, Measure, "Your solution should not use measurements");
                AllowAtMostNCallsCA(0, M, "Your solution should not use measurements");
            } apply {
                oracle(qs, target);
            }
            
            // Check that the result is what we'd expect to measure
            let val = f(binary);
            AssertQubit(val ? One | Zero, target);
            Reset(target);

            // Check that the query qubits are still in the same state
            ApplyPauliFromBitString(PauliX, true, binary, qs);
            AssertAllZero(qs);
        }
    }


    // ------------------------------------------------------
    function PalindromeF(args : Bool[]) : Bool {
        let N = Length(args);
        for i in 0 .. N / 2 - 1 {
            if args[i] != args[N - i - 1] {
                return false;
            }
        }
        return true;
    }


    @Test("QuantumSimulator")
    operation T01_PalindromeOracle () : Unit {
        for N in 2 .. 6 {
            AssertOracleImplementsFunction(N, PalindromeOracle, PalindromeF);
        }
    }


    // ------------------------------------------------------
    function PeriodicGivenPeriodF(args : Bool[], P : Int) : Bool {
        let N = Length(args);
        for i in 0 .. N - P - 1 {
            if args[i] != args[i + P] {
                return false;
            }
        }
        return true;
    }


    @Test("QuantumSimulator")
    operation T02_PeriodicGivenPeriodOracle () : Unit {
        for N in 2 .. 6 {
            for P in 2 .. N - 1 {
                AssertOracleImplementsFunction(N, PeriodicGivenPeriodOracle(_, _, P), PeriodicGivenPeriodF(_, P));
            }
        }
    }


    // ------------------------------------------------------
    function PeriodicF(args : Bool[]) : Bool {
        let N = Length(args);
        for P in 1 .. N - 1 {
            if PeriodicGivenPeriodF(args, P) {
                return true;
            }
        }
        return false;
    }


    @Test("QuantumSimulator")
    operation T03_PeriodicOracle () : Unit {
        for N in 2 .. 6 {
            AssertOracleImplementsFunction(N, PeriodicOracle, PeriodicF);
        }
    }


    // ------------------------------------------------------
    function  ContainsSubstringAtPositionF(args : Bool[], pattern : Bool[], P : Int) : Bool {
        for i in 0 .. Length(pattern) - 1 {
            if pattern[i] != args[i + P] {
                return false;
            }
        }
        return true;
    }


    @Test("QuantumSimulator")
    operation T04_ContainsSubstringAtPositionOracle () : Unit {
        for (N, P, pattern) in [
            (2, 1, [true]),
            (3, 0, [false, true]),
            (4, 1, [true, true, false]),
            (5, 3, [false])
        ] {
            AssertOracleImplementsFunction(N, 
                ContainsSubstringAtPositionOracle(_, _, pattern, P), 
                ContainsSubstringAtPositionF(_, pattern, P));
        }
    }


    // ------------------------------------------------------
    function PatternMatchingF(args : Bool[], indices : Int[], pattern : Bool[]) : Bool {
        for i in 0 .. Length(indices) - 1 {
            if args[indices[i]] != pattern[i] {
                return false;
            }
        }
        return true;
    }


    @Test("QuantumSimulator")
    operation T05_PatternMatchingOracle () : Unit {
        for (N, indices, pattern) in [
            (2, [], []),
            (2, [1], [true]),
            (3, [0, 2], [false, true]),
            (4, [1, 3], [true, false]),
            (5, [0, 1, 4], [true, true, false])
        ] {
            AssertOracleImplementsFunction(N, PatternMatchingOracle(_, _, indices, pattern), PatternMatchingF(_, indices, pattern));
        }
    }


    // ------------------------------------------------------
    function ContainsSubstringF(args : Bool[], pattern : Bool[]) : Bool {
        let N = Length(args);
        let K = Length(pattern);
        for P in 0 .. N - K {
            if ContainsSubstringAtPositionF(args, pattern, P) {
                return true;
            }
        }
        return false;
    }


    @Test("QuantumSimulator")
    operation T06_ContainsSubstringOracle () : Unit {
        for (N, pattern) in [
            (2, [true]),
            (3, [false, true]),
            (4, [true, true, false]),
            (5, [false, false])
        ] {
            AssertOracleImplementsFunction(N, 
                ContainsSubstringOracle(_, _, pattern), 
                ContainsSubstringF(_, pattern));
        }
    }


    // ------------------------------------------------------
    function BalancedF(args : Bool[]) : Bool {
        return Count(x -> x, args) == Length(args) / 2;
    }


    @Test("QuantumSimulator")
    operation T07_BalancedOracle () : Unit {
        for N in 2 .. 2 .. 6 {
            AssertOracleImplementsFunction(N, BalancedOracle, BalancedF);
        }
    }


    // ------------------------------------------------------
    function MajorityF(args : Bool[]) : Bool {
        let N = Length(args);
        return Count(x -> x, args) > (N - 1) / 2;
    }


    @Test("QuantumSimulator")
    operation T08_MajorityOracle () : Unit {
        let N = 7;
        AssertOracleImplementsFunction(N, MajorityOracle, MajorityF);
    }


    // ------------------------------------------------------
    function BitSumDivisibleBy3F(args : Bool[]) : Bool {
        return Count(x -> x, args) % 3 == 0;
    }


    @Test("QuantumSimulator")
    operation T09_BitSumDivisibleBy3Oracle () : Unit {
        for N in 3 .. 6 {
            AssertOracleImplementsFunction(N, BitSumDivisibleBy3Oracle, BitSumDivisibleBy3F);
        }
    }


    // ------------------------------------------------------
    function DivisibleBy3F(args : Bool[]) : Bool {
        return BoolArrayAsInt(args) % 3 == 0;
    }


    @Test("QuantumSimulator")
    operation T10_DivisibleBy3Oracle () : Unit {
        for N in 2 .. 7 {
            AssertOracleImplementsFunction(N, DivisibleBy3Oracle, DivisibleBy3F);
        }
    }
}
