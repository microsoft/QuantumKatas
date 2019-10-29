// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.BasicGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;


    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // "Basic Gates" quantum kata is a series of exercises designed
    // to get you familiar with the basic quantum gates in Q#.
    // It covers the following topics:
    //  - basic single-qubit and multi-qubit gates,
    //  - adjoint and controlled gates,
    //  - using gates to modify the state of a qubit.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    // Most tasks can be done using exactly one gate.
    // None of the tasks require measurement, and the tests are written so as to fail if qubit state is measured.

    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks.


    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Gates
    //////////////////////////////////////////////////////////////////

    // Note that all operations in this section have `is Adj+Ctl` in their signature.
    // This means that they should be implemented in a way that allows Q# 
    // to compute their adjoint and controlled variants automatically.
    // Since each task is solved using only intrinsic gates, you should not need to put any special effort in this.


    // Task 1.1. State flip: |0⟩ to |1⟩ and vice versa
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal:  Change the state of the qubit to α |1⟩ + β |0⟩.
    // Example:
    //        If the qubit is in state |0⟩, change its state to |1⟩.
    //        If the qubit is in state |1⟩, change its state to |0⟩.
    // Note that this operation is self-adjoint: applying it for a second time
    // returns the qubit to the original state.
    operation StateFlip (q : Qubit) : Unit is Adj+Ctl {
        // The Pauli X gate will change the |0⟩ state to the |1⟩ state and vice versa.
        // Type X(q);
        // Then rebuild the project and rerun the tests - T11_StateFlip_Test should now pass!

        // ...
    }


    // Task 1.2. Basis change: |0⟩ to |+⟩ and |1⟩ to |-⟩ (and vice versa)
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal:  Change the state of the qubit as follows:
    //        If the qubit is in state |0⟩, change its state to |+⟩ = (|0⟩ + |1⟩) / sqrt(2).
    //        If the qubit is in state |1⟩, change its state to |-⟩ = (|0⟩ - |1⟩) / sqrt(2).
    //        If the qubit is in superposition, change its state according to the effect on basis vectors.
    // Note:  |+⟩ and |-⟩ form a different basis for single-qubit states, called X basis.
    // |0⟩ and |1⟩ are called Z basis.
    operation BasisChange (q : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.3. Sign flip: |+⟩ to |-⟩ and vice versa.
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal:  Change the qubit state to α |0⟩ - β |1⟩ (flip the sign of |1⟩ component of the superposition).
    operation SignFlip (q : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.4*. Amplitude change: |0⟩ to cos(alpha)*|0⟩ + sin(alpha)*|1⟩.
    // Inputs:
    //     1) Angle alpha, in radians, represented as Double.
    //     2) A qubit in state β|0⟩ + γ|1⟩.
    // Goal:  Change the state of the qubit as follows:
    //        If the qubit is in state |0⟩, change its state to cos(alpha)*|0⟩ + sin(alpha)*|1⟩.
    //        If the qubit is in state |1⟩, change its state to -sin(alpha)*|0⟩ + cos(alpha)*|1⟩.
    //        If the qubit is in superposition, change its state according to the effect on basis vectors.
    // This is the first operation in this kata that is not self-adjoint, 
    // i.e., applying it for a second time does not return the qubit to the original state. 
    operation AmplitudeChange (alpha : Double, q : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.5. Phase flip
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal:  Change the qubit state to α |0⟩ + iβ |1⟩ (flip the phase of |1⟩ component of the superposition).
    operation PhaseFlip (q : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.6*. Phase change
    // Inputs:
    //     1) Angle alpha, in radians, represented as Double.
    //     2) A qubit in state β|0⟩ + γ|1⟩.
    // Goal:  Change the state of the qubit as follows:
    //        If the qubit is in state |0⟩, don't change its state.
    //        If the qubit is in state |1⟩, change its state to exp(i*alpha)|1⟩.
    //        If the qubit is in superposition, change its state according to the effect on basis vectors.
    operation PhaseChange (alpha : Double, q : Qubit) : Unit is Adj+Ctl {
        // ...
    }

    // Task 1.7. Global phase change
    // Input: A qubit in state β|0⟩ + γ|1⟩.
    // Goal: Change the state of the qubit to - β|0⟩ - γ|1⟩.
    //
    // Note: This change on its own is not observable - 
    // there is no experiment you can do on a standalone qubit 
    // to figure out whether it acquired the global phase or not. 
    // However, you can use a controlled version of this operation 
    // to observe the global phase it introduces. This is used 
    // in later katas as part of more complicated tasks.
    operation GlobalPhaseChange (q: Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.8. Bell state change - 1
    // Input: Two entangled qubits in Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2).
    // Goal:  Change the two-qubit state to |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2).
    operation BellStateChange1 (qs : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.9. Bell state change - 2
    // Input: Two entangled qubits in Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2).
    // Goal:  Change the two-qubit state to |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2).
    operation BellStateChange2 (qs : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.10. Bell state change - 3
    // Input: Two entangled qubits in Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2).
    // Goal:  Change the two-qubit state to |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2).
    operation BellStateChange3 (qs : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Multi-Qubit Gates
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Two-qubit gate - 1
    // Input: Two unentangled qubits (stored in an array of length 2).
    //        The first qubit will be in state |ψ⟩ = α |0⟩ + β |1⟩, the second - in state |0⟩
    //        (this can be written as two-qubit state (α|0⟩ + β|1⟩) ⊗ |0⟩).
    // Goal:  Change the two-qubit state to α |00⟩ + β |11⟩.
    // Note that unless the starting state of the first qubit was |0⟩ or |1⟩,
    // the resulting two-qubit state can not be represented as a tensor product
    // of the states of individual qubits any longer; thus the qubits become entangled.
    operation TwoQubitGate1 (qs : Qubit[]) : Unit is Adj {
        // ...
    }


    // Task 2.2. Two-qubit gate - 2
    // Input: Two qubits (stored in an array of length 2)
    //        in state |+⟩ ⊗ |+⟩ = (|00⟩ + |01⟩ + |10⟩ + |11⟩) / 2.
    // Goal:  Change the two-qubit state to (|00⟩ + |01⟩ + |10⟩ - |11⟩) / 2.
    // Note that while the starting state can be represented as a tensor product of single-qubit states,
    // the resulting two-qubit state can not be represented in such a way.
    operation TwoQubitGate2 (qs : Qubit[]) : Unit is Adj {
        // ...
    }


    // Task 2.3. Two-qubit gate - 3
    // Input: Two qubits (stored in an array of length 2) in an arbitrary
    //        two-qubit state α|00⟩ + β|01⟩ + γ|10⟩ + δ|11⟩.
    // Goal:  Change the two-qubit state to α|00⟩ + γ|01⟩ + β|10⟩ + δ|11⟩.
    operation TwoQubitGate3 (qs : Qubit[]) : Unit is Adj {
        // Hint: this task can be solved using one intrinsic gate;
        // as an exercise, try to express the solution using several
        // (possibly controlled) Pauli gates.
        // ...
    }


    // Task 2.4. Toffoli gate
    // Input: Three qubits (stored in an array of length 3) in an arbitrary three-qubit state
    //        α|000⟩ + β|001⟩ + γ|010⟩ + δ|011⟩ + ε|100⟩ + ζ|101⟩ + η|110⟩ + θ|111⟩.
    // Goal:  Flip the state of the third qubit if the state of the first two is |11⟩:
    //        i.e., change the three-qubit state to
    //        α|000⟩ + β|001⟩ + γ|010⟩ + δ|011⟩ + ε|100⟩ + ζ|101⟩ + θ|110⟩ + η|111⟩.
    operation ToffoliGate (qs : Qubit[]) : Unit is Adj {
        // ...
    }


    // Task 2.5. Fredkin gate
    // Input: Three qubits (stored in an array of length 3) in an arbitrary three-qubit state
    //        α|000⟩ + β|001⟩ + γ|010⟩ + δ|011⟩ + ε|100⟩ + ζ|101⟩ + η|110⟩ + θ|111⟩.
    // Goal:  Swap the states of second and third qubit if and only if the state of the first qubit is |1⟩:
    //        α|000⟩ + β|001⟩ + γ|010⟩ + δ|011⟩ + ε|100⟩ + η|101⟩ + ζ|110⟩ + θ|111⟩.
    operation FredkinGate (qs : Qubit[]) : Unit is Adj {
        // ...
    }

}
