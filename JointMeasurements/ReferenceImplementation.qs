// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.JointMeasurements {
    
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    
    // Task 1. Single-qubit measurement
    operation SingleQubitMeasurement_Reference (qs : Qubit[]) : Int {
        // Hint: use two single-qubit measurements
        return M(qs[0]) == M(qs[1]) ? 0 | 1;
    }
    
    
    // Task 2. Parity measurement
    operation ParityMeasurement_Reference (qs : Qubit[]) : Int {
        return Measure([PauliZ, PauliZ], qs) == Zero ? 0 | 1;
    }
    
    
    // Task 3. |0000⟩ + |1111⟩ or |0011⟩ + |1100⟩ ?
    operation GHZOrGHZWithX_Reference (qs : Qubit[]) : Int {
        // Considering only the two middle qubits of the array, their parity for the first state is 0,
        // so the first state belongs to the +1 eigenspace of operator Z ⊗ Z on these qubits;
        // their parity for the second state is 1, so the second state belongs to the -1 eigenspace.
        return Measure([PauliZ, PauliZ], qs[1 .. 2]) == Zero ? 0 | 1;
    }
    
    
    // Task 4. |0..0⟩ + |1..1⟩ or W state ?
    operation GHZOrWState_Reference (qs : Qubit[]) : Int {
        // Since the number of qubits in qs is even, the parity of both |0..0⟩ and |1..1⟩ basis states is 0,
        // so both of them belong to the +1 eigenspace of operator Z ⊗ Z ⊗ ... ⊗ Z. 
        // All basis vectors in W state have parity 1 and belong to the -1 eigenspace of this operator.
        return MeasureAllZ(qs) == Zero ? 0 | 1;
    }
    
    
    // Task 5*. Parity measurement in different basis
    operation DifferentBasis_Reference (qs : Qubit[]) : Int {
        // The first state is a superposition of the states |++⟩ and |--⟩, 
        // which belong to the +1 eigenspace of the operator X ⊗ X;
        // the second one is a superposition of |+-⟩ and |-+⟩, which belong to the -1 eigenspace.
        return Measure([PauliX, PauliX], qs) == Zero ? 0 | 1;
    }
    
    
    // Task 6*. Controlled X gate with |0⟩ target
    operation ControlledX_Reference (qs : Qubit[]) : Unit {
        H(qs[1]);
        if (Measure([PauliZ, PauliZ], qs) == One) {
            X(qs[1]);
        }
    }
    
    
    // Task 7**. Controlled X gate with arbitrary target
    operation ControlledX_General_Reference (qs : Qubit[]) : Unit {
        
        body (...) {
            // This implementation follows the description at https://arxiv.org/pdf/1201.5734.pdf.
            // Note the parity notation used in the table of fixups in the paper
            // differs from the notation used in Q#.
            using (a = Qubit()) {
                let c = qs[0];
                let t = qs[1];
                H(a);
                let p1 = MeasureAllZ([c, a]);
                H(a);
                H(t);
                let p2 = MeasureAllZ([a, t]);
                H(a);
                H(t);
                let m = MResetZ(a);
                
                // apply fixups
                if (p2 == One) {
                    Z(c);
                }
                if (p1 != m) {
                    X(t);
                }
            }
        }
        
        adjoint self;
    }
    
}
