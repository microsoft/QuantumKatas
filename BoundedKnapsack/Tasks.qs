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
    
    // The "BoundedKnapsack" quantum kata is a series of exercises designed
    // to teach you to use Grover Search to solve the Knapsack Problem.
    // The Knapsack Problem is a prominent computational problem, whose
    // description can be found at https://en.wikipedia.org/wiki/Knapsack_problem

    // The overall goal in this kata is to solve the Knapsack Optimization Problem,
    // by running Grover's Algorithm multiple times.

    // The kata covers the following topics:
    //  - writing operations to perform arithmetic tasks
    //  - writing oracles to implement constraints based on:
    //        - The 0-1 Knapsack Problem, a simple version of the Knapsack Problem.
    //        - The Bounded Knapsack Problem
    //  - using the oracle with Grover's Algorithm to solve the Knapsack Decision Problem.
    //  - using Grover's Algorithm repeatedly, to solve the Knapsack Optimization Problem.

    // You may find this kata to be more challenging than other Grover Search
    // katas, so you might want to try SolveSATWithGrover or GraphColoring first.
    // Unlike the other katas, whose tasks consist of a series of individual
    // problems, this kata's tasks each comprise one part of a large
    // operation to solve one problem.
    // Hints for the more complicated tasks can be found in the Hints.qs file.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.


    //////////////////////////////////////////////////////////////////
    // Part I. 0-1 Knapsack Problem
    //////////////////////////////////////////////////////////////////

    // Introduction:
    // There exist n items, indexed 0 to n-1.
    // The item with index i has a weight of wᵢ and a profit of pᵢ.
    // In (a modified version of) the 0-1 Knapsack Decision Problem, we wish to 
    // determine if we can put a combination of items in a knapsack to have 
    // a total profit of more than P, while not exceeding a maximum weight W.

    // The following tasks will write an oracle that evaluates whether a
    // particular register of n qubits, representing an item combination,
    // satisfies the described conditions.
    

    // Task 1.1. Read combination from a register
    // Input: An array of n qubits, which are guaranteed to be in one of the 2ⁿ basis states. The qubit at
    //        index i represents whether the item with index i is put into the knapsack.
    // Output: The item combination that this state represents, expressed as a boolean array with length n.
    //           The operation should not change the state of the qubits.
    // Example: For n = 3 and qubit state |101⟩, return [true, false, true].
    operation MeasureCombination_01 (register : Qubit[]) : Bool[] {
        // ...
        return new Bool[0];
    }


    // Task 1.2. Calculate Total Weight or Profit
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An array of n integers, describing either the weight of each item or the profit of each item.
    //        3) An array of n qubits, which describe whether each item is put into the knapsack
    //        4) An array of maxTotal qubits in the |0...0⟩ state. It is guaranteed there are enough qubits to hold the total.
    // Goal: Transform the total array to represent, in little-endian format, the sum of the values of the items that are put in the knapsack.
    // Example: For n = 4, maxTotal = 5, and values = [1,2,3,4], input state |1001⟩|00000⟩ transforms to |1001⟩|10100⟩, since items 0 and 3 are put
    //          in the knapsack, and values[0] + values[3] = 1 + 4 = 5.
    operation CalculateTotalWeightOrProfit_01 (n : Int, values : Int[], register : Qubit[], total : Qubit[]) : Unit is Adj+Ctl{
        // ...
    }
    

    // Task 1.3. Compare Qubit Array with Integer (>)
    // Inputs:
    //        1) An array of D qubits representing an integer in little-endian format
    //        2) An integer b (0 ≤ b ≤ 2ᴰ - 1)
    //      3) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if the integer represented by qs is greater than b.
    // Example: For b = 11, the input state |1011⟩|0⟩ should return as |1011⟩|1⟩, since 1101₂ = 13 > 11.
    operation CompareQubitArrayGreaterThanInt(qs : Qubit[], b : Int, target : Qubit) : Unit is Adj+Ctl{
        // ...
    }

    
    // Task 1.4. Compare Qubit Array with Integer (≤)
    // Inputs:
    //        1) An array of D qubits that represent an integer in little-endian format
    //        2) An integer b (0 ≤ b ≤ 2ᴰ - 1)
    //      3) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if the integer represented by qs is less than or equal to b.
    // Example: For b = 7, the input state |1010⟩|0⟩ should return as |1010⟩|1⟩, since 0101₂ = 5 ≤ 7.
    operation CompareQubitArrayLeqThanInt (qs : Qubit[], b : Int, target : Qubit) : Unit is Adj+Ctl{
        // ...
    }


    // Task 1.5. Verify that total weight doesn't exceed limit W
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An integer W, the maximum weight the knapsack can hold
    //        3) An array of n integers, such that itemWeights[i] = wᵢ
    //        4) An array of n qubits, which describe whether each item is put into the knapsack
    //        5) A qubit in an arbitrary state (target qubit)
    //        6) An integer maxTotal, the number of qubits to allocate to calculate the weight.
    // Goal: Flip the state of the target qubit if the total weight is less than or equal to W.
    operation VerifyWeight_01 (n: Int, W : Int, maxTotal : Int, itemWeights : Int[], register : Qubit[], target : Qubit) : Unit is Adj+Ctl{
        // ...
    }


    // Task 1.6. Verify that the total profit exceeds threshold P
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An integer P, which the total profit must exceed
    //        3) An integer maxTotal, the number of qubits to allocate to calculate the profit.
    //        4) An array of n integers, such that itemProfits[i] = pᵢ
    //        5) An array of n qubits, which describe whether each item is put into the knapsack
    //        6) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if the total profit is greater than P.
    operation VerifyProfit_01 (n: Int, P : Int, maxTotal : Int, itemProfits : Int[], register : Qubit[], target : Qubit) : Unit is Adj+Ctl{
        // ...
    }

    // Task 1.7. 0-1 Knapsack Problem Validation Oracle
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An integer W, the maximum weight the knapsack can hold
    //        3) An integer P, which the total profit must exceed
    //        4) An integer maxTotal, the number of qubits to allocate to calculate the profit.
    //        5) An array of n integers, such that itemWeights[i] = wᵢ
    //        6) An array of n integers, such that itemProfits[i] = pᵢ
    //        7) An array of n qubits, which describe whether each item is put into the knapsack
    //        8) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if the weight and profit both satisfy their respective constraints.
    operation KnapsackValidationOracle_01 (n : Int, W : Int, P : Int, maxTotal: Int, itemWeights : Int[], itemProfits : Int[], register : Qubit[], target : Qubit) : Unit is Adj+Ctl{
        // ...
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Bounded Knapsack Problem
    //////////////////////////////////////////////////////////////////

    // Introduction:
    // Unlike in the 0-1 Knapsack Problem, each type of item in the Bounded
    // Knapsack Problem can have more than one instance. Specifically,
    // the item type with index i can have from 0 to bᵢ instances.
    // xᵢ represents the number of instances of item with index i that are
    // put into the knapsack. Thus, for each i, xᵢ must be bounded by the range [0, bᵢ].
    // Again, each instance of item i has a weight of wᵢ and a profit of pᵢ.

    // The total weight of the knapsack is the sum of the weights of all the instances
    // put into the knapsack. The total profit is the sum of the profits of the same instances.

    // For the Bounded Knapsack Decision Problem, we seek a combination xs = [x₀, x₁, ..., xₙ₋₁]
    // that satisfies the bounds, has total weight at most W, and has total profit more than P.

    // The comparators from Part I can be reused, but the operations for
    // weight and profit calculation will need to be rewritten.


    // Task 2.1. Read combination from a jagged array of qubits
    // Inputs:
    //        1) A jagged array of qubits, with length n. Array xs[i] represents xᵢ in little-endian format.
    // Output: An integer array of length n, containing the combination that this jagged array represents.
    //           The integer at index i in the output array should have value xᵢ.
    // Example: For state xs = [|101⟩, |1110⟩, |0100⟩], return [5, 7, 2].
    operation MeasureCombination (xs : Qubit[][]) : Int[] {
        // ...
        return new Int[0];
    }


    // Task 2.2. Convert Qubit Register into Jagged Qubit Array

    // To facilitate access to the register's qubits within the oracle, the register is reorganized
    // into qubit groups, that represent, in little-endian format, the number of instances of each item type.
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An array of Q qubits
    //        3) An array of n integers, such that itemInstanceBounds[i] = bᵢ.
    // Output: A jagged array of n arrays of qubits. Small array i should have enough
    //         qubits to represent any integer from 0 to bᵢ in little-endian format. Q is defined
    //         such that there are exactly enough total qubits to perform this transformation.
    // Example: For n = 3, itemInstanceBounds = [6, 15, 13], and register in state |10111100100⟩, return [|101⟩, |1110⟩, |0100⟩].
    function RegisterAsJaggedArray (n : Int, itemInstanceBounds : Int[], register : Qubit[]) : Qubit[][]{
        // ...
        return new Qubit[][0];
    }


    // Task 2.3. Verification of Bounds Satisfaction
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An array of n integers, such that itemInstanceBounds[i] = bᵢ.
    //        3) A jagged array of qubits, with length n. Array xs[i] represents xᵢ in little-endian format.
    //        4) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if xᵢ ≤ bᵢ for all i.
    operation VerifyBounds (n : Int, itemInstanceBounds : Int[], xs : Qubit[][], target : Qubit) : Unit is Adj+Ctl{
        // ...
    }

    
    // Task 2.4. Increment Qubit Array by Product of an Integer and a different Qubit Array
    // Inputs:
    //        1) An integer x
    //        2) An array of D qubits, representing an arbitrary integer
    //        3) An second array of D qubits, representing an arbitrary integer
    // Goal: Increment z by the product of x and y.
    operation IncrementByProduct (x : Int, y : Qubit[], z : Qubit[]) : Unit is Adj+Ctl{
        // ...
    }


    // Task 2.5. Calculate Total Weight or Profit
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An array of n integers, describing either the weight of each item or the profit of each item.
    //        3) A jagged array of qubits, with length n. Array xs[i] represents xᵢ in little-endian format.
    //        4) An array of qubits in the |0...0⟩ state. It is guaranteed there are enough qubits to hold the total.
    // Goal: Transform the total array to represent, in little-endian format, the sum of the values of all the instances that are put in the knapsack.
    operation CalculateTotalWeightOrProfit (n : Int, values : Int[], xs : Qubit[][], total : Qubit[]) : Unit is Adj+Ctl{
        // ...
    }


    // Task 2.6. Verify that Weight satisfies limit W
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An integer W, the maximum weight the knapsack can hold
    //        3) An integer maxTotal, the number of qubits to allocate to calculate the weight.
    //        4) An array of n integers, such that itemWeights[i] = wᵢ
    //        5) A jagged array of qubits, with length n. Array xs[i] represents xᵢ in little-endian format.
    //        6) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if the total weight is less than or equal to W.
    operation VerifyWeight (n: Int, W : Int, maxTotal : Int, itemWeights : Int[], xs : Qubit[][], target : Qubit) : Unit is Adj+Ctl{
        // ...
    }


    // Task 2.7. Verify that the total profit exceeds threshold P
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An integer P, which the total profit must exceed
    //        3) An integer maxTotal, the number of qubits to allocate to calculate the profit.
    //        4) An array of n integers, such that itemProfits[i] = pᵢ
    //        5) A jagged array of qubits, with length n. Array xs[i] represents xᵢ in little-endian format.
    //        6) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if the total profit is greater than P.
    operation VerifyProfit (n: Int, P : Int, maxTotal : Int, itemProfits : Int[], xs : Qubit[][], target : Qubit) : Unit is Adj+Ctl{
        // ...
    }


    // Task 2.8. Bounded Knapsack Problem Validation Oracle
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An integer W, the maximum weight the knapsack can hold
    //        3) An integer P, which the total profit must exceed
    //        4) An integer maxTotal, the number of qubits to allocate to calculate the profit.
    //        5) An array of n integers, such that itemWeights[i] = wᵢ
    //        6) An array of n integers, such that itemProfits[i] = pᵢ
    //        7) An array of n integers, such that itemInstanceBounds[i] = bᵢ.
    //        8) An array of Q qubits. Q is the minimum number of qubits necessary to store the xs values.
    //        9) A qubit in an arbitrary state (target qubit)
    // Goal: Flip the state of the target qubit if the conditions for the bounds, weight, and profit are all satisfied.
    operation KnapsackValidationOracle (n : Int, W : Int, P : Int, maxTotal: Int, itemWeights : Int[], itemProfits : Int[], itemInstanceBounds : Int[], register : Qubit[], target : Qubit) : Unit is Adj+Ctl{
        // ...
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Grover Search and Knapsack Optimization Problem
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Implementing Grover Search with Bounded Knapsack Oracle to solve (a slightly modified version of the) Bounded Knapsack Decision Problem
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An integer W, the maximum weight the knapsack can hold
    //        3) An integer P, which the total profit must exceed
    //        4) An integer maxTotal, the number of qubits to allocate for holding each of the weight and profit.
    //        5) An array of n integers, such that itemWeights[i] = wᵢ
    //        6) An array of n integers, such that itemProfits[i] = pᵢ
    //        7) An array of n integers, such that itemInstanceBounds[i] = bᵢ.
    // Output: If a combination [x₀, x₁, ..., xₙ₋₁] can be found that satisfies the bounds, has total weight at most W,
    //         and has total profit more than P, return a tuple containing that combination and its total profit.
    //           Otherwise, return a tuple containing an array of zeroes with length n and the input P value.
    operation GroversAlgorithm (n : Int, W : Int, P : Int, maxTotal : Int, itemWeights : Int[], itemProfits : Int[], itemInstanceBounds : Int[]) : (Int[], Int) {
        // ...
        return (new Int[0], 0);
    }
    

    // Knapsack Optimization Problem:
    // The above tasks, when implemented, solve the Bounded Knapsack Decision Problem, which
    // asks: "Is there a valid combination that has more than P profit?"

    // The more common, applicable, and complex Knapsack Optimization Problem, by contrast,
    // asks "Which valid combination yields the most profit?", or "What's the highest
    // achievable profit?", and can be solved by repeatedly answering the Knapsack Decision Problem.

    // Thus, we will solve the Optimization Problem by setting a profit threshold P, repeatedly calling
    // Grover Search with P, and increasing P every time Grover Search concludes there exists a combination
    // more profitable than P. When Grover Search determines that there exist no combinations that are
    // more profitable than P, we will have found the highest achievable profit and thus answered the
    // Knapsack Optimization Problem.
     
    
    // Task 3.2. Solving the Bounded Knapsack Optimization Problem
    // Inputs:
    //        1) An integer n, the number of items
    //        2) An integer W, the maximum weight the knapsack can hold
    //        3) An integer maxTotal, the number of qubits to allocate for holding each of the weight and profit.
    //        4) An array of n integers, such that itemWeights[i] = wᵢ
    //        5) An array of n integers, such that itemProfits[i] = pᵢ
    //        6) An array of n integers, such that itemInstanceBounds[i] = bᵢ.
    // Output: An integer, the value of the highest achievable profit among all combinations that satisfy
    //         both the instance bounds and weight constraint.
    
    operation KnapsackOptimizationProblem (n : Int, W : Int, maxTotal : Int, itemWeights : Int[], itemProfits : Int[], itemInstanceBounds : Int[]) : Int {
        // ...
        return 0;
    }
}
