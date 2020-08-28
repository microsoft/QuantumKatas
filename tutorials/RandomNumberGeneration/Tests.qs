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
    open Microsoft.Quantum.Arrays;
    open Quantum.Kata.Utils;
    open Microsoft.Quantum.Random;

    // Exercise 1.
    operation T1_RandomBit_Test () : Unit {
        Message("Testing...");
        CheckFlatDistribution(RandomBit_Wrapper, 1, 0.4, 0.6, 1000, 450);
    }

    operation RandomBit_Wrapper (throwaway: Int) : Int {
        return RandomBit();
    }

    // Exercise 2.
    operation T2_RandomTwoBits_Test () : Unit {
        Message("Testing...");
        CheckFlatDistribution(RandomTwoBits_Wrapper, 2, 1.4, 1.6, 1000, 200);
    }

    operation RandomTwoBits_Wrapper (throwaway: Int) : Int {
        return RandomTwoBits();
    }
    
    // Exercise 3.
    operation T3_RandomNBits_Test () : Unit {
        Message("Testing N = 1...");
        CheckFlatDistribution(RandomNBits, 1, 0.4, 0.6, 1000, 450);
        Message("Testing N = 2...");
        CheckFlatDistribution(RandomNBits, 2, 1.4, 1.6, 1000, 200);
        Message("Testing N = 3...");
        CheckFlatDistribution(RandomNBits, 3, 3.3, 3.7, 1000, 90);
        Message("Testing N = 10...");
        CheckFlatDistribution(RandomNBits, 10, 461.0, 563.0, 1000, 0);
    }

    /// # Input
    /// ## f
    /// Random number generation operation to be tested
    /// ## numBits
    /// Number of bits in the generated result
    /// ## lowRange
    /// The lower bound of the median and average for generated dataset
    /// ## highRange
    /// The upper bound of the median and average for generated dataset
    /// ## nRuns
    /// The number of random numbers to generate for test
    /// ## minimumCopiesGenerated
    /// The minimum number of times each possible number should be generated
    operation CheckFlatDistribution (f : (Int => Int), numBits : Int, lowRange : Double, highRange : Double, nRuns : Int, minimumCopiesGenerated : Int) : Unit {
        let max = PowI(2, numBits);
        mutable counts = ConstantArray(max, 0);
        mutable average = 0.0;

        ResetOracleCallsCount();
        for (i in 1..nRuns) {
            let val = f(numBits);
            if (val < 0 or val >= max) {
                fail $"Unexpected number generated. Expected values from 0 to {max - 1}, generated {val}";
            }
            set average += IntAsDouble(val);
            set counts w/= val <- counts[val] + 1;
        }
        CheckRandomCalls();

        set average = average / IntAsDouble(nRuns);
        if (average < lowRange or average > highRange) {
            fail $"Unexpected average of generated numbers. Expected between {lowRange} and {highRange}, got {average}";
        }

        let median = FindMedian (counts, max, nRuns);
        if (median < Floor(lowRange) or median > Ceiling(highRange)) {
            fail $"Unexpected median of generated numbers. Expected between {Floor(lowRange)} and {Ceiling(highRange)}, got {median}.";

        }

        for (i in 0..max - 1) {
            if (counts[i] < minimumCopiesGenerated) {
                fail $"Unexpectedly low number of {i}'s generated. Only {counts[i]} out of {nRuns} were {i}";
            }
        }
    }

    operation FindMedian (counts : Int [], arrSize : Int, sampleSize : Int) : Int {
        mutable totalCount = 0;
        for (i in 0..arrSize - 1) {
            set totalCount = totalCount + counts[i];
            if (totalCount >= sampleSize / 2) {
                return i;
            }
        }
        return -1;
    }

    // Exercise 4.
    operation T4_WeightedRandomBit_Test () : Unit {
        ResetOracleCallsCount();
        CheckXPercentZero(0.0);
        CheckXPercentZero(0.25);
        CheckXPercentZero(0.5);
        CheckXPercentZero(0.75);
        CheckXPercentZero(1.0);
        CheckRandomCalls();
    }

    operation CheckXPercentZero (x : Double) : Unit {
        Message($"Testing x = {x}...");
        mutable oneCount = 0;
        let nRuns = 1000;
        ResetOracleCallsCount();
        for (N in 1..nRuns) {
            let val = WeightedRandomBit(x);
            if (val < 0 or val > 1) {
                fail $"Unexpected number generated. Expected 0 or 1, instead generated {val}";
            }
            set oneCount += val;
        }
        CheckRandomCalls();

        let zeroCount = nRuns - oneCount;
        let goalZeroCount = (x == 0.0) ? 0 | (x == 1.0) ? nRuns | Floor(x * IntAsDouble(nRuns));
        // We don't have tests with probabilities near 0.0 or 1.0, so for those the matching has to be exact
        if (goalZeroCount == 0 or goalZeroCount == nRuns) {
            if (zeroCount != goalZeroCount) {
                fail $"Expected {x * 100.0}% 0's, instead got {zeroCount} 0's out of {nRuns}";
            }
        } else {
            if (zeroCount < goalZeroCount - 4 * nRuns / 100) {
                fail $"Unexpectedly low number of 0's generated: expected around {x * IntAsDouble(nRuns)} 0's, got {zeroCount} out of {nRuns}";
            } elif (zeroCount > goalZeroCount + 4 * nRuns / 100) {
                fail $"Unexpectedly high number of 0's generated: expected around {x * IntAsDouble(nRuns)} 0's, got {zeroCount} out of {nRuns}";
            }
        }
    }

    operation CheckRandomCalls () : Unit {
        Fact(GetOracleCallsCount(RandomInt) == 0, "You are not allowed to call RandomInt() in this task");
        Fact(GetOracleCallsCount(DrawRandomInt) == 0, "You are not allowed to call DrawRandomInt() in this task");
        Fact(GetOracleCallsCount(RandomIntPow2) == 0, "You are not allowed to call RandomIntPow2() in this task");
        Fact(GetOracleCallsCount(RandomReal) == 0, "You are not allowed to call RandomReal() in this task");
        Fact(GetOracleCallsCount(DrawRandomDouble) == 0, "You are not allowed to call DrawRandomDouble() in this task");
        Fact(GetOracleCallsCount(RandomSingleQubitPauli) == 0, "You are not allowed to call RandomSingleQubitPauli() in this task");
        Fact(GetOracleCallsCount(Random) == 0, "You are not allowed to call Random() in this task");
        ResetOracleCallsCount();
    }
}