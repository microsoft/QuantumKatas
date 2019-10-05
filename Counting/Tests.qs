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
	    let reference=Counting_Reference(4,4,3);
//		Message(DoubleAsString(reference));
		let actual=4.0;
		EqualityWithinToleranceFact(reference,actual,3.0);
    }
    
}
