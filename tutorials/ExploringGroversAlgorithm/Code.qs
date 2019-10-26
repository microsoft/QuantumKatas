// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains pre-written code used by the tutorial notebooks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.ExploringGroversAlgorithm
{
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    //////////////////////////////////////////////////////////////////
    // Part I. Quantum oracles for solving SAT problem
    //////////////////////////////////////////////////////////////////

    // Helper function to get the list of qubits used in the clause and the bitmask of whether they need to be flipped
    function GetClauseQubits (queryRegister : Qubit[], clause : (Int, Bool)[]) : (Qubit[], Bool[]) {
        mutable clauseQubits = new Qubit[Length(clause)];
        mutable flip = new Bool[Length(clause)];
        for (varIndex in 0 .. Length(clause) - 1) {
            let (index, isTrue) = clause[varIndex];
            // Add the variable used in the clause to the list of variables which we'll need to call the OR oracle
            let qt = queryRegister[index];
            set clauseQubits w/= varIndex <- queryRegister[index];
            // If the negation of the variable is present in the formula, mark the qubit as needing a flip
            set flip w/= varIndex <- not isTrue;
        }
    
        return (clauseQubits, flip);
    }


    // ---------------------------------------------------------------------------------------------
    // Oracle to evaluate one clause of a SAT formula
    operation Oracle_SATClause (queryRegister : Qubit[], 
                                target : Qubit, 
                                clause : (Int, Bool)[]) : Unit is Adj {
        let (clauseQubits, flip) = GetClauseQubits(queryRegister, clause);

        // Actually calculate the clause (flip the necessary qubits, calculate OR, flip them back)
        within {
            ApplyPauliFromBitString(PauliX, true, flip, clauseQubits);
        }
        apply {
            // First, flip target if all qubits are in |0⟩ state
            (ControlledOnInt(0, X))(clauseQubits, target);
            // Then flip target again to get negation
            X(target);
        }
    }


    // ---------------------------------------------------------------------------------------------
    // Helper operation to evaluate all OR clauses given in the formula (independent on the number of variables in each clause)
    operation EvaluateOrClauses (queryRegister : Qubit[], 
                                 ancillaRegister : Qubit[], 
                                 problem : (Int, Bool)[][]) : Unit is Adj {
        for (clauseIndex in 0..Length(problem)-1) {
            Oracle_SATClause(queryRegister, ancillaRegister[clauseIndex], problem[clauseIndex]);
        }
    }


    // ---------------------------------------------------------------------------------------------
    // General SAT problem oracle: f(x) = ∧ᵢ (∨ₖ yᵢₖ), where yᵢₖ = either xᵢₖ or ¬xᵢₖ
    operation Oracle_SAT (queryRegister : Qubit[], 
                          target : Qubit, 
                          problem : (Int, Bool)[][]) : Unit is Adj {
        // Allocate qubits to store results of clauses evaluation
        using (ancillaRegister = Qubit[Length(problem)]) {
            // Compute clauses, evaluate the overall formula as an AND oracle (can use reference depending on the implementation) and uncompute
            within {
                EvaluateOrClauses(queryRegister, ancillaRegister, problem);
            }
            apply {
                Controlled X(ancillaRegister, target);
            }
        }
    }


    // ---------------------------------------------------------------------------------------------
    function CreateOracleForSATInstance (problem : (Int, Bool)[][]) : ((Qubit[], Qubit) => Unit is Adj) {
        return Oracle_SAT(_, _, problem);
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Grover's iteration
    //////////////////////////////////////////////////////////////////

    // Helper operation which converts marking oracle into phase oracle using an extra qubit
    operation ApplyMarkingOracleAsPhaseOracle (markingOracle : ((Qubit[], Qubit) => Unit is Adj), register : Qubit[]) : Unit is Adj {
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


    // ---------------------------------------------------------------------------------------------
    // Grover's algorithm loop: repeat Grover iteration the given number of times
    operation GroversAlgorithm_Loop (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        ApplyToEach(H, register);
            
        for (i in 1 .. iterations) {
            // apply oracle
            ApplyMarkingOracleAsPhaseOracle(oracle, register);
            // apply inversion about the mean
            ApplyToEach(H, register);
            ApplyToEach(X, register);
            Controlled Z(Most(register), Tail(register));
            ApplyToEach(X, register);
            ApplyToEach(H, register);
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Helper functions for pretty printing
    //////////////////////////////////////////////////////////////////

    // A set of helper functions to pretty-print SAT formulas
    function SATVariableAsString (var : (Int, Bool)) : String {
        let (index, isTrue) = var;
        return (isTrue ? "" | "¬") + $"x{index}";
    }

    function SATClauseAsString (clause : (Int, Bool)[]) : String {
        mutable ret = SATVariableAsString(clause[0]);
        for (ind in 1 .. Length(clause) - 1) {
            set ret = ret + " ∨ " + SATVariableAsString(clause[ind]);
        }
        return ret;
    }

    function SATInstanceAsString (instance : (Int, Bool)[][]) : String {
        mutable ret = "(" + SATClauseAsString(instance[0]) + ")";
        for (ind in 1 .. Length(instance) - 1) {
            set ret = ret + " ∧ (" + SATClauseAsString(instance[ind]) + ")";
        }
        return ret;
    }

    function VariableAssignmentAsString (variables : Bool[]) : String {
        mutable ret = $"x0 = {variables[0]}";
        for (ind in 1 .. Length(variables) - 1) {
            set ret = ret + $", x{ind} = {variables[ind]}";
        }
        return ret;
    }


    //////////////////////////////////////////////////////////////////
    // Part IV. Helper functions for Python visualization notebook
    //////////////////////////////////////////////////////////////////

    // Helper function for computing the success probability of Grover's algorithm with the given number of iterations (and given formula)
    operation SuccessProbability_SAT (N : Int, instance : (Int, Bool)[][], iter : Int) : Double {
        let oracle = Oracle_SAT(_, _, instance);

        mutable correct = 0;
        using ((register, answer) = (Qubit[N], Qubit())) {
            for (run in 1..100) {
                GroversAlgorithm_Loop(register, oracle, iter);
                let res = MultiM(register);
                oracle(register, answer);
                if (MResetZ(answer) == One) {
                    set correct += 1;
                }
                ResetAll(register);
            }
        }

        return IntAsDouble(correct) / 100.0;
    }

    // ---------------------------------------------------------------------------------------------
    operation Oracle_SolutionCount (queryRegister : Qubit[], target : Qubit, nSol : Int) : Unit is Adj {
        // Designate first nSol integers solutions (since we don't really care which ones are solutions)
        for (i in 0 .. nSol - 1) {
            (ControlledOnInt(i, X))(queryRegister, target);
        }
    }


    // Helper function for computing the success probability of Grover's algorithm with the given number of iterations (and given formula)
    operation SuccessProbability_Sol (nQubit : Int, nSol : Int, iter : Int) : Double {
        let oracle = Oracle_SolutionCount(_, _, nSol);

        mutable correct = 0;
        using ((register, answer) = (Qubit[nQubit], Qubit())) {
            for (run in 1..100) {
                GroversAlgorithm_Loop(register, oracle, iter);
                let res = MultiM(register);
                oracle(register, answer);
                if (MResetZ(answer) == One) {
                    set correct += 1;
                }
                ResetAll(register);
            }
        }

        return IntAsDouble(correct) / 100.0;
    }

}
