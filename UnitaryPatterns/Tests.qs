// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.UnitaryPatterns {
    
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Quantum.Kata.Utils;
    
    
    // ------------------------------------------------------
    // Test harness: given an operation on N qubits and a function which takes two indices between 0 and 2^N-1
    // and returns false if the element of the matrix at that index is 0 and true if it is non-zero,
    // test that the operation implements a matrix of this shape
    operation AssertOperationMatrixMatchesPattern (N : Int, op : (Qubit[] => Unit), pattern : ((Int, Int, Int) -> Bool)) : Unit {
        let size = 1 <<< N;
        
        //Message($"Testing on {N} qubits");

        // ε is the threshold for probability, which is absolute value squared; the absolute value is bounded by √ε.
        let ε = 0.000001;
        
        using (qs = Qubit[N]) {
            for (k in 0 .. size - 1) {                
                // Prepare k-th basis vector
                let binary = IntAsBoolArray(k, N);
                
                //Message($"{k}/{N} = {binary}");
                // binary is little-endian notation, so the second vector tried has qubit 0 in state 1 and the rest in state 0
                ApplyPauliFromBitString(PauliX, true, binary, qs);
                
                // Reset the counter of measurements done outside of the solution call
                ResetOracleCallsCount();
                
                // Apply the operation
                op(qs);
                
                // Make sure the solution didn't use any measurements
                Fact(GetOracleCallsCount(M) == 0, "You are not allowed to use measurements in this task");
                Fact(GetOracleCallsCount(Measure) == 0, "You are not allowed to use measurements in this task");

                // Test that the result matches the k-th column
                // DumpMachine($"C:/Tmp/dump{N}_{k}.txt");
                for (j in 0 .. size - 1) {                    
                    let nonZero = pattern(size, j, k);
                    
                    let (expected, tol) = nonZero ? (0.5 + ε, 0.5) | (0.0, ε);
                    AssertProbInt(j, expected, LittleEndian(qs), tol);
                }
                
                ResetAll(qs);
            }
        }
    }
    
    
    // ------------------------------------------------------
    function MainDiagonal_Pattern (size : Int, row : Int, col : Int) : Bool {
        return row == col;
    }
    
    
    operation T01_MainDiagonal_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, MainDiagonal, MainDiagonal_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function AllNonZero_Pattern (size : Int, row : Int, col : Int) : Bool {
        return true;
    }
    
    
    operation T02_AllNonZero_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, AllNonZero, AllNonZero_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function BlockDiagonal_Pattern (size : Int, row : Int, col : Int) : Bool {
        return row / 2 == col / 2;
    }
    
    
    operation T03_BlockDiagonal_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, BlockDiagonal, BlockDiagonal_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function Quarters_Pattern (size : Int, row : Int, col : Int) : Bool {
        // The indices are little-endian, with qubit 0 corresponding to the least significant bit
        // and qubits 1..N-1 corresponding to most significant bits.
        // The pattern of quarters corresponds to equality of the most significant bits of row and column (qubit N-1)
        return row / (size / 2) == col / (size / 2);
    }
    
    
    operation T04_Quarters_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, Quarters, Quarters_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function EvenChessPattern_Pattern (size : Int, row : Int, col : Int) : Bool {
        // The indices are little-endian, qubit 0 corresponding to the least significant bit
        // and qubits 1..N-1 corresponding to most significant bits.
        // The chessboard pattern corresponds to equality of the least significant bits of row and column (qubit 0)
        return row % 2 == col % 2;
    }
    
    
    operation T05_EvenChessPattern_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, EvenChessPattern, EvenChessPattern_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function OddChessPattern_Pattern (size : Int, row : Int, col : Int) : Bool {
        // The indices are little-endian, qubit 0 corresponding to the least significant bit
        // and qubits 1..N-1 corresponding to most significant bits.
        // The chessboard pattern corresponds to inequality of the least significant bits of row and column (qubit 0)
        return row % 2 != col % 2;
    }
    
    
    operation T06_OddChessPattern_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, OddChessPattern, OddChessPattern_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function Antidiagonal_Pattern (size : Int, row : Int, col : Int) : Bool {
        return row == (size - 1) - col;
    }
    
    
    operation T07_Antidiagonal_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, Antidiagonal, Antidiagonal_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function ChessPattern2x2_Pattern (size : Int, row : Int, col : Int) : Bool {
        return (row / 2) % 2 == (col / 2) % 2;
    }
    
    
    operation T08_ChessPattern2x2_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, ChessPattern2x2, ChessPattern2x2_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function TwoPatterns_Pattern (size : Int, row : Int, col : Int) : Bool {
        // top right and bottom left quarters are all 0
        let s2 = size / 2;
        if (row / s2 != col / s2) {
            return false;
        }
        if (row / s2 == 0) {
            // top left quarter is an anti-diagonal
            return row % s2 + col % s2 == s2 - 1;
        }
        // bottom right quarter is all 1
        return true;
    }
    
    
    operation T09_TwoPatterns_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, TwoPatterns, TwoPatterns_Pattern);
        }
    }


    // ------------------------------------------------------
    function IncreasingBlocks_Pattern (size : Int, row : Int, col : Int) : Bool {
        // top right and bottom left quarters are all 0
        let s2 = size / 2;
        if (row / s2 != col / s2) {
            return false;
        }
        if (row / s2 == 0) {
            // top left quarter is the same pattern for s2, except for the start of the recursion
            if (s2 == 1) {
                return true;
            }
            return IncreasingBlocks_Pattern(s2, row, col);
        }
        // bottom right quarter is all 1
        return true;
    }
    
    
    operation T10_IncreasingBlocks_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, IncreasingBlocks, IncreasingBlocks_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function XWing_Fighter_Pattern (size : Int, row : Int, col : Int) : Bool {
        return row == col or row == (size - 1) - col;
    }
    
    
    operation T11_XWing_Fighter_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, XWing_Fighter, XWing_Fighter_Pattern);
        }
    }
    

    // ------------------------------------------------------
    function Rhombus_Pattern (size : Int, row : Int, col : Int) : Bool {
        let s2 = size / 2;
        return row / s2 == col / s2 and row % s2 + col % s2 == s2 - 1 or 
               row / s2 != col / s2 and row % s2 == col % s2;
    }
    
    
    operation T12_Rhombus_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, Rhombus, Rhombus_Pattern);
        }
    }


    // ------------------------------------------------------
    function TIE_Fighter_Pattern (size : Int, row : Int, col : Int) : Bool {
        let s2 = size / 2;
        return row / s2 == 0  and  col / s2 == 0  and  row % s2 + col % s2 == s2 - 2 or 
               row / s2 == 0  and  col / s2 == 1  and  col % s2 - row % s2 == 1 or 
               row / s2 == 1  and  col / s2 == 0  and  row % s2 - col % s2 == 1 or 
               row / s2 == 1  and  col / s2 == 1  and  row % s2 + col % s2 == s2 or 
               (row == s2 - 1 or row == s2) and (col == s2 - 1 or col == s2);
    }
    

    operation T13_TIE_Fighter_Test () : Unit {
        for (n in 2 .. 5) {
            AssertOperationMatrixMatchesPattern(n, TIE_Fighter, TIE_Fighter_Pattern);
        }
    }
    
    
    // ------------------------------------------------------
    function Creeper_Pattern (size : Int, row : Int, col : Int) : Bool {
        let A = [ [ true, true, false, false, false, false, true, true], 
                  [ true, true, false, false, false, false, true, true], 
                  [ false, false, false, true, true, false, false, false], 
                  [ false, false, false, true, true, false, false, false], 
                  [ false, false, true, false, false, true, false, false], 
                  [ false, false, true, false, false, true, false, false], 
                  [ true, true, false, false, false, false, true, true], 
                  [ true, true, false, false, false, false, true, true] ];
        return size != 8 ? false | A[row][col];         
    }
    

    operation T14_Creeper_Test () : Unit {
        AssertOperationMatrixMatchesPattern(3, Creeper, Creeper_Pattern);
    }
    
    // ------------------------------------------------------
    function Hessenberg_Matrix_Pattern (size : Int, row : Int, col : Int) : Bool {
        return (row - 1) <= col;
    }
    

    operation T15_Hessenberg_Matrix_Test () : Unit {
        for (n in 2 .. 4) {
            AssertOperationMatrixMatchesPattern(n, Hessenberg_Matrix, Hessenberg_Matrix_Pattern);
        }
    }
}
