// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks. 
// The tasks themselves can be found in Tasks.qs file.
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Teleportation
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    
    //////////////////////////////////////////////////////////////////
    // Part I. Standard teleportation
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Entangled pair
    operation Entangle_Reference (qAlice : Qubit, qBob : Qubit) : ()
    {   
        body {
            H(qAlice);
            CNOT(qAlice, qBob);
        }
        adjoint auto;
    }

    // Task 1.2. Send the message (Alice's task)
    operation SendMessage_Reference (qAlice : Qubit, qMessage : Qubit) : (Bool, Bool)
    {
        body {
            CNOT(qMessage, qAlice);
            H(qMessage);
            return (M(qMessage) == One, M(qAlice) == One);
        }
    }

    // Task 1.3. Reconstruct the message (Bob's task)
    operation ReconstructMessage_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool)) : ()
    {
        body {
            if (b1) { Z(qBob); }
            if (b2) { X(qBob); }
        }
    }

    // Task 1.4. Standard teleportation protocol
    operation StandardTeleport_Reference (qAlice : Qubit, qBob : Qubit, qMessage : Qubit):()
    {
        body{
            Entangle_Reference(qAlice, qBob);
            let classicalBits = SendMessage_Reference(qAlice, qMessage);

            // Alice sends the classical bits to Bob.
            // Bob uses these bits to transform his part of the entangled pair into |ψ⟩.
            ReconstructMessage_Reference(qBob, classicalBits);
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Teleportation using different entangled pair
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Reconstruct the message if the entangled qubits were in the state |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2).
    operation ReconstructMessage_PhiMinus_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool)) : ()
    {
        body {
            // Bob can apply a Z gate to his qubit to convert the pair to |Φ⁺⟩ 
            // and use the standard teleportation reconstruction process.
            if (!b1) { Z(qBob); }
            if (b2) { X(qBob); }
        }
    }

    // Task 2.2. Reconstruct the message if the entangled qubits were in the state |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2).
    operation ReconstructMessage_PsiPlus_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool)) : ()
    {
        body {
            // Bob can apply an X gate to his qubit to convert the pair to |Φ⁺⟩ 
            // and use the standard teleportation reconstruction process.
            if (b1) { Z(qBob); }
            if (!b2) { X(qBob); }
        }
    }

    // Task 2.3. Reconstruct the message if the entangled qubits were in the state |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2).
    operation ReconstructMessage_PsiMinus_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool)) : ()
    {
        body {
            // Bob can apply a Z gate and an X gate to his qubit to convert the pair to |Φ⁺⟩ 
            // and use the standard teleportation reconstruction process.
            if (!b1) { Z(qBob); }
            if (!b2) { X(qBob); }
        }
    }

    // Task 3.1. Measurement-free teleportation.
    operation MeasurementFreeTeleport_Reference (qAlice : Qubit, qBob : Qubit, qMessage : Qubit) : ()
    {
        body {
            // The first part of the circuit is similar to Alice's part, but without measurements.
            CNOT(qMessage, qAlice);
            H(qMessage);

            // Classically controlled gates applied by Bob are replaced by controlled gates
            (Controlled Z)([qMessage], qBob);
            (Controlled X)([qAlice], qBob);
        }
    }
}
