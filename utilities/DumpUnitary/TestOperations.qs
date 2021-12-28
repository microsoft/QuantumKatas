// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.DumpUnitaryTest {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    // The operations below are part of the unit test;
    // you do not need to modify them to run the tool on your unitary!

    operation BlockDiagonalUnitary (qs : Qubit[]) : Unit is Adj {
        S(qs[2]);
        S(qs[1]);
        H(qs[0]);
    }

    operation TestBlockDiagonalUnitary (N : Int) : Unit {
        // make sure the operation passed to DumpUnitaryToFiles matches the number of qubits set in Driver.cs
        DumpOperation(N, BlockDiagonalUnitary);
    }


    operation Creeper (qs : Qubit[]) : Unit is Adj {
        CNOT(qs[1], qs[2]); 
        CNOT(qs[2], qs[0]); 
        CCNOT(qs[0], qs[2], qs[1]); 
        (ControlledOnInt(0, H))([qs[2]], qs[1]);
        H(qs[0]);
        CNOT(qs[1], qs[2]);         
    }

    operation TestCreeperUnitary (N : Int) : Unit {
        // make sure the operation passed to DumpUnitaryToFiles matches the number of qubits set in Driver.cs
        DumpOperation(N, Creeper);
    }
}
