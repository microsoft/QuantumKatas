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
	open Microsoft.Quantum.Intrinsic;
    
    

   
  
    
    // ------------------------------------------------------
    operation T11_Counting_Test () : Unit {
		let n_sol=8;
		let reference=Counting_Reference(6,n_sol,6);
		Message(DoubleAsString(reference));

		EqualityWithinToleranceFact(reference,IntAsDouble(n_sol),3.0);
    }
    
}
