// Copyright (c) Wenjun Hou.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.BoundedKnapsack
{
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Random;

    open Quantum.Kata.Utils;


    // Hardcoded sets of 0-1 knapsack problem parameters, for testing the operations
    // The function returns an array of tuples, each representing a set of parameters.
    // The contents of each tuple include: n, W, P, itemWeights, itemProfits (in that order).
    function ExampleSets01 () : (Int, Int, Int, Int[], Int[])[] {
        return [(2, 6, 3, [2, 5], [1, 3]),
                (3, 12, 15, [2, 3, 10], [2, 3, 15]),
                (3, 9, 5, [6, 3, 1], [5, 2, 1]),
                (4, 4, 9, [1, 2, 3, 1], [2, 4, 9, 2]),
                (5, 16, 16, [7, 7, 2, 3, 3], [3, 2, 9, 6, 5])];
    }


    @Test("QuantumSimulator")
    operation T11_MeasureCombination01 () : Unit {
        for n in 1 .. 4 {
            use selectedItems = Qubit[n];
            // Iterate through all possible combinations.
            for combo in 0 .. (1 <<< n) - 1 {
                // Prepare the register so that it contains the integer a in little-endian format.
                let binaryCombo = IntAsBoolArray(combo, n);
                within {
                    ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItems);
                } apply {
                    let measuredCombo = MeasureCombination01(selectedItems);
                    Fact(Length(measuredCombo) == n, $"Unexpected length of the result: expected {n}, got {Length(measuredCombo)}");
                    Fact(BoolArrayAsInt(measuredCombo) == combo, $"Unexpected result for combination {binaryCombo} : {measuredCombo}");
                }
                // Check that the measurement didn't impact the state of the qubits
                AssertAllZero(selectedItems);
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T12_NumBitsTotalValue01 () : Unit {
        for (_, _, _, itemWeights, itemProfits) in ExampleSets01() {
            for values in [itemWeights, itemProfits] {
                let res = NumBitsTotalValue01(values);
                let exp = NumBitsTotalValue01_Reference(values);
                Fact(res == exp, $"Unexpected result for values = {itemWeights} : {res} (expected {exp})");
            }
        }
    }


    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T13_CalculateTotalValueOfSelectedItems01 () : Unit {
        for (n, _, _, itemWeights, _) in ExampleSets01() {
            let numQubitsTotalWeight = NumBitsTotalValue01_Reference(itemWeights);
            use (selectedItems, totalWeight) = (Qubit[n], Qubit[numQubitsTotalWeight]);
            // Iterate through all possible combinations of items.
            for combo in 0 .. (1 <<< n) - 1 {
                // Prepare the register so that it represents the combination.
                let binaryCombo = IntAsBoolArray(combo, n);
                ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItems);

                // Reset the counter of measurements done
                ResetOracleCallsCount();

                // Calculate and measure the weight with qubits
                CalculateTotalValueOfSelectedItems01(itemWeights, selectedItems, totalWeight);
                    
                // Make sure the solution didn't use any measurements
                Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                mutable MeasuredWeight = ResultArrayAsInt(MultiM(totalWeight));

                // Calculate the weight classically
                mutable actualWeight = 0;
                for i in 0 .. n - 1 {
                    if binaryCombo[i] {
                        set actualWeight += itemWeights[i];
                    }
                }

                // Assert that both methods yield the same result
                Fact(actualWeight == MeasuredWeight, $"Unexpected result for selectedItems = {binaryCombo}, itemWeights = {itemWeights} : {MeasuredWeight}");

                // Check that the operation didn't modify the input state
                ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItems);
                AssertAllZero(selectedItems);

                ResetAll(totalWeight);
            }
        }
    }


    // ------------------------------------------------------
    // "Framework" operation to test a comparator of qubit array and an integer
    operation ValidateComparator (testOp : (Qubit[], Int, Qubit) => Unit is Adj+Ctl, comparator : (Int, Int) -> Bool) : Unit {
        for D in 1 .. 4 {
            // Iterate through all possible left operands a.
            for a in 0 .. (1 <<< D) - 1 {
                use (selectedItems, target) = (Qubit[D], Qubit());
                let binaryA = IntAsBoolArray(a, D);
                                    
                // Iterate through all possible right operands b.
                for b in 0 .. (1 <<< D) - 1 {
                    // Prepare the register so that it contains the integer a in little-endian format.
                    ApplyPauliFromBitString(PauliX, true, binaryA, selectedItems);

                    // Reset the counter of measurements done
                    ResetOracleCallsCount();

                    testOp(selectedItems, b, target);
                    
                    // Make sure the solution didn't use any measurements
                    Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                    let output = MResetZ(target) == One;
                    Fact(comparator(a, b) == output, $"Unexpected result for a = {a}, b = {b} : {output}");

                    // Check that the operation didn't modify the input state
                    ApplyPauliFromBitString(PauliX, true, binaryA, selectedItems);
                    AssertAllZero(selectedItems);
                }
            }
        }
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T14_CompareQubitArrayGreaterThanInt () : Unit {
        ValidateComparator(CompareQubitArrayGreaterThanInt, GreaterThanI);
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T15_CompareQubitArrayLeqThanInt () : Unit {
        ValidateComparator(CompareQubitArrayLeqThanInt, LessThanOrEqualI);
    }


    // ------------------------------------------------------
    // "Framework" operation to test a comparator of qubit array and an integer
    operation ValidateTotalValueVerification (
        testOp : (Int, Int[], Qubit[], Qubit) => Unit is Adj+Ctl, 
        comparator : (Int, Int) -> Bool
    ) : Unit {
        for (n, W, P, itemWeights, itemProfits) in ExampleSets01() {
            use (selectedItems, target) = (Qubit[n], Qubit());
            // Iterate through all possible combinations of items.
            for combo in 0 .. (1 <<< n) - 1 {
                // Prepare the register so that it represents the combination.
                let binaryCombo = IntAsBoolArray(combo, n);
                ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItems);
                    
                // Reset the counter of measurements done
                ResetOracleCallsCount();

                // Verify the weight with qubits
                testOp(W, itemWeights, selectedItems, target);
                    
                // Make sure the solution didn't use any measurements
                Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                let output = MResetZ(target) == One;

                // Calculate the weight classically
                mutable actualWeight = 0;
                for i in 0 .. n-1 {
                    if binaryCombo[i] {
                        set actualWeight += itemWeights[i];
                    }
                }

                // Assert that both methods yield the same result
                Fact(comparator(actualWeight, W) == output, 
                    $"Unexpected result for selectedItems = {binaryCombo}, itemValues = {itemWeights}, W = {W} : {output}");

                // Check that the operation didn't modify the input state
                ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItems);
                AssertAllZero(selectedItems);
            }
        }
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T16_VerifyTotalWeight01 () : Unit {
        ValidateTotalValueVerification(VerifyTotalWeight01, LessThanOrEqualI);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T17_VerifyTotalProfit01 () : Unit {
        ValidateTotalValueVerification(VerifyTotalProfit01, GreaterThanI);
    }


    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T18_KnapsackValidationOracle_01 () : Unit {
        for (n, W, P, itemWeights, itemProfits) in ExampleSets01() {
            use (selectedItems, target) = (Qubit[n], Qubit());
            // Iterate through all possible combinations of items.
            for combo in 0..(1 <<< n) - 1 {
                // Prepare the register so that it represents the combination.
                let binaryCombo = IntAsBoolArray(combo, n);
                ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItems);
                    
                // Reset the counter of measurements done
                ResetOracleCallsCount();

                // Verify the combination with qubits
                VerifyKnapsackProblemSolution01(W, P, itemWeights, itemProfits, selectedItems, target);
                    
                // Make sure the solution didn't use any measurements
                Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                let output = MResetZ(target) == One;

                // Verify the combination classically
                mutable actualWeight = 0;
                mutable actualProfit = 0;
                for i in 0 .. n - 1 {
                    if binaryCombo[i] {
                        set actualWeight += itemWeights[i];
                        set actualProfit += itemProfits[i];
                    }
                }

                // Assert that both methods yield the same result
                Fact((actualWeight <= W and actualProfit > P) == output, 
                    $"Unexpected result for selectedItems = {binaryCombo}, itemWeights = {itemWeights}, itemProfits = {itemProfits}, P = {P} : {output}");

                // Check that the operation didn't modify the input state
                ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItems);
                AssertAllZero(selectedItems);
            }
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Bounded Knapsack Problem
    //////////////////////////////////////////////////////////////////
    
    // Hardcoded sets of knapsack problem parameters for testing the operations.
    // The function returns an array of tuples, each representing a set of parameters.
    // The contents of each tuple include: n, W, P, itemWeights, itemProfits, P_max (in that order).
    // For each set, 
    //  * P is a sample profit threshold for testing that set in the knapsack decision problem.
    //  * P_max is the maximum profit achievable within the given constraints of that set 
    //    (i.e., the solution to the knapsack optimization problem).
    //  * P and P_max will never be used in the same test.
    function ExampleSets () : (Int, Int, Int, Int[], Int[], Int[], Int)[] {
        return [(2, 30, 10, [2, 5], [1, 3], [7, 5], 17),
                (3, 24, 16, [2, 3, 10], [2, 3, 15], [6, 5, 2], 24),
                (3, 16, 5, [6, 3, 1], [5, 2, 1], [4, 7, 2], 13),
                (4, 14, 24, [1, 2, 3, 1], [2, 4, 9, 2], [4, 3, 2, 3], 34)];
    }


    @Test("QuantumSimulator")
    operation T21_MeasureCombination () : Unit {
        for (_, _, _, _, _, itemInstanceLimits, _) in ExampleSets() {
            // Calculate the total number of qubits necessary to store the integers.
            let Q = RegisterSize(itemInstanceLimits);
            use register = Qubit[Q];

            // It will be too time-intensive to iterate through all possible combinations of items,
            // so random combinations will be used for testing.
            for _ in 1 .. 4 * Q {
                let combo = DrawRandomInt(0, 2^Q - 1);
                // Prepare the register so that it represents the combination.
                let binaryCombo = IntAsBoolArray(combo, Q);
                ApplyPauliFromBitString(PauliX, true, binaryCombo, register);
                    
                // Convert the quantum register into a jagged array.
                let jaggedRegister = RegisterAsJaggedArray_Reference(register, itemInstanceLimits);
                    
                // Measure the combination written in it as an Int[].
                let measuredCombo = MeasureCombination(jaggedRegister);

                // Check that the measured result matches the expected one.
                let expectedCombo = BoolArrayConcatenationAsIntArray(itemInstanceLimits, binaryCombo);
                AllEqualityFactI(measuredCombo, expectedCombo, "The result doesn't match the expected combination");

                ResetAll(register);
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T22_RegisterAsJaggedArray () : Unit {
        // Run the test on integers, since qubits are not possible to compare to each other directly.
        for (_, _, _, _, _, integerLimits, _) in ExampleSets() {
            // Generate random integers between 0 and integerLimits[i] to fill the array.
            let integers = ForEach(DrawRandomInt(0, _), integerLimits);
            // Convert those integers into bit strings.
            let integersBitstrings = Mapped(IntAsBoolArray, Zipped(integers, Mapped(BitSizeI, integerLimits)));
            // Concatenate bit strings to get the input array.
            let inputRegister = Flattened(integersBitstrings);

            // Call the solution to get bit strings back.
            Message($"Testing {inputRegister}, {integerLimits}...");
            let actualBitstrings = RegisterAsJaggedArray(inputRegister, integerLimits);

            // Compare the lengths of the bit strings to the expected ones.
            let actualLengths = Mapped(Length, actualBitstrings);
            AllEqualityFactI(actualLengths, Mapped(BitSizeI, integerLimits), 
                "The lengths of the elements of your return should match the numbers of bits necessary to store bᵢ.");

            // Compare the concatenation of the bit strings to the expected one.
            AllEqualityFactB(Flattened(actualBitstrings), inputRegister, 
                "The concatenation of all elements of your return should match the input register.");
            Message("   Success!");
        }
    }
    

    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T23_VerifyLimits () : Unit {
        for (_, _, _, _, _, itemInstanceLimits, _) in ExampleSets() {
            // Calculate the total number of qubits necessary to store the integers.
            let Q = RegisterSize(itemInstanceLimits);

            use (selectedItemCounts, target) = (Qubit[Q], Qubit());
            // It will be too time-intensive to iterate through all possible combinations of items,
            // so random combinations will be used for testing.
            for _ in 1 .. 4 * Q {
                let combo = DrawRandomInt(0, 2^Q - 1);

                // Prepare the register so that it represents the combination.
                let binaryCombo = IntAsBoolArray(combo, Q);
                ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItemCounts);
                    
                // Reset the counter of measurements done.
                ResetOracleCallsCount();

                // Verify the limits.
                let xs = RegisterAsJaggedArray_Reference(selectedItemCounts, itemInstanceLimits);
                VerifyLimits(itemInstanceLimits, xs, target);
                    
                // Make sure the solution didn't use any measurements.
                Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                let actualOutput = MResetZ(target) == One;

                // Verify the limits classically.
                let xsIntegers = BoolArrayConcatenationAsIntArray(itemInstanceLimits, binaryCombo);
                mutable expectedOutput = true;
                for i in 0 .. Length(xsIntegers) - 1 {
                    // If any limit isn't satisfied, the operation should return false.
                    if xsIntegers[i] > itemInstanceLimits[i] {
                        set expectedOutput = false;
                    }
                }

                // Assert that both methods yield the same result
                Fact(expectedOutput == actualOutput, $"Unexpected result for xs = {binaryCombo}, itemInstanceLimits = {itemInstanceLimits} : {actualOutput}");

                // Check that the operation didn't modify the input state
                ApplyPauliFromBitString(PauliX, true, binaryCombo, selectedItemCounts);
                AssertAllZero(selectedItemCounts);
            }
        }
    }


    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T24_IncrementByProduct () : Unit {
        for (n, m) in [(1, 2), (2, 2), (2, 3)] {
            use (qy, qz) = (Qubit[n], Qubit[m]);

            // Iterate through all possible left operands x (integers).
            for x in 0 .. (1 <<< m) - 1 {

                // Iterate through all possible right operands y.
                for y in 0 .. (1 <<< n) - 1 {
                    let binaryY = IntAsBoolArray(y, n);

                    // Iterate through all initial values of z.
                    for z in 0 .. (1 <<< m) - 1 {
                        // Prepare the registers so that they contain the integers y and z in little-endian format.
                        let binaryZ = IntAsBoolArray(z, m);
                        ApplyPauliFromBitString(PauliX, true, binaryY, qy);
                        ApplyPauliFromBitString(PauliX, true, binaryZ, qz);
                            
                        // Reset the counter of measurements done.
                        ResetOracleCallsCount();

                        IncrementByProduct(x, qy, qz);
                    
                        // Make sure the solution didn't use any measurements.
                        Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                        // Check that the computation result is correct.
                        let res = MeasureInteger(LittleEndian(qz));
                        let exp = (z + x*y) % (1 <<< m);
                        Fact(res == exp, $"Unexpected result for x = {x}, y = {y}, z = {z} : {res} (expected {exp})");

                        // Check that the value of y has not changed.
                        ApplyPauliFromBitString(PauliX, true, binaryY, qy);
                        AssertAllZero(qy);
                    }
                }
            }
        }
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T25_NumBitsTotalValue_Reference () : Unit {
        for (_, _, _, itemWeights, itemProfits, itemInstanceLimits, _) in ExampleSets() {
            for values in [itemWeights, itemProfits] {
                let res = NumBitsTotalValue(values, itemInstanceLimits);
                let exp = NumBitsTotalValue_Reference(values, itemInstanceLimits);
                Fact(res == exp, $"Unexpected result for values = {itemWeights}, limits = {itemInstanceLimits} : {res} (expected {exp})");
            }
        }
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T26_CalculateTotalValueOfSelectedItems () : Unit {
        for (_, _, _, itemWeights, itemProfits, itemInstanceLimits, _) in ExampleSets() {
            for values in [itemWeights, itemProfits] {
                // Calculate the total number of qubits necessary to store the integers.
                let Q = RegisterSize(itemInstanceLimits);

                // Calculate the number of bits necessary to store the maximal total value.
                let numQubitsTotal = NumBitsTotalValue_Reference(values, itemInstanceLimits);

                use (register, totalValue) = (Qubit[Q], Qubit[numQubitsTotal]);
                // It will be too time-intensive to iterate through all possible combinations of items,
                // so random combinations will be used for testing.
                for _ in 1 .. 4 * Q {
                    // Generate random integers between 0 and integerLimits[i] to fill the array.
                    let itemCounts = ForEach(DrawRandomInt(0, _), itemInstanceLimits);
                    // Convert those integers into bit strings and concatenate them.
                    let binaryCombo = Flattened(Mapped(IntAsBoolArray, Zipped(itemCounts, Mapped(BitSizeI, itemInstanceLimits))));
                    // Prepare the register so that it represents the combination.
                    ApplyPauliFromBitString(PauliX, true, binaryCombo, register);

                    // Reset the counter of measurements done
                    ResetOracleCallsCount();

                    // Calculate and measure the total weight and profit with qubits
                    let xs = RegisterAsJaggedArray_Reference(register, itemInstanceLimits);
                    CalculateTotalValueOfSelectedItems(values, xs, totalValue);
                    
                    // Make sure the solution didn't use any measurements
                    Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                    mutable actualValue = MeasureInteger(LittleEndian(totalValue));

                    // Calculate the weight and profit classically
                    mutable expectedValue = 0;
                    for (val, num) in Zipped(values, itemCounts) {
                        // Add the weight of all instances of this item type.
                        set expectedValue += val * num;
                    }

                    // Assert that both methods yield the same result
                    Fact(actualValue == expectedValue, $"Unexpected result for item counts = {itemCounts}, item values = {values}: total value {actualValue}, expected {expectedValue}");

                    // Check that the operation didn't modify the input state
                    ApplyPauliFromBitString(PauliX, true, binaryCombo, register);
                    AssertAllZero(register);
                }
            }
        }
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T27_VerifyWeight () : Unit {
        for ((n, W, P, itemWeights, itemProfits, itemInstanceLimits, P_max) in ExampleSets()){

            // Calculate the total number of qubits
            let Q = RegisterSize(itemInstanceLimits);

            using ((register, target) = (Qubit[Q], Qubit())){
                // It will be too time-intensive to iterate through all possible combinations of items,
                // so a random selection of combinations will be used for testing.
                mutable combos = new Int[2*Q];
                for (c in 0..2*Q-1){
                    set combos w/= c <- RandomIntPow2(Q);
                }

                // Iterate through the selected combinations.
                for (combo in combos){
                    // Prepare the register so that it represents the combination.
                    let binaryCombo = IntAsBoolArray(combo, Q);
                    ApplyPauliFromBitString(PauliX, true, binaryCombo, register);

                    // Reset the counter of measurements done
                    ResetOracleCallsCount();

                    // Verify the weight with qubits
                    let xs = RegisterAsJaggedArray_Reference(register, itemInstanceLimits);
                    VerifyWeight(W, itemWeights, xs, target);
                    
                    // Make sure the solution didn't use any measurements
                    Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                    let output = (M(target) == One);

                    // Verify the weight classically
                    let xsCombo = BoolArrayConcatenationAsIntArray(itemInstanceLimits, binaryCombo);
                    mutable actualWeight = 0;
                    for (i in 0..n-1){
                        // Add the weight of all instances of this item type.
                        set actualWeight += itemWeights[i]*xsCombo[i];
                    }

                    // Assert that both methods yield the same result
                    Fact(not XOR(actualWeight <= W, output), $"Unexpected result for xs = {xsCombo}, itemWeights = {itemWeights}, W = {W} : {output}");
                    ResetAll(register);
                    Reset(target);
                }
            }
        }
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T28_VerifyProfit () : Unit {
        for ((n, W, P, itemWeights, itemProfits, itemInstanceLimits, P_max) in ExampleSets()){

            // Calculate the total number of qubits
            let Q = RegisterSize(itemInstanceLimits);

            using ((register, target) = (Qubit[Q], Qubit())){
                // It will be too time-intensive to iterate through all possible combinations of items,
                // so a random selection of combinations will be used for testing.
                mutable combos = new Int[2*Q];
                for (c in 0..2*Q-1){
                    set combos w/= c <- RandomIntPow2(Q);
                }

                // Iterate through the selected combinations.
                for (combo in combos){
                    // Prepare the register so that it represents the combination.
                    let binaryCombo = IntAsBoolArray(combo, Q);
                    ApplyPauliFromBitString(PauliX, true, binaryCombo, register);

                    // Reset the counter of measurements done
                    ResetOracleCallsCount();

                    // Verify the profit with qubits
                    let xs = RegisterAsJaggedArray_Reference(register, itemInstanceLimits);
                    VerifyProfit(P, itemProfits, xs, target);
                    
                    // Make sure the solution didn't use any measurements
                    Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                    let output = (M(target) == One);

                    // Verify the profit classically
                    let xsCombo = BoolArrayConcatenationAsIntArray(itemInstanceLimits, binaryCombo);
                    mutable actualProfit = 0;
                    for (i in 0..n-1){
                        // Add the profit of all instances of this item type.
                        set actualProfit += itemProfits[i]*xsCombo[i];
                    }

                    // Assert that both methods yield the same result
                    Fact(not XOR(actualProfit > P, output), $"Unexpected result for xs = {xsCombo}, itemProfits = {itemProfits}, P = {P} : {output}");
                    ResetAll(register);
                    Reset(target);
                }
            }
        }
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T29_KnapsackValidationOracle () : Unit {
        for ((n, W, P, itemWeights, itemProfits, itemInstanceLimits, P_max) in ExampleSets()){

            // Calculate the total number of qubits
            let Q = RegisterSize(itemInstanceLimits);

            using ((register, target) = (Qubit[Q], Qubit())){
                // It will be too time-intensive to iterate through all possible combinations of items,
                // so a random selection of combinations will be used for testing.
                mutable combos = new Int[2*Q];
                for (c in 0..2*Q-1){
                    set combos w/= c <- RandomIntPow2(Q);
                }

                // Iterate through the selected combinations.
                for (combo in combos){
                    // Prepare the register so that it represents the combination.
                    let binaryCombo = IntAsBoolArray(combo, Q);
                    ApplyPauliFromBitString(PauliX, true, binaryCombo, register);
                    
                    // Reset the counter of measurements done
                    ResetOracleCallsCount();

                    // Verify the combination with qubits
                    let xs = RegisterAsJaggedArray_Reference(register, itemInstanceLimits);
                    KnapsackValidationOracle(n, W, P, itemWeights, itemProfits, itemInstanceLimits, register, target);
                    
                    // Make sure the solution didn't use any measurements
                    Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                    let output = (M(target) == One);

                    // Verify the combination classically
                    let xsCombo = BoolArrayConcatenationAsIntArray(itemInstanceLimits, binaryCombo);
                    mutable actualLimits = true;
                    mutable actualWeight = 0;
                    mutable actualProfit = 0;
                    for (i in 0..n-1){
                        // If any bound isn't satisfied, the operation should return 0.
                        if (xsCombo[i] > itemInstanceLimits[i]){
                            set actualLimits = false;
                        }
                        // Add the weight and profit of all instances of this item type.
                        set actualWeight += itemWeights[i]*xsCombo[i];
                        set actualProfit += itemProfits[i]*xsCombo[i];
                    }

                    // Assert that both methods yield the same result
                    Fact(not XOR(actualLimits and actualWeight <= W and actualProfit > P, output), $"Unexpected result for xs = {xsCombo}, itemWeights = {itemWeights}, itemProfits = {itemProfits}, itemInstanceLimits = {itemInstanceLimits}, P = {P} : {output}");
                    ResetAll(register);
                    Reset(target);
                }
            }
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Grover Search and Knapsack Optimization Problem
    //////////////////////////////////////////////////////////////////

    @Test("QuantumSimulator")
    operation T31_GroversAlgorithm () : Unit {
        let testSets = ExampleSets();
        let (n, W, P, itemWeights, itemProfits, itemInstanceLimits, P_max) = testSets[0];

        // Calculate the total number of qubits
        let Q = RegisterSize(itemInstanceLimits);

        using ((register, target) = (Qubit[Q], Qubit())){

            let (xs_found, P_found) = GroversAlgorithm(n, W, P, itemWeights, itemProfits, itemInstanceLimits);

            // Verify the found combination classically (should be valid if P < P_max)
            mutable actualLimits = true;
            mutable actualWeight = 0;
            mutable actualProfit = 0;
            for (i in 0..n-1){
                // If any bound isn't satisfied, the operation should return 0.
                if (xs_found[i] > itemInstanceLimits[i]){
                    set actualLimits = false;
                }
                // Add the weight and profit of all instances of this item type.
                set actualWeight += itemWeights[i]*xs_found[i];
                set actualProfit += itemProfits[i]*xs_found[i];
            }
            let valid = actualLimits and actualWeight <= W and actualProfit > P;

            // Assert that the output from Grover's algorithm is correct.
            Fact(not XOR(valid, P < P_max), $"Unexpected result for W = {W}, P = {P}, itemWeights = {itemWeights}, itemProfits = {itemProfits}, itemInstanceLimits = {itemInstanceLimits} : {xs_found}");
            ResetAll(register);
            Reset(target);
        }
    }


    @Test("QuantumSimulator")
    operation T32_KnapsackOptimizationProblem() : Unit {
        let testSets = ExampleSets();
        let (n, W, P, itemWeights, itemProfits, itemInstanceLimits, P_max) = testSets[0];

        let P_max_found = KnapsackOptimizationProblem(n, W, itemWeights, itemProfits, itemInstanceLimits);
        Fact(P_max_found == P_max, $"Unexpected result for W = {W}, P = {P}, itemWeights = {itemWeights}, itemProfits = {itemProfits}, itemInstanceLimits = {itemInstanceLimits} : {P_max_found}, should be {P_max}");
    }

}
