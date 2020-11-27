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
    function Is_Seven(x: String) : Bool {
        // ...
        return false;
    }

    // Exercise 2.
    operation Phase_7_Oracle (x : Qubit[]) : Unit 
    is Adj {
        // ...
    }

    // Exercise 3.
    operation Marking_7_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj {
        // ...
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Phase Kickback
    //////////////////////////////////////////////////////////////////

    // Exercise 4.
    function Oracle_Converter(markingOracle: ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        // ...
        // Right now we return this function to allow this function to compile.
        // This return statement will have to be replaced with your own implementation.
        return Phase_7_Oracle;
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Implementing Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Exercise 5.
    operation Or_Oracle(x: Qubit[], y: Qubit) : Unit
    is Adj {
        // ...
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