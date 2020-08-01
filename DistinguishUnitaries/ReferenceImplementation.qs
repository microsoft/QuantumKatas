// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DistinguishUnitaries {    
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Oracles;
    
    // Task 1.1. Identity or Pauli X?
    // Output: 0 if the given operation is the I gate,
    //         1 if the given operation is the X gate.
    operation DistinguishIfromX_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply operation to the |0⟩ state and measure: |0⟩ means I, |1⟩ means X
        using (q = Qubit()) {
            unitary(q);
            return MResetZ(q) == Zero ? 0 | 1;
        }
    }


    // Task 1.2. Identity or Pauli Z?
    // Output: 0 if the given operation is the I gate,
    //         1 if the given operation is the Z gate.
    operation DistinguishIfromZ_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply operation to the |+⟩ state and measure: |+⟩ means I, |-⟩ means Z
        using (q = Qubit()) {
            H(q);
            unitary(q);
            H(q);
            return MResetZ(q) == Zero ? 0 | 1;
        }
    }


    // Task 1.3. Z or S?
    // Output: 0 if the given operation is the Z gate,
    //         1 if the given operation is the S gate.
    operation DistinguishZfromS_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply operation twice to |+⟩ state and measure: |+⟩ means Z, |-⟩ means S
        // X will end up as XXX = X, H will end up as HXH = Z (does not change |0⟩ state)
        using (q = Qubit()) {
            H(q);
            unitary(q);
            unitary(q);
            H(q);
            return MResetZ(q) == Zero ? 0 | 1;
        }
    }


    // Task 1.4. Z or -Z?
    // Output: 0 if the given operation is the Z gate,
    //         1 if the given operation is the -Z gate.
    operation DistinguishZfromMinusZ_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply Controlled unitary to (|0⟩ + |1⟩) ⊗ |0⟩ state: Z will leave it unchanged while -Z will make it into (|0⟩ + |1⟩) ⊗ |0⟩
        using (qs = Qubit[2]) {
            // prep (|0⟩ + |1⟩) ⊗ |0⟩
            H(qs[0]);

            Controlled unitary(qs[0..0], qs[1]);

            H(qs[0]);
            // |0⟩ means it was Z, |1⟩ means -Z

            return MResetZ(qs[0]) == Zero ? 0 | 1;
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Multi-Qubit Gates
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1. I ⊗ X or CNOT?
    // Output: 0 if the given operation is I ⊗ X,
    //         1 if the given operation is the CNOT gate.
    operation DistinguishIXfromCNOT_Reference (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // apply to |00⟩ and measure 2nd qubit: CNOT will do nothing, I ⊗ X will change to |01⟩
        using (qs = Qubit[2]) {
            unitary(qs);
            return MResetZ(qs[1]) == One ? 0 | 1;
        }
    }


}
