// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Teleportation {
    
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Intrinsic;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Standard teleportation
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. Entangled pair
    operation Entangle_Reference (qAlice : Qubit, qBob : Qubit) : Unit is Adj {        
        H(qAlice);
        CNOT(qAlice, qBob);
    }
    
    
    // Task 1.2. Send the message (Alice's task)
    operation SendMessage_Reference (qAlice : Qubit, qMessage : Qubit) : (Bool, Bool) {
        CNOT(qMessage, qAlice);
        H(qMessage);
        return (M(qMessage) == One, M(qAlice) == One);
    }
    
    
    // Task 1.3. Reconstruct the message (Bob's task)
    operation ReconstructMessage_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        if (b1) {
            Z(qBob);
        }
        if (b2) {
            X(qBob);
        }
    }
    
    
    // Task 1.4. Standard teleportation protocol
    operation StandardTeleport_Reference (qAlice : Qubit, qBob : Qubit, qMessage : Qubit) : Unit {
        Entangle_Reference(qAlice, qBob);
        let classicalBits = SendMessage_Reference(qAlice, qMessage);
        
        // Alice sends the classical bits to Bob.
        // Bob uses these bits to transform his part of the entangled pair into |ψ⟩.
        ReconstructMessage_Reference(qBob, classicalBits);
    }
    
    
    // Task 1.5. Prepare the message specified and send it (Alice's task)
    operation PrepareAndSendMessage_Reference (qAlice : Qubit, basis : Pauli, state : Bool) : (Bool, Bool) {
        use message = Qubit();
        if (state) {
            X(message);
        }
            
        PreparePauliEigenstate(basis, message);
        let classicalBits = SendMessage_Reference(qAlice, message);
        Reset(message);
        return classicalBits;
    }
    
    
    // Task 1.6. Reconstruct the message and measure it (Bob's task)
    operation ReconstructAndMeasureMessage_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool), basis : Pauli) : Bool {
        ReconstructMessage_Reference(qBob, (b1, b2));
        return Measure([basis], [qBob]) == One;
    }
    

    // Task 1.8. Entanglement swapping
    operation EntanglementSwapping_Reference () : ((Qubit, Qubit) => Int, (Qubit, Int) => Unit) {
        return (TeleportEntanglement_Reference, AdjustTeleportedState_Reference);
    }

    // Helper operations that wrap tasks 1.2 and 1.3 to the format required in task 1.8.
    // The integer message is an integer representation of the tuple used in 1.2 and 1.3.
    internal operation TeleportEntanglement_Reference (qAlice1 : Qubit, qBob1 : Qubit) : Int {
        let (c1, c2) = SendMessage_Reference(qAlice1, qBob1);
        return BoolArrayAsInt([c1, c2]);
    } 

    internal operation AdjustTeleportedState_Reference (qBob2 : Qubit, resultCharlie : Int) : Unit {
        let classicalBits = IntAsBoolArray(resultCharlie, 2);
        ReconstructMessage_Reference(qBob2, (classicalBits[0], classicalBits[1]));
    }
    

    //////////////////////////////////////////////////////////////////
    // Part II. Teleportation using different entangled pair
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1. Reconstruct the message if the entangled qubits were in the state |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2).
    operation ReconstructMessage_PhiMinus_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        // Bob can apply a Z gate to his qubit to convert the pair to |Φ⁺⟩
        // and use the standard teleportation reconstruction process.
        if (not b1) {
            Z(qBob);
        }
        
        if (b2) {
            X(qBob);
        }
    }
    
    
    // Task 2.2. Reconstruct the message if the entangled qubits were in the state |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2).
    operation ReconstructMessage_PsiPlus_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        // Bob can apply an X gate to his qubit to convert the pair to |Φ⁺⟩
        // and use the standard teleportation reconstruction process.
        if (b1) {
            Z(qBob);
        }
        
        if (not b2) {
            X(qBob);
        }
    }
    
    
    // Task 2.3. Reconstruct the message if the entangled qubits were in the state |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2).
    operation ReconstructMessage_PsiMinus_Reference (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        // Bob can apply a Z gate and an X gate to his qubit to convert the pair to |Φ⁺⟩
        // and use the standard teleportation reconstruction process.
        if (not b1) {
            Z(qBob);
        }
        
        if (not b2) {
            X(qBob);
        }
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part III. Principle of deferred measurement
    //////////////////////////////////////////////////////////////////
    
    // Task 3.1. Measurement-free teleportation.
    operation MeasurementFreeTeleport_Reference (qAlice : Qubit, qBob : Qubit, qMessage : Qubit) : Unit {
        // The first part of the circuit is similar to Alice's part, but without measurements.
        CNOT(qMessage, qAlice);
        H(qMessage);
        
        // Classically controlled gates applied by Bob are replaced by controlled gates
        Controlled Z([qMessage], qBob);
        Controlled X([qAlice], qBob);
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part IV. Teleportation with three entangled qubits
    //////////////////////////////////////////////////////////////////
    
    // Task 4.1. Entangled trio
    operation EntangleThreeQubits_Reference (qAlice : Qubit, qBob : Qubit, qCharlie : Qubit) : Unit is Adj {
        // Starting with |000⟩
        
        H(qBob);

        // now state is: 1/sqrt(2) (|000⟩ + |010⟩)

        CNOT(qBob, qCharlie);

        // state: 1/sqrt(2) (|000⟩ + |011⟩)

        H(qAlice);

        // state: 1/2 (|000⟩ + |011⟩ + |100⟩ + |111⟩)

        CNOT(qAlice, qCharlie);

        // final state:  1/2 (|000⟩ + |011⟩ + |101⟩ + |110⟩)
    }
    
    
    // Task 4.2. Reconstruct the message (Charlie's task)
    operation ReconstructMessageWhenThreeEntangledQubits_Reference (qCharlie : Qubit, (b1 : Bool, b2 : Bool), b3 : Bool) : Unit {
        if (b1) {
            Z(qCharlie);
        }
        
        if (b2) {
            X(qCharlie);
        }
        
        if (b3) {
            X(qCharlie);
        }
    }
}
