// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.UnitaryPatterns {
    
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
    
    // Task 1. Main diagonal
    operation MainDiagonal_Reference (qs : Qubit[]) : Unit {
        
    }
    
    
    // Task 2. All-non-zero matrix
    operation AllNonZero_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, qs);
    }
    
    
    // Task 3. Quarters
    operation Quarters_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, Most(qs));
    }
    
    
    // Task 4. Even chessboard pattern
    operation EvenChessPattern_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, qs[1 .. Length(qs) - 1]);
    }
    
    
    // Task 5. Odd chessboard pattern
    operation OddChessPattern_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, qs[1 .. Length(qs) - 1]);
        X(Head(qs));
    }
}
