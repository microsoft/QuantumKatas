// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.BasicGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;


    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Gates
    //////////////////////////////////////////////////////////////////

    // Task 1.1. State flip
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal: Change the state of the qubit to α |1⟩ + β |0⟩.
    // Example:
    //     If the qubit is in state |0⟩, change its state to |1⟩.
    //     If the qubit is in state |1⟩, change its state to |0⟩.
    operation StateFlip_Reference (q : Qubit) : Unit is Adj+Ctl {
        X(q);
    }


    // Task 1.2. Basis change: |0⟩ to |+⟩ and |1⟩ to |-⟩ (and vice versa)
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal: Change the state of the qubit as follows:
    //     If the qubit is in state |0⟩, change its state to |+⟩ = (|0⟩ + |1⟩) / sqrt(2).
    //     If the qubit is in state |1⟩, change its state to |-⟩ = (|0⟩ - |1⟩) / sqrt(2).
    //     If the qubit is in superposition, change its state according to the effect on basis vectors.
    // Note: |+⟩ and |-⟩ form a different basis for single-qubit states, called X basis.
    operation BasisChange_Reference (q : Qubit) : Unit is Adj+Ctl {
        H(q);
    }


    // Task 1.3. Sign flip: |+⟩ to |-⟩ and vice versa.
    // Inputs: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal: Change the qubit state to α |0⟩ - β |1⟩ (flip the sign of |1⟩ component of the superposition).
    operation SignFlip_Reference (q : Qubit) : Unit is Adj+Ctl {
        Z(q);
    }


    // Task 1.4*. Amplitude change (|0⟩ to cos(alpha)*|0⟩ + sin(alpha)*|1⟩).
    // Inputs:
    //     1) Angle alpha, in radians, represented as Double.
    //     2) A qubit in state β|0⟩ + γ|1⟩.
    // Goal:  Change the state of the qubit as follows:
    //        If the qubit is in state |0⟩, change its state to cos(alpha)*|0⟩ + sin(alpha)*|1⟩.
    //        If the qubit is in state |1⟩, change its state to -sin(alpha)*|0⟩ + cos(alpha)*|1⟩.
    //        If the qubit is in superposition, change its state according to the effect on basis vectors.
    operation AmplitudeChange_Reference (alpha : Double, q : Qubit) : Unit is Adj+Ctl {
        Ry(2.0 * alpha, q);
    }


    // Task 1.5. Phase flip
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal:  Change the qubit state to α |0⟩ + iβ |1⟩ (flip the phase of |1⟩ component of the superposition).
    operation PhaseFlip_Reference (q : Qubit) : Unit is Adj+Ctl {
        S(q);
        // alternatively R1(0.5 * PI(), q);
    }


    // Task 1.6*. Phase change
    // Inputs:
    //     1) Angle alpha, in radians, represented as Double.
    //     2) A qubit in state β|0⟩ + γ|1⟩.
    // Goal:  Change the state of the qubit as follows:
    //        If the qubit is in state |0⟩, don't change its state.
    //        If the qubit is in state |1⟩, change its state to exp(i*alpha)|1⟩.
    //        If the qubit is in superposition, change its state according to the effect on basis vectors.
    operation PhaseChange_Reference (alpha : Double, q : Qubit) : Unit is Adj+Ctl {
        R1(alpha, q);
    }

    // Task 1.7. Global Phase Change
    // Input: A qubit in state β|0⟩ + γ|1⟩.
    // Goal: Change the state of the qubit to - β|0⟩ - γ|1⟩.
    operation GlobalPhaseChange_Reference (q: Qubit) : Unit is Adj+Ctl {
        R(PauliI, 2.0 * PI(), q);
    }

    // Task 1.8. Bell state change - 1
    // Input: Two entangled qubits in Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2).
    // Goal:  Change the two-qubit state to |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2).
    operation BellStateChange1_Reference (qs : Qubit[]) : Unit is Adj+Ctl {
        Z(qs[0]);
        // alternatively Z(qs[1]);
    }


    // Task 1.9. Bell state change - 2
    // Input: Two entangled qubits in Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2).
    // Goal:  Change the two-qubit state to |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2).
    operation BellStateChange2_Reference (qs : Qubit[]) : Unit is Adj+Ctl {
        X(qs[0]);
        // alternatively X(qs[1]);
    }


    // Task 1.10. Bell state change - 3
    // Input: Two entangled qubits in Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2).
    // Goal:  Change the two-qubit state to |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2).
    operation BellStateChange3_Reference (qs : Qubit[]) : Unit is Adj+Ctl {
        X(qs[0]);
        Z(qs[0]);
        // note that this is not equivalent to Y(qs[0]), since Y gate adds an extra global phase
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Multi-Qubit Gates
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Two-qubit gate - 1
    // Input: Two unentangled qubits (stored in an array of length 2).
    //     The first qubit will be in state |ψ⟩ = α |0⟩ + β |1⟩, the second - in state |0⟩
    //     (this can be written as two-qubit state (α|0⟩ + β|1⟩) ⊗ |0⟩).
    // Goal: Change the two-qubit state to α |00⟩ + β |11⟩.
    // Note that unless the starting state of the first qubit was |0⟩ or |1⟩,
    // the resulting two-qubit state can not be represented as a tensor product
    // of the states of individual qubits any longer; thus the qubits become entangled.
    operation TwoQubitGate1_Reference (qs : Qubit[]) : Unit is Adj {
        CNOT(qs[0], qs[1]);
    }


    // Task 2.2. Two-qubit gate - 2
    // Input: Two qubits (stored in an array of length 2)
    //        in state |+⟩ ⊗ |+⟩ = (|00⟩ + |01⟩ + |10⟩ + |11⟩) / 2.
    // Goal: Change the two-qubit state to (|00⟩ + |01⟩ + |10⟩ - |11⟩) / 2.
    // Note that while the starting state can be represented as a tensor product of single-qubit states,
    // the resulting two-qubit state can not be represented in such a way.
    operation TwoQubitGate2_Reference (qs : Qubit[]) : Unit is Adj {
        Controlled Z([qs[0]], qs[1]);
        // alternatively: CZ(qs[0], qs[1]);
    }

    // Task 2.3. Two-qubit gate - 3
    // Input: Two qubits (stored in an array of length 2) in an arbitrary
    //        two-qubit state α|00⟩ + β|01⟩ + γ|10⟩ + δ|11⟩.
    // Goal:  Change the two-qubit state to α|00⟩ + γ|01⟩ + β|10⟩ + δ|11⟩.
    operation TwoQubitGate3_Reference (qs : Qubit[]) : Unit is Adj {
        // Hint: this task can be solved using one intrinsic gate;
        // as an exercise, try to express the solution using several controlled Pauli gates.
        CNOT(qs[0], qs[1]);
        CNOT(qs[1], qs[0]);
        CNOT(qs[0], qs[1]);
    }


    // Task 2.4. Toffoli gate
    // Input: Three qubits (stored in an array of length 3) in an arbitrary three-qubit state
    //        α|000⟩ + β|001⟩ + γ|010⟩ + δ|011⟩ + ε|100⟩ + ζ|101⟩ + η|110⟩ + θ|111⟩.
    // Goal:  Flip the state of the third qubit if the state of the first two is |11⟩:
    //        i.e., change the three-qubit state to
    //        α|000⟩ + β|001⟩ + γ|010⟩ + δ|011⟩ + ε|100⟩ + ζ|101⟩ + θ|110⟩ + η|111⟩.
    operation ToffoliGate_Reference (qs : Qubit[]) : Unit is Adj {
        CCNOT(qs[0], qs[1], qs[2]);
        // alternatively (Controlled X)(qs[0..1], qs[2]);
    }

    // Task 2.5. Fredkin gate
    // Input: Three qubits (stored in an array of length 3) in an arbitrary three-qubit state
    //        α|000⟩ + β|001⟩ + γ|010⟩ + δ|011⟩ + ε|100⟩ + ζ|101⟩ + η|110⟩ + θ|111⟩.
    // Goal:  Swap the states of second and third qubit if and only if the state of the first qubit is |1⟩:
    //        i.e., change the three-qubit state to
    //        α|000⟩ + β|001⟩ + γ|010⟩ + δ|011⟩ + ε|100⟩ + η|101⟩ + ζ|110⟩ + θ|111⟩.
    operation FredkinGate_Reference (qs : Qubit[]) : Unit is Adj {
        Controlled SWAP([qs[0]], (qs[1], qs[2]));
    }

}
