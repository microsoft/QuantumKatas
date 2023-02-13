// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.MarkingOracles {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;


    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // "MarkingOracles" quantum kata is a series of exercises designed
    // to teach you to implement marking oracles for classical functions in Q#.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    // The tasks are given in approximate order of increasing difficulty.


    // Task 1. Palindrome checker.
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit).
    // Goal: Implement a quantum oracle which checks whether the input register is a palindrome, 
    //       i.e., implements the function f(x) = 1 if x is a palindrome, and 0 otherwise.
    //       A bit string is a palindrome if it equal its reverse, or, in other words,
    //       its first bit equals its last bit, its second bit equals its second-to-last bit, and so on.
    // For example, for N = 3 the input state |101⟩ is a palindrome, and |001⟩ is not.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation PalindromeOracle (input : Qubit[], target : Qubit) : Unit is Adj {
        // ...
    }


    // Task 2. Is the bit string periodic with period P?
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit),
    //      3) an integer P < N.
    // Goal: Implement a quantum oracle which checks whether the input register is periodic with period P,
    //       i.e., for all j between 0 and N - P - 1, inclusive, xⱼ = xⱼ₊ₚ.
    // For example, for N = 3 a bit string [false, true, false] is periodic with period 2.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation PeriodicGivenPeriodOracle (input : Qubit[], target : Qubit, P : Int) : Unit is Adj {
        // ...
    }


    // Task 3. Is the bit string periodic?
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit).
    // Goal: Implement a quantum oracle which checks whether the input register is periodic with any period,
    //       i.e., whether there exists a value P < N such that for all j between 0 and N - P - 1, inclusive, xⱼ = xⱼ₊ₚ.
    // For example, for N = 3 a bit string [false, true, false] is periodic with period 2, so the bit string is periodic.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation PeriodicOracle (input : Qubit[], target : Qubit) : Unit is Adj {
        // ...
    }


    // Task 4. Does the bit string contain the given substring at the given position?
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit),
    //      3) a bit pattern of length K represented as a Bool[] (1 ≤ K ≤ N),
    //      4) an integer 0 ≤ P < N - K.
    // Goal: Implement a quantum oracle which checks whether the input register contains the given pattern
    //       starting at the given position, i.e., for all j between 0 and K - 1, inclusive, patternⱼ = xⱼ₊ₚ
    //       ("false" and "true" values represent states |0⟩ and |1⟩, respectively).
    // For example, for N = 3 a bit string [false, true, false] contains a pattern [true, false] starting at index 1.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation ContainsSubstringAtPositionOracle (input : Qubit[], target : Qubit, pattern : Bool[], P : Int) : Unit is Adj {
        // ...
    }


    // Task 5. Pattern matching.
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit),
    //      3) an array of K distinct indices in the input register,
    //      4) a bit pattern of length K represented as a Bool[] (1 ≤ K ≤ N).
    // Goal: Implement a quantum oracle which checks whether the input register matches the given pattern,
    //       i.e., the bits at the given indices match the corresponding bits in the pattern
    //       ("false" and "true" values represent states |0⟩ and |1⟩, respectively).
    // For example, for N = 3 a pattern [false, true] at indices [0, 2] would match two basis states: |001⟩ and |011⟩.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation PatternMatchingOracle (input : Qubit[], target : Qubit, indices : Int[], pattern : Bool[]) : Unit is Adj {
        // ...
    }


    // Task 6. Does the bit string contain the given substring?
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit),
    //      3) a bit pattern of length K represented as a Bool[] (1 ≤ K ≤ N).
    // Goal: Implement a quantum oracle which checks whether the input register contains the given pattern,
    //       i.e., whether there exists a position P such that for all j between 0 and K - 1, inclusive, patternⱼ = xⱼ₊ₚ.
    // For example, for N = 3 a bit string [false, true, false] contains a pattern [true, false] (starting at index 1).
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation ContainsSubstringOracle (input : Qubit[], target : Qubit, pattern : Bool[]) : Unit is Adj {
        // ...
    }


    // Task 7. Is the bit string balanced?
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit).
    // Goal: Implement a quantum oracle which checks whether the input register is a balanced bit string,
    //       i.e., whether it contains exactly N/2 0s and N/2 1s.
    // N will be an even number.
    // For example, for N = 4 basis states |0011⟩ and |0101⟩ are balanced, and |0010⟩ and |1111⟩ are not.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation BalancedOracle (input : Qubit[], target : Qubit) : Unit is Adj {
        // ...
    }


    // Task 8. Majority function
    // Inputs:
    //      1) an array of 7 qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit).
    // Goal: Implement a quantum oracle which calculates the majority function,
    //       i.e., f(x) = 1 if most of the bits in the bit string are 1s, and 0 otherwise.
    // For example, for N = 3 majority function for basis states |001⟩ and |000⟩ is 0, and for |101⟩ and |111⟩ - 1.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation MajorityOracle (input : Qubit[], target : Qubit) : Unit is Adj {
        // ...
    }


    // Task 9. Is the sum of bits in the bit string divisible by 3?
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit).
    // Goal: Implement a quantum oracle which checks whether the sum of bits in the bit string is divisible by 3.
    // For example, for N = 3 the only basis states that should be marked are |000⟩ and |111⟩.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation BitSumDivisibleBy3Oracle (input : Qubit[], target : Qubit) : Unit is Adj {
        // ...
    }


    // Task 10. Is the number divisible by 3?
    // Inputs:
    //      1) an array of N qubits in an arbitrary state |x⟩ (input register),
    //      2) a qubit in an arbitrary state |y⟩ (target qubit).
    // Goal: Implement a quantum oracle which checks whether the number represented by the bit string is divisible by 3.
    // Use little endian notation to convert the bit string to an integer, i.e., the least significant bit is stored in input[0].
    // For example, for N = 3 the basis states that should be marked are |000⟩, |110⟩, and |011⟩.
    // Leave the qubits in the input register in the same state they started in.
    // Your solution should work on inputs in superposition, and not use any measurements.
    operation DivisibleBy3Oracle (input : Qubit[], target : Qubit) : Unit is Adj {
        // ...
    }
}
