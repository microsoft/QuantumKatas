// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.ReversibleLogicSynthesis {
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;

    operation T11_ProjectiveTruthTables_Test () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference(); // REVERT
        EqualityFactI(x1, 0b10101010, "Truth table of x1 is not correct");
        EqualityFactI(x2, 0b11001100, "Truth table of x2 is not correct");
        EqualityFactI(x3, 0b11110000, "Truth table of x3 is not correct");
    }

    operation DummyTest () : Unit {
        let (x1, x2, x3) = ProjectiveTruthTables_Reference();

        let expr = (x1 &&& x2) ||| x3;
        Message($"Expression = {expr}");

        let positions = Mapped(
                Fst<Int, Bool>,
                Filtered(
                    Compose(EqualB(true, _), Snd<Int, Bool>),
                    Enumerated(IntAsBoolArray(expr, 8))));
        Message($"Positions = {positions}");
    }
}
