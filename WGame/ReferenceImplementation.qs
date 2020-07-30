// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.WGame {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;


    //////////////////////////////////////////////////////////////////
    // Part I. Classical GHZ
    //////////////////////////////////////////////////////////////////

    // Task 1.1. Win condition
    function WinCondition_Reference (rst : Bool[], abc : Bool[]) : Bool {
        mutable rstOnes = 0;
        mutable abcOnes = 0;
        for (i in rst) { if (i) {set rstOnes = rstOnes + 1;} }
        for (i in abc) { if (i) {set abcOnes = abcOnes + 1;} }
        if (rstOnes == 2) {
            return (abcOnes != 1);
        }
        if (rstOnes == 1) {
            return (abcOnes < 3);
        }
        return (abcOnes == 1);      // By initial conditions, if rstOnes is not 1 or 2, it must be 0
    }


    // Task 1.2. Random classical strategy
    operation RandomClassicalStrategy_Reference (input : Bool) : Bool {
        return RandomInt(2) == 1;
    }


    // Task 1.3. Best classical strategy
    operation BestClassicalStrategy_Reference (input : Bool) : Bool {
        // One of several simple strategies that reaches optimal classical win probability.
        return false;
    }


    // Task 1.4. Referee classical GHZ game
    operation PlayClassicalGHZ_Reference (strategy : (Bool => Bool), inputs : Bool[]) : Bool[] {
        return ForEach(strategy, inputs);
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum GHZ
    //////////////////////////////////////////////////////////////////

    // Task 2.1. Entangled triple
    operation CreateEntangledTriple_Reference (qs : Qubit[]) : Unit is Adj {
        let theta = ArcSin(1.0 / Sqrt(3.0));
        Ry(2.0 * theta, qs[0]);
        // Starting from |000>, this produces {sqrt(2/3) |000>  +  sqrt(1/3) |100>}.

        (ControlledOnBitString([false], H))([qs[0]], qs[1]);
        // Hadamard-transforms second qubit when first is 0,
        // so this leads to (|000> + |010> + |100>) / sqrt(3).

        (ControlledOnBitString([false, false], X))([qs[0], qs[1]], qs[2]);
        // Applies NOT gate to third qubit when first two are both 0, leading to the W state desired.
    }


    // Task 2.2. Quantum strategy
    operation QuantumStrategy_Reference (input : Bool, qubit : Qubit) : Bool {
        if (input) {
            H(qubit);
        }
        return ResultAsBool(M(qubit));
    }


    // Task 2.3. Play the GHZ game using the quantum strategy
    operation PlayQuantumGHZ_Reference (strategies : (Qubit => Bool)[]) : Bool[] {

        using (qs = Qubit[3]) {
            CreateEntangledTriple_Reference(qs);
            
            let a = strategies[0](qs[0]);
            let b = strategies[1](qs[1]);
            let c = strategies[2](qs[2]);

            ResetAll(qs);
            return [a, b, c];
        }
    }

}
