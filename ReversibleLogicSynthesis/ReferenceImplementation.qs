// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.ReversibleLogicSynthesis {
    
    //////////////////////////////////////////////////////////////////
    // Part I. Truth tables as integers
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. Projective functions (elementary variables)
    operation ProjectiveTruthTables_Reference () : (Int, Int, Int) {
        let x1 = 0b10101010;
        let x2 = 0b11001100;
        let x3 = 0b11110000;
        return (x1, x2, x3);
    }
}
