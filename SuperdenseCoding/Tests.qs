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
        
    operation T1_CreateEntangledPair_Test () : Unit {
        using ((q1, q2) = (Qubit(), Qubit())) {

            // apply operation that needs to be tested
            CreateEntangledPair(q1, q2);

            // apply adjoint reference operation and check that the result is |0^N⟩
            Adjoint CreateEntangledPair_Reference(q1, q2);

            // assert that all qubits end up in |0⟩ state
            AssertAllZero([q1, q2]);
        }
    }
    
    
    // ------------------------------------------------------
    // Helper operation that runs superdense coding protocol using two building blocks
    // specified as first two parameters.
    operation ComposeProtocol (
		encodeOp : ((Qubit, ProtocolMessage) => Unit), 
		decodeOp : ((Qubit, Qubit) => ProtocolMessage), 
		message : ProtocolMessage
	) : ProtocolMessage {
        
        using (qs = Qubit[2]) {
            CreateEntangledPair_Reference(qs[0], qs[1]);
            encodeOp(qs[0], message);
            return decodeOp(qs[0], qs[1]);            
        }
    }
    
    
    // ------------------------------------------------------
    // Helper operation that runs superdense coding protocol (specified by protocolOp)
    // on all possible input values and verifies that decoding result matches the inputs
    operation TestProtocol (protocolOp : (ProtocolMessage => ProtocolMessage)) : Unit {
        
        // Loop over the 4 possible combinations of two bits
        for (n in 0 .. 3) {
            let data = ProtocolMessage(1 == n / 2, 1 == n % 2);
            
            for (iter in 1 .. 100) {
                let result = protocolOp(data);
                
                // Now test if the bits were transfered correctly.
                Fact(result::Bit1 == data::Bit1 and result::Bit2 == data::Bit2, 
                    $"{data} was transfered incorrectly as {result}");
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
