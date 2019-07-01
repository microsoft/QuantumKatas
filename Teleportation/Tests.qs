// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Teleportation {
    
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    
    
    // ------------------------------------------------------
    operation T11_Entangle_Test () : Unit {
        using ((q0, q1) = (Qubit(), Qubit())) {
            // Apply operation that needs to be tested
            Entangle(q0, q1);
            
            // Apply adjoint reference operation and check that the result is |00⟩
            Adjoint Entangle_Reference(q0, q1);
            
            // Assert that all qubits end up in |0⟩ state
            AssertAllZero([q0, q1]);
        }
    }
    
    
    // ------------------------------------------------------
    // Helper which prepares proper Bell state on two qubits
    // 0 - |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
    // 1 - |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
    // 2 - |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
    // 3 - |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
    operation StatePrep_BellState (q1 : Qubit, q2 : Qubit, state : Int) : Unit {
        H(q1);
        CNOT(q1, q2);
        
        // now we have |00⟩ + |11⟩ - modify it based on state arg
        if (state % 2 == 1) {
            // negative phase
            Z(q2);
        }
        
        if (state / 2 == 1) {
            X(q2);
        }
    }
    
    
    // ------------------------------------------------------
    // Helper operation that runs teleportation using two building blocks
    // specified as first two parameters.
    operation ComposeTeleportation (
        bellPrepOp : ((Qubit, Qubit) => Unit), 
        getDescriptionOp : ((Qubit, Qubit) => (Bool, Bool)), 
        reconstructOp : ((Qubit, (Bool, Bool)) => Unit), 
        qAlice : Qubit, 
        qBob : Qubit, 
        qMessage : Qubit) : Unit {
        
        bellPrepOp(qAlice, qBob);
        let classicalBits = getDescriptionOp(qAlice, qMessage);
        
        // Alice sends the classical bits to Bob.
        // Bob uses these bits to transform his part of the entangled pair into the message.
        reconstructOp(qBob, classicalBits);
    }
    
    
    // ------------------------------------------------------
    // Helper operation that runs a teleportation operation (specified by teleportOp).
    // The state to teleport is set up using an operation (specified by setupPsiOp).
    //
    // Specifying the state to teleport through an operation allows to get the inverse
    // which makes testing easier.
    operation TeleportTestHelper (
        teleportOp : ((Qubit, Qubit, Qubit) => Unit), 
        setupPsiOp : (Qubit => Unit is Adj)) : Unit {
        
        using (qs = Qubit[3]) {
            let qMessage = qs[0];
            let qAlice = qs[1];
            let qBob = qs[2];
            setupPsiOp(qMessage);
            
            // This should modify qBob to be identical to the state
            // of qMessage before the function call.
            teleportOp(qAlice, qBob, qMessage);
            
            // Applying the inverse of the setup operation to qBob
            // should make it Zero.
            Adjoint setupPsiOp(qBob);
            AssertQubit(Zero, qBob);
            ResetAll(qs);
        }
    }
    
    
    // ------------------------------------------------------
    // Run teleportation for a number of different states.
    // After each teleportation success is asserted.
    // Also repeats for each state several times as
    // code is expected to take different paths each time because
    // measurements done by Alice are not deterministic.
    operation TeleportTestLoop (teleportOp : ((Qubit, Qubit, Qubit) => Unit)) : Unit {
        // Define setup operations for the message qubit
        // on which to test teleportation: |0⟩, |1⟩, |0⟩ + |1⟩, unequal superposition.
        let setupPsiOps = [I, X, H, Ry(42.0, _)];
        
        // As part of teleportation Alice runs some measurements
        // with nondeterministic outcome.
        // Depending on the outcomes different paths are taken on Bob's side.
        // We repeat each test run several times to ensure that all paths are checked.
        let numRepetitions = 100;
        for (i in 0 .. Length(setupPsiOps) - 1) {
            for (j in 1 .. numRepetitions) {
                TeleportTestHelper(teleportOp, setupPsiOps[i]);
            }
        }
    }
    
    
    // Test the 'SendMessage' operation by using it as one part of full teleportation,
    // taking reference implementation for the other parts.
    operation T12_SendMessage_Test () : Unit {
        let teleport = ComposeTeleportation(StatePrep_BellState(_, _, 0), SendMessage, ReconstructMessage_Reference, _, _, _);
        TeleportTestLoop(teleport);
    }
    
    
    // Test the 'ReconstructMessage' operation by using it as one part of full teleportation,
    // taking reference implementation for the other parts.
    operation T13_ReconstructMessage_Test () : Unit {
        let teleport = ComposeTeleportation(StatePrep_BellState(_, _, 0), SendMessage_Reference, ReconstructMessage, _, _, _);
        TeleportTestLoop(teleport);
    }
    
    
    // Test the full Teleport operation
    operation T14_StandardTeleport_Test () : Unit {
        TeleportTestLoop(StandardTeleport);
    }
    
    
    // ------------------------------------------------------
    // Runs teleportation for each state that is to be prepared and
    // sent by Alice. Success is asserted after each teleportation.
    // Also repeats for each state several times; this is because
    // code is expected to take different paths each time since
    // measurements done by Alice are not deterministic.
    operation TeleportPreparedStateTestLoop (prepareAndSendMessageOp : ((Qubit, Pauli, Bool) => (Bool, Bool)), reconstructAndMeasureMessageOp : ((Qubit, (Bool, Bool), Pauli) => Bool)) : Unit {
        
        let messages = [(PauliX, false), 
                        (PauliX, true), 
                        (PauliY, false), 
                        (PauliY, true), 
                        (PauliZ, false), 
                        (PauliZ, true)];
        let numRepetitions = 100;
        
        using ((qAlice, qBob) = (Qubit(), Qubit())) {
            for (i in 0 .. Length(messages) - 1) {
                for (j in 1 .. numRepetitions) {
                    let (basis, sentState) = messages[i];
                    StatePrep_BellState(qAlice, qBob, 0);
                    let classicalBits = prepareAndSendMessageOp(qAlice, basis, sentState);
                    let receivedState = reconstructAndMeasureMessageOp(qBob, classicalBits, basis);
                    EqualityFactB(receivedState, sentState, $"Sent and received states were not equal for {sentState} eigenstate in {basis} basis.");
                    ResetAll([qAlice, qBob]);
                }
            }
        }
    }
    
    
    // Test the 'PrepareAndSendMessage' operation by using it as one part of full teleportation,
    // taking reference implementation for the other parts.
    operation T15_PrepareAndSendMessage_Test () : Unit {
        TeleportPreparedStateTestLoop(PrepareAndSendMessage, ReconstructAndMeasureMessage_Reference);
    }
    
    
    // Test the 'ReconstructAndMeasureMessage' operation by using it as one part of full teleportation,
    // taking reference implementation for the other parts.
    operation T16_ReconstructAndMeasureMessage_Test () : Unit {
        TeleportPreparedStateTestLoop(PrepareAndSendMessage_Reference, ReconstructAndMeasureMessage);
    }
    
    
    // ------------------------------------------------------
    // Test variations of the teleport protocol using different state prep procedures
    operation T21_ReconstructMessage_PhiMinus_Test () : Unit {
        let teleport = ComposeTeleportation(StatePrep_BellState(_, _, 1), SendMessage_Reference, ReconstructMessage_PhiMinus, _, _, _);
        TeleportTestLoop(teleport);
    }
    
    
    operation T22_ReconstructMessage_PsiPlus_Test () : Unit {
        let teleport = ComposeTeleportation(StatePrep_BellState(_, _, 2), SendMessage_Reference, ReconstructMessage_PsiPlus, _, _, _);
        TeleportTestLoop(teleport);
    }
    
    
    operation T23_ReconstructMessage_PsiMinus_Test () : Unit {
        let teleport = ComposeTeleportation(StatePrep_BellState(_, _, 3), SendMessage_Reference, ReconstructMessage_PsiMinus, _, _, _);
        TeleportTestLoop(teleport);
    }
    
    
    // ------------------------------------------------------
    operation T31_MeasurementFreeTeleport_Test () : Unit {
        let setupPsiOps = [I, X, H, Ry(42.0, _)];
        let numRepetitions = 100;
        
        using (qs = Qubit[3]) {
            let qMessage = qs[0];
            let qAlice = qs[1];
            let qBob = qs[2];
            
            for (i in 0 .. Length(setupPsiOps) - 1) {
                for (j in 1 .. numRepetitions) {
                    setupPsiOps[i](qMessage);
                    StatePrep_BellState(qAlice, qBob, 0);
                    MeasurementFreeTeleport(qAlice, qBob, qMessage);
                    Adjoint setupPsiOps[i](qBob);
                    AssertQubit(Zero, qBob);
                    ResetAll(qs);
                }
            }
        }
    }
    
    
    // ------------------------------------------------------
    operation T41_EntangleThreeQubits_Test () : Unit {
        
        using (qs = Qubit[3]) {
            let qAlice = qs[0];
            let qBob = qs[1];
            let qCharlie = qs[2];
            
            // Apply operation that needs to be tested
            EntangleThreeQubits(qAlice, qBob, qCharlie);
            
            // Apply adjoint reference operation and check that the result is |000⟩
            Adjoint EntangleThreeQubits_Reference(qAlice, qBob, qCharlie);
            
            // Assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }
    
    
    operation T42_ReconstructMessageWhenThreeEntangledQubits_Test () : Unit {
        
        let setupPsiOps = [I, X, H, Ry(42.0, _)];
        let numRepetitions = 100;
        
        using (qs = Qubit[4]) {
            let qMessage = qs[0];
            let qAlice = qs[1];
            let qBob = qs[2];
            let qCharlie = qs[3];
            
            for (i in 0 .. Length(setupPsiOps) - 1) {
                for (j in 1 .. numRepetitions) {
                    setupPsiOps[i](qMessage);
                    EntangleThreeQubits_Reference(qAlice, qBob, qCharlie);
                    let (b1, b2) = SendMessage_Reference(qAlice, qMessage);
                    let b3 = ResultAsBool(M(qBob));
                    ReconstructMessageWhenThreeEntangledQubits(qCharlie, (b1, b2), b3);
                    Adjoint setupPsiOps[i](qCharlie);
                    AssertQubit(Zero, qCharlie);
                    ResetAll(qs);
                }
            }
        }
    }
    
}
