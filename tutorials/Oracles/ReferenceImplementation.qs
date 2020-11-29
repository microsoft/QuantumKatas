// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;



    //////////////////////////////////////////////////////////////////
    // Part I. Introduction to Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Exercise 1.
    function Is_Seven_Reference(x: String) : Bool {
        // ...
        return false;
    }

    // Exercise 2.
    operation Phase_7_Oracle_Reference(x : Qubit[]) : Unit 
    is Adj {
        Controlled Z(x[0..Length(x)-2], x[Length(x)-1]);
    }

    // Exercise 3.
    operation Marking_7_Oracle_Reference(x: Qubit[], y: Qubit) : Unit
    is Adj {
        Controlled X(x, y);
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Phase Kickback
    //////////////////////////////////////////////////////////////////

    // _ is partial application
    // 
    // https://en.wikipedia.org/wiki/Partial_application

    // Exercise 4.
    operation Apply_Phase_Oracle_Reference(markingOracle: ((Qubit[], Qubit) => Unit is Adj), qubits: Qubit[]) : Unit
    is Adj {
        using (minus = Qubit()) {
            within {
                X(minus);
                H(minus);
            } apply {
                markingOracle(qubits, minus);
            }
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Implementing Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Controlled Z(x[:n-2], x[n-1])
    // Controlled Z(x[...n-2])
    // Array function Most: https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arrays.most
    // 
    // https://docs.microsoft.com/en-us/quantum/user-guide/language/expressions#array-slices

    // Exercise 5.
    operation Or_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj {
        within {
            for (q in x) {
                X(q);
            }
        } apply {
            X(y);  // flip y
            Controlled X(x, y);  // flip y again if input x was all zeros
        }
    }

    // Exercise 6.
    operation kth_Spin_Up_Reference(x: Qubit[], k: Int) : Unit 
    is Adj {
        // ...

    }

    // Exercise 7.
    operation kth_Excluded_Or_Reference(x: Qubit[], k: Int) : Unit
    is Adj {
        // ...
    }

    //////////////////////////////////////////////////////////////////
    // Part IV. More Oracles! Implementation and Testing
    //////////////////////////////////////////////////////////////////

    // Exercise 8.
    operation Arbitrary_Pattern_Oracle_Reference(x: Qubit[], y: Qubit, b: Bool[]) : Unit 
    is Adj {
        // ...
    }

    // Exercise 9.
    operation Meeting_Oracle_Reference(x: Qubit[], jasmine: Qubit[], z: Qubit) : Unit 
    is Adj {
        // ...
    }
}