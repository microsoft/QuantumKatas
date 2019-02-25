// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.UnitaryPatterns {
    
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // The "Unitary Patterns" quantum kata is a series of exercises designed
    // to get you comfortable with creating unitary transformations which can be represented
    // with matrices of certain shapes (with certain pattern of zero and non-zero values).
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task has a unit test associated with it, which initially fails.
    // Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // The tasks are given in approximate order of increasing difficulty;
    // harder ones are marked with asterisks.
    
    // Each task describes a matrix which your unitary needs to implement.
    // The row and column indices of the matrix elements are in little-endian format (the least significant bit is stored first).
    // For example, index 1 corresponds to the qubit state |10..0⟩, and to store this state in an array of qubits qs 
    // its first element qs[0] would have to be in state |1⟩ and the rest of the qubits would have to be in state |0⟩.

    // In the example patterns provided in the tasks, X marks a "non-zero" element, and . marks a "zero" element.
    // "Zero" element of a matrix is a complex number which has an absolute value of 0.001 or less,
    // and "non-zero" element is a complex number which has an absolute value of 0.001 or greater.
    // You can see the details of the verification in Tests.qs file, operation AssertOperationMatrixMatchesPattern.

    // Note that all tasks require you to implement a unitary transformation,
    // which means that you're not allowed to use any measurements.
    


    // Task 1. Main diagonal
    // Input: N qubits in an arbitrary state.
    // Goal: Implement a unitary transformation on N qubits which is represented by a matrix
    //       with non-zero elements on the main diagonal and zero elements everywhere else.
    // Example: For N = 2, the matrix of the transformation should look as follows:
    //          X...
    //          .X..
    //          ..X.
    //          ...X
    operation MainDiagonal (qs : Qubit[]) : Unit {
        // The simplest example of such a unitary transformation is represented by an identity matrix. 
        // This means that the operation doesn't need to do anything with the input qubits.
        // Build the project and run the tests to see that T01_MainDiagonal_Test test passes.

        // You are welcome to try and come up with other diagonal unitaries.
        // ...
    }
    
    
    // Task 2. All-non-zero matrix
    // Input: N qubits in an arbitrary state.
    // Goal: Implement a unitary transformation on N qubits which is represented by a matrix
    //       with all elements non-zero.
    // Example: For N = 2, the matrix of the transformation should look as follows:
    //          XXXX
    //          XXXX
    //          XXXX
    //          XXXX
    operation AllNonZero (qs : Qubit[]) : Unit {
        // ...
    }
    
    
    // Task 3. Quarters
    // Input: N qubits in an arbitrary state.
    // Goal: Implement a unitary transformation on N qubits which is represented by a matrix
    //       with non-zero elements in top left and bottom right quarters
    //       and zero elements everywhere else.
    // Example: For N = 2, the matrix of the transformation should look as follows:
    //          XX..
    //          XX..
    //          ..XX
    //          ..XX
    operation Quarters (qs : Qubit[]) : Unit {
        // Hint: represent this matrix as a tensor product of a 2x2 diagonal matrix and a larger matrix with all non-zero elements.

        // ...
    }
    
    
    // Task 4. Even chessboard pattern
    // Input: N qubits in an arbitrary state.
    // Goal: Implement a unitary transformation on N qubits which is represented by a matrix
    //       with non-zero elements in positions where row and column indices have the same parity
    //       and zero elements everywhere else.
    // Example: For N = 2, the matrix of the transformation should look as follows:
    //          X.X.
    //          .X.X
    //          X.X.
    //          .X.X
    operation EvenChessPattern (qs : Qubit[]) : Unit {
        // ...
    }
    
    
    // Task 5. Odd chessboard pattern
    // Input: N qubits in an arbitrary state.
    // Goal: Implement a unitary transformation on N qubits which is represented by a matrix
    //       with non-zero elements in positions where row and column indices have different parity
    //       and zero elements everywhere else.
    // Example: For N = 2, the matrix of the transformation should look as follows:
    //          .X.X
    //          X.X.
    //          .X.X
    //          X.X.
    operation OddChessPattern (qs : Qubit[]) : Unit {
        // ...
    }
    
    
    // Task 6. Anti-diagonal
    // Input: N qubits in an arbitrary state.
    // Goal: Implement a unitary transformation on N qubits which is represented by a matrix
    //       with non-zero elements on the anti-diagonal and zero elements everywhere else.
    // Example: For N = 2, the matrix of the transformation should look as follows:
    //          ...X
    //          ..X.
    //          .X..
    //          X...
    operation Antidiagonal (qs : Qubit[]) : Unit {
        // ...
    }


    // Task 7. 2x2 chessboard pattern
    // Input: N qubits in an arbitrary state.
    // Goal: Implement a unitary transformation on N qubits which is represented by a matrix
    //       in which zero and non-zero elements form a chessboard pattern with 2x2 squares,
    //       with the top left square occupied by non-zero elements.
    // Example: For N = 3, the matrix of the transformation should look as follows:
    // XX..XX..
    // XX..XX..
    // ..XX..XX
    // ..XX..XX
    // XX..XX..
    // XX..XX..
    // ..XX..XX
    // ..XX..XX
    operation ChessPattern2x2 (qs : Qubit[]) : Unit {
        // ...
    }
    

    // Task 8. Two patterns
    // Input: N qubits in an arbitrary state.
    // Goal: Implement a unitary transformation on N qubits which is represented by a matrix
    //       with all zero elements in the top right and bottom left quarters, 
    //       an anti-diagonal pattern from task 1.6 in the top left quarter,
    //       and an all-non-zero pattern from task 1.2 in the bottom right quarter.
    // Example: For N = 2, the matrix of the transformation should look as follows:
    //          .X..
    //          X...
    //          ..XX
    //          ..XX
    operation TwoPatterns (qs : Qubit[]) : Unit {
        // ...
    }
}
