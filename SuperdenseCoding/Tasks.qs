// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.SuperdenseCoding
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

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
    //
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
    // Input: An array of two qubits in the |00⟩ state.
    // Goal:  Create a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    operation CreateEntangledPair (qs : Qubit[]) : ()
    {
        body
        {
            // The following lines enforce the constraints on the input that you are given.
            // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
            AssertIntEqual(Length(qs), 2, "The array should have exactly 2 qubits.");

            // ...
        }
    }

    // Task 2. Send the message (Alice's task)
    // Encode the message (classical bits) in the state of Alice's qubit.
    // Inputs:
    //      1) Alice's part of the entangled pair of qubits qAlice.
    //      2) two classical bits, stored in an array.
    // Goal: Transform the input qubit to encode the two classical bits.
    operation EncodeMessageInQubit (qAlice : Qubit, message : Bool[]) : ()
    {
        body
        {
            // Hint: manipulate Alice's half of the entangled pair
            // to change the joint state of the two qubits to one of the following four states
            // based on the value of message:
            // [0; 0]:    |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
            // [0; 1]:    |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
            // [1; 0]:    |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
            // [1; 1]:    |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)

            // ...
        }
    }

    // Task 3. Decode the message (Bob's task)
    // Decode the message using the qubit received from Alice.
    // Inputs:
    //      1) Bob's part of the entangled pair qBob.
    //      2) qubit received from Alice qAlice.
    // Goal:  Retrieve two bits of classic data from the qubits.
    // The state of the qubits in the end of the operation doesn't matter.
    operation DecodeMessageFromQubits (qBob : Qubit, qAlice : Qubit) : Bool[]
    {
        body
        {
            // Declare a Bool array in which the result will be stored;
            // the array has to be mutable to allow updating its elements.
            mutable decoded_bits = new Bool[2];

            // ...

            return decoded_bits;
        }
    }

    // Task 4. Superdense coding protocol end-to-end
    // Put together the steps performed in tasks 1-3 to implement the full superdense coding protocol.
    // Input: Two classical bits
    // Goal:  Prepare an EPR Pair, encode the two classical bits in the
    // state of the pair by applying quantum gates to one member of the pair,
    // and decode the two classical gates from the state of the pair
    operation SuperdenseCodingProtocol (message : Bool[]) : Bool[]
    {
        body
        {
            mutable decoded_bits = new Bool[2];

            // ...

            return decoded_bits;
        }
    }
}
