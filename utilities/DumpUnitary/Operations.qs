// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.DumpUnitary
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    
    // The operation which is called from C# code
    operation CallDumpUnitary (N : Int) : Unit {
        // Change this unitary to the one from which you want to obtain the pattern.
        // Make sure the operation passed to DumpOperation matches the number of qubits set in Driver.cs.
        // Note that the unitary must have the adjoint variant defined.
        let unitary = ApplyToEachA(I, _);

        DumpOperation(N, unitary);
    }
}
