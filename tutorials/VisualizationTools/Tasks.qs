// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in the tutorial.
// We strongly recommend to use the Notebook version of the tutorial
// to enjoy the full experience.
//////////////////////////////////////////////////////////////////

namespace Quantum.Kata.VisualizationTools {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation LearnSingleQubitState (q : Qubit) : (Double, Double) {
        // ...
        return (0.0, 0.0);
    }


    operation LearnBasisStateAmplitudes (qs : Qubit[]) : (Double, Double) {
        // ...
        return (0.0, 0.0);
    }


    operation HighProbabilityBasisStates (qs : Qubit[]) : Int[] {
        // ...
        return [];
    }


    operation ReadMysteryOperationMatrix () : Double {
        // ...
        return 0.0;
    }


    operation ReadMysteryOperationTrace () : (Int, Int, Int) {
        // ...
        return (0, 0, 0);
    }
}
