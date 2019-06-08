// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SuperdenseCoding {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    
    
    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => Unit), refImpl : (Qubit[] => Unit is Adj)) : Unit {
        using (qs = Qubit[N]) {
            // apply operation that needs to be tested
            taskImpl(qs);
            
            // apply adjoint reference operation and check that the result is |0^N⟩
            Adjoint refImpl(qs);
            
            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }
    
    
    operation T1_CreateEntangledPair_Test () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, CreateEntangledPair, CreateEntangledPair_Reference);
    }
    
    
    // ------------------------------------------------------
    // Helper operation that runs superdense coding protocol using two building blocks
    // specified as first two parameters.
    operation ComposeProtocol (encodeOp : ((Qubit, Bool[]) => Unit), decodeOp : ((Qubit, Qubit) => Bool[]), message : Bool[]) : Bool[] {
        
        using (qs = Qubit[2]) {
            CreateEntangledPair_Reference(qs);
            encodeOp(qs[0], message);
            let result = decodeOp(qs[1], qs[0]);
            
            // Make sure that we return qubits back in 0 state.
            ResetAll(qs);
            return result;
        }
    }
    
    
    // ------------------------------------------------------
    // Helper operation that runs superdense coding protocol (specified by protocolOp)
    // on all possible input values and verifies that decoding result matches the inputs
    operation TestProtocol (protocolOp : (Bool[] => Bool[])) : Unit {
        
        // Loop over the 4 possible combinations of two bits
        for (n in 0 .. 3) {
            let data = [1 == n / 2, 1 == n % 2];
            
            for (iter in 1 .. 100) {
                let result = protocolOp(data);
                
                // Now test if the bits were transfered correctly.
                AllEqualityFactB(result, data, $"The message {data} was transfered incorrectly as {result}");
            }
        }
    }
    
    
    operation T2_EncodeMessageInQubit_Test () : Unit {
        TestProtocol(ComposeProtocol(EncodeMessageInQubit, DecodeMessageFromQubits_Reference, _));
    }
    
    
    operation T3_DecodeMessageFromQubits_Test () : Unit {
        TestProtocol(ComposeProtocol(EncodeMessageInQubit_Reference, DecodeMessageFromQubits, _));
    }
    
    
    operation T4_SuperdenseCodingProtocol_Test () : Unit {
        TestProtocol(SuperdenseCodingProtocol);
    }
    
}
