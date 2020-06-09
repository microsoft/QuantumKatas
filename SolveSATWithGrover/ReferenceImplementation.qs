// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GroversAlgorithm {
    
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Oracles for SAT problems
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. The AND oracle: f(x) = x₀ ∧ x₁
    operation Oracle_And_Reference_2 (queryRegister : Qubit[], target : Qubit) : Unit is Adj {        
        CCNOT(queryRegister[0], queryRegister[1], target);
    }

    // AND oracle for an arbitrary number of qubits in query register
    operation Oracle_And_Reference (queryRegister : Qubit[], target : Qubit) : Unit is Adj {        
        Controlled X(queryRegister, target);
    }


    // ------------------------------------------------------
    // Task 1.2. The OR oracle: f(x) = x₀ ∨ x₁
    operation Oracle_Or_Reference_2 (queryRegister : Qubit[], target : Qubit) : Unit is Adj {
        // x₀ ∨ x₁ = ¬ (¬x₀ ∧ ¬x₁)
        // First, flip target if both qubits are in |0⟩ state
        within {
            X(queryRegister[0]);
            X(queryRegister[1]);
        }
        apply {
            CCNOT(queryRegister[0], queryRegister[1], target);
        }
        // Then flip target again to get negation
        X(target);
    }

    // OR oracle for an arbitrary number of qubits in query register
    operation Oracle_Or_Reference (queryRegister : Qubit[], target : Qubit) : Unit is Adj {        
        // x₀ ∨ x₁ = ¬ (¬x₀ ∧ ¬x₁)
        // First, flip target if both qubits are in |0⟩ state
        (ControlledOnInt(0, X))(queryRegister, target);
        // Then flip target again to get negation
        X(target);
    }


    // ------------------------------------------------------
    // Task 1.3. The XOR oracle: f(x) = x₀ ⊕ x₁
    operation Oracle_Xor_Reference_2 (queryRegister : Qubit[], target : Qubit) : Unit is Adj {        
        CNOT(queryRegister[0], target);
        CNOT(queryRegister[1], target);
    }

    // XOR oracle for an arbitrary number of qubits in query register
    operation Oracle_Xor_Reference (queryRegister : Qubit[], target : Qubit) : Unit is Adj {        
        ApplyToEachA(CNOT(_, target), queryRegister);
    }

    // Alternative solution to task 1.3, based on representation as a 2-SAT problem
    operation Oracle_Xor_2SAT (queryRegister : Qubit[], target : Qubit) : Unit is Adj {        
        // x₀ ⊕ x₁ = (x₀ ∨ x₁) ∧ (¬x₀ ∨ ¬x₁)
        // Allocate 2 auxiliary qubits to store results of clause evaluation
        using ((a1, a2) = (Qubit(), Qubit())) {
            within {
                // The first clause is exactly the Or oracle
                Oracle_Or_Reference(queryRegister, a1);
                // The second clause is the Or oracle, applied to negations of the variables
                ApplyWithA(ApplyToEachA(X, _), Oracle_Or_Reference(_, a2), queryRegister);
            }
            apply {
                // To calculate the final answer, apply the And oracle with the ancilla qubits as inputs
                Oracle_And_Reference([a1, a2], target);
            }
        }
    }



    // ------------------------------------------------------
    // Task 1.4. Alternating bits oracle: f(x) = (x₀ ⊕ x₁) ∧ (x₁ ⊕ x₂) ∧ ... ∧ (xₙ₋₂ ⊕ xₙ₋₁)
    operation Oracle_AlternatingBits_Reference (queryRegister : Qubit[], target : Qubit) : Unit is Adj {
        
        // Allocate N-1 qubits to store results of clauses evaluation
        let N = Length(queryRegister);
        using (anc = Qubit[N-1]) {
            // Evaluate all XOR clauses (using XOR oracle)
            for (i in 0..N-2) {
                Oracle_Xor_Reference(queryRegister[i..i+1], anc[i]);
            }
                
            // Evaluate the overall formula as an AND oracle (can use reference depending on the implementation)
            Controlled X(anc, target);
                
            // Uncompute
            for (i in 0..N-2) {
                Adjoint Oracle_Xor_Reference(queryRegister[i..i+1], anc[i]);
            }
        }
    }

    // Answer-based solution for alternating bits oracle
    operation FlipAlternatingPositionBits_Reference (register : Qubit[], firstIndex : Int) : Unit is Adj {
        
        // iterate over elements in every second position, starting with firstIndex (indexes are 0-based)
        for (i in firstIndex .. 2 .. Length(register) - 1) {
            X(register[i]);
        }
    }

    operation Oracle_AlternatingBits_Answer (queryRegister : Qubit[], target : Qubit) : Unit is Adj {
        
        // similar to task 1.2 from GroversAlgorithm kata: 
        // first mark the state with 1s in even positions (starting with the first qubit, index 0), 
        // then mark the state with 1s in odd positions
        for (firstIndex in 0..1) {
            FlipAlternatingPositionBits_Reference(queryRegister, firstIndex);
            Controlled X(queryRegister, target);
            Adjoint FlipAlternatingPositionBits_Reference(queryRegister, firstIndex);
        }
    }


    // ------------------------------------------------------
    function GetClauseQubits (queryRegister : Qubit[], clause : (Int, Bool)[]) : (Qubit[], Bool[]) {
        mutable clauseQubits = new Qubit[Length(clause)];
        mutable flip = new Bool[Length(clause)];
        for (varIndex in 0 .. Length(clause) - 1) {
            let (index, isTrue) = clause[varIndex];
            // Add the variable used in the clause to the list of variables which we'll need to call the OR oracle
            set clauseQubits w/= varIndex <- queryRegister[index];
            // If the negation of the variable is present in the formula, mark the qubit as needing a flip
            set flip w/= varIndex <- not isTrue;
        }
    
        return (clauseQubits, flip);
    }


    // Task 1.5. Evaluate one clause of a SAT formula
    operation Oracle_SATClause_Reference (queryRegister : Qubit[], 
                                          target : Qubit, 
                                          clause : (Int, Bool)[]) : Unit is Adj {
        let (clauseQubits, flip) = GetClauseQubits(queryRegister, clause);

        // Actually calculate the clause (flip the necessary qubits, call OR oracle, flip them back)
        within {
            ApplyPauliFromBitString(PauliX, true, flip, clauseQubits);
        }
        apply {
            Oracle_Or_Reference(clauseQubits, target);
        }
    }


    // ------------------------------------------------------
    // Helper operation to evaluate all OR clauses given in the formula (independent on the number of variables in each clause)
    operation EvaluateOrClauses (queryRegister : Qubit[], 
                                 ancillaRegister : Qubit[], 
                                 problem : (Int, Bool)[][],
                                 clauseOracle : ((Qubit[], Qubit, (Int, Bool)[]) => Unit is Adj)) : Unit is Adj {
        for (clauseIndex in 0..Length(problem)-1) {
            clauseOracle(queryRegister, ancillaRegister[clauseIndex], problem[clauseIndex]);
        }
    }

    // Task 1.6. General SAT problem oracle: f(x) = ∧ᵢ (∨ₖ yᵢₖ), yᵢₖ = either xᵢₖ or ¬xᵢₖ
    operation Oracle_SAT_Reference (queryRegister : Qubit[], 
                           target : Qubit, 
                           problem : (Int, Bool)[][]) : Unit is Adj {
        // Similar to task 1.4.
        // Allocate qubits to store results of clauses evaluation
        using (ancillaRegister = Qubit[Length(problem)]) {
            // Compute clauses, evaluate the overall formula as an AND oracle (can use reference depending on the implementation) and uncompute
            within {
                EvaluateOrClauses(queryRegister, ancillaRegister, problem, Oracle_SATClause_Reference);
            }
            apply {
                Controlled X(ancillaRegister, target);
            }
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Oracles for exactly-1 3-SAT problem
    //////////////////////////////////////////////////////////////////

    // Task 2.1. "Exactly one |1⟩" oracle
    operation Oracle_Exactly1One_Reference_3 (queryRegister : Qubit[], target : Qubit) : Unit is Adj {
        ApplyToEachA(CNOT(_, target), queryRegister);
        // cancel the case of all 3 input qubits in |1⟩ state
        Controlled X(queryRegister, target);
    }

    // "Exactly one |1⟩" oracle for an arbitrary number of qubits in query register
    operation Oracle_Exactly1One_Reference (queryRegister : Qubit[], target : Qubit) : Unit is Adj {
        mutable bits = new Bool[Length(queryRegister)];
        for (i in 0..Length(queryRegister) - 1) {
            // Iterate over all possible bit strings which have exactly one bit set to 1
            // and perform a controlled X with each of these bit strings as control
            (ControlledOnBitString(bits w/ i <- true, X))(queryRegister, target);
        }
    }

    // ------------------------------------------------------
    operation Oracle_Exactly1OneClause_Reference (queryRegister : Qubit[], 
                                                  target : Qubit, 
                                                  clause : (Int, Bool)[]) : Unit is Adj {
        let (clauseQubits, flip) = GetClauseQubits(queryRegister, clause);

        // Actually calculate the clause (flip the necessary qubits, call the oracle, flip them back)
        within {
            ApplyPauliFromBitString(PauliX, true, flip, clauseQubits);
        }
        apply {
            // This is the only difference with the normal SAT problem - the clause is evaluated with a different oracle
            Oracle_Exactly1One_Reference(clauseQubits, target);
        }
    }

    // Task 2.2. "Exactly-1 3-SAT" oracle
    operation Oracle_Exactly1_3SAT_Reference (queryRegister : Qubit[], 
                                              target : Qubit, 
                                              problem : (Int, Bool)[][]) : Unit is Adj {        
        // similar to task 1.7
        using (ancillaRegister = Qubit[Length(problem)]) {
            // Compute clauses, evaluate the overall formula as an AND oracle (can use reference depending on the implementation) and uncompute
            within {
                EvaluateOrClauses(queryRegister, ancillaRegister, problem, Oracle_Exactly1OneClause_Reference);
            }
            apply {
                Controlled X(ancillaRegister, target);
            }
        }
    }



    //////////////////////////////////////////////////////////////////
    // Part III. Using Grover's algorithm for problems with multiple solutions
    //////////////////////////////////////////////////////////////////
    
    operation OracleConverterImpl_Reference (markingOracle : ((Qubit[], Qubit) => Unit is Adj), register : Qubit[]) : Unit is Adj {

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
    
    function OracleConverter_Reference (markingOracle : ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        return OracleConverterImpl_Reference(markingOracle, _);
    }

    operation GroversAlgorithm_Loop (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        let phaseOracle = OracleConverter_Reference(oracle);
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


    // Task 3.2. Universal implementation of Grover's algorithm
    operation UniversalGroversAlgorithm_Reference (N : Int, oracle : ((Qubit[], Qubit) => Unit is Adj)) : Bool[] {
        // In this task you don't know the optimal number of iterations upfront, 
        // so it makes sense to try different numbers of iterations.
        // This way, even if you don't hit the "correct" number of iterations on one of your tries,
        // you'll eventually get a high enough success probability.

        // This solution tries numbers of iterations that are powers of 2;
        // this is not the only valid solution, since a lot of sequences will eventually yield the answer.
        mutable answer = new Bool[N];
        using ((register, output) = (Qubit[N], Qubit())) {
            mutable correct = false;
            mutable iter = 1;
            repeat {
                Message($"Trying search with {iter} iterations");
                GroversAlgorithm_Loop(register, oracle, iter);
                let res = MultiM(register);
                // to check whether the result is correct, apply the oracle to the register plus ancilla after measurement
                oracle(register, output);
                if (MResetZ(output) == One) {
                    set correct = true;
                    set answer = ResultArrayAsBoolArray(res);
                }
                ResetAll(register);
            } until (correct or iter > 100)  // the fail-safe to avoid going into an infinite loop
            fixup {
                set iter *= 2;
            }
            if (not correct) {
                fail "Failed to find an answer";
            }
        }
        Message($"{answer}");
        return answer;
    }
}
