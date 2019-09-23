// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Teleportation {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // "Teleportation" quantum kata is a series of exercises designed
    // to get you familiar with programming in Q#.
    // It covers the quantum teleportation protocol which allows you
    // to communicate a quantum state using only classical communication
    // and previously shared quantum entanglement.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    //////////////////////////////////////////////////////////////////
    // Part I. Standard Teleportation
    //////////////////////////////////////////////////////////////////
    
    // We split the teleportation protocol into several steps, following the description at
    // https://docs.microsoft.com/quantum/techniques/putting-it-all-together :
    // * Preparation (creating the entangled pair of qubits that are sent to Alice and Bob).
    // * Sending the message (Alice's task): Entangling the message qubit with Alice's qubit
    //   and extracting two classical bits to be sent to Bob.
    // * Reconstructing the message (Bob's task): Using the two classical bits Bob received from Alice
    //   to get Bob's qubit into the state in which the message qubit had been originally.
    // Finally, we compose these steps into the complete teleportation protocol.
    
    // Task 1.1. Entangled pair
    // Input: two qubits qAlice and qBob, each in |0⟩ state.
    // Goal: prepare a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    //
    // In the context of the quantum teleportation protocol, this is the preparation step:
    // qubits qAlice and qBob will be sent to Alice and Bob, respectively.
    operation Entangle (qAlice : Qubit, qBob : Qubit) : Unit {
        // ...
    }
    
    
    // Task 1.2. Send the message (Alice's task)
    // Entangle the message qubit with Alice's qubit
    // and extract two classical bits to be sent to Bob.
    // Inputs:
    //      1) Alice's part of the entangled pair of qubits qAlice.
    //      2) The message qubit qMessage.
    // Output:
    //      Two classical bits Alice will send to Bob via classical channel as a tuple of Bool values.
    //      The first bit in the tuple should hold the result of measurement of the message qubit,
    //      the second bit - the result of measurement of Alice's qubit.
    //      Represent measurement result 'One' as 'true' and 'Zero' as 'false'.
    // The state of the qubits in the end of the operation doesn't matter.
    operation SendMessage (qAlice : Qubit, qMessage : Qubit) : (Bool, Bool) {
        // ...
        return (false, false);
    }
    
    
    // Task 1.3. Reconstruct the message (Bob's task)
    // Transform Bob's qubit into the required state using the two classical bits
    // received from Alice.
    // Inputs:
    //      1) Bob's part of the entangled pair of qubits qBob.
    //      2) The tuple of classical bits received from Alice,
    //         in the format used in task 1.2.
    // Goal: transform Bob's qubit qBob into the state in which the message qubit had been originally.
    operation ReconstructMessage (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        // ...
    }
    
    
    // Task 1.4. Standard teleportation protocol
    // Put together the steps implemented in tasks 1.1 - 1.3 to implement
    // the full teleportation protocol.
    // Inputs:
    //      1) The two qubits qAlice and qBob in |0⟩ state.
    //      2) The message qubit qMessage in the state |ψ⟩ to be teleported.
    // Goal: transform Bob's qubit qBob into the state |ψ⟩.
    // The state of the qubits qAlice and qMessage in the end of the operation doesn't matter.
    operation StandardTeleport (qAlice : Qubit, qBob : Qubit, qMessage : Qubit) : Unit {
        // ...
    }
    
    
    // Task 1.5. Prepare a state and send it as a message (Alice's task)
    // Given a Pauli basis along with a state 'true' as 'One' or 'false'
    // as 'Zero', prepare a message qubit, entangle it with Alice's qubit,
    // and extract two classical bits to be sent to Bob.
    // Inputs:
    //      1) Alice's part of the entangled pair of qubits qAlice.
    //      2) A PauliX, PauliY, or PauliZ basis in which the message
    //         qubit should be prepared
    //      3) A Bool indicating the eigenstate in which the message
    //         qubit should be prepared
    // Output:
    //      Two classical bits Alice will send to Bob via classical channel as a tuple of Bool values.
    //      The first bit in the tuple should hold the result of measurement of the message qubit,
    //      the second bit - the result of measurement of Alice's qubit.
    //      Represent measurement result 'One' as 'true' and 'Zero' as 'false'.
    // The state of the qubit qAlice in the end of the operation doesn't matter.
    operation PrepareAndSendMessage (qAlice : Qubit, basis : Pauli, state : Bool) : (Bool, Bool) {
        // ...
        return (false, false);
    }
    
    
    // Task 1.6. Reconstruct and measure the message state (Bob's task)
    // Transform Bob's qubit into the required state using the two classical bits
    // received from Alice and measure it in the same basis in which she prepared the message.
    // Inputs:
    //      1) Bob's part of the entangled pair of qubits qBob.
    //      2) The tuple of classical bits received from Alice,
    //         in the format used in task 1.5.
    //      3) The PauliX, PauliY, or PauliZ basis in which the
    //         message qubit was originally prepared
    // Output:
    //      A Bool indicating the eigenstate in which the message qubit was prepared, 'One' as
    //      'True' and 'Zero' as 'False'.
    // To get the output, transform Bob's qubit qBob into the state
    // in which the message qubit was originally prepared, then measure it. 
    // The state of the qubit qBob in the end of the operation doesn't matter.
    operation ReconstructAndMeasureMessage (qBob : Qubit, (b1 : Bool, b2 : Bool), basis : Pauli) : Bool {
        
        // ...
        return false;
    }
    
    
    // Task 1.7. Testing standard quantum teleportation
    // Goal: Test that the StandardTeleport operation from task 1.4 is able
    // to successfully teleport the states |0⟩ and |1⟩, as well as superposition states such as
    // (|0⟩ + |1⟩) / sqrt(2),
    // (|0⟩ - |1⟩) / sqrt(2),
    // (|0⟩ + i|1⟩) / sqrt(2), and
    // (|0⟩ - i|1⟩) / sqrt(2)
    operation StandardTeleport_Test () : Unit {
        // Hint: You may find your answers for 1.5 and 1.6 useful

        // StandardTeleport_Test appears in the list of unit tests for the solution; run it to verify your code.

        // ...
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
    // The goal is to transform Bob's qubit qBob into the state in which the message qubit had been originally.
    
    // Task 2.1. Reconstruct the message if the entangled qubits were in the state |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2).
    operation ReconstructMessage_PhiMinus (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        // ...
    }
    
    
    // Task 2.2. Reconstruct the message if the entangled qubits were in the state |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2).
    operation ReconstructMessage_PsiPlus (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        // ...
    }
    
    
    // Task 2.3. Reconstruct the message if the entangled qubits were in the state |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2).
    operation ReconstructMessage_PsiMinus (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        // ...
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
    operation MeasurementFreeTeleport (qAlice : Qubit, qBob : Qubit, qMessage : Qubit) : Unit {
        // ...
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part IV. Teleportation with three entangled qubits
    //////////////////////////////////////////////////////////////////
    
    // Quantum teleportation using entangled states other than Bell pairs is also feasible.
    // Here we look at just one of many possible schemes - in it a state is transferred from
    // Alice to a third participant Charlie, but this may only be accomplished if Charlie
    // has the trust of the second participant Bob.
    
    // Task 4.1*. Entangled trio
    // Input: three qubits qAlice, qBob, and qCharlie, each in |0⟩ state.
    // Goal: create an entangled state |Ψ³⟩ = (|000⟩ + |011⟩ + |101⟩ + |110⟩) / 2 on these qubits.
    //
    // In the context of the quantum teleportation protocol, this is the preparation step:
    // qubits qAlice, qBob, and qCharlie will be sent to Alice, Bob, and Charlie respectively.
    operation EntangleThreeQubits (qAlice : Qubit, qBob : Qubit, qCharlie : Qubit) : Unit {
        // ...
    }
    
    
    // Task 4.2*. Reconstruct the message (Charlie's task)
    // Alice has a message qubit in the state |ψ⟩ to be teleported, she has entangled it with
    // her own qubit from |Ψ³⟩ in the same manner as task 1.2 and extracted two classical bits
    // in order to send them to Charlie. Bob has also measured his own qubit from |Ψ³⟩ and sent
    // Charlie the result.
    //
    // Transform Charlie's qubit into the required state using the two classical bits
    // received from Alice, and the one classical bit received from Bob.
    // Inputs:
    //      1) Charlie's part of the entangled trio of qubits qCharlie.
    //      2) The tuple of classical bits received from Alice,
    //         in the format used in task 1.2.
    //      3) A classical bit resulting from the measurement of Bob's qubit.
    // Goal: transform Charlie's qubit qCharlie into the state in which the message qubit had been originally.
    operation ReconstructMessageWhenThreeEntangledQubits (qCharlie : Qubit, (b1 : Bool, b2 : Bool), b3 : Bool) : Unit {
        // ...
    }
    
}
