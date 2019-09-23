// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.QEC_BitFlipCode {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    // Task 1. Parity Measurements
    operation MeasureParity_Reference (register : Qubit[]) : Result {
        return Measure([PauliZ, PauliZ, PauliZ], register);
    }
    
    
    // Task 2. Encoding Codewords
    operation Encode_Reference (register : Qubit[]) : Unit
    is Adj {        
        ApplyToEachA(CNOT(Head(register), _), Rest(register));
    }
    
    
    // Task 3. Error Detection I
    operation DetectErrorOnLeftQubit_Reference (register : Qubit[]) : Result {
        return Measure([PauliZ, PauliZ], register[0 .. 1]);
    }
    
    
    // Task 4. Error Correction I
    operation CorrectErrorOnLeftQubit_Reference (register : Qubit[]) : Unit {
        if (Measure([PauliZ, PauliZ], register[0 .. 1]) == One) {
            X(register[0]);
        }
    }
    
    
    // Task 5. Error Detection II
    operation DetectErrorOnAnyQubit_Reference (register : Qubit[]) : Int {
        
        let m1 = Measure([PauliZ, PauliZ], register[0 .. 1]);
        let m2 = Measure([PauliZ, PauliZ], register[1 .. 2]);
        
        if (m1 == One and m2 == Zero) {
            return 1;
        }
        
        if (m1 == One and m2 == One) {
            return 2;
        }
        
        if (m1 == Zero and m2 == One) {
            return 3;
        }
        
        return 0;
    }
    
    
    // Task 6. Error Correction II
    operation CorrectErrorOnAnyQubit_Reference (register : Qubit[]) : Unit {
        let idx = DetectErrorOnAnyQubit_Reference(register);
        if (idx > 0) {
            X(register[idx - 1]);
        }
    }
    
    
    // Task 7. Logical X Gate
    operation LogicalX_Reference (register : Qubit[]) : Unit {
        ApplyToEach(X, register);
    }
    
    
    // Task 8. Logical Z Gate
    operation LogicalZ_Reference (register : Qubit[]) : Unit {
        ApplyToEach(Z, register);
    }
    
}
