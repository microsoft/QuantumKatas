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

    // ------------------------------------------------------
    // Exercise 1.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T1_RandomBit () : Unit {
        Message("Testing one random bit generation...");
        RetryCheckUniformDistribution(RandomBit_Wrapper, 0, 1, 1000);
        Message("Test passed");
    }

    operation RandomBit_Wrapper (throwawayMin : Int, throwawayMax : Int) : Int {
        return RandomBit();
    }


    // ------------------------------------------------------
    // Exercise 2.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T2_RandomTwoBits () : Unit {
        Message("Testing two random bits generation...");
        RetryCheckUniformDistribution(RandomTwoBits_Wrapper, 0, 3, 1000);
        Message("Test passed");
    }

    operation RandomTwoBits_Wrapper (throwawayMin : Int, throwawayMax : Int) : Int {
        return RandomTwoBits();
    }
    

    // ------------------------------------------------------
    // Exercise 3.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T3_RandomNBits () : Unit {
        // Test random number generation for 1, 2, 3, 10 bits
        for (min, max) in [(0, 1), (0, 3), (0, 7), (0, 1023)] {
            let N = Ceiling( Lg(IntAsDouble(max + 1)) );
            Message($"Testing N = {N}...");
            RetryCheckUniformDistribution(RandomNBits_Wrapper, min, max, 1000);
            Message($"Test passed for N = {N}");
	    }
    }

    operation RandomNBits_Wrapper (min : Int, max : Int) : Int {
        // For N bit random number : min = 0, max = 2^N - 1
        let N = Ceiling( Lg(IntAsDouble(max+1)) );
        return RandomNBits(N);
    }


    // ------------------------------------------------------
    /// # Summary
    /// Helper operation that checks that the given RNG operation generates a uniform distribution.
    /// # Input
    /// ## f
    /// Random number generation operation to be tested.
    /// ## min, max
    /// Minimal and maximal numbers in the range to be generated, inclusive.
    /// ## nRuns
    /// The number of random numbers to generate for test.
    operation CheckUniformDistribution (f : ((Int, Int) => Int), min : Int, max : Int, nRuns : Int) : Bool {
        let idealMean = 0.5 * IntAsDouble(max + min) ;
        let rangeDividedByTwo = 0.5 * IntAsDouble(max - min);
        // Variance = a*(a+1)/3, where a = (max-min)/2
        // For sample population : divide it by nRuns
        let varianceInSamplePopulation = (rangeDividedByTwo * (rangeDividedByTwo + 1.0)) / IntAsDouble(3 * nRuns);
        let standardDeviation = Sqrt(varianceInSamplePopulation);

        // lowRange : The lower bound of the median and average for generated dataset
        // highRange : The upper bound of the median and average for generated dataset
        // Set them with 3 units of std deviation for 99% accuracy.
        let lowRange = idealMean - 3.0 * standardDeviation;
        let highRange = idealMean + 3.0 * standardDeviation;

        let idealCopiesGenerated = IntAsDouble(nRuns) / IntAsDouble(max-min+1);
        let minimumCopiesGenerated = ( 0.8 * idealCopiesGenerated > 40.0 ) ? 0.8 * idealCopiesGenerated | 0.0;

        mutable counts = ConstantArray(max + 1, 0);
        mutable average = 0.0;

        ResetOracleCallsCount();
        for i in 1..nRuns {
            let val = f(min, max);
            if (val < min or val > max) {
                Message($"Unexpected number generated. Expected values from {min} to {max}, generated {val}");
                return false;
            }
            set average += IntAsDouble(val);
            set counts w/= val <- counts[val] + 1;
        }
        CheckRandomCalls();

        set average = average / IntAsDouble(nRuns);
        if (average < lowRange or average > highRange) {
            Message($"Unexpected average of generated numbers. Expected between {lowRange} and {highRange}, got {average}");
            return false;
        }

        let median = FindMedian (counts, max+1, nRuns);
        if (median < Floor(lowRange) or median > Ceiling(highRange)) {
            Message($"Unexpected median of generated numbers. Expected between {Floor(lowRange)} and {Ceiling(highRange)}, got {median}.");
            return false;
        }

        for i in min..max {
            if (counts[i] < Floor(minimumCopiesGenerated)) {
                Message($"Unexpectedly low number of {i}'s generated. Only {counts[i]} out of {nRuns} were {i}");
                return false;
            }
        }
        return true;
    }


    /// # Summary
    /// Helper operation to rerun check for uniform distribution several times
    /// (a single run can fail with non-negligible probability even for a correct solution).
    operation RetryCheckUniformDistribution (f : ((Int, Int) => Int), min : Int, max : Int, nRuns : Int) : Unit {
        let numRetries = 3;
        mutable sufficientlyRandom = false;
        mutable attemptNum = 1;
        repeat {
            set sufficientlyRandom = CheckUniformDistribution(f, min, max, nRuns);
            set attemptNum += 1;
        } until (sufficientlyRandom or attemptNum >= numRetries);

        if not sufficientlyRandom {
            fail $"Failed to generate sufficiently random integers";
        }
    }


    operation FindMedian (counts : Int[], arrSize : Int, sampleSize : Int) : Int {
        mutable totalCount = 0;
        for i in 0 .. arrSize - 1 {
            set totalCount = totalCount + counts[i];
            if (totalCount >= sampleSize / 2) {
                return i;
            }
        }
        return -1;
    }


    // ------------------------------------------------------
    // Exercise 4.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T4_WeightedRandomBit () : Unit {
        ResetOracleCallsCount();
        RetryCheckXPercentZero(0.0);
        RetryCheckXPercentZero(0.25);
        RetryCheckXPercentZero(0.5);
        RetryCheckXPercentZero(0.75);
        RetryCheckXPercentZero(1.0);
        CheckRandomCalls();
    }


    operation CheckXPercentZero (x : Double) : Bool {
        mutable oneCount = 0;
        let nRuns = 1000;
        ResetOracleCallsCount();
        for N in 1..nRuns {
            let val = WeightedRandomBit(x);
            if (val < 0 or val > 1) {
                Message($"Unexpected number generated. Expected 0 or 1, instead generated {val}");
                return false;
            }
            set oneCount += val;
        }
        CheckRandomCalls();

        let zeroCount = nRuns - oneCount;
        let goalZeroCount = (x == 0.0) ? 0 | (x == 1.0) ? nRuns | Floor(x * IntAsDouble(nRuns));
        // We don't have tests with probabilities near 0.0 or 1.0, so for those the matching has to be exact
        if (goalZeroCount == 0 or goalZeroCount == nRuns) {
            if (zeroCount != goalZeroCount) {
                Message($"Expected {x * 100.0}% 0's, instead got {zeroCount} 0's out of {nRuns}");
                return false;
            }
        } else {
            if (zeroCount < goalZeroCount - 4 * nRuns / 100) {
                Message($"Unexpectedly low number of 0's generated: expected around {x * IntAsDouble(nRuns)} 0's, got {zeroCount} out of {nRuns}");
                return false;
            } elif (zeroCount > goalZeroCount + 4 * nRuns / 100) {
                Message($"Unexpectedly high number of 0's generated: expected around {x * IntAsDouble(nRuns)} 0's, got {zeroCount} out of {nRuns}");
                return false;
            }
        }
        return true;
    }


    operation RetryCheckXPercentZero (x : Double) : Unit {
        let numRetries = 3;
        Message($"Testing probability of zero = {x}...");
        mutable sufficientlyRandom = false;
        mutable attemptNum = 1;
        repeat {
            set sufficientlyRandom = CheckXPercentZero(x);
            set attemptNum += 1;
        } until sufficientlyRandom or attemptNum >= numRetries;

        if not sufficientlyRandom {
            fail $"Failed to generate 0 with {100.0*x}% probability";
        } else {
            Message($"Test passed for probability of zero {x}");
        }
    }


    // ------------------------------------------------------
    // Exercise 5.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T5_RandomNumberInRange () : Unit {
        for (min, max) in [(1, 3), (27, 312), (0, 3), (0, 1023)] {
            Message($"Testing for min = {min} and max = {max}...");
            RetryCheckUniformDistribution(RandomNumberInRange, min, max, 1000);
            Message($"Test passed for min = {min} and max = {max}");
	    }
    }

    operation CheckRandomCalls () : Unit {
        Fact(GetOracleCallsCount(DrawRandomInt) == 0, "You are not allowed to call DrawRandomInt() in this task");
        Fact(GetOracleCallsCount(DrawRandomDouble) == 0, "You are not allowed to call DrawRandomDouble() in this task");
        ResetOracleCallsCount();
    }
}