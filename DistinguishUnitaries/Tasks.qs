// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.DistinguishUnitaries {
    
    open Microsoft.Quantum.Intrinsic;
    
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // "Distinguishing Unitaries" quantum kata is a series of exercises designed
    // to help you learn to think about unitary transformations in a different way.
    // It covers figuring out ways to distinguish several unitaries from the given list
    // by performing experiments on them.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks.
    

    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Gates
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. Identity or Pauli X?
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the identity (I gate)
    //        or the Pauli X gate (X gate).
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the I gate,
    //         1 if the given operation is the X gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
    operation DistinguishIfromX (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }
    

    // Task 1.2. Identity or Pauli Z?
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the identity (I gate)
    //        or the Pauli Z gate (Z gate).
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the I gate,
    //         1 if the given operation is the Z gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
    operation DistinguishIfromZ (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }
    

    // Task 1.3. Z or S?
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the Pauli Z gate
    //        or the S gate.
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the Z gate,
    //         1 if the given operation is the S gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants at most twice.
    operation DistinguishZfromS (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }
    

    // Task 1.4. Hadamard or Pauli X?
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the Hadamard gate
    //        or the Pauli X gate.
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the H gate,
    //         1 if the given operation is the X gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants at most twice.
    operation DistinguishHfromX (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }


    // Task 1.5. Z or -Z?
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the Pauli Z gate
    //        or the minus Pauli Z gate (i.e., a gate -|0〉〈0| + |1〉〈1|).
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the Z gate,
    //         1 if the given operation is the -Z gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
    operation DistinguishZfromMinusZ (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }
    

    // Task 1.6. Rz or R1 (arbitrary angle)?
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the Rz gate 
    //        or the R1 gate.
    // This operation will take two parameters: the first parameter is the rotation angle, in radians, 
    // and the second parameter is the qubit to which the gate should be applied (matching normal Rz and R1 gates in Q#).
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the Rz gate,
    //         1 if the given operation is the R1 gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
    operation DistinguishRzFromR1 (unitary : ((Double, Qubit) => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }


    // Task 1.7. Y or XZ?
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the Pauli Y gate
    //        or the sequence of Pauli Z and Pauli X gates (equivalent to applying the Z gate followed by the X gate).
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the Y gate,
    //         1 if the given operation is the XZ gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants at most twice.
    operation DistinguishYfromXZ (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }
    

    // Task 1.8. Y, XZ, -Y or -XZ?
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the Pauli Y gate (possibly with an extra global phase of -1)
    //        or the sequence of Pauli Z and Pauli X gates (possibly with an extra global phase of -1).
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the Y gate,
    //         1 if the given operation is the -XZ gate,
    //         2 if the given operation is the -Y gate,
    //         3 if the given operation is the XZ gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants at most three times.
    operation DistinguishYfromXZWithPhases (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }


    // Task 1.9. Rz or Ry (fixed angle)?
    // Inputs:
    //      1) An angle θ ∊ [0.01π; 0.99π].
    //      2) An operation that implements a single-qubit unitary transformation:
    //         either the Rz(θ) gate
    //         or the Ry(θ) gate.
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the Rz(θ) gate,
    //         1 if the given operation is the Ry(θ) gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants any number of times.
    operation DistinguishRzFromRy (theta : Double, unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }


    // Task 1.10*. Rz or R1 (fixed angle)?
    // Inputs:
    //      1) An angle θ ∊ [0.01π; 0.99π].
    //      2) An operation that implements a single-qubit unitary transformation:
    //         either the Rz(θ) gate
    //         or the R1(θ) gate.
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the Rz(θ) gate,
    //         1 if the given operation is the R1(θ) gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants any number of times.
    operation DistinguishRzFromR1WithAngle (theta : Double, unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }

    
    // Task 1.11. Distinguish 4 Pauli unitaries
    // Input: An operation that implements a single-qubit unitary transformation:
    //        either the identity (I gate) or one of the Pauli gates (X, Y or Z gate).
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the I gate,
    //         1 if the given operation is the X gate,
    //         2 if the given operation is the Y gate,
    //         3 if the given operation is the Z gate,
    // You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
    operation DistinguishPaulis (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Multi-Qubit Gates
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1. I ⊗ X or CNOT?
    // Input: An operation that implements a two-qubit unitary transformation:
    //        either I ⊗ X (the X gate applied to the second qubit)
    //        or the CNOT gate with the first qubit as control and the second qubit as target.
    // The operation will accept an array of qubits as input, but it will fail if the array is empty or has one or more than two qubits.
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is I ⊗ X,
    //         1 if the given operation is the CNOT gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
    operation DistinguishIXfromCNOT (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }
    

    // Task 2.2. Figure out the direction of CNOT
    // Input: An operation that implements a two-qubit unitary transformation:
    //        either the CNOT gate with the first qubit as control and the second qubit as target (CNOT₁₂),
    //        or the CNOT gate with the second qubit as control and the first qubit as target (CNOT₂₁).
    // The operation will accept an array of qubits as input, but it will fail if the array is empty or has one or more than two qubits.
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is CNOT₁₂,
    //         1 if the given operation is CNOT₂₁.
    // You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
    operation CNOTDirection (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }


    // Task 2.3. CNOT₁₂ or SWAP?
    // Input: An operation that implements a two-qubit unitary transformation:
    //        either the CNOT gate with the first qubit as control and the second qubit as target (CNOT₁₂)
    //        or the SWAP gate.
    // The operation will accept an array of qubits as input, but it will fail if the array is empty or has one or more than two qubits.
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the CNOT₁₂ gate,
    //         1 if the given operation is the SWAP gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
    operation DistinguishCNOTfromSWAP (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }


    // Task 2.4. Identity, CNOTs or SWAP?
    // Input: An operation that implements a two-qubit unitary transformation:
    //        either the identity (I ⊗ I gate), 
    //        the CNOT gate with one of the qubits as control and the other qubit as a target, 
    //        or the SWAP gate.
    // The operation will accept an array of qubits as input, but it will fail if the array is empty or has one or more than two qubits.
    // The operation will have Adjoint and Controlled variants defined.
    // Output: 0 if the given operation is the I ⊗ I gate,
    //         1 if the given operation is the CNOT₁₂ gate,
    //         2 if the given operation is the CNOT₂₁ gate,
    //         3 if the given operation is the SWAP gate.
    // You are allowed to apply the given operation and its adjoint/controlled variants at most twice.
    operation DistinguishTwoQubitUnitaries (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // ...
        return -1;
    }
}
