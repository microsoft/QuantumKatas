// Copyright (c) Wenjun Hou.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.BoundedKnapsack {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;


    //////////////////////////////////////////////////////////////////
    // Part I. 0-1 Knapsack Problem
    //////////////////////////////////////////////////////////////////
    

    // Task 1.1. Read combination from a register
    operation MeasureCombination01_Reference (register : Qubit[]) : Bool[] {
        return ResultArrayAsBoolArray(MultiM(register));
    }

    
    // Task 1.2. Calculate the number of (qu)bits necessary to hold the maximum total value
    function NumBitsTotalValue01_Reference (itemValues : Int[]) : Int {
        mutable maxValue = 0;
        for itemValue in itemValues {
            set maxValue += itemValue;
        }
        return BitSizeI(maxValue);
    }
    

    // Task 1.3. Calculate total value of selected items
    operation CalculateTotalValueOfSelectedItems01_Reference (itemValues : Int[], selectedItems : Qubit[], total : Qubit[]) : Unit is Adj+Ctl {
        // Each qubit in selectedItems determines whether the corresponding value is added.
        // Adding the selected items is implemented using a library operation with a control from each qubit of the selectedItems.
        let totalLE = LittleEndian(total);
        for (control, value) in Zipped(selectedItems, itemValues) {
            Controlled IncrementByInteger([control], (value, totalLE));
        }
    }


    // Task 1.4. Compare an integer stored in a qubit array with an integer (>)
    operation CompareQubitArrayGreaterThanInt_Reference (a : Qubit[], b : Int, target : Qubit) : Unit is Adj+Ctl {
        let D = Length(a);

        // Convert b into array of bits in little endian format
        let binaryB = IntAsBoolArray(b, D);

        // Iterate descending from the most significant digit (stored last), flipping the target qubit
        // upon finding i such that a[i] > binaryB[i], AND a[j] = binaryB[j] for all j > i.
        // The X gate flips a[i] to represent whether a[i] and binaryB[i] are equal, to
        // be used as controls for the Toffoli.
        // Thus, the Toffoli will only flip the target when a[i] = 1, binaryB[i] = 0, and  
        // a[j] = 1 for all j > i (meaning a and binaryB have the same digits above i).

        for i in D - 1 .. -1 .. 0 {
            if (not binaryB[i]) {
                // Checks if a has a greater bit than b at index i AND all bits above index i have equal values in a and b.
                Controlled X(a[i ...], target);
                // Flips the qubit if b's corresponding bit is 0.
                // This temporarily sets the qubit to 1 if the corresponding bits are equal.
                X(a[i]);
            }
        }

        // Uncompute
        ApplyPauliFromBitString(PauliX, false, binaryB, a);
    }


    // Task 1.5. Compare an integer stored in a qubit array with an integer (≤)
    operation CompareQubitArrayLeqThanInt_Reference (a : Qubit[], b : Int, target : Qubit) : Unit is Adj+Ctl {
        // This operation calculates the opposite of the greater-than comparator from the previous task, 
        // so we can just call CompareQubitArrayGreaterThanInt, and then an X gate.
        CompareQubitArrayGreaterThanInt_Reference(a, b, target);
        X(target);
    }


    // Task 1.6. Verify that the total weight doesn't exceed the limit W
    operation VerifyTotalWeight01_Reference (W : Int, itemWeights : Int[], selectedItems : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        let numQubitsTotalWeight = NumBitsTotalValue01_Reference(itemWeights);
        use totalWeight = Qubit[numQubitsTotalWeight];
        within {
            CalculateTotalValueOfSelectedItems01_Reference(itemWeights, selectedItems, totalWeight);
        } apply {
            CompareQubitArrayLeqThanInt_Reference(totalWeight, W, target);
        }
    }


    // Task 1.7. Verify that the total profit exceeds threshold P
    operation VerifyTotalProfit01_Reference (P : Int, itemProfits : Int[], selectedItems : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        let numQubitsTotalProfit = NumBitsTotalValue01_Reference(itemProfits);
        use totalProfit = Qubit[numQubitsTotalProfit];
        within {
            CalculateTotalValueOfSelectedItems01_Reference(itemProfits, selectedItems, totalProfit);
        } apply {
            CompareQubitArrayGreaterThanInt_Reference(totalProfit, P, target);
        }
    }


    // Task 1.8. Verify the solution to the 0-1 knapsack problem
    operation VerifyKnapsackProblemSolution01_Reference (
        W : Int, P : Int, itemWeights : Int[], itemProfits : Int[], selectedItems : Qubit[], target : Qubit
    ) : Unit is Adj+Ctl {
        use (outputW, outputP) = (Qubit(), Qubit());
        within {
            VerifyTotalWeight01_Reference(W, itemWeights, selectedItems, outputW);
            VerifyTotalProfit01_Reference(P, itemProfits, selectedItems, outputP);
        } apply {
            CCNOT(outputW, outputP, target);
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Bounded Knapsack Problem
    //////////////////////////////////////////////////////////////////
    

    // Task 2.1. Read combination from a jagged array of qubits
    operation MeasureCombination_Reference (selectedItemCounts : Qubit[][]) : Int[] {
        // Measure each array and convert the result to int.
        return Mapped(ResultArrayAsInt, ForEach(MultiM, selectedItemCounts));
    }


    // Task 2.2. Convert an array into a jagged array
    function RegisterAsJaggedArray_Reference<'T> (array : 'T[], b : Int[]) : 'T[][] {
        // Identify bit lengths of integers bᵢ.
        let bitLengths = Mapped(BitSizeI, b);
        // Partition the array in accordance to these lengths.
        // Remember to discard the last element in the return of Partitioned, 
        // which will be empty, since our partitioning is precise.
        return Most(Partitioned(bitLengths, array));
    }


    // Task 2.3. Verification of limits satisfaction
    operation VerifyLimits_Reference (itemCountLimits : Int[], selectedItemCounts : Qubit[][], target : Qubit) : Unit is Adj+Ctl {
        use satisfy = Qubit[Length(itemCountLimits)];
        within {
            for (x, b, satisfyBit) in Zipped3(selectedItemCounts, itemCountLimits, satisfy) {
                // Check that each individual xᵢ satisfies the limit itemCountLimits[i].
                // If the number represented by x is ≤ bᵢ, then the result will be 1, indicating satisfaction.
                CompareQubitArrayLeqThanInt_Reference(x, b, satisfyBit);
            }
        } apply {
            // If all constraints are satisfied, then the combination passes limits verification.
            Controlled X(satisfy, target);
        }
    }


    // Task 2.4. Increment a quantum integer by a product of classical and quantum integers
    operation IncrementByProduct_Reference (x : Int, y : Qubit[], z : Qubit[]) : Unit is Adj+Ctl {
        for (i, control) in Enumerated(y) {
            // Calculate each partial product, y[i] · x · 2ⁱ,
            // and add each partial product to z, if the corresponding qubit in y is 1.
            // For more information, see https://en.wikipedia.org/wiki/Binary_multiplier#Unsigned_numbers.
            // IncrementByInteger performs addition modulo 2ᵐ, where m is the length of register z.
            Controlled IncrementByInteger([control], (x <<< i, LittleEndian(z)));
        }
    }

    
    // Task 2.5. Calculate the number of qubits necessary to hold the maximum total value
    function NumBitsTotalValue_Reference (itemValues : Int[], itemCountLimits : Int[]) : Int {
        mutable maxValue = 0;
        for (v, lim) in Zipped(itemValues, itemCountLimits) {
            set maxValue += v * lim;
        }
        return BitSizeI(maxValue);
    }


    // Task 2.6. Calculate total value of selected items
    operation CalculateTotalValueOfSelectedItems_Reference (itemValues : Int[], selectedCounts : Qubit[][], total : Qubit[]) : Unit is Adj+Ctl {
        // The item type with index i contributes xᵢ instances to the knapsack, adding itemValues[i] per instance to the total.
        // Thus, for each item type, we increment the total by their product.
        for (value, count) in Zipped(itemValues, selectedCounts) {
            IncrementByProduct_Reference(value, count, total);
        }
    }


    // Task 2.7. Verify that the total weight doesn't exceed the limit W
    operation VerifyTotalWeight_Reference (W : Int, itemWeights : Int[], itemCountLimits : Int[], selectedCounts : Qubit[][], target : Qubit) : Unit is Adj+Ctl {
        let numQubitsTotalWeight = NumBitsTotalValue_Reference(itemWeights, itemCountLimits);
        use totalWeight = Qubit[numQubitsTotalWeight];
        within {
            // Calculate the total weight
            CalculateTotalValueOfSelectedItems_Reference(itemWeights, selectedCounts, totalWeight);
        } apply {
            CompareQubitArrayLeqThanInt_Reference(totalWeight, W, target);
        }
    }


    // Task 2.8. Verify that the total profit exceeds threshold P
    operation VerifyTotalProfit_Reference (P : Int, itemProfits : Int[], itemCountLimits : Int[], selectedCounts : Qubit[][], target : Qubit) : Unit is Adj+Ctl {
        let numQubitsTotalProfit = NumBitsTotalValue_Reference(itemProfits, itemCountLimits);
        use totalProfit = Qubit[numQubitsTotalProfit];
        within {
            // Calculate the total profit
            CalculateTotalValueOfSelectedItems_Reference(itemProfits, selectedCounts, totalProfit);
        } apply {
            CompareQubitArrayGreaterThanInt_Reference(totalProfit, P, target);
        }
    }


    // Task 2.9. Bounded knapsack problem validation oracle
    operation VerifyKnapsackProblemSolution_Reference (W : Int, P : Int, itemWeights : Int[], itemProfits : Int[], itemCountLimits : Int[], selectedCountsRegister : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        let selectedItems = RegisterAsJaggedArray_Reference(selectedCountsRegister, itemCountLimits);
        use (outputB, outputW, outputP) = (Qubit(), Qubit(), Qubit());
        within {
            // Compute the result of each constraint check.
            VerifyLimits_Reference(itemCountLimits, selectedItems, outputB);
            VerifyTotalWeight_Reference(W, itemWeights, itemCountLimits, selectedItems, outputW);
            VerifyTotalProfit_Reference(P, itemProfits, itemCountLimits, selectedItems, outputP);
        } apply {
            // The final result is the AND operation of the three separate results (all constraints must be satisfied).
            Controlled X([outputB, outputW, outputP], target);
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Knapsack Oracle and Grover Search
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Using Grover search with bounded knapsack problem oracle to solve (a slightly modified version of the) knapsack decision problem
    operation GroversAlgorithm_Reference (n : Int, W : Int, P : Int, itemWeights : Int[], itemProfits : Int[], itemCountLimits : Int[]) : (Int[], Int) {
        
        mutable xs_found = new Int[n];
        mutable P_found = P;
        mutable correct = false;

        let Q = RegisterSize(itemCountLimits);

        // We will classically count M (the number of solutions), and calculate the optimal number of Grover iterations.
        // Generally this can be replaced by the quantum counting algorithm.
        let N = IntAsDouble(1 <<< Q);
        let m = IntAsDouble(NumberOfSolutions(n, W, P, itemWeights, itemProfits, itemCountLimits));
        if (m == 0.0) {
            return (xs_found, P_found);
        }
        // Using the formula for the number of iterations, and rounding to the nearest integer
        mutable iter = Floor(PI() / 4.0 * Sqrt(N/m) + 0.5);
        mutable attempts = 0;

        use register = Qubit[Q];
            
        repeat {
            // Note: The register is not converted into the jagged array before being used in the oracle, because
            //         the ApplyToEach operations in the GroverIterations can't directly be called on jagged arrays.
            GroversAlgorithm_Loop(register, VerifyKnapsackProblemSolution_Reference(W, P, itemWeights, itemProfits, itemCountLimits, _, _), iter);

            // Measure the combination that Grover's Algorithm finds.
            let xs = RegisterAsJaggedArray_Reference(register, itemCountLimits);
            for i in 0 .. n - 1 {
                let result = MultiM(xs[i]);
                set xs_found w/= i <- ResultArrayAsInt(result);
            }

            // Check that the combination is a valid combination.
            use output = Qubit();
            VerifyKnapsackProblemSolution_Reference(W, P, itemWeights, itemProfits, itemCountLimits, register, output);
            set correct = IsResultOne(MResetZ(output));

            // When the valid combination is found, calculate its profit
            if (correct) {
                let numQubitsTotalProfit = NumBitsTotalValue01_Reference(itemProfits);
                use profit = Qubit[numQubitsTotalProfit];
                CalculateTotalValueOfSelectedItems_Reference(itemProfits, xs, profit);
                set P_found = ResultArrayAsInt(MultiM(profit));
                ResetAll(profit);
            }
            ResetAll(register);
            set attempts += 1;
        } until (correct or attempts > 10);

        return (xs_found, P_found);
    }


    /// # Summary
    /// Calculate the number of qubits necessary to store a concatenation of the given integers.
    /// # Remarks
    /// Storing each integer bᵢ requires log₂(bᵢ+1) qubits (rounded up), computes using BitSizeI.
    /// Storing all integers requires a sum of registers required to store each one.
    internal function RegisterSize (arrayElementLimits : Int[]) : Int {
        mutable Q = 0;
        for b in arrayElementLimits {
            set Q += BitSizeI(b);
        }
        return Q;
    }

    // Grover loop implementation taken from SolveSATWithGrover kata.
    internal operation OracleConverterImpl (markingOracle : ((Qubit[], Qubit) => Unit is Adj), register : Qubit[]) : Unit is Adj {
        use target = Qubit();
        within {
            // Put the target into the |-⟩ state
            X(target);
            H(target);
        } apply {
            // Apply the marking oracle; since the target is in the |-⟩ state,
            // flipping the target if the register satisfies the oracle condition will apply a -1 factor to the state
            markingOracle(register, target);
        }
    }
    
    internal operation GroversAlgorithm_Loop (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        let phaseOracle = OracleConverterImpl(oracle, _);
        ApplyToEach(H, register);
            
        for i in 1 .. iterations {
            phaseOracle(register);
            within {
                ApplyToEachA(H, register);
                ApplyToEachA(X, register);
            } apply {
                Controlled Z(Most(register), Tail(register));
            }
        }
    }


    // A placeholder for the quantum counting algorithm, which will be implemented in a separate kata.
    // Calculate value M for the oracle (number of solutions), which is used in determining how many
    // Grover Iterations are necessary in Grover's Algorithm.
    internal function NumberOfSolutions (n : Int, W : Int, P : Int, itemWeights : Int[], itemProfits : Int[], itemCountLimits : Int[]) : Int {
        let Q = RegisterSize(itemCountLimits);
        mutable m = 0;
        for combo in 0 .. (1 <<< Q) - 1 {
            let binaryCombo = IntAsBoolArray(combo, Q);
            let xsCombo = BoolArrayConcatenationAsIntArray(itemCountLimits, binaryCombo);

            // Determine if each combination is a solution.
            mutable ActualLimits = true;
            mutable ActualWeight = 0;
            mutable ActualProfit = 0;
            for i in 0 .. n - 1 {
                // If any bound isn't satisfied, then Limits Verification is not satisfied.
                if (xsCombo[i] > itemCountLimits[i]){
                    set ActualLimits = false;
                }
                // Add the weight and profit of all instances of this item type.
                set ActualWeight += itemWeights[i]*xsCombo[i];
                set ActualProfit += itemProfits[i]*xsCombo[i];
            }
            if (ActualLimits and ActualWeight <= W and ActualProfit > P) {
                set m += 1;
            }
        }
        return m;
    }


    /// # Summary
    /// Convert a single array of bits which stores binary notations of n integers into an array of integers written in it.
    /// Each integer can be between 0 and bᵢ, inclusive, which defines the number of bits its notation takes.
    internal function BoolArrayConcatenationAsIntArray (arrayElementLimits : Int[], binaryCombo : Bool[]) : Int[] {
        // Split the bool array into a jagged bool array.
        let binaryNotations = RegisterAsJaggedArray_Reference(binaryCombo, arrayElementLimits);
        // Convert each element of the jagged array into an integer.
        return Mapped(BoolArrayAsInt, binaryNotations);
    }
    
    
    // Task 3.2 Solving the bounded knapsack optimization problem
    operation KnapsackOptimizationProblem_Reference (n : Int, W : Int, itemWeights : Int[], itemProfits : Int[], itemCountLimits : Int[]) : Int {
        // This implementation uses exponential search to search over profit thresholds and find the maximum possible profit.
        // The Grover Search using the Knapsack Oracle serves as the comparison function.
        // A description of exponential search is found at https://en.wikipedia.org/wiki/Exponential_search.

        // Determining an upper bound for a search range
        mutable P_high = 1;
        mutable upperBoundFound = false;
        repeat {
            let (xs_found, P_found) = GroversAlgorithm_Reference(n, W, P_high, itemWeights, itemProfits, itemCountLimits);
            if (P_found > P_high) {
                set P_high = P_high * 2;
            }
            else {
                set upperBoundFound = true;
            }
        } until (upperBoundFound);


        // Performing binary search in the determined search range
        mutable P_low = P_high / 2;
        repeat {
            let P_middle = (P_low + P_high) / 2;
            let (xs_found, P_found) = GroversAlgorithm_Reference(n, W, P_high, itemWeights, itemProfits, itemCountLimits);
            if (P_found > P_high){
                set P_low = P_middle;
            }
            else{
                set P_high = P_middle;
            }
        } until (P_high - P_low == 1);
        return P_high;
    }
}
