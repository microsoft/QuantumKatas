// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SuperdenseCoding {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    
    // Task 1. Entangled pair
    operation CreateEntangledPair_Reference (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        
        // The easiest way to create an entangled pair is to start with
        // applying a Hadamard transformation to one of the qubits:
        H(q1);
            
        // This has left us in state:
        // ((|0⟩ + |1⟩) / sqrt(2)) ⊗ |0⟩
            
        // Now, if we flip the second qubit conditioned on the state
        // of the first one, we get that the states of the two qubits will always match.
        CNOT(q1, q2);
        // So we ended up in the state:
        // (|00⟩ + |11⟩) / sqrt(2)
        //
        // Which is the required Bell pair |Φ⁺⟩
    }
    
    
    // Task 2. Send the message (Alice's task)
    operation EncodeMessageInQubit_Reference (qAlice : Qubit, message : ProtocolMessage) : Unit {
        // We are starting this step with the entangled pair in state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2).
        // By doing operations on one of those qubits,
        // we can encode each of the values as a transformation:
        
        // "00" as I and |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
        // "01" as X and |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
        // "10" as Z and |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
        // "11" as Y and |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
        
        // Also, since Y(q) = iX(Z(q)), we can express this shorter:
        if (message::Bit1) {
            Z(qAlice);
        }
        
        if (message::Bit2) {
            X(qAlice);
        }
    }
    
    
    // Task 3. Decode the message and reset the qubits (Bob's task)
    operation DecodeMessageFromQubits_Reference (qAlice : Qubit, qBob : Qubit) : ProtocolMessage {
        
        // Time to get our state back, by performing transformations as follows.
        // Notice that it's important to keep the order right. The qubits that are
        // subject to the Hadamard transform and the CNOT gate in the preparation
        // of the pair have to match the operations below, or the order of the data
        // bits will get flipped.
        Adjoint CreateEntangledPair_Reference(qAlice, qBob);
        
        // What is the outcome of this transformation, assuming each of the possible
        // quantum states after the encoding step?
        
        // |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) ---> |00⟩
        // |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2) ---> |01⟩
        // |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2) ---> |10⟩
        // |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2) ---> |11⟩
        
        // So we can retrieve the encoded bits just by measuring.
        return ProtocolMessage(MResetZ(qAlice) == One, MResetZ(qBob) == One);
    }
    
    
    // Task 4. Superdense coding protocol end-to-end
    operation SuperdenseCodingProtocol_Reference (message : ProtocolMessage) : ProtocolMessage {
        
        // Get a temporary qubit register for the protocol run.
        using ((q1, q2) = (Qubit(), Qubit())) {
            // STEP 1:
            // Start by creating an entangled pair of qubits.
            CreateEntangledPair_Reference(q1, q2);
            
            // Alice and Bob receive one half of the pair each.
            
            // STEP 2:
            // Alice encodes the pair of bits in the qubit she received.
            EncodeMessageInQubit_Reference(q1, message);
            
            // Alice sends her qubit to Bob.
            
            // STEP 3:
            // Bob receives the qubit from Alice and can now
            // manipulate and measure both qubits to get the encoded data.
            return DecodeMessageFromQubits_Reference(q1, q2);            
        }
    }
    
}
