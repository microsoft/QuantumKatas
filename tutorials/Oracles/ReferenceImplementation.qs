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

    // Exercise 5.
    operation Alternating_1_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj {
        for (i in IndexRange(x)) {
            if (i % 2 == 0) {  // flip even values
                X(x[i]);
            }
        }

        Controlled X(x, y);

        for (q in x) {
            X(q);  // undo even flips and flip the odds
        }
        
        Controlled X(x, y);

        for (i in IndexRange(x)) {
            if (i % 2 == 1) {  // undo odd flips
                X(x[i]);
            }
        }
    }

    // Exercise 6.
    operation kth_Spin_Up(x: Qubit[], k: Int) : Unit 
    is Adj {
        // number of the form | x_n, x_n-1, ..., x_2, x_1>
        Message("Implement me!");
    }

    // Exercise 7.
    operation Alternating_2_Oracle(x: Qubit[]) : Unit
    is Adj {
        for (i in IndexRange(x)) {
            if (i % 2 == 0) {  // flip even values
                X(x[i]);
            }
        }

        using (one = Qubit()) {
            X(one);
            Controlled Z(x, one);
            X(one);
        }

        // Controlled Z(x[:n-2], x[n-1])
        // Controlled Z(x[...n-2])
        // Array function Most: https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arrays.most
        // 
        // https://docs.microsoft.com/en-us/quantum/user-guide/language/expressions#array-slices


        for (q in x) {
            X(q);  // undo even flips and flip the odds
        }

        using (one = Qubit()) {
            X(one);
            Controlled Z(x, one);
            X(one);
        }

        for (i in IndexRange(x)) {
            if (i % 2 == 1) {  // undo odd flips
                X(x[i]);
            }
        }
    }

    // Exercise 8.
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
}