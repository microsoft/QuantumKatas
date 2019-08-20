// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Counting {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    
    // ------------------------------------------------------
    // helper wrapper to represent oracle operation on input and output registers as an operation on an array of qubits
    operation QubitArrayWrapperOperation (op : ((Qubit[], Qubit, Qubit[]) => Unit is Adj), qs : Qubit[]) : Unit
    is Adj {
		let reg= Partitioned([3,1],qs);
        op(reg[0], reg[1][0], reg[2]);
    }
    
    
    // ------------------------------------------------------
    // helper wrapper to test for operation equality on various register sizes
    operation AssertRegisterOperationsEqual (testOp : (Qubit[] => Unit), refOp : (Qubit[] => Unit is Adj)) : Unit {
            AssertOperationsEqualReferenced(7, testOp, refOp);

    }
    
    
    // ------------------------------------------------------
	
    operation T11_Oracle_Sprinkler_Test () : Unit {
        let testOp = QubitArrayWrapperOperation(Oracle_Sprinkler, _);
        let refOp = QubitArrayWrapperOperation(Oracle_Sprinkler_Reference, _);
        AssertRegisterOperationsEqual(testOp, refOp);
    }
    
   
  
    
    // ------------------------------------------------------
    operation T21_Counting_Test () : Unit {
	    let reference=Counting();
		let actual=4.0;
		EqualityWithinToleranceFact(reference,actual,3.0);
    }
    
}
