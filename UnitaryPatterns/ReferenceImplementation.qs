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
    
    
    // Task 6. Anti-diagonal
    operation Antidiagonal_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(X, qs);
    }


    // Task 7. 2x2 chessboard pattern
    operation ChessPattern2x2_Reference (qs : Qubit[]) : Unit {
        H(Head(qs));
        for (i in 2 .. Length(qs) - 1) {
            H(qs[i]);
        }
    }
    

    // Task 8. Two patterns
    operation TwoPatterns_Reference (qs : Qubit[]) : Unit {
        // bottom right quarter is obtained by applying Controlled AllNonZero
        ApplyToEach(Controlled H([Tail(qs)], _), Most(qs));
        // top left quarter is obtained by applying 0-controlled Antidiagonal
        ApplyToEach((ControlledOnInt(0, X))([Tail(qs)], _), Most(qs));
    }
}
