// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// You should not modify anything in this file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.VisualizationTools {
    open Microsoft.Quantum.Intrinsic;

    operation LearnSingleQubitState_Reference (q : Qubit) : (Double, Double) {
        return (0.9689, 0.2474);
    }


    operation LearnBasisStateAmplitudes_Reference (qs : Qubit[]) : (Double, Double) {
        return (0.3821, 0.339);
    }


    operation HighProbabilityBasisStates_Reference (qs : Qubit[]) : Int[] {
        return [0, 2, 8, 9, 11, 15, 18, 20, 22, 25, 28];
    }


    operation ReadMysteryOperationMatrix_Reference () : Double {
        return 0.5184;
    }


    operation ReadMysteryOperationTrace_Reference () : (Int, Int, Int) {
        return (4, 8, 2);
    }
}
