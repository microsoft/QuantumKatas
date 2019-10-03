// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.UnitaryPatterns {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    
    
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
        ApplyToEach(H, Rest(qs));
    }
    
    
    // Task 6. Odd chessboard pattern
    operation OddChessPattern_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(H, Rest(qs));
        X(Head(qs));
    }
    
    
    // Task 7. Anti-diagonal
    operation Antidiagonal_Reference (qs : Qubit[]) : Unit {
        ApplyToEach(X, qs);
    }


    // Task 8. 2⨯2 chessboard pattern
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
    operation IncreasingBlocks_Reference (qs : Qubit[]) : Unit is Adj + Ctl {

        let N = Length(qs);
        // for N = 1, we need an identity
        if (N > 1) {
            // do the bottom-right quarter
            ApplyToEachCA(Controlled H([Tail(qs)], _), Most(qs));
            // do the top-left quarter by calling the same operation recursively
            (ControlledOnInt(0, IncreasingBlocks_Reference))([Tail(qs)], Most(qs));
        }
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


    // Task 13. TIE fighter

    // Helper operation: decrement a little-endian register
    operation Decrement (qs : Qubit[]) : Unit {
        X(qs[0]);
        for (i in 1..Length(qs)-1) {
            Controlled X(qs[0..i-1], qs[i]);
        }
    }
    
    // Helper operation: antidiagonal 
    operation Reflect (qs : Qubit[]) : Unit
    is Ctl {
        ApplyToEachC(X, qs);
    }
    
    // Main operation for Task 13
    operation TIE_Fighter_Reference (qs : Qubit[]) : Unit {
        let n = Length(qs);
        X(qs[n-1]);
        Controlled Reflect([qs[n-1]], qs[0..(n-2)]);
        X(qs[n-1]);
        Decrement(qs[0..(n-2)]);
        H(qs[n-1]);
        Controlled Reflect([qs[n-1]], qs[0..(n-2)]);
    }
    

    // Task 14. Creeper
    operation Creeper_Reference (qs : Qubit[]) : Unit {
        // We observe that a Hadamard transform on 2 qubits already produces the block structure that is 
        // required for the 4 "corners" of the unitary matrix. The rest of the pattern is a suitable 
        // permutation of a additional block, where this block contains the Hadamard transform on 1 qubit. 
        // The permutation producing the corners can be constructed from a CNOT from middle qubit to most 
        // significant qubit. The permutation producing the pattern in the center can be produced by 
        // applying a cyclic shift of the quantum register. This can be accomplished using a CNOT and a CCNOT. 
        CNOT(qs[1], qs[2]); 
        CNOT(qs[2], qs[0]); 
        CCNOT(qs[0], qs[2], qs[1]); 
        X(qs[2]);
        Controlled H([qs[2]], qs[1]);
        X(qs[2]);
        H(qs[0]);
        CNOT(qs[1], qs[2]);         
    }

    
    // Task 15. Hessenberg matrices         

    // Helper function for Embedding_Perm: finds first location where bit strings differ. 
    function FirstDiff (bits1 : Bool[], bits2 : Bool[]) : Int {
        for (i in 0 .. Length(bits1)-1) {
            if (bits1[i] != bits2[i]) {
                return i;
            }
        }
        return -1;
    }
    
    // Helper function for Embed_2x2_Operator: performs a Clifford to implement a base change
    // that maps basis states index1 to 111...10 and index2 to 111...11 (in big endian notation, i.e., LSB in qs[n-1]) 
    operation Embedding_Perm (index1 : Int, index2 : Int, qs : Qubit[]) : Unit is Adj {

        let n = Length(qs); 
        let bits1 = IntAsBoolArray(index1, n);
        let bits2 = IntAsBoolArray(index2, n);
        // find the index of the first bit at which the bit strings are different
        let diff = FirstDiff(bits1, bits2);

        // we care only about 2 inputs: basis state of bits1 and bits2

        // make sure that the state corresponding to bits1 has qs[diff] set to |0⟩
        if (bits1[diff]) { 
            X(qs[diff]); 
        }
        
        // iterate through the bit strings again, setting the final state of qubits
        for (i in 0..n-1) {
            if (bits1[i] == bits2[i]) {
                // if two bits are the same, set both to 1 using X or nothing
                if (not bits1[i]) {
                    X(qs[i]);
                }
            } else {
                // if two bits are different, set both to 1 using CNOT
                if (i > diff) {
                    if (not bits1[i]) {
                        X(qs[diff]);
                        CNOT(qs[diff], qs[i]);
                        X(qs[diff]);
                    }
                    if (not bits2[i]) {
                        CNOT(qs[diff], qs[i]);
                    }
                }
            }
        }

        // move the differing bit to the last qubit
        if (diff < n-1) {
            SWAP(qs[n-1], qs[diff]);
        }
    }
    
    
    // Helper function: apply the 2⨯2 unitary operator at the sub-matrix given by indices for 2 rows/columns
    operation Embed_2x2_Operator (U : (Qubit => Unit is Ctl), index1 : Int, index2 : Int, qs : Qubit[]) : Unit {
        Embedding_Perm(index1, index2, qs);
        Controlled U(Most(qs), Tail(qs));
        Adjoint Embedding_Perm(index1, index2, qs);
    }

    
    // Putting everything together: the target pattern is produced by a sequence of controlled H gates. 
    operation Hessenberg_Matrix_Reference (qs : Qubit[]) : Unit {
        let n = Length(qs);
        for (i in 2^n - 2 .. -1 .. 0) {     
            Embed_2x2_Operator(H, i, i+1, qs);
        }
    }

}
