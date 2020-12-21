// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in Quantum Oracles tutorial.
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

    // Task 1.1.
    function IsSeven (x : Bool[]) : Bool {
        // ...
        return false;
    }

    // Task 1.2.
    operation IsSeven_PhaseOracle (x : Qubit[]) : Unit is Adj + Ctl {
        // ...
    }

    // Task 1.3.
    operation IsSeven_MarkingOracle (x : Qubit[], y : Qubit) : Unit is Adj + Ctl {
        // ...
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Phase Kickback
    //////////////////////////////////////////////////////////////////

    // Task 2.1.
    operation ApplyMarkingOracleAsPhaseOracle (markingOracle : ((Qubit[], Qubit) => Unit is Adj + Ctl), qubits : Qubit[]) : Unit is Adj + Ctl {
        // ...
    }

    function Oracle_Converter (markingOracle : ((Qubit[], Qubit) => Unit is Adj + Ctl)) : (Qubit[] => Unit is Adj + Ctl) {
        return ApplyMarkingOracleAsPhaseOracle(markingOracle, _);
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Implementing Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Task 3.1.
    operation Or_Oracle (x : Qubit[], y : Qubit) : Unit is Adj + Ctl {
        // ...
    }

    // Task 3.2.
    operation KthBit_Oracle (x : Qubit[], k : Int) : Unit is Adj + Ctl {
        // ...
    }

    // Task 3.3
    operation OrOfBitsExceptKth_Oracle (x : Qubit[], k : Int) : Unit is Adj + Ctl {
        // ...
    }

    //////////////////////////////////////////////////////////////////
    // Part IV. More Oracles! Implementation and Testing
    //////////////////////////////////////////////////////////////////

    // Task 4.1.
    operation ArbitraryBitPattern_Oracle (x : Qubit[], y : Qubit, pattern : Bool[]) : Unit is Adj + Ctl {
        // ...
    }

    // Task 4.2.
    operation ArbitraryBitPattern_Oracle_Challenge (x : Qubit[], pattern : Bool[]) : Unit is Adj + Ctl {
        // ...
    }

    // Task 4.3.
    operation Meeting_Oracle (x : Qubit[], jasmine : Qubit[], z : Qubit) : Unit is Adj + Ctl {
        // ...
    }
}
