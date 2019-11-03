// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.MultiQubitSystems {
    open Microsoft.Quantum.Intrinsic;

    operation PrepareState1_Reference (qs : Qubit[]) : Unit is Adj+Ctl {
        X(qs[0]);
        X(qs[1]);
    }

    operation PrepareState2_Reference (qs : Qubit[]) : Unit is Adj+Ctl {
        X(qs[1]);
        H(qs[1]);
    }

    operation PrepareState3_Reference (qs : Qubit[]) : Unit is Adj+Ctl {
        H(qs[0]);
        X(qs[1]);
        H(qs[1]);
    }

    operation PrepareState4_Reference (qs : Qubit[]) : Unit is Adj+Ctl {
        H(qs[0]);
        H(qs[1]);
        S(qs[0]);
        T(qs[1]);
    }
}