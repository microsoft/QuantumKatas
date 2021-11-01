// Copyright (c) Wenjun Hou.
// Licensed under the MIT license.

namespace Quantum.Kata.BoundedKnapsack
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;


    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The Bounded Knapsack quantum kata is a series of exercises designed
    // to teach you to use Grover search to solve the knapsack problem.
    // The knapsack problem is a prominent computational problem;
    // you can find its description at https://en.wikipedia.org/wiki/Knapsack_problem.

    // The overall goal in this kata is to solve the knapsack optimization problem
    // by running Grover's algorithm.

    // The kata covers the following topics:
    //  - writing operations to perform arithmetic tasks.
    //  - writing oracles to implement constraints based on:
    //        - the 0-1 knapsack problem, a simple version of the knapsack problem;
    //        - the bounded knapsack problem.
    //  - using the oracle with Grover's algorithm to solve the knapsack decision problem.
    //  - using Grover's algorithm repeatedly to solve the knapsack optimization problem.

    // You may find this kata to be more challenging than other Grover's search
    // katas, so you might want to try SolveSATWithGrover or GraphColoring first.
    // Hints for the more complicated tasks can be found in the Hints.qs file.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.


    //////////////////////////////////////////////////////////////////
    // Part I. 0-1 Knapsack Problem
    //////////////////////////////////////////////////////////////////

    // Introduction:
    // You are given n items, indexed 0 to n-1.
    // The item with index i has a weight of wᵢ and yields a profit of pᵢ.
    // In the original 0-1 knapsack decision problem, we wish to determine
    // whether we can put a subset of items in a knapsack to get a total profit
    // of at least P, while not exceeding a maximum weight W.

    // However, we will slightly modify the problem:
    // the total profit must be strictly greater than P, rather than at least P.

    // In the following tasks you will implement an oracle that evaluates whether
    // a particular register of n qubits, representing an item combination,
    // satisfies the described conditions.
    

    // Task 1.1. Read combination from a register
    // Input: An array of n qubits, which are guaranteed to be in one of the 2ⁿ basis states.
    // Output: The item combination that this state represents, expressed as a boolean array of length n.
    //         The i-th element of the array should be true (indicating that i-th item is selected) 
    //         if and only if the i-th qubit of the register is in the |1⟩ state.
    //         The operation should not change the state of the qubits.
    // Example: For n = 3 and the qubits state |101⟩, return [true, false, true].
    operation MeasureCombination01 (selectedItems : Qubit[]) : Bool[] {
        // ...
        return [];
    }

    
    // Task 1.2. Calculate the number of (qu)bits necessary to hold the maximum total value
    // Input: An array of n positive integers, describing the value (the weight or the profit) of each item.
    // Output: The minimum number of (qu)bits needed to store the maximum total value of the items.
    // Example: For n = 4 and itemValues = [1, 2, 3, 4], the maximum total value is 10, 
    //          which requires at least 4 qubits to store it, so 4 is returned.
    function NumBitsTotalValue01 (itemValues : Int[]) : Int {
        // ...
        return 0;
    }


    // Task 1.3. Calculate the total value of selected items
    // Inputs:
    //      1) An array of n integers, describing the values (the weights or the profits) of the items.
    //      2) An array of n qubits, describing whether each item is put into the knapsack.
    //      3) An array of qubits "total" in the |0...0⟩ state to store the total value of the selected items. 
    //         It is guaranteed that there are enough qubits to store the total value.
    // Goal: Transform the "total" array to represent, in little-endian format, the sum of the values of the items that are put in the knapsack.
    //       The input qubits can be in a superposition state. Leave the qubits in selectedItems in the same state they started in.
    // Example: For n = 4 and itemValues = [1, 2, 3, 4], the input state |1001⟩|0000⟩ should be transformed to |1001⟩|1010⟩, 
    //          since items 0 and 3 are put in the knapsack, and itemValues[0] + itemValues[3] = 1 + 4 = 5 = 1010₂.
    operation CalculateTotalValueOfSelectedItems01 (itemValues : Int[], selectedItems : Qubit[], total : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }
    

    // Task 1.4. Compare an integer stored in a qubit array with an integer (>)
    // Inputs:
    //      1) An array of D qubits representing an integer in little-endian format.
    //      2) An integer b (0 ≤ b ≤ 2ᴰ - 1).
    //      3) A qubit in an arbitrary state (target qubit).
    // Goal: Flip the state of the target qubit if the integer represented by the qubit array is greater than b.
    //       The input qubits can be in superposition. Leave the qubits in the qubit array in the same state they started in.
    // Example: For b = 11, the input state |1011⟩|0⟩ should be transformed to |1011⟩|1⟩, since 1101₂ = 13₁₀ > 11₁₀.
    operation CompareQubitArrayGreaterThanInt (qs : Qubit[], b : Int, target : Qubit) : Unit is Adj+Ctl {
        // ...
    }

    
    // Task 1.5. Compare an integer stored in a qubit array with an integer (≤)
    // Inputs:
    //      1) An array of D qubits representing an integer in little-endian format.
    //      2) An integer b (0 ≤ b ≤ 2ᴰ - 1).
    //      3) A qubit in an arbitrary state (target qubit).
    // Goal: Flip the state of the target qubit if the integer represented by the qubit array is less than or equal to b.
    //       The input qubits can be in superposition. Leave the qubits in the qubit array in the same state they started in.
    // Example: For b = 7, the input state |1010⟩|0⟩ should be transformed to |1010⟩|1⟩, since 0101₂ = 5₁₀ ≤ 7₁₀.
    operation CompareQubitArrayLeqThanInt (qs : Qubit[], b : Int, target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.6. Verify that the total weight doesn't exceed the limit W
    // Inputs:
    //      1) An integer W, the maximum weight the knapsack can hold.
    //      2) An array of n integers, describing the weights of the items: itemWeights[i] = wᵢ.
    //      3) An array of n qubits, describing whether each item is put into the knapsack.
    //      4) A qubit in an arbitrary state (target qubit).
    // Goal: Flip the state of the target qubit if the total weight is less than or equal to W.
    //       The input qubits can be in superposition. Leave the qubits in the qubit array in the same state they started in.
    operation VerifyTotalWeight01 (W : Int, itemWeights : Int[], selectedItems : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.7. Verify that the total profit exceeds the threshold P
    // Inputs:
    //      1) An integer P, the threshold which the total profit must exceed.
    //      2) An array of n integers, describing the profits of the items: itemProfits[i] = pᵢ.
    //      3) An array of n qubits, describing whether each item is put into the knapsack.
    //      4) A qubit in an arbitrary state (target qubit).
    // Goal: Flip the state of the target qubit if the total profit is greater than P.
    //       The input qubits can be in superposition. Leave the qubits in the qubit array in the same state they started in.
    operation VerifyTotalProfit01 (P : Int, itemProfits : Int[], selectedItems : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.8. Verify the solution to the 0-1 knapsack problem
    // Inputs:
    //      1) An integer W, the maximum weight the knapsack can hold.
    //      2) An integer P, the threshold which the total profit must exceed.
    //      3) An array of n integers, describing the weights of the items: itemWeights[i] = wᵢ.
    //      4) An array of n integers, describing the profits of the items: itemProfits[i] = pᵢ.
    //      5) An array of n qubits, describing whether each item is put into the knapsack.
    //      6) A qubit in an arbitrary state (target qubit).
    // Goal: Flip the state of the target qubit if the selection of the items in selectedItems satisfies both constraints:
    //        * the total weight of all items is less than or equal to W, and
    //        * the total profit of all items is greater than P.
    //       The input qubits can be in superposition. Leave the qubits in the qubit array in the same state they started in.
    operation VerifyKnapsackProblemSolution01 (
        W : Int, P : Int, itemWeights : Int[], itemProfits : Int[], selectedItems : Qubit[], target : Qubit
    ) : Unit is Adj+Ctl {
        // ...
    }



    //////////////////////////////////////////////////////////////////
    // Part II. Bounded Knapsack Problem
    //////////////////////////////////////////////////////////////////

    // Introduction:
    // In this version of the problem we still consider n items, indexed 0 to n-1,
    // the item with index i has a weight of wᵢ and yields a profit of pᵢ.
    // But in the bounded knapsack version of the problem, unlike in the 0-1 knapsack problem,
    // each type of item can have more than one copy, and can be selected multiple times.
    // Specifically, there are bᵢ copies of item type i available,
    // so this item type can be selected between 0 and bᵢ times, inclusive.
    // Let xᵢ represent the number of copies of index i that are put into the knapsack; the constraint 0 ≤ xᵢ ≤ bᵢ must hold for all i.
    // Thus, we seek a combination xs = [x₀, x₁, ..., xₙ₋₁] which
    // has total weight at most W, and has total profit that is greater than P.

    // Again, we slightly modify the problem, such that the total profit must
    // be strictly greater than P, rather than at least P.

    // The comparators from Part I (tasks 1.4-1.5) can be reused, but the operations for
    // calculating total weight and profit will need to be rewritten.


    // Task 2.1. Read combination from a jagged array of qubits
    // Input: A jagged array of qubits of length n. 
    //        Array selectedItemCounts[i] represents the binary notation of xᵢ in little-endian format.
    //        Each qubit is guaranteed to be in one of the basis states (|0⟩ or |1⟩).
    // Output: An integer array of length n, containing the combination that this jagged array represents.
    //         The i-th element of the output array should have value xᵢ.
    //         The operation should not change the state of the qubits.
    // Example: For state selectedItemCounts = [|101⟩, |1110⟩, |0100⟩], return [5, 7, 2].
    operation MeasureCombination (selectedItemCounts : Qubit[][]) : Int[] {
        // ...
        return [];
    }


    // Task 2.2. Convert an array into a jagged array
    // To simplify access to the register as an array of integers within the oracle, 
    // we reorganize the register into several qubit arrays that represent, in little-endian format, 
    // the number of copies of each item type.
    // We can do the same transformation with arrays of other types, for example, 
    // arrays of classical bits (boolean or integer) that store binary notations of several integers.
    // To make our code reusable, we can make it type-parameterized.
    // 
    // Inputs:
    //      1) An array of type T (T could be qubits or classical bits).
    //      2) An array of n integers bᵢ.
    // Output: A jagged array of n arrays of type T. 
    //         i-th element of the return value should have enough bits to represent the integer bᵢ in binary notation.
    //         The length of the input array of T is defined to be able to store all integers bᵢ.
    // Example: For b = [6, 15, 13] and a register of qubits in state |10111100100⟩, 
    //          you need to use 3, 4, and 4 bits to represent the integers bᵢ,
    //          so you'll return an array of qubit arrays [|101⟩, |1110⟩, |0100⟩].
    function RegisterAsJaggedArray<'T> (array : 'T[], b : Int[]) : 'T[][] {
        // ...
        return new 'T[][0];
    }


    // Task 2.3. Verification of limits satisfaction
    // Inputs:
    //      1) An array of n integers itemCountLimits[i] = bᵢ.
    //      2) A jagged array of n qubits. Each array selectedItemCounts[i] represents the number of items xᵢ in little-endian format.
    //      3) A qubit in an arbitrary state (target qubit).
    // Goal: Flip the state of the target qubit if xᵢ ≤ bᵢ for all i.
    //       The input qubits can be in superposition. Leave the qubits in qubit array in the same state they started in.
    operation VerifyLimits (itemCountLimits : Int[], selectedItemCounts : Qubit[][], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }

    
    // Task 2.4. Increment a quantum integer by a product of classical and quantum integers
    // Inputs:
    //      1) An integer x.
    //      2) An array of n qubits, representing an arbitrary integer y.
    //      3) An array of m qubits, representing an arbitrary integer z.
    // Goal: Increment register z by the product of x and y.
    //       Perform the increment modulo 2ᵐ (you don't need to track the carry bit).
    //       The input qubits can be in superposition. Leave the qubits in register y in the same state they started in.
    operation IncrementByProduct (x : Int, y : Qubit[], z : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }

    
    // Task 2.5. Calculate the number of (qu)bits necessary to hold the maximum total value
    // Inputs:
    //      1) An array of n positive integers, describing the value (the weight or the profit) of each item.
    //      2) An array of n positive integers, describing the bᵢ - the limits on the maximum number of items of type i that can be selected.
    // Output: The minimum number of (qu)bits needed to store the maximum total value of the items.
    // Example: For n = 4, itemValues = [1, 2, 3, 4], and itemCountLimits = [2, 5, 4, 3], 
    //          the maximum possible total value is  1*2 + 2*5 + 3*4 + 4*3 = 36, which requires at least 6 qubits, so 6 is returned.
    function NumBitsTotalValue (itemValues : Int[], itemCountLimits : Int[]) : Int {
        // ...
        return 0;
    }


    // Task 2.6. Calculate total value of selected items
    // Inputs:
    //      1) An array of n integers, describing the values (the weights or the profits) of the items.
    //      2) A jagged array of qubits of length n. Array selectedItems[i] represents the number of items of type i xᵢ in little-endian format.
    //      3) An array of qubits "total" in the |0...0⟩ state to store the total value of the selected items.
    //         It is guaranteed that there are enough qubits to store the total value.
    // Goal: Transform the "total" array to represent, in little-endian format, the sum of the values of the items that are put in the knapsack.
    //       The input qubits can be in a superposition state. Leave the qubits in selectedCounts in the same state they started in.
    operation CalculateTotalValueOfSelectedItems (itemValues : Int[], selectedCounts : Qubit[][], total : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 2.7. Verify that the total weight doesn't exceed the limit W
    // Inputs:
    //      1) An integer W, the maximum weight the knapsack can hold.
    //      2) An array of n integers, describing the weights of the items: itemWeights[i] = wᵢ.
    //      3) An array of n positive integers, describing the bᵢ - the limits on the maximum number of items of type i that can be selected.
    //      4) A jagged array of qubits, describing the number of each item type put into the knapsack. 
    //         Array selectedCounts[i] represents xᵢ in little-endian format.
    //      5) A qubit in an arbitrary state (target qubit).
    // Goal: Flip the state of the target qubit if the total weight is less than or equal to W.
    //       The input qubits can be in superposition. Leave the qubits in the selectedCounts array in the same state they started in.
    operation VerifyTotalWeight (W : Int, itemWeights : Int[], itemCountLimits : Int[], selectedCounts : Qubit[][], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 2.8. Verify that the total profit exceeds threshold P
    // Inputs:
    //      1) An integer P, the threshold which the total profit must exceed.
    //      2) An array of n integers, describing the profits of the items: itemProfits[i] = pᵢ
    //      3) An array of n positive integers, describing the bᵢ - the limits on the maximum number of items of type i that can be selected.
    //      4) A jagged array of qubits, describing the number of each item type put into the knapsack. 
    //         Array selectedCounts[i] represents xᵢ in little-endian format.
    //      5) A qubit in an arbitrary state (target qubit).
    // Goal: Flip the state of the target qubit if the total profit is greater than P.
    //       The input qubits can be in superposition. Leave the qubits in the selectedCounts array in the same state they started in.
    operation VerifyTotalProfit (P : Int, itemProfits : Int[], itemCountLimits : Int[], selectedCounts : Qubit[][], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 2.9. Verify the solution to the bounded knapsack problem
    // Inputs:
    //      1) An integer W, the maximum weight the knapsack can hold.
    //      2) An integer P, the threshold which the total profit must exceed.
    //      3) An array of n integers, describing the weights of the items: itemWeights[i] = wᵢ.
    //      4) An array of n integers, describing the profits of the items: itemProfits[i] = pᵢ.
    //      5) An array of n integers, describing the maximum numbers of each type of item that can be selected: itemCountLimits[i] = bᵢ.
    //      6) An array of Q qubits, describing the numbers of each type of item selected for the knapsack. 
    //         (Q is the minimum number of qubits necessary to store a concatenation of the numbers up to bᵢ.)
    //      7) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if the selection of the items in selectedCountsRegister satisfies both constraints:
    //        * the total weight of all items is less than or equal to W, 
    //        * the total profit of all items is greater than P, and
    //        * the number of i-th type of item is less than or equal to bᵢ.
    //       The input qubits can be in superposition. Leave the qubits in register in the same state they started in.
    operation VerifyKnapsackProblemSolution (W : Int, P : Int, itemWeights : Int[], itemProfits : Int[], itemCountLimits : Int[], selectedCountsRegister : Qubit[], target : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Using Grover's algorithm for knapsack optimization problems
    //////////////////////////////////////////////////////////////////

    // Coming soon...
}
