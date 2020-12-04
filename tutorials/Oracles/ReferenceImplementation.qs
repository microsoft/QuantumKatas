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
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;


    //////////////////////////////////////////////////////////////////
    // Part I. Introduction to Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Exercise 1.
    function Is_Seven_Reference(x: Bool[]) : Bool {
        let n = Length(x);

        if (n < 3) {
            return false;
        }

        for (i in IndexRange(x)) {
            if (i == n-1 or i == n-2 or i == n-3) {
                if (not x[i]) {
                    return false;
                }
            } else {
                if (x[i]) {
                    return false;
                }
            }
        }
        
        return true;
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

    function Oracle_Converter_Reference(markingOracle: ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        return Apply_Phase_Oracle_Reference(markingOracle, _);
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Implementing Quantum Oracles
    //////////////////////////////////////////////////////////////////

    // Exercise 5.
    operation Or_Oracle_Reference(x: Qubit[], y: Qubit) : Unit
    is Adj {
        within {
            ApplyToEachA(X, x);
        } apply {
            X(y);  // flip y
            Controlled X(x, y);  // flip y again if input x was all zeros
        }
    }

    // Exercise 6.
    operation kth_Spin_Up_Reference(x: Qubit[], k: Int) : Unit 
    is Adj {
        using (minus = Qubit()) {
            within {
                X(minus);
                H(minus);
            } apply {
                CNOT(x[k], minus);
            }
        }
    }

    // Exercise 7.
    operation kth_Excluded_Or_Reference(x: Qubit[], k: Int) : Unit
    is Adj {
        using (minus = Qubit()) {
            within {
                X(minus);
                H(minus);
            } apply {
                //Or_Oracle(Exclude([k], x), minus);
                Or_Oracle_Reference(x[0..k-1] + x[k+1..Length(x)-1], minus);
            }
        }
    }

    // TODO: need to slice the kth element out of this array
    // Array function Most: https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arrays.most
    // 
    // https://docs.microsoft.com/en-us/quantum/user-guide/language/expressions#array-slices
    //
    // https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arrays.exclude


    //////////////////////////////////////////////////////////////////
    // Part IV. More Oracles! Implementation and Testing
    //////////////////////////////////////////////////////////////////

    // Exercise 8.
    operation Arbitrary_Pattern_Oracle_Reference(x: Qubit[], y: Qubit, pattern: Bool[]) : Unit 
    is Adj {
        within {
            for (i in IndexRange(x)) {
                if (not pattern[i]) {
                    X(x[i]);
                }
            }
        } apply {
            Controlled X(x, y);
        }
    }

    // and oracle with no extra qubits:
    // Controlled Z(q[0..Length(q)-2], q[Length(q) - 1])
    //
    // negate everything and apply AND = OR
    //
    // take in some q 
        // 1) negate everything - applying X
        // 2) apply the AND oracle
        // 3) flip everything back
        // 4) 
    //
    //

    // Exercise 9.
    operation Arbitrary_Pattern_Oracle_Challenge_Reference(x: Qubit[], pattern: Bool[]) : Unit 
    is Adj {
        within {
            for (i in IndexRange(x)) {
                if (not pattern[i]) {
                    X(x[i]);
                }
            }
        } apply {
            Controlled Z(x[0..Length(x)-2], x[Length(x)-1]);
        }
    }

    // Exercise 10.
    operation Meeting_Oracle_Reference(x: Qubit[], jasmine: Qubit[], z: Qubit) : Unit 
    is Adj {
        using (q = Qubit[Length(x)]) {
            within {
                for (i in IndexRange(q)) {
                    // flip q[i] if both x and jasmine are free on the given day
                    X(x[i]);
                    X(jasmine[i]);
                    CCNOT(x[i], jasmine[i], q[i]);
                }
                ApplyToEachA(X, q);
            } apply {
                X(z);  // flip to allow for a meeting

                // flip z back if both parties, x and jasmine, are busy
                // every day of the week.
                Controlled X(q, z);
            }
        }
    }
}