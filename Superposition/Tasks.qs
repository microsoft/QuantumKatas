// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Superposition
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // "Superposition" quantum kata is a series of exercises designed 
    // to get you familiar with programming in Q#.
    // It covers the following topics:
    //  - basic single-qubit and multi-qubit gates,
    //  - superposition,
    //  - flow control and recursion in Q#.
    //
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    //
    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks. 

    // Task 1. Plus state
    // Input: a qubit in |0⟩ state (stored in an array of length 1).
    // Goal: create a |+⟩ state on this qubit (|+⟩ = (|0⟩ + |1⟩) / sqrt(2)).
    operation PlusState (qs : Qubit[]) : ()
    {
        body
        {
            // Hadamard gate H will convert |0⟩ state to |+⟩ state.
            // The first qubit of the array can be accessed as qs[0].
            // Type H(qs[0]);
            // Then rebuild the project and rerun the tests - T01_PlusState_Test should now pass!

            // ...
        }
    }

    // Task 2. Minus state
    // Input: a qubit in |0⟩ state (stored in an array of length 1).
    // Goal: create a |-⟩ state on this qubit (|-⟩ = (|0⟩ - |1⟩) / sqrt(2)).
    operation MinusState (qs : Qubit[]) : ()
    {
        body
        {
            // In this task, as well as in all subsequent ones, you have to come up with the solution yourself.
            
            // ...
        }
    }

    // Task 3*. Unequal superposition
    // Inputs:
    //      1) a qubit in |0⟩ state (stored in an array of length 1).
    //      2) angle alpha, in radians, represented as Double
    // Goal: create a cos(alpha) * |0⟩ + sin(alpha) * |1⟩ state on this qubit.
    operation UnequalSuperposition (qs : Qubit[], alpha : Double) : ()
    {
        body
        {
            // Hint: Experiment with rotation gates from Microsoft.Quantum.Primitive namespace.
            // Note that all rotation operators rotate the state by _half_ of its angle argument.

            // ...
        }
    }

    // Task 4. Bell state
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal: create a Bell state |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2) on these qubits.
    operation BellState (qs : Qubit[]) : ()
    {
        body
        {
            // ...
        }
    }

    // Task 5. All Bell states
    // Inputs:
    //      1) two qubits in |00〉 state (stored in an array of length 2)
    //      2) an integer index
    // Goal: create one of the Bell states based on the value of index:
    //       0: |Φ⁺〉 = (|00〉 + |11〉) / sqrt(2)
    //       1: |Φ⁻〉 = (|00〉 - |11〉) / sqrt(2)
    //       2: |Ψ⁺〉 = (|01〉 + |10〉) / sqrt(2)
    //       3: |Ψ⁻〉 = (|01〉 - |10〉) / sqrt(2)
    operation AllBellStates (qs : Qubit[], index : Int) : ()
    {
        body
        {
            // ...
        }
    }

    // Task 6. Greenberger–Horne–Zeilinger state
    // Input: N qubits in |0...0⟩ state.
    // Goal: create a GHZ state (|0...0⟩ + |1...1⟩) / sqrt(2) on these qubits.
    operation GHZ_State (qs : Qubit[]) : ()
    {
        body
        {
            // Hint: N can be found as Length(qs).

            // ...
        }
    }

    // Task 7. Superposition of all basis vectors
    // Input: N qubits in |0...0⟩ state.
    // Goal: create an equal superposition of all basis vectors from |0...0⟩ to |1...1⟩
    // (i.e. state (|0...0⟩ + ... + |1...1⟩) / sqrt(2^N) ).
    operation AllBasisVectorsSuperposition (qs : Qubit[]) : ()
    {
        body
        {
            // ...
        }
    }

    // Task 8. Superposition of |0...0⟩ and given bit string
    // Inputs:
    //      1) N qubits in |0...0⟩ state
    //      2) bit string represented as Bool[]
    // Goal: create an equal superposition of |0...0⟩ and basis state given by the bit string.
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // You are guaranteed that the qubit array and the bit string have the same length.
    // You are guaranteed that the first bit of the bit string is true.
    // Example: for bit string = [true; false] the qubit state required is (|00⟩ + |10⟩) / sqrt(2).
    operation ZeroAndBitstringSuperposition (qs : Qubit[], bits : Bool[]) : ()
    {
        body
        {
            // The following lines enforce the constraints on the input that you are given.
            // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
            AssertIntEqual(Length(bits), Length(qs), "Arrays should have the same length");
            AssertBoolEqual(bits[0], true, "First bit of the input bit string should be set to true");

            // ...
        }
    }

    // Task 9. Superposition of two bit strings
    // Inputs:
    //      1) N qubits in |0...0⟩ state
    //      2) two bit string represented as Bool[]s
    // Goal: create an equal superposition of two basis states given by the bit strings.
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // Example: for bit strings [false; true; false] and [false; false; true] 
    // the qubit state required is (|010⟩ + |001⟩) / sqrt(2).
    // You are guaranteed that the both bit strings have the same length as the qubit array,
    // and that the bit strings will differ in at least one bit.
    operation TwoBitstringSuperposition (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : ()
    {
        body
        {
            // ...
        }
    }

    // Task 10**. W state on 2^k qubits
    // Input: N = 2^k qubits in |0...0⟩ state.
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 4, W state is (|1000⟩ + |0100⟩ + |0010⟩ + |0001⟩) / 2.
    operation WState_PowerOfTwo (qs : Qubit[]) : ()
    {
        body
        {
            // Hint: you can use Controlled functor to perform arbitrary controlled gates.

            // ...
        }
    }

    // Task 11**. W state on arbitrary number of qubits
    // Input: N qubits in |0...0⟩ state (N is not necessarily a power of 2).
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 3, W state is (|100⟩ + |010⟩ + |001⟩) / sqrt(3).
    operation WState_Arbitrary (qs : Qubit[]) : ()
    {
        body
        {
            // ...
        }
    }
}
