// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.UnitaryPatterns {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    
    // Task 1. Main diagonal
    operation MainDiagonal_Reference (qs : Qubit[]) : Unit {
        
    }
    
    
    // Task 2. All-non-zero matrix
    operation AllNonZero_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, qs);
    }
    
    
    // Task 3. Block diagonal matrix
    operation BlockDiagonal_Reference (qs : Qubit[]) : Unit {
        H(Head(qs));
    }


    // Task 4. Quarters
    operation Quarters_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, Most(qs));
    }
    
    
    // Task 5. Even chessboard pattern
    operation EvenChessPattern_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, qs[1 .. Length(qs) - 1]);
    }
    
    
    // Task 6. Odd chessboard pattern
    operation OddChessPattern_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, qs[1 .. Length(qs) - 1]);
        X(Head(qs));
    }
    
    
    // Task 7. Anti-diagonal
    operation Antidiagonal_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(X, qs);
    }


    // Task 8. 2x2 chessboard pattern
    operation ChessPattern2x2_Reference (qs : Qubit[]) : Unit {
        H(Head(qs));
        for (i in 2 .. Length(qs) - 1) {
            H(qs[i]);
        }
    }
    

    // Task 9. Two patterns
    operation TwoPatterns_Reference (qs : Qubit[]) : Unit {
        // bottom right quarter is obtained by applying Controlled AllNonZero
        ApplyToEach(Controlled H([Tail(qs)], _), Most(qs));
        // top left quarter is obtained by applying 0-controlled Antidiagonal
        ApplyToEach((ControlledOnInt(0, X))([Tail(qs)], _), Most(qs));
    }
    
    
    // Task 10. Increasing blocks
    operation IncreasingBlocks_Reference (qs : Qubit[]) : Unit {
        body (...) {
            let N = Length(qs);
            // for N = 1, we need an identity
            if (N > 1) {
                // do the bottom-right quarter
                ApplyToEachCA(Controlled H([Tail(qs)], _), Most(qs));
                // do the top-left quarter by calling the same operation recursively
                (ControlledOnInt(0, IncreasingBlocks_Reference))([Tail(qs)], Most(qs));
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }


    // Task 11. X-Wing fighter
    operation XWing_Fighter_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(CNOT(qs[0], _), qs[1 .. Length(qs) - 1]);
        H(qs[0]);
        ApplyToEach(CNOT(qs[0], _), qs[1 .. Length(qs) - 1]);
    }
    

    // Task 12. Rhombus
    operation Rhombus_Reference (qs : Qubit[]) : Unit {
        XWing_Fighter_Reference(qs);
        X(Tail(qs));
    }
}
