// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MarkingOracles {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;


    // Task 1. Palindrome checker.
    operation PalindromeOracle_Reference (input : Qubit[], target : Qubit) : Unit is Adj {
        let N = Length(input);
        // Compute XORs of the bits that should be equal in the first qubits
        within {
            for i in 0 .. N / 2 - 1 {
                CNOT(input[N - 1 - i], input[i]);
            }
        } apply {
            // All XORs should be 0s
            ControlledOnInt(0, X)(input[... N / 2 - 1], target);
        }
    }


    // Task 2. Is bit string periodic with period P?
    operation PeriodicGivenPeriodOracle_Reference (input : Qubit[], target : Qubit, P : Int) : Unit is Adj {
        let N = Length(input);
        // Compute XORs of the bits that should be equal in the first N - P qubits
        within {
            for i in 0 .. N - P - 1 {
                CNOT(input[i + P], input[i]);
            }
        } apply {
            // All XORs should be 0s
            ControlledOnInt(0, X)(input[... N - P - 1], target);
        }
    }


    // Task 3. Is the bit string periodic?
    operation PeriodicOracle_Reference (input : Qubit[], target : Qubit) : Unit is Adj {
        let N = Length(input);
        // Check whether the bit string is periodic for any period
        use aux = Qubit[N - 1];
        within {
            for P in 1 .. N - 1 {
                PeriodicGivenPeriodOracle_Reference(input, aux[P - 1], P);
            }
        } apply {
            // If any of the aux qubits are 1, the bit string is periodic - use OR
            ControlledOnInt(0, X)(aux, target);
            X(target);
        }
    }


    // Task 4. Does the bit string contain the given substring at the given position?
    operation ContainsSubstringAtPositionOracle_Reference (input : Qubit[], target : Qubit, pattern : Bool[], P : Int) : Unit is Adj {
        ControlledOnBitString(pattern, X)(input[P .. P + Length(pattern) - 1], target);
    }


    // Task 5. Pattern matching.
    operation PatternMatchingOracle_Reference (input : Qubit[], target : Qubit, indices : Int[], pattern : Bool[]) : Unit is Adj {
        // Get the list of qubits that should be used as controls
        let ctrl = Subarray(indices, input);
        ControlledOnBitString(pattern, X)(ctrl, target);
    }


    // Task 6. Does the bit string contain the given substring?
    operation ContainsSubstringOracle_Reference (input : Qubit[], target : Qubit, pattern : Bool[]) : Unit is Adj {
        let N = Length(input);
        let K = Length(pattern);
        // Try to match the substring to every possible position in the string
        use aux = Qubit[N - K + 1];
        within {
            for P in 0 .. N - K {
                ContainsSubstringAtPositionOracle_Reference(input, aux[P], pattern, P);
            }
        } apply {
            // If any of the aux qubits are 1, the bit string contains the substring - use OR
            ControlledOnInt(0, X)(aux, target);
            X(target);
        }
    }


    // Task 7. Is the bit string balanced?

    // Helper operation that implements increment for a qubit register
    operation IncrementBE (register : Qubit[]) : Unit is Adj + Ctl {
        if Length(register) > 1 {
            // Increment the rest of the number if the least significant bit is 1
            Controlled IncrementBE([register[0]], register[1 ...]);
        }
        // Increment the least significant bit
        X(register[0]);
    }

    operation BalancedOracle_Reference (input : Qubit[], target : Qubit) : Unit is Adj {
        let N = Length(input);
        let log = BitSizeI(N);
        use inc = Qubit[log];
        within {
            // Count the 1s in the bit string
            for q in input {
                Controlled IncrementBE([q], inc);
            }
        } apply {
            // The number of 1s should be exactly N / 2
            ControlledOnInt(N / 2, X)(inc, target);
        }
    }


    // Task 8. Majority function
    operation MajorityOracle_Reference (input : Qubit[], target : Qubit) : Unit is Adj {
        let N = Length(input);
        let log = BitSizeI(N); // For N = 7 will be 3
        use inc = Qubit[log];
        within {
            // Count the 1s in the bit string
            for q in input {
                Controlled IncrementBE([q], inc);
            }
        } apply {
            // For majority of the bits to be 1s, their count has to be 4, 5, 6, or 7 - all have 1xx BE notations,
            // and the counts for which majority is 0 are 0xx.
            CNOT(inc[2], target);
        }
    }


    // Task 9. Is the number of 1s in the bit string divisible by 3?

    // Helper operation that implements counting modulo 3
    operation IncrementMod3 (counterRegister : Qubit[]) : Unit is Adj + Ctl {
        let sum = counterRegister[0];
        let carry = counterRegister[1];
        // we need to implement +1 mod 3:
        // sum carry | sum carry
        //  0    0   |  1    0
        //  1    0   |  0    1
        //  0    1   |  0    0
        // compute sum bit
        ControlledOnInt(0, X)([carry], sum);
        // sum carry | carry
        //  1    0   |   0
        //  0    0   |   1
        //  0    1   |   0
        ControlledOnInt(0, X)([sum], carry);
    }

    operation BitSumDivisibleBy3Oracle_Reference (input : Qubit[], target : Qubit) : Unit is Adj {
        use counter = Qubit[2];
        within {
            for q in input { // The iteration order doesn't matter
                Controlled IncrementMod3([q], counter);
            }
        } apply {
            // divisible by 3 only if the result is divisible by 3
            ControlledOnInt(0, X)(counter, target);
        }
    }


    // Task 10. Is the number divisible by 3?
    operation DivisibleBy3Oracle_Reference (input : Qubit[], target : Qubit) : Unit is Adj {
    use counter = Qubit[2];
        within {
            for i in 0 .. Length(input) - 1 { // Iterate starting from the least significant bit
                if i % 2 == 0 {
                    // i-th power of 2 is 1 mod 3
                    Controlled IncrementMod3([input[i]], counter);
                } else {
                    // i-th power of 2 is 2 mod 3 - same as -1, which is Adjoint of +1
                    Controlled Adjoint IncrementMod3([input[i]], counter);
                }
            }
        } apply {
            // divisible by 3 only if the result is divisible by 3
            ControlledOnInt(0, X)(counter, target);
        }
    }
}
