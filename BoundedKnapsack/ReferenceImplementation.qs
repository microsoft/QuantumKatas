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
	operation MeasureCombination_01_Reference (register : Qubit[]) : Bool[] {
		return ResultArrayAsBoolArray(MultiM(register));
	}
	

	// Task 1.2. Calculate Total Weight or Profit
	operation CalculateTotalWeightOrProfit_01_Reference (n : Int, values : Int[], register : Qubit[], total : Qubit[]) : Unit is Adj+Ctl{
		// Each qubit in xs determines whether the corresponding value is added.
		// This process is implemented with a control from xs[i].
		let TotalLE = LittleEndian(total);
		for (i in 0..n-1){
			Controlled IncrementByInteger([register[i]], (values[i], TotalLE));
		}
	}


    // Task 1.3. Compare Qubit Array with Integer (>)
    operation CompareQubitArrayGreaterThanInt_Reference (a : Qubit[], b : Int, target : Qubit) : Unit is Adj+Ctl{
		let D = Length(a);

		// Convert n into array of bits in little endian format
		let binaryB = IntAsBoolArray(b, D);

		// Iterates descending from the most significant digit, flipping the target qubit
		// upon finding i such that a[i] > binaryB[i], AND a[j] = binaryB[j] for all j > i.
		// The X gate flips a[i] to represent whether a[i] and binaryB[i] are equal, to
		// be used as controls for the Toffoli.
		// Thus, the Toffoli will only flip the target when a[i] = 1, binaryB[i] = 0, and  
		// a[j] = 1 for all j > i (meaning a and binaryB have the same digits above i).

		for(i in D-1..-1..0){
			if (not(binaryB[i])){
				// Checks if a has a greater bit than b at index i AND all bits above index i have equal values in a and b.
				Controlled X(a[i..D-1], target);
				// Flips the qubit if b's corresponding bit is 0.
				// This temporarily sets the qubit to 1 if the corresponding bits are equal.
				X(a[i]);
			}
		}

		// Uncompute
		for(i in Length(a)-1..-1..0){
			if (not(binaryB[i])){
				X(a[i]);
			}
		}
	}


    // Task 1.4. Compare Qubit Array with Integer (≤)
    operation CompareQubitArrayLeqThanInt_Reference (a : Qubit[], b : Int, target : Qubit) : Unit is Adj+Ctl{
		// This operation essentially calculates the opposite of the greater-than
		// comparator, so we can just call CompareQubitArrayGreaterThanInt, and then an X gate.
		CompareQubitArrayGreaterThanInt_Reference(a, b, target);
		X(target);
	}


	// Task 1.5. Verify that total weight doesn't exceed limit W
	operation VerifyWeight_01_Reference (n: Int, W : Int, maxTotal : Int, itemWeights : Int[], register : Qubit[], target : Qubit) : Unit is Adj+Ctl{
		using (TotalWeight = Qubit[maxTotal]){
			CalculateTotalWeightOrProfit_01_Reference(n, itemWeights, register, TotalWeight);
			CompareQubitArrayLeqThanInt_Reference(TotalWeight, W, target);

			//Uncompute
			Adjoint CalculateTotalWeightOrProfit_01_Reference(n, itemWeights, register, TotalWeight);
		}
	}


	// Task 1.6. Verify that the total profit exceeds threshold P
	operation VerifyProfit_01_Reference (n: Int, P : Int, maxTotal : Int, itemProfits : Int[], register : Qubit[], target : Qubit) : Unit is Adj+Ctl{
		using (profit = Qubit[maxTotal]){
			CalculateTotalWeightOrProfit_01_Reference(n, itemProfits, register, profit);
			CompareQubitArrayGreaterThanInt_Reference(profit, P, target);

			//Uncompute
			Adjoint CalculateTotalWeightOrProfit_01_Reference(n, itemProfits, register, profit);
		}
	}


	// Task 1.7. 0-1 Knapsack Problem Validation Oracle
	operation KnapsackValidationOracle_01_Reference (n : Int, W : Int, P : Int, maxTotal : Int, itemWeights : Int[], itemProfits : Int[], register : Qubit[], target : Qubit) : Unit is Adj+Ctl{
		using ((outputW, outputP) = (Qubit(), Qubit())){
			VerifyWeight_01_Reference(n, W, maxTotal, itemWeights, register, outputW);
			VerifyProfit_01_Reference(n, P, maxTotal, itemProfits, register, outputP);
			CCNOT(outputW, outputP, target);
			Adjoint VerifyProfit_01_Reference(n, P, maxTotal, itemProfits, register, outputP);
			Adjoint VerifyWeight_01_Reference(n, W, maxTotal, itemWeights, register, outputW);
		}
	}


    //////////////////////////////////////////////////////////////////
    // Part II. Bounded Knapsack Problem
    //////////////////////////////////////////////////////////////////
	

	// Task 2.1. Read combination from a jagged array of qubits
	operation MeasureCombination_Reference (xs : Qubit[][]) : Int[] {
		let n = Length(xs);
		mutable xsCombo = new Int[n];
		for (i in 0..n-1){
			set xsCombo w/= i <- ResultArrayAsInt(MultiM(xs[i]));
		}
		return xsCombo;
	}


	// Task 2.2. Convert Qubit Register into Jagged Qubit Array
	function RegisterAsJaggedArray_Reference (n : Int, itemInstanceBounds : Int[], register : Qubit[]) : Qubit[][]{
		// Note: Declaring a new qubit array doesn't actually allocate new qubits; it allocates
		//		 memory to store references to existing qubits.
		mutable xs = new Qubit[][n];
		mutable q = 0;
		for (i in 0..n-1){
			set xs w/= i <- register[q..q+BinaryLength(itemInstanceBounds[i])-1];
			set q += BinaryLength(itemInstanceBounds[i]);
		}
		return xs;
	}


	function BinaryLength (x : Int) : Int {
		// There are x + 1 integers in the range 0..x, inclusive. Thus, the minimum number of qubits
		// to hold numbers up to x is log₂(x+1), rounded up.
		return Ceiling(Lg(IntAsDouble(x+1)));
	}


    // Task 2.3. Verification of Bounds Satisfaction
	operation VerifyBounds_Reference (n : Int, itemInstanceBounds : Int[], xs : Qubit[][], target : Qubit) : Unit is Adj+Ctl{
		using (satisfy = Qubit[n]){
			for (i in 0..n-1){
				// Check that each individual xᵢ satisfies the bound.
				// If the number represented by xs[i] is at most itemInstanceBounds[i] = bᵢ, then the result will be 1, indicating satisfication.
				CompareQubitArrayLeqThanInt_Reference(xs[i], itemInstanceBounds[i], satisfy[i]);
			}
			// If all are satisfied, then the combination xs passes bounds Verification.
			Controlled X(satisfy, target);
			for (i in 0..n-1){
				CompareQubitArrayLeqThanInt_Reference(xs[i], itemInstanceBounds[i], satisfy[i]);
			}
		}
	}


    // Task 2.4. Increment Qubit Array by Product of an Integer and a different Qubit Array
    operation IncrementByProduct_Reference (x : Int, y : Qubit[], z : Qubit[]) : Unit is Adj+Ctl{
		let D = Length(y);
		let zLE = LittleEndian(z);

		// Calculates each partial product, y[i] · x · 2ⁱ
		// Thus, the following code adds each partial product to z, if the corresponding qubit in y is 1.
		// For more information, see https://en.wikipedia.org/wiki/Binary_multiplier#Unsigned_numbers
		for (i in 0..D-1){
			Controlled IncrementByInteger([y[i]], (x <<< i, zLE));
		}
	}


    // Task 2.5. Calculation of Total Weight
	operation CalculateTotalWeightOrProfit_Reference (n : Int, values : Int[], xs : Qubit[][], total : Qubit[]) : Unit is Adj+Ctl{
		// The item type with index i contributes xᵢ instances to the knapsack, adding values[i] per instance to the total.
		// Thus, for each item type, we increment the total by their product.
		for (i in 0..n-1){
			IncrementByProduct_Reference(values[i], xs[i], total);
		}
	}


	// Task 2.6. Verify that Weight satisfies limit W
	operation VerifyWeight_Reference (n: Int, W : Int, maxTotal : Int, itemWeights : Int[], xs : Qubit[][], target : Qubit) : Unit is Adj+Ctl{
		using (totalWeight = Qubit[maxTotal]){
			// Calculate the total weight by using the array with each item's weight.
			CalculateTotalWeightOrProfit_Reference(n, itemWeights, xs, totalWeight);
			CompareQubitArrayLeqThanInt_Reference(totalWeight, W, target);

			//Uncompute
			Adjoint CalculateTotalWeightOrProfit_Reference(n, itemWeights, xs, totalWeight);
		}
	}


	// Task 2.7. Verify that the total profit exceeds threshold P
	operation VerifyProfit_Reference (n: Int, P : Int, maxTotal : Int, itemProfits : Int[], xs : Qubit[][], target : Qubit) : Unit is Adj+Ctl{
		using (totalProfit = Qubit[maxTotal]){
			// Calculate the total profit by using the array with each item's profit.
			CalculateTotalWeightOrProfit_Reference(n, itemProfits, xs, totalProfit);
			CompareQubitArrayGreaterThanInt_Reference(totalProfit, P, target);

			//Uncompute
			Adjoint CalculateTotalWeightOrProfit_Reference(n, itemProfits, xs, totalProfit);
		}
	}


	// Task 2.8. Bounded Knapsack Problem Validation Oracle
	operation KnapsackValidationOracle_Reference (n : Int, W : Int, P : Int, maxTotal: Int, itemWeights : Int[], itemProfits : Int[], itemInstanceBounds : Int[], register : Qubit[], target : Qubit) : Unit is Adj+Ctl{
		let xs = RegisterAsJaggedArray_Reference(n, itemInstanceBounds, register);
		using ((outputB, outputW, outputP) = (Qubit(), Qubit(), Qubit())){
			// Compute the result of each verification onto separate qubits
			VerifyBounds_Reference(n, itemInstanceBounds, xs, outputB);
			VerifyWeight_Reference(n, W, maxTotal, itemWeights, xs, outputW);
			VerifyProfit_Reference(n, P, maxTotal, itemProfits, xs, outputP);

			// Compute the final result, which is the AND operation of the three separate results
			// Accomplished by a triple-control Toffoli.
			Controlled X([outputB] + [outputW] + [outputP], target);

			Adjoint VerifyProfit_Reference(n, P, maxTotal, itemProfits, xs, outputP);
			Adjoint VerifyWeight_Reference(n, W, maxTotal, itemWeights, xs, outputW);
			Adjoint VerifyBounds_Reference(n, itemInstanceBounds, xs, outputB);
		}
	}

    //////////////////////////////////////////////////////////////////
    // Part III. Knapsack Oracle and Grover Search
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Using Grover Search with Knapsack Oracle to solve (a slightly modified version of the) Knapsack Decision Problem
    operation GroversAlgorithm_Reference (n : Int, W : Int, P : Int, maxTotal : Int, itemWeights : Int[], itemProfits : Int[], itemInstanceBounds : Int[]) : (Int[], Int) {
        
        mutable xs_found = new Int[n];
		mutable P_found = P;
		mutable correct = false;

		let Q = RegisterSize(n, itemInstanceBounds);

		// We will classically count M (the number of solutions), and calculate the optimal number of Grover Iterations.
		// In the future, this will be replaced by the quantum counting algorithm.
		let N = IntAsDouble(1 <<< Q);
		let m = IntAsDouble(NumberOfSolutions(n, W, P, itemWeights, itemProfits, itemInstanceBounds));
		if (m == 0.0){
			return (xs_found, P_found);
		}
		// Using the formula for the number of iterations, and rounding to the nearest integer
		mutable iter = Floor(PI() / 4.0 * Sqrt(N/m)+0.5);
		mutable attempts = 0;

		using (register = Qubit[Q]){
			
			repeat {
				// Note: The register is not converted into the jagged array before being used in the oracle, because
				//		 the ApplyToEach operations in the GroverIterations can't directly be called on jagged arrays.
				GroversAlgorithm_Loop(register, KnapsackValidationOracle_Reference(n, W, P, maxTotal, itemWeights, itemProfits, itemInstanceBounds, _, _), iter);

				// Measure the combination that Grover's Algorithm finds.
				let xs = RegisterAsJaggedArray_Reference(n, itemInstanceBounds, register);
				for (i in 0..n-1){
					let result = MultiM(xs[i]);
					set xs_found w/= i <- ResultArrayAsInt(result);
				}

				// Check that the combination is a valid combination.
				using (output = Qubit()){
					KnapsackValidationOracle_Reference(n, W, P, maxTotal, itemWeights, itemProfits, itemInstanceBounds, register, output);
					if (MResetZ(output) == One){
						set correct = true;
					}
				}

				// When the valid combination is found, calculate its profit
				if (correct){
					using (profit = Qubit[maxTotal]){
						CalculateTotalWeightOrProfit_Reference(n, itemProfits, xs, profit);
						set P_found = ResultArrayAsInt(MultiM(profit));
						ResetAll(profit);
					}
				}
                ResetAll(register);
				set attempts += 1;
			} until(correct or attempts > 10);

		}

		return (xs_found, P_found);
		
    }

	function RegisterSize(n : Int, itemInstanceBounds : Int[]) : Int {
		// Calculate the total number of qubits for the register, given the bounds array. The item with index i can have 0 to bᵢ instances,
		// which requires log₂(bᵢ+1) qubits (rounded up). The auxiliary function BinaryLength is used to faciliate
		// this calculation. The total number of qubits, Q, is the sum of each individual number of qubits.
		mutable Q = 0;
		for (i in 0..n-1){
			set Q = Q + BinaryLength(itemInstanceBounds[i]);
		}
		return Q;
	}

    // Grover loop implementation taken from SolveSATWithGrover kata.
    operation OracleConverterImpl (markingOracle : ((Qubit[], Qubit) => Unit is Adj), register : Qubit[]) : Unit is Adj {

        using (target = Qubit()) {
            // Put the target into the |-⟩ state
            X(target);
            H(target);
                
            // Apply the marking oracle; since the target is in the |-⟩ state,
            // flipping the target if the register satisfies the oracle condition will apply a -1 factor to the state
            markingOracle(register, target);
                
            // Put the target back into |0⟩ so we can return it
            H(target);
            X(target);
        }
    }
    
    operation GroversAlgorithm_Loop (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        let phaseOracle = OracleConverterImpl(oracle, _);
        ApplyToEach(H, register);
            
        for (i in 1 .. iterations) {
            phaseOracle(register);
            ApplyToEach(H, register);
            ApplyToEach(X, register);
            Controlled Z(Most(register), Tail(register));
            ApplyToEach(X, register);
            ApplyToEach(H, register);
        }
    }


	// A placeholder for the quantum counting algorithm, which will be implemented in a separate kata.
	// Calculate value M for the oracle (number of solutions), which is used in determining how many
	// Grover Iterations are necessary in Grover's Algorithm.
	function NumberOfSolutions (n : Int, W : Int, P : Int, itemWeights : Int[], itemProfits : Int[], itemInstanceBounds : Int[]) : Int {
		let Q = RegisterSize(n, itemInstanceBounds);
		mutable m = 0;
		for (combo in 0..(1 <<< Q) - 1){
			let binaryCombo = IntAsBoolArray(combo, Q);
			let xsCombo = BoolArrayAsIntArray(n, itemInstanceBounds, binaryCombo);

			// Determine if each combination is a solution.
			mutable ActualBounds = true;
			mutable ActualWeight = 0;
			mutable ActualProfit = 0;
			for (i in 0..n-1){
				// If any bound isn't satisfied, then Bounds Verification is not satisfied.
				if (xsCombo[i] > itemInstanceBounds[i]){
					set ActualBounds = false;
				}
				// Add the weight and profit of all instances of this item type.
				set ActualWeight += itemWeights[i]*xsCombo[i];
				set ActualProfit += itemProfits[i]*xsCombo[i];
			}
			if (ActualBounds and ActualWeight <= W and ActualProfit > P) {
				set m += 1;
			}
		}
		return m;
	}


	function BoolArrayAsIntArray (n : Int, itemInstanceBounds : Int[], binaryCombo : Bool[]) : Int[]{
		mutable xsCombo = new Int[n];
		mutable q = 0;
		for (i in 0..n-1){
			set xsCombo w/= i <- BoolArrayAsInt(binaryCombo[q..q+BinaryLength(itemInstanceBounds[i])-1]);
			set q += BinaryLength(itemInstanceBounds[i]);
		}
		return xsCombo;
	}
	
	
	// Task 3.2 Solving the Bounded Knapsack Optimization Problem
	operation KnapsackOptimizationProblem_Reference (n : Int, W : Int, maxTotal : Int, itemWeights : Int[], itemProfits : Int[], itemInstanceBounds : Int[]) : Int {
		// This implementation uses exponential search to search over profit thresholds and find the maximum possible profit.
		// The Grover Search using the Knapsack Oracle serves as the comparison function.
		// A description of exponential search is found at https://en.wikipedia.org/wiki/Exponential_search.

		// Determining an upper bound for a search range
		mutable P_high = 1;
		mutable upperBoundFound = false;
		repeat {
			let (xs_found, P_found) = GroversAlgorithm_Reference(n, W, P_high, maxTotal, itemWeights, itemProfits, itemInstanceBounds);
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
			let (xs_found, P_found) = GroversAlgorithm_Reference(n, W, P_high, maxTotal, itemWeights, itemProfits, itemInstanceBounds);
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
