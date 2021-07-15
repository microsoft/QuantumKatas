// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.RippleCarryAdder {
    
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Simple adder outputting to empty Qubits
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. Summation of two bits
    operation LowestBitSum_Reference (a : Qubit, b : Qubit, sum : Qubit) : Unit is Adj {
        CNOT(a, sum);
        CNOT(b, sum);
    }


    // Task 1.2. Carry of two bits
    operation LowestBitCarry_Reference (a : Qubit, b : Qubit, carry : Qubit) : Unit is Adj {
        CCNOT(a, b, carry);
    }


    // Task 1.3. One-bit adder
    operation OneBitAdder_Reference (a : Qubit, b : Qubit, sum : Qubit, carry : Qubit) : Unit is Adj {
        LowestBitSum_Reference(a, b, sum);
        LowestBitCarry_Reference(a, b, carry);
    }


    // Task 1.4. Summation of 3 bits
    operation HighBitSum_Reference (a : Qubit, b : Qubit, carryin : Qubit, sum : Qubit) : Unit is Adj {
        CNOT(a, sum);
        CNOT(b, sum);
        CNOT(carryin, sum);
    }


    // Task 1.5. Carry of 3 bits
    operation HighBitCarry_Reference (a : Qubit, b : Qubit, carryin : Qubit, carryout : Qubit) : Unit is Adj {
        CCNOT(a, b, carryout);
        CCNOT(a, carryin, carryout);
        CCNOT(b, carryin, carryout);
    }


    // Task 1.6. Two-bit adder
    operation TwoBitAdder_Reference (a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit) : Unit is Adj {
        use internalCarry = Qubit();
        LowestBitSum_Reference(a[0], b[0], sum[0]);
        LowestBitCarry_Reference(a[0], b[0], internalCarry);

        HighBitSum_Reference(a[1], b[1], internalCarry, sum[1]);
        HighBitCarry_Reference(a[1], b[1], internalCarry, carry);

        // Clean up ancillary qubit
        Adjoint LowestBitCarry_Reference(a[0], b[0], internalCarry);
    }


    // Task 1.7. N-bit adder
    operation ArbitraryAdder_Reference (a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit) : Unit is Adj {
        let N = Length(a);
        if (N == 1) {
            LowestBitSum_Reference(a[0], b[0], sum[0]);
            LowestBitCarry_Reference(a[0], b[0], carry);
        }
        else {
            use internalCarries = Qubit[N-1];
            LowestBitSum_Reference(a[0], b[0], sum[0]);
            LowestBitCarry_Reference(a[0], b[0], internalCarries[0]);
                
            for i in 1 .. N-2 {
                HighBitSum_Reference(a[i], b[i], internalCarries[i-1], sum[i]);
                HighBitCarry_Reference(a[i], b[i], internalCarries[i-1], internalCarries[i]);
            }

            HighBitSum_Reference(a[N-1], b[N-1], internalCarries[N-2], sum[N-1]);
            HighBitCarry_Reference(a[N-1], b[N-1], internalCarries[N-2], carry);

            // Clean up the ancillary qubits
            for i in N-2 .. -1 .. 1 {
                Adjoint HighBitCarry_Reference(a[i], b[i], internalCarries[i-1], internalCarries[i]);
            }
            Adjoint LowestBitCarry_Reference(a[0], b[0], internalCarries[0]);
        }
    }


    // A slightly simpler solution - more uniform, but slightly slower, and requires one extra qubit
    operation ArbitraryAdder_Simplified_Reference (a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit) : Unit is Adj {
        let N = Length(a);
        use internalCarries = Qubit[N];
        let carries = internalCarries + [carry];
        for i in 0 .. N-1 {
            HighBitSum_Reference(a[i], b[i], carries[i], sum[i]);
            HighBitCarry_Reference(a[i], b[i], carries[i], carries[i+1]);
        }

        // Clean up the ancilla
        for i in N-2 .. -1 .. 0 {
            Adjoint HighBitCarry_Reference(a[i], b[i], carries[i], carries[i+1]);
        }
    }


    // The challenge solution - the sum qubits are used to store the carry bits, and the sum is calculated as they get cleaned up
    operation ArbitraryAdder_Challenge_Reference (a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit) : Unit is Adj {
        let N = Length(a);

        // Calculate carry bits
        LowestBitCarry_Reference(a[0], b[0], sum[0]);
        for i in 1 .. N-1 {
            HighBitCarry_Reference(a[i], b[i], sum[i - 1], sum[i]);
        }
        CNOT(sum[N-1], carry);

        // Clean sum qubits and compute sum
        for i in N-1 .. -1 .. 1 {
            Adjoint HighBitCarry_Reference(a[i], b[i], sum[i - 1], sum[i]);
            HighBitSum_Reference(a[i], b[i], sum[i - 1], sum[i]);
        }
        Adjoint LowestBitCarry_Reference(a[0], b[0], sum[0]);
        LowestBitSum_Reference(a[0], b[0], sum[0]);
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Simple in-place adder
    //////////////////////////////////////////////////////////////////

    // Task 2.1. In-place summation of two bits
    operation LowestBitSumInPlace_Reference (a : Qubit, b : Qubit) : Unit is Adj {
        CNOT(a, b);
    }


    // Task 2.2. In-place one-bit adder
    operation OneBitAdderInPlace_Reference (a : Qubit, b : Qubit, carry : Qubit) : Unit is Adj {
        LowestBitCarry_Reference(a, b, carry);
        LowestBitSumInPlace_Reference(a, b);
    }


    // Task 2.3. In-place summation of three bits
    operation HighBitSumInPlace_Reference (a : Qubit, b : Qubit, carryin : Qubit) : Unit is Adj {
        CNOT(a, b);
        CNOT(carryin, b);
    }


    // Task 2.4. In-place two-bit adder
    operation TwoBitAdderInPlace_Reference (a : Qubit[], b : Qubit[], carry : Qubit) : Unit is Adj {
        use internalCarry = Qubit();
        // Set up the carry bits
        LowestBitCarry_Reference(a[0], b[0], internalCarry);
        HighBitCarry_Reference(a[1], b[1], internalCarry, carry);
            
        // Calculate sums and clean up the ancilla
        HighBitSumInPlace_Reference(a[1], b[1], internalCarry);
        Adjoint LowestBitCarry_Reference(a[0], b[0], internalCarry);
        LowestBitSumInPlace_Reference(a[0], b[0]);
    }


    // Task 2.5. In-place N-bit adder
    operation ArbitraryAdderInPlace_Reference (a : Qubit[], b : Qubit[], carry : Qubit) : Unit is Adj {
        let N = Length(a);

        use internalCarries = Qubit[N];
        // Set up the carry bits
        LowestBitCarry_Reference(a[0], b[0], internalCarries[0]);
        for i in 1 .. N-1 {
            HighBitCarry_Reference(a[i], b[i], internalCarries[i - 1], internalCarries[i]);
        }
        CNOT(internalCarries[N-1], carry);

        // Clean up carry bits and compute sum
        for i in N-1 .. -1 .. 1 {
            Adjoint HighBitCarry_Reference(a[i], b[i], internalCarries[i - 1], internalCarries[i]);
            HighBitSumInPlace_Reference(a[i], b[i], internalCarries[i - 1]);
        }
        Adjoint LowestBitCarry_Reference(a[0], b[0], internalCarries[0]);
        LowestBitSumInPlace_Reference(a[0], b[0]);
    }

    
    //////////////////////////////////////////////////////////////////
    // Part III*. Improved in-place adder
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Majority gate
    operation Majority_Reference (a : Qubit, b : Qubit, c : Qubit) : Unit is Adj {
        CNOT(a, b);
        CNOT(a, c);
        CCNOT(b, c, a);
    }

    
    // Task 3.2. UnMajority and Add gate
    operation UnMajorityAdd_Reference (a : Qubit, b : Qubit, c : Qubit) : Unit is Adj {
        CCNOT(b, c, a);
        CNOT(a, c);
        CNOT(c, b);
    }


    // Task 3.3. One-bit majority-UMA adder
    operation OneBitMajUmaAdder_Reference (a : Qubit, b : Qubit, carry : Qubit) : Unit is Adj {
        use tempCarry = Qubit();
        Majority_Reference(a, b, tempCarry);
        CNOT(a, carry);
        UnMajorityAdd_Reference(a, b, tempCarry);
    }

    
    // Task 3.4. Two-bit majority-UMA adder
    operation TwoBitMajUmaAdder_Reference (a : Qubit[], b : Qubit[], carry : Qubit) : Unit is Adj {
        use tempCarry = Qubit();
        // We only need the extra qubit so we have 3 to pass to the majority gate for the lowest bits
        Majority_Reference(a[0], b[0], tempCarry);
        Majority_Reference(a[1], b[1], a[0]);

        // Save last carry bit
        CNOT(a[1], carry);

        // Restore inputs/ancilla and compute sum
        UnMajorityAdd_Reference(a[1], b[1], a[0]);
        UnMajorityAdd_Reference(a[0], b[0], tempCarry);
    }

    
    // Task 3.5. N-bit majority-UMA adder
    operation ArbitraryMajUmaAdder_Reference (a : Qubit[], b : Qubit[], carry : Qubit) : Unit is Adj {
        let N = Length(a);
        
        use tempCarry = Qubit();
        let carries = [tempCarry] + a;

        // Compute carry bits
        for i in 0 .. N-1 {
            Majority_Reference(a[i], b[i], carries[i]);
        }

        // Save last carry bit
        CNOT(carries[N], carry);

        // Restore inputs and ancilla, compute sum
        for i in N-1 .. -1 .. 0 {
            UnMajorityAdd_Reference(a[i], b[i], carries[i]);
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part IV*. In-place subtractor
    //////////////////////////////////////////////////////////////////

    // Task 4.1. N-bit subtractor
    operation Subtractor_Reference (a : Qubit[], b : Qubit[], borrowBit : Qubit) : Unit is Adj {
        // transform b into 2ᴺ - 1 - b
        ApplyToEachA(X, b);

        // compute (2ᴺ - 1 - b) + a = 2ᴺ - 1 - (b - a) using existing adder
        // if this produced a carry, then (2ᴺ - 1 - (b - a)) > 2ᴺ - 1, so (b - a) < 0, and we need a borrow
        // this means we can use the carry qubit from the addition as the borrow qubit
        ArbitraryMajUmaAdder_Reference(a, b, borrowBit);

        // transform 2ᴺ - 1 - (b - a) into b - a
        ApplyToEachA(X, b);
    }
    
    //////////////////////////////////////////////////////////////////
    // Part V. Addition and subtraction modulo 2ᴺ
    //////////////////////////////////////////////////////////////////

    // Task 5.1. Adder Modulo 2ᴺ
    operation AdderModuloN_Reference (a : Qubit[], b : Qubit[], sum : Qubit[]) : Unit is Adj {
        // Modification of challenge solution of task 1.7 (last carry bit isn't calculated).
        // Sum qubits are used to store the carry bits, and the sum is calculated as they get cleaned up.
        // (It's also possible to use a similar modification of regular solution of task 1.7.)
        
        let N = Length(a);

        // Calculate carry bits and Store them in Sum
        LowestBitCarry_Reference(a[0], b[0], sum[0]);
        for i in 1 .. N-1 {
            HighBitCarry_Reference(a[i], b[i], sum[i - 1], sum[i]);
        }
        // No need to calculated last (N+1)th carry bit, as addition is modulo 2ᴺ.
        
        // Clean sum qubits (uncompute carries after they aren't needed) and compute sum
        for i in N-1 .. -1 .. 1 {
            Adjoint HighBitCarry_Reference(a[i], b[i], sum[i - 1], sum[i]); // Restore sum[i] to state 0
            HighBitSum_Reference(a[i], b[i], sum[i - 1], sum[i]); // Compute sum[i]
        }
        Adjoint LowestBitCarry_Reference(a[0], b[0], sum[0]); // Restore sum[0] to state 0
        LowestBitSum_Reference(a[0], b[0], sum[0]); // Compute sum[i]
    }
    

    // Task 5.2. Two's Complement
    operation TwosComplement_Reference (a : Qubit[]) : Unit is Adj {
        // Transform a into 2ᴺ - 1 - a ("one's complement")
        ApplyToEachA(X, a);
        
        // Increment mod 2ᴺ.
        // Since we are incrementing by 1, we flip the next most significant bit only if all previous bits are 0.
        for prefix in Prefixes(a) {
            (ControlledOnInt(0, X))(Most(prefix), Tail(prefix));
        }
    }


    // Task 5.3. Subtractor Modulo 2ᴺ
    operation SubtractorModuloN_Reference (a : Qubit[], b : Qubit[], diff : Qubit[]) : Unit is Adj {
        within {
            // Transform a into its Two's Complement 2ᴺ - a 
            TwosComplement_Reference(a);
        } apply {
            // Add 2ᴺ - a and b to get (2ᴺ + b - a) mod 2ᴺ = (b-a) mod 2ᴺ 
            AdderModuloN_Reference(a, b, diff);
        }
    }
    

    // Task 5.4. In-place adder modulo 2ᴺ
    operation InPlaceAdderModuloN_Reference (a : Qubit[], b : Qubit[]) : Unit is Adj {
        // Modification of task 3.5 solution (last carry bit isn't calculated)    
        use tempCarry = Qubit();
        let carries = [tempCarry] + a;

        // Compute carry bits
        ApplyToEachA(Majority_Reference, Zipped3(a, b, carries));
            
        // No need to save last (N+1)th carry bit
            
        // Restore inputs and ancilla, compute sum
        ApplyToEachA(UnMajorityAdd_Reference, Reversed(Zipped3(a, b, carries)));
    }
    

    // Task 5.5. In-place subtractor modulo 2ᴺ
    operation InPlaceSubtractorModuloN_Reference (a : Qubit[], b : Qubit[]) : Unit is Adj {
        // Notice that Task 5.4 is actually the Adjoint of Task 5.3. 
        // Task 5.3 maps (a,b) -> (a,(a+b)mod2ᴺ). Let c = (a+b)mod2ᴺ
        // Task 5.4 maps (a,b) -> (a,(b-a)mod2ᴺ). So Task 5.4 will maps (a,c) -> (a,(c-a)mod2ᴺ) = (a,((a+b)mod2ᴺ-a)mod2ᴺ) = (a,b).
        Adjoint InPlaceAdderModuloN_Reference(a, b);
    }
}
