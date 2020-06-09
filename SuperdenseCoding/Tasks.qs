// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.SuperdenseCoding {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    /// # Summary
    /// Data type that represents the message that is transmitted 
    /// as part of the superdense coding protocol. 
    /// It includes two classical bits (Bit1 and Bit2) of type Bool.   
    newtype ProtocolMessage = (Bit1 : Bool, Bit2 : Bool);    


    ///////////////////////////////////////////////////////////////////////
    //                                                                   //
    //  Superdense Coding Kata : Share 2 bits for the price of 1 qubit!  //
    //                                                                   //
    ///////////////////////////////////////////////////////////////////////
    
    // "Superdense Coding" quantum kata is a series of exercises designed
    // to get you familiar with programming in Q#.
    // It covers the superdense coding protocol which allows to transmit
    // two bits of classical information by sending just one qubit
    // using previously shared quantum entanglement.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // Each task defines an operation that can be used in subsequent tasks to simplify implementations
    // and build on existing code.
    
    // We split the superdense coding protocol into several steps, following the description at
    // https://en.wikipedia.org/wiki/Superdense_coding :
    // * Preparation (creating the entangled pair of qubits that are sent to Alice and Bob).
    // * Encoding the message (Alice's task): Encoding the classical bits of the message
    //   into the state of Alice's qubit which then is sent to Bob.
    // * Decoding the message (Bob's task): Using Bob's original qubit and the qubit he
    //   received from Alice to decode the classical message sent.
    // Finally, we compose those steps into the complete superdense coding protocol.
    
    // Task 1. Entangled pair
    // Input: Two qubits, each in the |0⟩ state.
    // Goal:  Create a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    operation CreateEntangledPair (q1 : Qubit, q2 : Qubit) : Unit is Adj {

        // ...
    }
    
    
    // Task 2. Send the message (Alice's task)
    // Encode the message (two classical bits) in the state of Alice's qubit.
    // Inputs:
    //      1) Alice's part of the entangled pair of qubits qAlice.
    //      2) Two classical bits, stored as ProtocolMessage.
    //         ProtocolMessage is a custom type introduced in the beginning of this file.
    // Goal: Transform the input qubit to encode the two classical bits.
    operation EncodeMessageInQubit (qAlice : Qubit, message : ProtocolMessage) : Unit {
        // Hint: manipulate Alice's half of the entangled pair
        // to change the joint state of the two qubits to one of the following four states
        // based on the value of message:
        // [0; 0]:    |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
        // [0; 1]:    |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
        // [1; 0]:    |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
        // [1; 1]:    |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)

        if (message::Bit1) { // accesses the item 'Bit1' of 'message'
            // ...
        }
        // ...
    }
    
    
    // Task 3. Decode the message and reset the qubits (Bob's task)
    // Decode the message using the qubit received from Alice and reset both qubits to a |00⟩ state.
    // Inputs:
    //      1) The qubit received from Alice qAlice.
    //      2) Bob's part of the entangled pair qBob.
    // Goal:  Retrieve two bits of classic data from the qubits and return them as ProtocolMessage.
    // The state of the qubits in the end of the operation should be |00⟩.
    // You can create an instance of ProtocolMessage as ProtocolMessage(bit1value, bit2value).
    operation DecodeMessageFromQubits (qAlice : Qubit, qBob : Qubit) : ProtocolMessage {

        fail ("Task 3 not implemented");
    }
    
    
    // Task 4. Superdense coding protocol end-to-end
    // Put together the steps performed in tasks 1-3 to implement the full superdense coding protocol.
    // Input: Two classical bits to be transmitted.
    // Goal:  Prepare an EPR Pair, encode the two classical bits in the
    // state of the pair by applying quantum gates to one member of the pair,
    // and decode the two classical bits from the state of the pair.
    // Return the result of decoding. 
    operation SuperdenseCodingProtocol (message : ProtocolMessage) : ProtocolMessage {
                
        fail ("Task 4 not implemented");
    }
    
}
