// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SuperdenseCoding
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Testing;

    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, taskImpl : (Qubit[] => ()), refImpl : (Qubit[] => () : Adjoint)) : ()
    {
        body
        {
            using (qs = Qubit[N])
            {
                // apply operation that needs to be tested
                taskImpl(qs);

                // apply adjoint reference operation and check that the result is |0^N⟩
                (Adjoint refImpl)(qs);

                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }

    operation T1_CreateEntangledPair_Test () : ()
    {
        body
        {
            // We only check for 2 qubits.
            AssertEqualOnZeroState(2, CreateEntangledPair, CreateEntangledPair_Reference);
        }
    }

    // ------------------------------------------------------
    // Helper operation that runs superdense coding protocol using two building blocks
    // specified as first two parameters.
    operation ComposeProtocol (
        encodeOp : ((Qubit, Bool[]) => ()),
        decodeOp : ((Qubit, Qubit) => Bool[]),
        message : Bool[]
    ) : Bool[]
    {
        body
        {
            mutable result = new Bool[2];
            using (qs = Qubit[2]) {
                CreateEntangledPair_Reference(qs);
                encodeOp(qs[0], message);
                set result = decodeOp(qs[1], qs[0]);
                // Make sure that we return qubits back in 0 state.
                ResetAll(qs);
            }
            return result;
        }
    }

    // ------------------------------------------------------
    // Helper operation that runs superdense coding protocol (specified by protocolOp)
    // on all possible input values and verifies that decoding result matches the inputs
    operation TestProtocol (
        protocolOp : ((Bool[]) => Bool[])
    ) : ()
    {
        body
        {
            mutable data = new Bool[2];

            // Loop over the 4 possible combinations of two bits
            for (n in 0..3)
            {
                set data[0] = 1 == (n / 2);
                set data[1] = 1 == (n % 2);
                for (iter in 1..100) {
                    let result = protocolOp(data);

                    // Now test if the bits were transfered correctly.
                    AssertBoolArrayEqual(result, data, $"The message {data} was transfered incorrectly as {result}" );
                }
            }
        }
    }

    operation T2_EncodeMessageInQubit_Test () : ()
    {
        body
        {
            TestProtocol(ComposeProtocol(EncodeMessageInQubit, DecodeMessageFromQubits_Reference, _));
        }
    }

    operation T3_DecodeMessageFromQubits_Test () : ()
    {
        body
        {
            TestProtocol(ComposeProtocol(EncodeMessageInQubit_Reference, DecodeMessageFromQubits, _));
        }
    }

    operation T4_SuperdenseCodingProtocol_Test () : ()
    {
        body
        {
            TestProtocol(SuperdenseCodingProtocol);
        }
    }
}