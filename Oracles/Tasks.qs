// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Oracles {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    //////////////////////////////////////////////////////////////////
    // Part I. Introduction to Quantum Oracles
    //////////////////////////////////////////////////////////////////

    function Is_Seven(x: String) : Bool {
        Message("Implement me!");
    }

    operation Phase_7_Oracle (x : Qubit[]) : Unit 
    is Adj {
        Message("Implement me!");
    }

    operation Marking_7_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj {
        Message("Implement me!");
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Phase Kickback
    //////////////////////////////////////////////////////////////////

    function Oracle_Converter(markingOracle: ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        Message("Implement me!");
        //return ConstructPhaseOracle(markingOracle, _);
    }

    // operation ConstructPhaseOracle(markingOracle: ((Qubit[], Qubit) => Unit is Adj), qubits: Qubit[]) : Unit
    // is Adj {
    //     using (minus = Qubit()) {
    //         within {
    //             X(minus);
    //             H(minus);
    //         } apply {
    //             markingOracle(qubits, minus);
    //         }
    //     }
    // }

    //////////////////////////////////////////////////////////////////
    // Part III. Implementing Quantum Oracles
    //////////////////////////////////////////////////////////////////

    operation Alternating_1_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj {
        Message("Implement me!");
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
        Message("Implement me!");
    }
}