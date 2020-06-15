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
    

    // Task 1.4. Z or -Z?
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
    

}
