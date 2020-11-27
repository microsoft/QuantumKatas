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
        Message("Implement me!");
    }

    // Exercise 3.
    operation Marking_7_Oracle_Reference(x: Qubit[], y: Qubit) : Unit
    is Adj {
        Controlled X(x, y);
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Phase Kickback
    //////////////////////////////////////////////////////////////////

    // Exercise 4.
    function Oracle_Converter_Reference(markingOracle: ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        // _ is partial application
        // 
        // https://en.wikipedia.org/wiki/Partial_application

        return ConstructPhaseOracle_Reference(markingOracle, _);
    }

    operation ConstructPhaseOracle_Reference(markingOracle: ((Qubit[], Qubit) => Unit is Adj), qubits: Qubit[]) : Unit
    is Adj {
        using (minus = Qubit()) {
            // within - apply
            // this block tells you to first do the within block, then do the apply
            // then do the adjoint of the within block.
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
        for (q in x) {
            X(q);
        }

        X(y);  // flip y
        Controlled X(x, y);  // flip y again if input x was all zeros

        for (q in x) {
            X(q);  // undo changes to input
        }
    }

    // Exercise 6.
    operation kth_Spin_Up(x: Qubit[], k: Int) : Unit 
    is Adj {
        // ...

    }

    // Exercise 7.
    operation kth_Excluded_Or(x: Qubit[], k: Int) : Unit
    is Adj {
        // ...
    }
}