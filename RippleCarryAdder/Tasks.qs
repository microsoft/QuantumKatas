namespace Quantum.Kata.Arithmetic {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // We first look at the simplest case of an RCA circuit: addition of two one bit numbers. We split
    // the circuit into two operations: outputting the carry bit and the sum of the bits. 
    // We build on this by first considering the case of RCA of two two-bit numbers as well as a generalized one bit adder, 
    // and then finally a fully fleshed out n-bit RCA circuit. 
    // We also show how to convert an RCA circuit into a subtraction circuit.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    //////////////////////////////////////////////////////////////////
    // Part I: One bit RCA
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Carry bit for one bit addition
    // Inputs:
        // 1) a qubit in arbitrary state |Φ⟩
        // 2) a qubit in arbitrary state |ψ⟩
        // 3) a qubit in |0⟩ state.
    // Goal:
        // Determine the carry bit (flag) of |Φ⟩ + |ψ⟩ and store it in the carry qubit.
        // That is, if the sum of |Φ⟩ ,|ψ⟩  would overflow into a new bit, set the carry bit to |1⟩. 
    operation oneBitCarry(a : Qubit, b : Qubit, carry : Qubit) : Unit {
        body (...) {
            // ...
        }
        controlled auto;
        adjoint auto;
        controlled adjoint auto;
    }

    // Task 1.2. Sum of two qubits
    // Inputs:
        // 1) a qubit in arbitrary state |Φ⟩
        // 2) a qubit in arbitrary state |ψ⟩
        // 3) a qubit in |0⟩ state.
    // Goal:
        // Determine the sum of |Φ⟩ ,|ψ⟩ and store it in the sum qubit.
        // If the sum would overflow into a new bit, set sum to |0⟩.
    operation oneBitSum(a : Qubit, b : Qubit, sum : Qubit) : Unit {
        body (...) {
            // ...
        }
        controlled auto;
        adjoint auto;
        controlled adjoint auto;
    }

    // Task 1.3. One qubit RCA
    // Inputs:
        // 1) a qubit in arbitrary state |Φ⟩
        // 2) a qubit in arbitrary state |ψ⟩
        // 3) a qubit in |0⟩ state.
        // 4) a qubit in |0⟩ state.
    // Goal:
        // Determine both the carry flag and the sum of |Φ⟩ ,|ψ⟩ 
        // and store it in the carry and sum qubits respectively.
        // If the sum would overflow into a new bit, set sum to |0⟩ and carry to |1⟩.
    operation oneBitRCA(a : Qubit, b : Qubit, sum : Qubit, carry : Qubit) : Unit {
        body (...) {
            // ...
        }
        controlled auto;
        adjoint auto;
        controlled adjoint auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part II: Two bit RCA + subtraction
    //////////////////////////////////////////////////////////////////

    // Task 2.1. One bit carry for arbritary input carry bit.
    // Inputs:
        // 1) a qubit in arbitrary state |Φ⟩
        // 2) a qubit in arbitrary state |ψ⟩
        // 3) a qubit in an arbitrary state.
        // 3) a qubit in |0⟩ state.
    // Goal:
        // Determine the carry flag of |Φ⟩ ,|ψ⟩ , along with an input carry bit called carryin.
        // Thus to determine the output carry flag, carry out, you need to consider the sum of a, b and carryin.
        // Store the result in carryout.
    operation oneBitCarryArbitrary(a : Qubit, b : Qubit, carryin : Qubit, carryout : Qubit) : Unit {
        body (...) {
            // ...
        }
        controlled auto;
        adjoint auto;
        controlled adjoint auto;
    }

    // Task 2.2. One bit sum for arbitrary input carry bit. 
    // Inputs:
        // 1) a qubit in arbitrary state |Φ⟩
        // 2) a qubit in arbitrary state |ψ⟩
        // 3) a qubit in an arbitrary state.
        // 3) a qubit in |0⟩ state.
    // Goal:
        // Determine the sum of |Φ⟩ ,|ψ⟩ , along with an input carry bit called carryin.
        // Thus to determine the sum, you need to consider the sum of a, b and carryin.
        // Store the result in sum.
    operation oneBitSumArbitrary(a : Qubit, b : Qubit, carryin: Qubit, sum : Qubit) : Unit {
        body (...) {
            // ...
        }
        controlled auto;
        adjoint auto;
        controlled adjoint auto;
    }

    // Task 2.3. RCA for two qubit registers
    // Inputs: 
        // 1) a two qubit register in arbitrary state |Φ⟩
        // 2) a two qubit register in arbitrary state |ψ⟩
        // 3) a qubit register in |00⟩ state.
        // 4) a qubit in |0⟩ state.
    // Goal:
        // Determine both the carry flag and the sum of |Φ⟩ ,|ψ⟩.
        // The registers are little endian (that is, a[0] and b[0]
        // are the least significant bit).
        // Store the carry flag and sum it in the carry and sum qubits respectively.
        // If the sum would overflow into a new bit, set sum[1] to |0⟩ and carry to |1⟩.
    operation twoBitRCA(a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit) : Unit {
        body (...) {
            // ...
        }
        controlled auto;
        adjoint auto;
        controlled adjoint auto;
    }

    // Task 2.4. Subtraction for two qubit registers.
    // Inputs:
        // 1) a 2 qubit register in arbitrary state |Φ⟩
        // 2) a 2 qubit register in arbitrary state |ψ⟩
        // 3) a 2 qubit register in |00⟩ state.
    // Goal:
        // Detemine |Φ⟩ -  |ψ⟩ and store it in diff. Leave a and b unchanged. 
    operation twoBitSubtraction(a : Qubit[], b : Qubit[], diff : Qubit[]): Unit {
        body (...) {
            // ...
            // Hint: Note that a - b = (a' + b)' where ' is the complement of a register.
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part III: N bit RCA + subtraction
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Carry flag for n qubit registers 
    // Inputs:
        // 1) an n qubit register in arbitrary state |Φ⟩
        // 2) an n qubit register in arbitrary state |ψ⟩
        // 3) a qubit in |0⟩ state.
    // Goal:
        // Determine the carry flag for the sum of |Φ⟩ ,|ψ⟩.
        // That is, if the sum would overflow into a new bit, set carry to |1⟩.
    operation nBitCarry(a : Qubit[], b : Qubit[], carry : Qubit) : Unit {
        body (...) {
            // ...
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Task 3.2. Sum for n qubit registers
    // Inputs:
        // 1) an n qubit register in arbitrary state |Φ⟩
        // 2) an n qubit register in arbitrary state |ψ⟩
        // 3) an n qubit register in |00..0⟩ state.
    // Goal:
        // Determine the sum of |Φ⟩ ,|ψ⟩, where those registers are
        // little endian (a[0] and b[0] are the least significant bit).
        // The sum should truncate if it's too large to be represented by n qubits.
    operation nBitSum(a : Qubit[], b : Qubit[], sum : Qubit[]) : Unit {
        body (...) {
            // ...
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Task 3.3. RCA for n qubit registers.
    // Inputs:
        // 1) an n qubit register in arbitrary state |Φ⟩
        // 2) an n qubit register in arbitrary state |ψ⟩
        // 3) an n qubit register in |00..0⟩ state.
        // 4) a qubit in |0⟩ state.
    // Goal:
        // Determine the sum and carry of the registers |Φ⟩ ,|ψ⟩.
        // The registers are little endian (that is, their element at 0 is the 
        // least significant bit).
    operation nBitRCA(a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit) : Unit {
        body (...) {
            // ...
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Task 3.4. Subtraction for n qubit registers.
    // Inputs:
        // 1) an n qubit register in arbitrary state |Φ⟩
        // 2) an n qubit register in arbitrary state |ψ⟩
        // 3) an n qubit register in |00..0⟩ state.
    // Goal:
        // Detemine |Φ⟩ -  |ψ⟩ and store it in diff. 
    operation nBitSubtraction(a : Qubit[], b : Qubit[], diff : Qubit[]): Unit {
        body (...) {
            // ...
            // Hint: Note that a - b = (a' + b)' where ' is the complement of a register.
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}