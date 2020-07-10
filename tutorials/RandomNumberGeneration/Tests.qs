// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.RandomNumberGeneration {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Quantum.Kata.Utils;
    open Microsoft.Quantum.Arrays;
    

    // Exercise 1.
    operation T1_RandomBit_Test () : Unit {
        Message("Testing...");
        mutable count = 0;

        ResetOracleCallsCount();
        for (N in 1..1000) {
            set count += RandomBit();
        }
        if (count < 465) {
            fail $"Unexpectedly low number of 1's generated. Generated {count} out of 1000";
        } elif (count > 535) {
            fail $"Unexpectedly high number of 1's generated. Generated {count} out of 1000";
        }
        CheckRandomCalls();
    }

    // Exercise 2.
    operation T2_RandomTwoBits_Test () : Unit {
        Message("Testing...");
        CheckFlatDistribution(RandomTwoBits_Wrapper, 2, 1, 2, 200);
    }

    operation RandomTwoBits_Wrapper (throwaway: Int) : Int {
        return RandomTwoBits();
    }
    
    // Exercise 3.
    operation T3_RandomNBits_Test () : Unit {
        Message("Testing N = 1...");
        CheckFlatDistribution(RandomNBits, 1, 0, 2, 465);
        Message("Testing N = 2...");
        CheckFlatDistribution(RandomNBits, 2, 1, 2, 200);
        Message("Testing N = 10...");
        CheckFlatDistribution(RandomNBits, 10, 461, 563, 0);

    }

    // f: operation to be tested
    // numBits: number of bits in each result
    // lowRange, highRange: median and average for generated dataset should be within [lowRange, highRange]
    // minimum: the minimum number of times each possible number should be generated
    operation CheckFlatDistribution (f : (Int => Int), numBits: Int, lowRange: Int, highRange: Int, minimum: Int) : Unit {
        let max = PowI(2, numBits);
        mutable counts = ConstantArray(max, 0);
        mutable average = 0;
        let total = 1000;

        ResetOracleCallsCount();
        for (i in 1..total) {
            let val = f(numBits);
            set average = average + val;
            set counts w/= val <- counts[val] + 1;
        }
        CheckRandomCalls();

        set average = average / total;
        if (average < lowRange or average > highRange) {
            fail $"Unexpected average. Expected between {lowRange} and {highRange}, instead was {average}";
        }

        let median = FindMedian (counts, max, total);
        if (median < lowRange or median > highRange) {
            fail $"Unexpected median. Expected between {lowRange} and {highRange}, instead was {median}.";

        }

        for (i in 0..max - 1) {
            if (counts[i] < minimum) {
                fail $"Unexpectedly low number of {i}'s generated. Only {counts[i]} out of {total} were {i}";
            }
        }
    }

    operation FindMedian (counts : Int [], arrSize : Int, sampleSize : Int) : Int {
        mutable x = 0;
        for (i in 0..arrSize - 1) {
            set x = x + counts[i];
            if (x >= sampleSize / 2) {
                return i;
            }
        }
        return -1;
    }

    // Exercise 4.
    operation T4_WeightedRandomBit_Test () : Unit {
        ResetOracleCallsCount();
        CheckXPercentZero(0.0);
        CheckXPercentZero(1.0);
        CheckXPercentZero(0.25);
        CheckXPercentZero(0.5);
        CheckXPercentZero(0.75);
        CheckRandomCalls();
    }

    operation CheckXPercentZero (x : Double) : Unit {
        Message($"Testing x = {x}...");
        mutable oneCount = 0;
        ResetOracleCallsCount();
        for (N in 1..1000) {
            set oneCount += WeightedRandomBit(x);
        }
        CheckRandomCalls();

        let zeroCount = 1000 - oneCount;
        
        if (x == 0.0) {
            if (zeroCount != 0) {
                fail $"expected 0% 0's, instead got {zeroCount} 0's out of 1000";
            }
        } elif (x == 1.0) {
            if (zeroCount != 1000) {
                fail $"expected 100% 0's, instead got {zeroCount} 0's out of 1000";
            }
        } else {
            let goalZeroCount = Floor(x * 1000.0);
            if (zeroCount < goalZeroCount - 35) {
                fail $"Unexpectedly low number of 0's generated. Generated {zeroCount} out of 1000";
            } elif (zeroCount > goalZeroCount + 35) {
                fail $"Unexpectedly high number of 0's generated. Generated {zeroCount} out of 1000";
            }
        }
    }

    operation CheckRandomCalls () : Unit {
        Fact(GetOracleCallsCount(RandomInt) == 0, "You are not allowed to call RandomInt() in this task");
        Fact(GetOracleCallsCount(RandomIntPow2) == 0, "You are not allowed to call RandomIntPow2() in this task");
        Fact(GetOracleCallsCount(RandomReal) == 0, "You are not allowed to call RandomReal() in this task");
        Fact(GetOracleCallsCount(RandomSingleQubitPauli) == 0, "You are not allowed to call RandomSingleQubitPauli() in this task");
        Fact(GetOracleCallsCount(Random) == 0, "You are not allowed to call Random() in this task");
        ResetOracleCallsCount();
    }
}