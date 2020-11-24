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

    function Is_Seven_Reference(x: String) : Bool {
        Message("Implement me!");
    }

    operation Phase_7_Oracle_Reference(x : Qubit[]) : Unit 
    is Adj {
        Message("Implement me!");
    }

    operation Marking_7_Oracle_Reference(x: Qubit[], y: Qubit) : Unit
    is Adj {
        Controlled X(x, y);
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Phase Kickback
    //////////////////////////////////////////////////////////////////

    function Oracle_Converter_Reference(markingOracle: ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        return ConstructPhaseOracle_Reference(markingOracle, _);
    }

    operation ConstructPhaseOracle_Reference(markingOracle: ((Qubit[], Qubit) => Unit is Adj), qubits: Qubit[]) : Unit
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

    operation kth_Spin_Up(x: Qubit[], k: Int) : Unit 
    is Adj {
        Message("Implement me!");
    }

    operation Alternating_2_Oracle(x: Qubit[]) : Unit
    is Adj {
        Message("Implement me!");
    }

    operation Or_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj {
        for (q in x) {
            X(x);
        }

        X(y);  // flip y
        Controlled X(x, y);  // flip y again if input x was all zeros

        for (q in x) {
            X(x);  // undo changes to input
        }
    }
}