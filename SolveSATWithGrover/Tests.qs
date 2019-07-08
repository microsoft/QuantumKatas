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
    operation QubitArrayWrapperOperation (op : ((Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit
    is Adj {        
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
    function F_SAT (args : Bool[], problem : (Int, Bool)[][]) : Bool {
        for (clauseIndex in 0..Length(problem)-1) {
            mutable isClauseTrue = false;
            let clause = problem[clauseIndex];
            for ((index, isTrue) in clause) {
                if (isTrue == args[index]) {
                    set isClauseTrue = true;
                }
            }
            // One clause can invalidate the whole formula
            if (not isClauseTrue) {
                return false;
            }
        }
        return true;
    }

    operation Generate_SAT_Instance (is2SAT : Bool) : (Int, (Int, Bool)[][]) {
        let nVar = RandomInt(5) + 3;
        let nClause = RandomInt(2 * nVar) + 1;
        mutable problem = new (Int, Bool)[][nClause];

        for (j in 0..nClause-1) {
            mutable nVarInClause = is2SAT ? 2 | (RandomInt(4) + 1);
            if (nVarInClause > nVar) {
                set nVarInClause = nVar;
            }
            
            mutable problemRow = new (Int, Bool)[nVarInClause];
            mutable usedVariables = new Bool[nVar];
            // Make sure variables in each clause are distinct
            for (k in 0..nVarInClause-1) {
                mutable nextInd = -1;
                repeat { 
                    set nextInd = RandomInt(nVar);
                } until (not usedVariables[nextInd])
                fixup {}
                set problemRow w/= k <- (nextInd, RandomInt(2) > 0);
                set usedVariables w/= nextInd <- true;
            }
            set problem w/= j <- problemRow;
        }
        return (nVar, problem);
    }

    operation Run2SATTests (oracle : ((Qubit[], Qubit, (Int, Bool)[][]) => Unit is Adj)) : Unit {
        // Cross-tests:
        // OR oracle
        AssertOperationsEqualReferenced(3, 
            QubitArrayWrapperOperation(oracle(_, _, [[(0, true), (1, true)]]), _),
            QubitArrayWrapperOperation(Oracle_Or_Reference, _));

        // XOR oracle
        AssertOperationsEqualReferenced(3, 
            QubitArrayWrapperOperation(oracle(_, _, [[(0, true), (1, true)], [(1, false), (0, false)]]), _),
            QubitArrayWrapperOperation(Oracle_Xor_Reference, _));

        // AlternatingBits oracle for 3 qubits
        AssertOperationsEqualReferenced(4,
            QubitArrayWrapperOperation(oracle(_, _, [[(1, false), (2, false)], [(0, true), (1, true)], [(1, false), (0, false)], [(2, true), (1, true)]]), _),
            QubitArrayWrapperOperation(Oracle_AlternatingBits_Reference, _));

        // Standalone tests
        for (i in 1..8) {
            let (nVar, problem) = Generate_SAT_Instance(true);
            Message($"Testing 2-SAT instance {problem}");

            AssertOracleImplementsFunction(nVar, oracle(_, _, problem), F_SAT(_, problem));

            AssertOperationsEqualReferenced(nVar + 1,
                QubitArrayWrapperOperation(oracle(_, _, problem), _),
                QubitArrayWrapperOperation(Oracle_SAT_Reference(_, _, problem), _)
            );
        }
    }

    operation T15_Oracle_2SAT_Test () : Unit {
        Run2SATTests(Oracle_2SAT);
    }


    // ------------------------------------------------------
    operation T16_Oracle_SAT_Test () : Unit {
        // General SAT oracle should be able to implement all 2SAT problems
        Run2SATTests(Oracle_SAT);

        // General SAT instances
        for (i in 1..5) {
            let (nVar, problem) = Generate_SAT_Instance(false);
            Message($"Testing k-SAT instance {problem}");

            AssertOracleImplementsFunction(nVar, Oracle_SAT(_, _, problem), F_SAT(_, problem));

            AssertOperationsEqualReferenced(nVar + 1,
                QubitArrayWrapperOperation(Oracle_SAT(_, _, problem), _),
                QubitArrayWrapperOperation(Oracle_SAT_Reference(_, _, problem), _)
            );
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Using Grover's search for problems with multiple solutions
    //////////////////////////////////////////////////////////////////

    // Run algorithm on one instance of the SAT problem and check that the answer is correct
    operation RunGroverOnOneInstance (nVar : Int, problem : (Int, Bool)[][]) : Unit {
        let oracle = Oracle_SAT_Reference(_, _, problem);
        let answer = GroversAlgorithm(nVar, oracle);
        if (not F_SAT(answer, problem)) {
            fail $"Incorrect answer {answer} for {problem}";
        }
    }

    operation T22_GroversSearch_Test () : Unit {
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
