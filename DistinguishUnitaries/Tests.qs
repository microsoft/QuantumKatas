// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DistinguishUnitaries {    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Random;
    
    open Quantum.Kata.Utils;
    
    // "Framework" operation for testing tasks for distinguishing unitaries
    // "unitaries" is the list of unitaries that can be passed to the task
    // "testImpl" - the solution to be tested
    // "maxCalls" - max # of calls to the unitary that are allowed (-1 means unlimited)
    operation DistinguishUnitaries_Framework<'UInput> (
        unitaries : ('UInput => Unit is Adj+Ctl)[], 
        testImpl : (('UInput => Unit is Adj+Ctl) => Int),
        maxCalls : Int) : Unit {

        let nUnitaries = Length(unitaries);
        let nTotal = 100;
        mutable wrongClassifications = [0, size = nUnitaries * nUnitaries]; // [i * nU + j] number of times unitary i was classified as j
        mutable unknownClassifications = [0, size = nUnitaries];            // number of times unitary i was classified as something unknown
        
        for i in 1 .. nTotal {
            // get a random integer to define the unitary used
            let actualIndex = DrawRandomInt(0, nUnitaries - 1);
            
            ResetOracleCallsCount();

            // get the solution's answer and verify that it's a match
            let returnedIndex = testImpl(unitaries[actualIndex]);

            // check the constraint on the number of allowed calls to the unitary
            // note that a unitary can be implemented as Controlled on |1⟩, so we need to count variants as well
            if (maxCalls > 0) {
                let actualCalls = GetOracleCallsCount(unitaries[actualIndex]) + 
                                  GetOracleCallsCount(Adjoint unitaries[actualIndex]) + 
                                  GetOracleCallsCount(Controlled unitaries[actualIndex]);
                if (actualCalls > maxCalls) {
                    fail $"You are allowed to do at most {maxCalls} calls, and you did {actualCalls}";
                }
            }
            
            if (returnedIndex != actualIndex) {
                if (returnedIndex < 0 or returnedIndex >= nUnitaries) {
                    set unknownClassifications w/= actualIndex <- unknownClassifications[actualIndex] + 1;
                } else {
                    let index = actualIndex * nUnitaries + returnedIndex;
                    set wrongClassifications w/= index <- wrongClassifications[index] + 1;
                }
            }
        }
        
        mutable totalMisclassifications = 0;
        for i in 0 .. nUnitaries - 1 {
            for j in 0 .. nUnitaries - 1 {
                let misclassifiedIasJ = wrongClassifications[(i * nUnitaries) + j];
                if (misclassifiedIasJ != 0) {
                    set totalMisclassifications += misclassifiedIasJ;
                    Message($"Misclassified {i} as {j} in {misclassifiedIasJ} test runs.");
                }
            }
            if (unknownClassifications[i] != 0) {
                set totalMisclassifications += unknownClassifications[i];
                Message($"Misclassified {i} as unknown unitary in {unknownClassifications[i]} test runs.");
            }
        }
        // This check will tell the total number of failed classifications
        Fact(totalMisclassifications == 0, $"{totalMisclassifications} test runs out of {nTotal} returned incorrect state.");
    }
    
    
    // ------------------------------------------------------
    // A pair of helper wrappers used to differentiate the unitary we pass as an argument from gates used normally
    internal operation SingleQubitGateWrapper<'UInput> (unitary : ('UInput => Unit is Adj+Ctl), input : 'UInput) : Unit is Adj+Ctl {
        unitary(input);
    }

    internal function SingleQubitGateAsUnitary<'UInput> (unitary : ('UInput => Unit is Adj+Ctl)) : ('UInput => Unit is Adj+Ctl) {
        return SingleQubitGateWrapper(unitary, _);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T101_DistinguishIfromX () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [I, X]), DistinguishIfromX, 1);
    }
    
    
    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T102_DistinguishIfromZ () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [I, Z]), DistinguishIfromZ, 1);
    }
    
    
    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T103_DistinguishZfromS () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [Z, S]), DistinguishZfromS, 2);
    }
    
    
    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T104_DistinguishHfromX () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [H, X]), DistinguishHfromX, 2);
    }
    
    
    // ------------------------------------------------------
    operation MinusOne (q : Qubit) : Unit is Adj+Ctl {
        within { X(q); }
        apply { Z(q); }
        Z(q);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T105_DistinguishZfromMinusZ () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [Z, BoundCA([Z, MinusOne])]), DistinguishZfromMinusZ, 1);
    }


    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T106_DistinguishRzFromR1 () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [Rz, R1]), DistinguishRzFromR1, 1);
    }


    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T107_DistinguishYfromXZ () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [Y, BoundCA([Z, X])]), DistinguishYfromXZ, 2);
    }
    
    
    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T108_DistinguishYfromXZWithPhases () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [Y, BoundCA([Z, X, MinusOne]), BoundCA([Y, MinusOne]), BoundCA([Z, X])]), DistinguishYfromXZWithPhases, 3);
    }


    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T109_DistinguishRzFromRy () : Unit {
        for theta in [0.04, 0.1, 0.25, 0.31, 0.5, 0.87, 1.05, 1.41, 1.66, 1.75, 2.0, 2.16, 2.22, 2.51, 2.93, 3.0, 3.1] {
            DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [Rz(theta, _), Ry(theta, _)]), DistinguishRzFromRy(theta, _), -1);
        }
    }


    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T110_DistinguishRzFromR1WithAngle () : Unit {
        for theta in [0.04, 0.1, 0.25, 0.31, 0.5, 0.87, 1.05, 1.41, 1.66, 1.75, 2.0, 2.16, 2.22, 2.51, 2.93, 3.0, 3.1] {
            DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [Rz(theta, _), R1(theta, _)]), DistinguishRzFromR1WithAngle(theta, _), -1);
        }
    }
    

    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T111_DistinguishPaulis () : Unit {
        DistinguishUnitaries_Framework(Mapped(SingleQubitGateAsUnitary, [I, X, Y, Z]), DistinguishPaulis, 1);
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Multi-Qubit Gates
    //////////////////////////////////////////////////////////////////
    
    operation IXWrapper (qs : Qubit[]) : Unit is Adj+Ctl {
        Fact(Length(qs) == 2, "This unitary can only be applied to arrays of length 2.");
        X(qs[1]);
    }

    operation CNOTWrapper (qs : Qubit[]) : Unit is Adj+Ctl {
        Fact(Length(qs) == 2, "This unitary can only be applied to arrays of length 2.");
        CNOT(qs[0], qs[1]);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T201_DistinguishIXfromCNOT () : Unit {
        DistinguishUnitaries_Framework([IXWrapper, CNOTWrapper], DistinguishIXfromCNOT, 1);
    }

    // ------------------------------------------------------
    operation ReverseCNOTWrapper (qs : Qubit[]) : Unit is Adj+Ctl {
        Fact(Length(qs) == 2, "This unitary can only be applied to arrays of length 2.");
        CNOT(qs[1], qs[0]);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T202_CNOTDirection () : Unit {
        DistinguishUnitaries_Framework([CNOTWrapper, ReverseCNOTWrapper], CNOTDirection, 1);
    }

    // ------------------------------------------------------
    operation SWAPWrapper (qs : Qubit[]) : Unit is Adj+Ctl {
        Fact(Length(qs) == 2, "This unitary can only be applied to arrays of length 2.");
        SWAP(qs[1], qs[0]);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T203_DistinguishCNOTfromSWAP () : Unit {
        DistinguishUnitaries_Framework([CNOTWrapper, SWAPWrapper], DistinguishCNOTfromSWAP, 1);
    }

    // ------------------------------------------------------
    operation IdentityWrapper (qs : Qubit[]) : Unit is Adj+Ctl {
        Fact(Length(qs) == 2, "This unitary can only be applied to arrays of length 2.");
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T204_DistinguishTwoQubitUnitaries () : Unit {
        DistinguishUnitaries_Framework([IdentityWrapper, CNOTWrapper, ReverseCNOTWrapper, SWAPWrapper], DistinguishTwoQubitUnitaries, 2);
    }
}
