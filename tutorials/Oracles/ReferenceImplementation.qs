// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Oracles {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;


    //////////////////////////////////////////////////////////////////
    // Part I. Introduction to Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Task 1.1.
    function IsSeven_Reference (x : Bool[]) : Bool {
        return BoolArrayAsInt(x) == 7;
    }

    // Task 1.2.
    operation IsSeven_PhaseOracle_Reference (x : Qubit[]) : Unit is Adj + Ctl {
        Controlled Z(Most(x), Tail(x));
    }

    // Task 1.3.
    operation IsSeven_MarkingOracle_Reference (x : Qubit[], y : Qubit) : Unit is Adj + Ctl {
        Controlled X(x, y);
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Phase Kickback
    //////////////////////////////////////////////////////////////////

    // Task 2.1.
    operation ApplyMarkingOracleAsPhaseOracle_Reference (markingOracle : ((Qubit[], Qubit) => Unit is Adj + Ctl), qubits : Qubit[]) : Unit is Adj + Ctl {
        use minus = Qubit();
        within {
            X(minus);
            H(minus);
        } apply {
            markingOracle(qubits, minus);
        }
    }

    function Oracle_Converter_Reference (markingOracle : ((Qubit[], Qubit) => Unit is Adj + Ctl)) : (Qubit[] => Unit is Adj + Ctl) {
        return ApplyMarkingOracleAsPhaseOracle_Reference(markingOracle, _);
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Implementing Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Task 3.1.
    operation Or_Oracle_Reference (x : Qubit[], y : Qubit) : Unit is Adj + Ctl {
        X(y);
        (ControlledOnInt(0, X))(x, y);
    }

    // Task 3.2.
    operation KthBit_Oracle_Reference (x : Qubit[], k : Int) : Unit is Adj + Ctl {
        Z(x[k]);
    }

    // Task 3.3.
    operation OrOfBitsExceptKth_Oracle_Reference (x : Qubit[], k : Int) : Unit is Adj + Ctl {
        use minus = Qubit();
        within {
            X(minus);
            H(minus);
        } apply {
            Or_Oracle_Reference(x[...k-1] + x[k+1...], minus);
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part IV. More Oracles! Implementation and Testing
    //////////////////////////////////////////////////////////////////

    // Task 4.1.
    operation ArbitraryBitPattern_Oracle_Reference (x : Qubit[], y : Qubit, pattern : Bool[]) : Unit  is Adj + Ctl {
        let PatternOracle = ControlledOnBitString(pattern, X);
        PatternOracle(x, y);
    }

    // Task 4.2.
    operation ArbitraryBitPattern_Oracle_Challenge_Reference (x : Qubit[], pattern : Bool[]) : Unit is Adj + Ctl {
        within {
            for i in IndexRange(x) {
                if (not pattern[i]) {
                    X(x[i]);
                }
            }
        } apply {
            Controlled Z(Most(x), Tail(x));
        }
    }

    // Task 4.3.
    operation Meeting_Oracle_Reference (x : Qubit[], jasmine : Qubit[], z : Qubit) : Unit is Adj + Ctl {
        use q = Qubit[Length(x)];
        within {
            for i in IndexRange(q) {
                // flip q[i] if both x and jasmine are free on the given day
                X(x[i]);
                X(jasmine[i]);
                CCNOT(x[i], jasmine[i], q[i]);
            }
        } apply {
            Or_Oracle_Reference(q, z);
        }
    }
}
