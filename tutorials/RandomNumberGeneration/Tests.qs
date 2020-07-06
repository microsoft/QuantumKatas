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
    // With 50/50, will fall in these bounds 95% of the time. With 45/55, probability of staying
    // in these bounds drops to 10%. 
    operation E1_RandomBit_Test () : Unit {
        Message("Testing function");
        mutable count = 0;
        for (N in 1..10000) {
            set count += RandomBit();
        }
        if (count < 470) {
            fail $"Unexpectedly low number of 1's generated. Generated {count} out of 1000";
        } elif (count > 530) {
            fail $"Unexpectedly high number of 1's generated. Generated {count} out of 1000";
        }
        Message($"{IntAsDouble(count) / 10.0}% 1's, {IntAsDouble(1000 - count)/10.0}% 0's");
        CheckRandomCalls();
    }

    operation E2_RandomTwoBits_Test () : Unit {
        Message("Testing function");
        mutable counts = [0, 0, 0, 0];
        let total = 8000;
        for (N in 1..total) {
            let val = RandomTwoBits();
            set counts w/= val <- counts[val] + 1;
        }
        //Message($"{counts}");

        mutable percents = [0.0, 0.0, 0.0, 0.0];
        for (i in 0..3) {
            set percents w/= i <- IntAsDouble(counts[i]) / IntAsDouble(total) * 100.0;
        }
        //Message($"{percents}");

        mutable sum = 0;
        for (i in 0..3) {
            set counts w/= i <- PowI(counts[i], 2);
            set sum += counts[i];
        }
        //Message($"{counts}, {Sqrt(IntAsDouble(sum))}");
        CheckRandomCalls();
    }
    
    operation E3_RandomNBits_Test () : Unit {
        //CheckFlatDistribution(2);
        CheckFlatDistribution(4);
    }

    operation CheckFlatDistribution (max: Int) : Unit {
        Message("Testing function");
        mutable counts = ConstantArray(PowI(2, max), 0);
        let total = 1000000;
        for (N in 1..total) {
            let val = RandomNBits(max);
            set counts w/= val <- counts[val] + 1;
        }
        Message($"{counts}");

        mutable percents = ConstantArray(PowI(2, max), 0.0);
        let expected = IntAsDouble(total) / IntAsDouble(PowI(2, max));
        mutable chi2 = 0.0;
        for (i in 0..PowI(2, max) - 1) {
            set percents w/= i <- IntAsDouble(counts[i]) / IntAsDouble(total) * 100.0;
            let rem = PowD(IntAsDouble(counts[i]) - expected, 2.0) / expected;
            set chi2 = chi2 + rem;
        }
        Message($"{percents}");
        Message($"{chi2}");

        mutable sum = 0;
        for (i in 0..PowI(2, max) - 1) {
            set counts w/= i <- PowI(counts[i], 2);
            set sum += counts[i];
        }
        Message($"{counts}, {Sqrt(IntAsDouble(sum))}");
        CheckRandomCalls();
    }

    operation CheckXPercentZero (x : Double) : Unit {
        Message($"Testing {x * 100.0}% of 0's...");

        mutable oneCount = 0;
        for (N in 1..1000) {
            set oneCount += WeightedRandomBit(x);
        }

        let zeroCount = 1000 - oneCount;
        
        if (x == 0.0) {
            if (oneCount != 1000) {
                fail $"expected 0% 0's, instead got {IntAsDouble(zeroCount) / 10.0}% 0's";
            }
        }elif (x == 1.0) {
            if (oneCount != 0) {
                fail $"expected 0% 0's, instead got {IntAsDouble(zeroCount) / 10.0}% 0's";
            }
        }else {
        
        let comp = (x * 1000.0) - 30.0;
        Message($"{IntAsDouble(zeroCount) / 10.0}% 0's");
        if (IntAsDouble(zeroCount) < comp) {
            fail $"Unexpectedly low number of 1's generated. Generated {oneCount} out of 1000";
        } elif (IntAsDouble(zeroCount) > comp + 60.0) {
            fail $"Unexpectedly high number of 1's generated. Generated {oneCount} out of 1000";
        }}
        CheckRandomCalls();
        Message("    correct!");
    }


    operation E4_WeightedRandomBit_Test () : Unit {
        CheckXPercentZero(0.0);
        CheckXPercentZero(1.0);
        CheckXPercentZero(0.25);
        CheckXPercentZero(0.5);
        CheckXPercentZero(0.75);
        CheckRandomCalls();
    }

    operation CheckRandomCalls () : Unit {
        ResetOracleCallsCount();
        Fact(GetOracleCallsCount(Random) == 0, "You are not allowed to call Random() in this task");
        Fact(GetOracleCallsCount(RandomInt) == 0, "You are not allowed to call RandomInt() in this task");
        Fact(GetOracleCallsCount(RandomIntPow2) == 0, "You are not allowed to call RandomIntPow2() in this task");
        Fact(GetOracleCallsCount(RandomReal) == 0, "You are not allowed to call RandomReal() in this task");
        Fact(GetOracleCallsCount(RandomSingleQubitPauli) == 0, "You are not allowed to call RandomSingleQubitPauli() in this task");
    }
}