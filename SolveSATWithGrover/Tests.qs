// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GroversAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    
    // ------------------------------------------------------
    // helper wrapper to represent oracle operation on input and output registers as an operation on an array of qubits
    operation QubitArrayWrapperOperation (op : ((Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {        
        op(Most(qs), Tail(qs));
    }
    
    
    // ------------------------------------------------------
    // helper wrapper to test for operation equality on various register sizes
    operation AssertRegisterOperationsEqual (testOp : (Qubit[] => Unit), refOp : (Qubit[] => Unit is Adj)) : Unit {
        for (n in 2 .. 10) {
            AssertOperationsEqualReferenced(n, testOp, refOp);
        }
    }
    
    //////////////////////////////////////////////////////////////////
    // Part I. Oracles for SAT problems
    //////////////////////////////////////////////////////////////////
    
    operation AssertOracleImplementsFunction (N : Int, oracle : ((Qubit[], Qubit) => Unit), f : (Bool[] -> Bool)) : Unit {
        let size = 1 <<< N;
        using ((qs, target) = (Qubit[N], Qubit())) {
            for (k in 0 .. size - 1) {
                // Prepare k-th bit vector
                let binary = IntAsBoolArray(k, N);
                
                //Message($"{k}/{N} = {binary}");
                // binary is little-endian notation, so the second vector tried has qubit 0 in state 1 and the rest in state 0
                ApplyPauliFromBitString(PauliX, true, binary, qs);
                
                // Apply the operation
                oracle(qs, target);
                
                // Check that the result is what we'd expect to measure
                let val = f(binary);
                AssertQubit(val ? One | Zero, target);
                Reset(target);

                // Check that the query qubits are still in the same state
                ApplyPauliFromBitString(PauliX, true, binary, qs);
                AssertAllZero(qs);
            }
        }
    }
    

    // ------------------------------------------------------
    function And (args : Bool[]) : Bool {
        return args[0] and args[1];
    }

    operation T11_Oracle_And_Test () : Unit {
        AssertOracleImplementsFunction(2, Oracle_And, And);

        let testOp = QubitArrayWrapperOperation(Oracle_And, _);
        let refOp = QubitArrayWrapperOperation(Oracle_And_Reference, _);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }
    

    // ------------------------------------------------------
    function Or (args : Bool[]) : Bool {
        return args[0] or args[1];
    }

    operation T12_Oracle_Or_Test () : Unit {
        AssertOracleImplementsFunction(2, Oracle_Or, Or);

        let testOp = QubitArrayWrapperOperation(Oracle_Or, _);
        let refOp = QubitArrayWrapperOperation(Oracle_Or_Reference, _);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }
    

    // ------------------------------------------------------
    function Xor (args : Bool[]) : Bool {
        return args[0] != args[1];
    }

    operation T13_Oracle_Xor_Test () : Unit {
        AssertOracleImplementsFunction(2, Oracle_Xor, Xor);

        let testOp = QubitArrayWrapperOperation(Oracle_Xor, _);
        let refOp = QubitArrayWrapperOperation(Oracle_Xor_Reference, _);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }


    // ------------------------------------------------------
    function AlternatingBits (args : Bool[]) : Bool {
        for (i in 0..Length(args)-2) {
            if (args[i] == args[i+1]) {
                return false;
            }
        }
        return true;
    }

    operation T14_Oracle_AlternatingBits_Test () : Unit {
        let testOp = QubitArrayWrapperOperation(Oracle_AlternatingBits, _);
        let refOp = QubitArrayWrapperOperation(Oracle_AlternatingBits_Reference, _);

        for (n in 2 .. 5) {
            AssertOracleImplementsFunction(n, Oracle_AlternatingBits, AlternatingBits);

            AssertOperationsEqualReferenced(n + 1, testOp, refOp);
        }
    }


    // ------------------------------------------------------
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


    // ------------------------------------------------------
    // Evaluate one clause of the SAT formula
    function F_SATClause (args : Bool[], clause : (Int, Bool)[]) : Bool {
        for ((index, isTrue) in clause) {
            if (isTrue == args[index]) {
                // one true literal is sufficient for the clause to be true
                return true;
            }
        }
        // none of the literals is true - the whole clause is false
        return false;
    }

    operation Generate_SAT_Clause (nVar : Int, nTerms : Int) : (Int, Bool)[] {
        mutable nVarInClause = (nTerms > 0) ? nTerms | (RandomInt(4) + 1);
        if (nVarInClause > nVar) {
            set nVarInClause = nVar;
        }
    
        mutable clause = new (Int, Bool)[nVarInClause];
        mutable usedVariables = new Bool[nVar];
        // Make sure variables in the clause are distinct
        for (k in 0 .. nVarInClause - 1) {
            mutable nextInd = -1;
            repeat { 
                set nextInd = RandomInt(nVar);
            } until (not usedVariables[nextInd])
            fixup {}
            set clause w/= k <- (nextInd, RandomInt(2) > 0);
            set usedVariables w/= nextInd <- true;
        }
        return clause;
    }


    operation T15_Oracle_SATClause_Test () : Unit {
        for (i in 1..10) {
            let nVar = RandomInt(5) + 3;
            let clause = Generate_SAT_Clause(nVar, i);

            Message($"Testing SAT clause instance {SATClauseAsString(clause)}...");

            AssertOracleImplementsFunction(nVar, Oracle_SATClause(_, _, clause), F_SATClause(_, clause));

            AssertOperationsEqualReferenced(nVar + 1,
                QubitArrayWrapperOperation(Oracle_SATClause(_, _, clause), _),
                QubitArrayWrapperOperation(Oracle_SATClause_Reference(_, _, clause), _)
            );
        }
    }


    // ------------------------------------------------------
    function F_SAT (args : Bool[], problem : (Int, Bool)[][]) : Bool {
        for (clause in problem) {
            // One clause can invalidate the whole formula
            if (not F_SATClause(args, clause)) {
                return false;
            }
        }
        return true;
    }

    operation Generate_SAT_Instance (nTerms : Int) : (Int, (Int, Bool)[][]) {
        let nVar = RandomInt(5) + 3;
        let nClause = RandomInt(2 * nVar) + 1;
        mutable problem = new (Int, Bool)[][nClause];

        for (j in 0..nClause-1) {
            set problem w/= j <- Generate_SAT_Clause(nVar, nTerms);
        }
        return (nVar, problem);
    }

    operation Run2SATTests (oracle : ((Qubit[], Qubit, (Int, Bool)[][]) => Unit is Adj)) : Unit {
        // Cross-tests:
        // OR oracle
        Message($"Testing 2-SAT instance (2, {SATInstanceAsString([[(0, true), (1, true)]])})...");
        AssertOperationsEqualReferenced(3, 
            QubitArrayWrapperOperation(oracle(_, _, [[(0, true), (1, true)]]), _),
            QubitArrayWrapperOperation(Oracle_Or_Reference, _));

        // XOR oracle
        Message($"Testing 2-SAT instance (2, {SATInstanceAsString([[(0, true), (1, true)], [(1, false), (0, false)]])})...");
        AssertOperationsEqualReferenced(3, 
            QubitArrayWrapperOperation(oracle(_, _, [[(0, true), (1, true)], [(1, false), (0, false)]]), _),
            QubitArrayWrapperOperation(Oracle_Xor_Reference, _));

        // AlternatingBits oracle for 3 qubits
        Message($"Testing 2-SAT instance (3, {SATInstanceAsString([[(1, false), (2, false)], [(0, true), (1, true)], [(1, false), (0, false)], [(2, true), (1, true)]])})...");
        AssertOperationsEqualReferenced(4,
            QubitArrayWrapperOperation(oracle(_, _, [[(1, false), (2, false)], [(0, true), (1, true)], [(1, false), (0, false)], [(2, true), (1, true)]]), _),
            QubitArrayWrapperOperation(Oracle_AlternatingBits_Reference, _));

        // Standalone tests
        for (i in 1..8) {
            let (nVar, problem) = Generate_SAT_Instance(2);
            Message($"Testing 2-SAT instance ({nVar}, {SATInstanceAsString(problem)})...");

            AssertOracleImplementsFunction(nVar, oracle(_, _, problem), F_SAT(_, problem));

            AssertOperationsEqualReferenced(nVar + 1,
                QubitArrayWrapperOperation(oracle(_, _, problem), _),
                QubitArrayWrapperOperation(Oracle_SAT_Reference(_, _, problem), _)
            );
        }
    }

    // ------------------------------------------------------
    operation T16_Oracle_SAT_Test () : Unit {
        // General SAT oracle should be able to implement all 2SAT problems
        Run2SATTests(Oracle_SAT);

        // General SAT instances
        for (i in 1..5) {
            let (nVar, problem) = Generate_SAT_Instance(-1);
            Message($"Testing k-SAT instance ({nVar}, {SATInstanceAsString(problem)})...");

            AssertOracleImplementsFunction(nVar, Oracle_SAT(_, _, problem), F_SAT(_, problem));

            AssertOperationsEqualReferenced(nVar + 1,
                QubitArrayWrapperOperation(Oracle_SAT(_, _, problem), _),
                QubitArrayWrapperOperation(Oracle_SAT_Reference(_, _, problem), _)
            );
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Oracles for exactly-1 3-SAT problem
    //////////////////////////////////////////////////////////////////

    // ------------------------------------------------------
    function F_Exactly1One (args : Bool[]) : Bool {
        mutable nOnes = 0;
        for (element in args) {
            if (element) {
                set nOnes += 1;
            }
        }
        return nOnes == 1;
    }

    operation T21_Oracle_Exactly1One_Test () : Unit {
        AssertOracleImplementsFunction(3, Oracle_Exactly1One, F_Exactly1One);

        let testOp = QubitArrayWrapperOperation(Oracle_Exactly1One, _);
        let refOp = QubitArrayWrapperOperation(Oracle_Exactly1One_Reference, _);
        AssertOperationsEqualReferenced(4, testOp, refOp);
    }


    // ------------------------------------------------------
    // Evaluate one clause of the SAT formula
    function F_Exactly1SATClause (args : Bool[], clause : (Int, Bool)[]) : Bool {
        mutable nOnes = 0;
        for ((index, isTrue) in clause) {
            if (isTrue == args[index]) {
                // count the number of true literals
                set nOnes += 1;
            }
        }
        return nOnes == 1;
    }

    function F_Exactly1_SAT (args : Bool[], problem : (Int, Bool)[][]) : Bool {
        for (clause in problem) {
            // One clause can invalidate the whole formula
            if (not F_Exactly1SATClause(args, clause)) {
                return false;
            }
        }
        return true;
    }

    operation T22_Oracle_Exactly1SAT_Test () : Unit {
        // General SAT instances
        for (i in 1..10) {
            let (nVar, problem) = Generate_SAT_Instance(3);
            Message($"Testing exactly-1 3-SAT instance ({nVar}, {SATInstanceAsString(problem)})...");

            AssertOracleImplementsFunction(nVar, Oracle_Exactly1_3SAT(_, _, problem), F_Exactly1_SAT(_, problem));

            AssertOperationsEqualReferenced(nVar + 1,
                QubitArrayWrapperOperation(Oracle_Exactly1_3SAT(_, _, problem), _),
                QubitArrayWrapperOperation(Oracle_Exactly1_3SAT_Reference(_, _, problem), _)
            );
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Using Grover's search for problems with multiple solutions
    //////////////////////////////////////////////////////////////////

    // Run algorithm on one instance of the SAT problem and check that the answer is correct
    operation RunGroverOnOneInstance (nVar : Int, problem : (Int, Bool)[][]) : Unit {
        let oracle = Oracle_SAT_Reference(_, _, problem);
        let answer = UniversalGroversAlgorithm(nVar, oracle);
        if (not F_SAT(answer, problem)) {
            fail $"Incorrect answer {answer} for {problem}";
        }
    }

    operation T32_UniversalGroversAlgorithm_Test () : Unit {
        // AND: 1 solution/4
        RunGroverOnOneInstance(2, [[(0, true)], [(1, true)]]);

        // XOR: 2 solutions/4
        RunGroverOnOneInstance(2, [[(0, true), (1, true)], [(1, false), (0, false)]]);

        // OR: 3 solutions/4
        RunGroverOnOneInstance(2, [[(0, true), (1, true)]]);

        // Alternating bits: 2 solutions/2^4
        RunGroverOnOneInstance(4, [[(1, false), (2, false)], [(0, true), (1, true)], [(1, false), (0, false)], [(2, true), (1, true)], [(2, false), (3, false)], [(3, true), (2, true)]]);

        // SAT instance: 1/2^6
        RunGroverOnOneInstance(6, [[(1, false)], [(0, true), (1, true)], [(2, true), (3, true), (4, true)], [(3, false), (5, false)], [(0, false), (2, false), (5, true)], [(1, true), (3, true), (4, false)], [(1, true), (5, true)]]);
    }
}
