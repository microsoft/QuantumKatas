// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in Deutsch-Jozsa algorithm tutorial.
// We strongly recommend to use the Notebook version of the tutorial
// to enjoy the full experience.
//////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Oracles {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    //////////////////////////////////////////////////////////////////
    // Part I. Introduction to Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Exercise 1.
    function Is_Seven(x: Bool[]) : Bool {
        // ...
        return false;
    }

    // Exercise 2.
    operation Phase_7_Oracle (x : Qubit[]) : Unit 
    is Adj + Ctl {
        // ...
    }

    // Exercise 3.
    operation Marking_7_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj + Ctl {
        // ...
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Phase Kickback
    //////////////////////////////////////////////////////////////////

    // Exercise 4.
    operation Apply_Phase_Oracle(markingOracle: ((Qubit[], Qubit) => Unit is Adj + Ctl), qubits: Qubit[]) : Unit
    is Adj + Ctl {
        // ...
    }

    function Oracle_Converter(markingOracle: ((Qubit[], Qubit) => Unit is Adj + Ctl)) : (Qubit[] => Unit is Adj + Ctl) {
        return Apply_Phase_Oracle(markingOracle, _);
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Implementing Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Exercise 5.
    operation Or_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj + Ctl {
        // ...
    }

    // Exercise 6.
    operation kth_Spin_Up(x: Qubit[], k: Int) : Unit 
    is Adj + Ctl {
        // ...
    }

    // Exercise 7.
    operation kth_Excluded_Or(x: Qubit[], k: Int) : Unit
    is Adj + Ctl {
        // ...
    }

    //////////////////////////////////////////////////////////////////
    // Part IV. More Oracles! Implementation and Testing
    //////////////////////////////////////////////////////////////////

    // Exercise 8.
    operation Arbitrary_Pattern_Oracle(x: Qubit[], y: Qubit, pattern: Bool[]) : Unit 
    is Adj + Ctl {
        // ...
    }

    // Exercise 9.
    operation Arbitrary_Pattern_Oracle_Challenge(x: Qubit[], pattern: Bool[]) : Unit 
    is Adj + Ctl {
        // ...
    }

    // Exercise 10.
    operation Meeting_Oracle(x: Qubit[], jasmine: Qubit[], z: Qubit) : Unit 
    is Adj + Ctl {
        // ...
    }
}