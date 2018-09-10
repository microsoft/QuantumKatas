// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Teleportation
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // "Teleportation" quantum kata is a series of exercises designed 
    // to get you familiar with programming in Q#.
    // It covers the quantum teleportation protocol which allows you
    // to communicate a quantum state using only classical communication 
    // and previously shared quantum entanglement.
    //
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    //////////////////////////////////////////////////////////////////
    // Part I. Standard Teleportation
    //////////////////////////////////////////////////////////////////

    // We split the teleportation protocol into several steps, following the description at
    // https://docs.microsoft.com/en-us/quantum/quantum-techniques-6-puttingitalltogether :
    // * Preparation (creating the entangled pair of qubits that are sent to Alice and Bob).
    // * Sending the message (Alice's task): Entangling the message qubit with Alice's qubit
    //   and extracting two classical bits to be sent to Bob.
    // * Reconstructing the message (Bob's task): Using the two classical bits Bob received from Alice 
    //   to get Bob's qubit into the state in which the message qubit has been originally.
    // Finally, we compose these steps into the complete teleportation protocol.

    // Task 1.1. Entangled pair
    // Input: two qubits qAlice and qBob, each in |0⟩ state.
    // Goal: create a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    //
    // In the context of quantum teleportation protocol, this is the preparation step:
    // qubits qAlice and qBob will be sent to Alice and Bob, respectively. 
    operation Entangle (qAlice : Qubit, qBob : Qubit) : ()
    {
        body {
            // ...
        }
    }

    // Task 1.2. Send the message (Alice's task)
    // Entangle the message qubit with Alice's qubit
    // and extract two classical bits to be sent to Bob.
    // Inputs: 
    //      1) Alice's part of the entangled pair of qubits qAlice.
    //      2) the message qubit qMessage.
    // Output:
    //      Two classical bits Alice will send to Bob via classical channel as a tuple of Bool values.
    //      The first bit in the tuple should hold the result of measurement of the message qubit,
    //      the second bit - the result of measurement of Alice's qubit.
    //      Represent measurement result 'One' as 'True' and 'Zero' as 'False'.
    // The state of the qubits in the end of the operation doesn't matter.
    operation SendMessage (qAlice : Qubit, qMessage : Qubit) : (Bool, Bool)
    {
        body {
            // ...
            return (false, false);
        }
    }

    // Task 1.3. Reconstruct the message (Bob's task)
    // Transform Bob's qubit into the required state using the two classical bits
    // received from Alice.
    // Inputs:
    //      1) Bob's part of the entangled pair of qubits qBob.
    //      2) the tuple of classical bits received from Alice, 
    //         in the format used in task 1.2.
    // Goal: transform Bob's qubit qBob into the state in which the message qubit has been originally.
    operation ReconstructMessage (qBob : Qubit, (b1 : Bool, b2 : Bool)) : ()
    {
        body {
            // ...
        }
    }

    // Task 1.4. Standard teleportation protocol
    // Put together the steps implemented in tasks 1.1 - 1.3 to implement 
    // the full teleportation protocol.
    // Inputs: 
    //      1) The two qubits qAlice and qBob in |0⟩ state. 
    //      2) The message qubit qMessage in the state |ψ⟩ to be teleported.
    // Goal: transform Bob's qubit qBob into the state |ψ⟩.
    // The state of the qubits qAlice and qBob in the end of the operation doesn't matter.
    operation StandardTeleport (qAlice : Qubit, qBob : Qubit, qMessage : Qubit) : ()
    {
        body {
            // ...
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Teleportation using different entangled pair
    //////////////////////////////////////////////////////////////////

    // In this section we will take a look at the changes in the reconstruction process (Bob's task)
    // if the qubits shared between Alice and Bob are entangled in a different state.
    // Alice's part of the protocol remains the same in all tasks.
    // As a reminder, the standard teleportation protocol requires shared qubits in state 
    // |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2).

    // In each task, the inputs are 
    //      1) Bob's part of the entangled pair of qubits qBob.
    //      2) the tuple of classical bits received from Alice, 
    //         in the format used in task 1.2.
    // The goal is to transform Bob's qubit qBob into the state in which the message qubit has been originally.

    // Task 2.1. Reconstruct the message if the entangled qubits were in the state |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2).
    operation ReconstructMessage_PhiMinus (qBob : Qubit, (b1 : Bool, b2 : Bool)) : ()
    {
        body {
            // ...
        }
    }

    // Task 2.2. Reconstruct the message if the entangled qubits were in the state |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2).
    operation ReconstructMessage_PsiPlus (qBob : Qubit, (b1 : Bool, b2 : Bool)) : ()
    {
        body {
            // ...
        }
    }

    // Task 2.3. Reconstruct the message if the entangled qubits were in the state |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2).
    operation ReconstructMessage_PsiMinus (qBob : Qubit, (b1 : Bool, b2 : Bool)) : ()
    {
        body {
            // ...
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Principle of deferred measurement
    //////////////////////////////////////////////////////////////////

    // The principle of deferred measurement claims that measurements can be moved
    // from an intermediate stage of a quantum circuit to the end of the circuit.
    // If the measurement results are used to perform classically controlled operations,
    // they can be replaced by controlled quantum operations.

    // In this task we will apply this principle to the teleportation circuit.
    
    // Task 3.1. Measurement-free teleportation.
    // Inputs: 
    //      1) The two qubits qAlice and qBob in |Φ⁺⟩ state. 
    //      2) The message qubit qMessage in the state |ψ⟩ to be teleported.
    // Goal: transform Bob's qubit qBob into the state |ψ⟩ using no measurements.
    // At the end of the operation qubits qAlice and qMessage should not be entangled with qBob.
    operation MeasurementFreeTeleport (qAlice : Qubit, qBob : Qubit, qMessage : Qubit) : ()
    {
        body {
            // ...
        }
    }
}
