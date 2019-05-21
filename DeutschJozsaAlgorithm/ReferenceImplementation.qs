// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Oracles
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. f(x) = 0
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_Zero_Reference (x : Qubit[], y : Qubit) : Unit
    is Adj {
        // Since f(x) = 0 for all values of x, |y ⊕ f(x)⟩ = |y⟩.
        // This means that the operation doesn't need to do any transformation to the inputs.
        // Build the project and run the tests to see that T01_Oracle_Zero_Test test passes.
    }
    
    
    // Task 1.2. f(x) = 1
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_One_Reference (x : Qubit[], y : Qubit) : Unit
    is Adj {
        // Since f(x) = 1 for all values of x, |y ⊕ f(x)⟩ = |y ⊕ 1⟩ = |NOT y⟩.
        // This means that the operation needs to flip qubit y (i.e. transform |0⟩ to |1⟩ and vice versa).
        X(y);
    }
    
    
    // Task 1.3. f(x) = xₖ (the value of k-th qubit)
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) 0-based index of the qubit from input register (0 <= k < N)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ xₖ⟩ (⊕ is addition modulo 2).
    operation Oracle_Kth_Qubit_Reference (x : Qubit[], y : Qubit, k : Int) : Unit
    is Adj {        
        EqualityFactB(0 <= k and k < Length(x), true, "k should be between 0 and N-1, inclusive");
        CNOT(x[k], y);
    }
    
    
    // Task 1.4. f(x) = 1 if x has odd number of 1s, and 0 otherwise
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_OddNumberOfOnes_Reference (x : Qubit[], y : Qubit) : Unit 
    is Adj {       
        // Hint: f(x) can be represented as x_0 ⊕ x_1 ⊕ ... ⊕ x_(N-1)
        for (q in x) {
            CNOT(q, y);
        }
        // alternative solution: ApplyToEachA(CNOT(_, y), x);
    }
    
    
    // Task 1.5. f(x) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for a given bit vector r (scalar product function)
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) a bit vector of length N represented as Int[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    
    // Note: the functions featured in tasks 1.1, 1.3 and 1.4 are special cases of this function.
    operation Oracle_ProductFunction_Reference (x : Qubit[], y : Qubit, r : Int[]) : Unit
    is Adj {        
        // The following line enforces the constraint on the input arrays.
        // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
        EqualityFactI(Length(x), Length(r), "Arrays should have the same length");
            
        for (i in IndexRange(x)) {
            if (r[i] == 1) {
                CNOT(x[i], y);
            }
        }
    }
    
    
    // Task 1.6. f(x) = Σᵢ (𝑟ᵢ 𝑥ᵢ + (1 - 𝑟ᵢ)(1 - 𝑥ᵢ)) modulo 2 for a given bit vector r
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) a bit vector of length N represented as Int[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_ProductWithNegationFunction_Reference (x : Qubit[], y : Qubit, r : Int[]) : Unit
    is Adj {
        // The following line enforces the constraint on the input arrays.
        // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
        EqualityFactI(Length(x), Length(r), "Arrays should have the same length");
            
        for (i in IndexRange(x)) {
            if (r[i] == 1) {
                CNOT(x[i], y);
            } else {
                // do a 0-controlled NOT
                X(x[i]);
                CNOT(x[i], y);
                X(x[i]);
            }
        }
    }
    
    
    // Task 1.7. f(x) = Σᵢ 𝑥ᵢ + (1 if prefix of x is equal to the given bit vector, and 0 otherwise) modulo 2
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) a bit vector of length P represented as Int[] (1 <= P <= N)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    
    // A prefix of length k of a state |x⟩ = |x₁, ..., xₙ⟩ is the state of its first k qubits |x₁, ..., xₖ⟩.
    // For example, a prefix of length 2 of a state |0110⟩ is 01.
    operation Oracle_HammingWithPrefix_Reference (x : Qubit[], y : Qubit, prefix : Int[]) : Unit
    is Adj {        
        // The following line enforces the constraint on the input arrays.
        // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
        let P = Length(prefix);
        EqualityFactB(1 <= P and P <= Length(x), true, "P should be between 1 and N, inclusive");
            
        // Hint: the first part of the function is the same as in task 1.4
        for (q in x) {
            CNOT(q, y);
        }
            
        // add check for prefix as a multicontrolled NOT
        // true bits of r correspond to 1-controls, false bits - to 0-controls
        for (i in 0 .. P - 1) {
                
            if (prefix[i] == 0) {
                X(x[i]);
            }
        }
            
        Controlled X(x[0 .. P - 1], y);
            
        // uncompute changes done to input register
        for (i in 0 .. P - 1) {
                
            if (prefix[i] == 0) {
                X(x[i]);
            }
        }
    }
    
    
    // Task 1.8*. f(x) = 1 if x has two or three bits (out of three) set to 1, and 0 otherwise  (majority function)
    // Inputs:
    //      1) 3 qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_MajorityFunction_Reference (x : Qubit[], y : Qubit) : Unit
    is Adj {        
        // The following line enforces the constraint on the input array.
        // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
        EqualityFactB(3 == Length(x), true, "x should have exactly 3 qubits");
            
        // f(x) can be represented in terms of AND and ⊕ operations as follows:
        // f(x) = (x₀ AND x₁) ⊕ (x₀ AND x₂) ⊕ (x₁ AND x₂)
        CCNOT(x[0], x[1], y);
        CCNOT(x[0], x[2], y);
        CCNOT(x[1], x[2], y);
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part II. Bernstein-Vazirani Algorithm
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1. State preparation for Bernstein-Vazirani algorithm
    // Inputs:
    //      1) N qubits in |0⟩ state (query register)
    //      2) a qubit in |0⟩ state (answer register)
    // Goal:
    //      1) create an equal superposition of all basis vectors from |0...0⟩ to |1...1⟩ on query register
    //         (i.e. state (|0...0⟩ + ... + |1...1⟩) / sqrt(2^N) )
    //      2) create |-⟩ state (|-⟩ = (|0⟩ - |1⟩) / sqrt(2)) on answer register
    operation BV_StatePrep_Reference (query : Qubit[], answer : Qubit) : Unit
    is Adj {        
        ApplyToEachA(H, query);
        X(answer);
        H(answer);
    }
    
    
    // Task 2.2. Bernstein-Vazirani algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x⟩|y⟩ -> |x⟩|y ⊕ f(x)⟩, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is a scalar product function
    // (can be represented as f(𝑥₀, …, 𝑥ₙ₋₁) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for some bit vector r = (𝑟₀, …, 𝑟ₙ₋₁)).
    // You have implemented the oracle implementing the scalar product function in task 1.5.
    // Output:
    //      A bit vector r reconstructed from the function
    
    // Note: a trivial approach is to call the oracle N times:
    //       |10...0⟩|0⟩ = |10...0⟩|r₀⟩, |010...0⟩|0⟩ = |010...0⟩|r₁⟩ and so on.
    // Quantum computing allows to perform this task in just one call to the oracle; try to implement this algorithm.
    operation BV_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Int[] {
                
        // allocate N qubits for input register and 1 qubit for output
        using ((x, y) = (Qubit[N], Qubit())) {
            
            // prepare qubits in the right state
            BV_StatePrep_Reference(x, y);
            
            // apply oracle
            Uf(x, y);
            
            // apply Hadamard to each qubit of the input register
            ApplyToEach(H, x);
            
            // measure all qubits of the input register;
            // the result of each measurement is converted to an Int
            mutable r = new Int[N];
            for (i in 0 .. N - 1) {
                if (M(x[i]) != Zero) {
                    set r w/= i <- 1;
                }
            }
            
            // before releasing the qubits make sure they are all in |0⟩ state
            ResetAll(x);
            Reset(y);
            return r;
        }
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part III. Deutsch-Jozsa Algorithm
    //////////////////////////////////////////////////////////////////
    
    // Task 3.1. Deutsch-Jozsa algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x⟩|y⟩ -> |x⟩|y ⊕ f(x)⟩, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is either
    // constant (returns 0 on all inputs or 1 on all inputs) or
    // balanced (returns 0 on exactly one half of the input domain and 1 on the other half).
    // Output:
    //      true if the function f is constant
    //      false if the function f is balanced
    
    // Note: a trivial approach is to call the oracle multiple times:
    //       if the values for more than half of the possible inputs are the same, the function is constant.
    // Quantum computing allows to perform this task in just one call to the oracle; try to implement this algorithm.
    operation DJ_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Bool {
        
        // Declare variable in which the result will be accumulated;
        // this variable has to be mutable to allow updating it.
        mutable isConstantFunction = true;
        
        // Hint: even though Deutsch-Jozsa algorithm operates on a wider class of functions
        // than Bernstein-Vazirani (i.e. functions which can not be represented as a scalar product, such as f(x) = 1),
        // it can be expressed as running Bernstein-Vazirani algorithm
        // and then post-processing the return value classically:
        // the function is constant if and only if all elements of the returned array are false
        let r = BV_Algorithm_Reference(N, Uf);
        
        for (i in 0 .. N - 1) {
            set isConstantFunction = isConstantFunction and r[i] == 0;
        }
        
        return isConstantFunction;
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part IV. Come up with your own algorithm!
    //////////////////////////////////////////////////////////////////
    
    // Task 4.1. Reconstruct the oracle from task 1.6
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x⟩|y⟩ -> |x⟩|y ⊕ f(x)⟩, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle can be represented as
    // f(𝑥₀, …, 𝑥ₙ₋₁) = Σᵢ (𝑟ᵢ 𝑥ᵢ + (1 - 𝑟ᵢ)(1 - 𝑥ᵢ)) modulo 2 for some bit vector r = (𝑟₀, …, 𝑟ₙ₋₁).
    // You have implemented the oracle implementing this function in task 1.6.
    // Output:
    //      A bit vector r which generates the same oracle as the one you are given
    operation Noname_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Int[] {
                
        using ((x, y) = (Qubit[N], Qubit())) {
            // apply oracle to qubits in all 0 state
            Uf(x, y);
            
            // f(x) = Σᵢ (𝑟ᵢ 𝑥ᵢ + (1 - 𝑟ᵢ)(1 - 𝑥ᵢ)) = 2 Σᵢ 𝑟ᵢ 𝑥ᵢ + Σᵢ 𝑟ᵢ + Σᵢ 𝑥ᵢ + N = Σᵢ 𝑟ᵢ + N
            // remove the N from the expression
            if (N % 2 == 1) {
                X(y);
            }
            
            // now y = Σᵢ 𝑟ᵢ
            
            // Declare an Int array in which the result will be stored;
            // the variable has to be mutable to allow updating it.
            mutable r = new Int[N];

            // measure the output register
            let m = M(y);
            if (m == One) {
                // adjust parity of bit vector r
                set r w/= 0 <- 1;
            }
            
            // before releasing the qubits make sure they are all in |0⟩ state
            ResetAll(x);
            Reset(y);
            return r;
        }
    }
    
}
