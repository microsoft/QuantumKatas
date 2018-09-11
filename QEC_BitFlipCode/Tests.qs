// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.QEC_BitFlipCode {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Bitwise;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;

    //////////////////////////////////////////////////////////////////////////
    // Task 01
    //////////////////////////////////////////////////////////////////////////

    function ToString_Bitmask (bits : Int) : String {
        let b1 = bits / 4;
        let b2 = (bits / 2) % 2;
        let b3 = bits % 2;
        return $"{b1}{b2}{b3}";
    }

    operation StatePrep_Bitmask (qs : Qubit[], bits : Int) : () {
        body {
            if (bits / 4 == 1) {
                X(qs[0]);
            }
            if ((bits / 2) % 2 == 1) {
                X(qs[1]);
            }
            if (bits % 2 == 1) {
                X(qs[2]);
            }
        }
        adjoint auto;
    }

    function FindFirstDiff_Reference (bits1 : Int[], bits2 : Int[]) : Int {
        mutable firstDiff = -1;
        for (i in 0 .. Length(bits1)-1) {
            if (bits1[i] != bits2[i] && firstDiff == -1) {
                set firstDiff = i;
            }
        }
        return firstDiff;
    }

    function IntToBoolArray (n : Int) : Int[] {
        return [(n / 4) % 2; (n / 2) % 2; n % 2];
    }

    operation StatePrep_TwoBitmasks (qs : Qubit[], bits1 : Int[], bits2 : Int[]) : () {
        body {
            let firstDiff = FindFirstDiff_Reference(bits1, bits2);

            H(qs[firstDiff]);

            for (i in 0 .. Length(qs)-1) {
                if (bits1[i] == bits2[i]) {
                    if (bits1[i] == 1) {
                        X(qs[i]);
                    }
                } else {
                    if (i > firstDiff) {
                        CNOT(qs[firstDiff], qs[i]);
                        if (bits1[i] != bits1[firstDiff]) {
                            X(qs[i]);
                        }
                    }
                }
            }
        }
        adjoint auto;
    }

    operation TestParityOnState (
        statePrep : (Qubit[] => () : Adjoint),
        parity : Int,
        stateStr : String
        ) : () {
        body {
            using (register = Qubit[3]) {
                // prepare basis state to test on
                statePrep(register);
                let res = MeasureParity(register);

                // check that the returned parity is correct
                AssertBoolEqual(res == Zero, parity == 0, $"Failed on {stateStr}.");

                // check that the state has not been modified
                (Adjoint statePrep)(register);
                AssertAllZero(register);
            }
        }
    }

    operation T01_MeasureParity_Test () : () {
        body {
            // test on all basis states
            for (bits in 0..7) {
                let bitsStr = ToString_Bitmask(bits);
                TestParityOnState(StatePrep_Bitmask(_, bits), Parity(bits), $"basis state |{bitsStr}⟩");
            }

            // test on all superpositions of two basis states of the same parity
            for (b1 in 0..7) {
                let bits1 = IntToBoolArray(b1);
                let bitsStr1 = ToString_Bitmask(b1);
                for (b2 in (b1 + 1)..7) {
                    if (Parity(b1) == Parity(b2)) {
                        let bits2 = IntToBoolArray(b2);
                        let bitsStr2 = ToString_Bitmask(b2);
                        let p = Parity(b1);
                        Message($"Testing on |{bitsStr1}⟩ + |{bitsStr2}⟩ with parity {p}");
                        TestParityOnState(StatePrep_TwoBitmasks(_, bits1, bits2), Parity(b1), 
                                          $"state |{bitsStr1}⟩ + |{bitsStr2}⟩");
                    }
                }
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Task 02
    //////////////////////////////////////////////////////////////////////////

    operation AssertEqualOnZeroState (
        statePrep : (Qubit[] => () : Adjoint),
        testImpl : (Qubit[] => ()), 
        refImpl : (Qubit[] => () : Adjoint)
    ) : () {
        body {
            using (qs = Qubit[3]) {
                // prepare state
                statePrep(qs);

                // apply operation that needs to be tested
                testImpl(qs);

                // apply adjoint reference operation and adjoint state prep
                (Adjoint refImpl)(qs);
                (Adjoint statePrep)(qs);

                // assert that all qubits end up in |0⟩ state
                AssertAllZero(qs);
            }
        }
    }

    operation StatePrep_Rotate (qs : Qubit[], alpha : Double) : () {
        body {
            Ry(2.0 * alpha, qs[0]);
        }
        adjoint auto;
    }

    operation T02_Encode_Test () : () {
        body {
            for (i in 0..36) {
                let alpha = 2.0 * PI() * ToDouble(i) / 36.0;
                AssertEqualOnZeroState(StatePrep_Rotate(_, alpha), Encode, Encode_Reference);
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Task 03
    //////////////////////////////////////////////////////////////////////////

    operation StatePrep_WithError (qs : Qubit[], alpha : Double, hasError : Bool) : () {
        body {
            StatePrep_Rotate(qs, alpha);
            Encode_Reference(qs);
            if (hasError) {
                X(qs[0]);
            }
        }
        adjoint auto;
    }

    operation T03_DetectErrorOnLeftQubit_Test () : () {
        body {
            using (register = Qubit[3]) {
                for (i in 0..36) {
                    let alpha = 2.0 * PI() * ToDouble(i) / 36.0;
                    StatePrep_WithError(register, alpha, false);
                    AssertResultEqual(DetectErrorOnLeftQubit(register), Zero, "Failed on a state without X error.");
                    (Adjoint StatePrep_WithError)(register, alpha, false);
                    AssertAllZero(register);

                    StatePrep_WithError(register, alpha, true);
                    AssertResultEqual(DetectErrorOnLeftQubit(register), One, "Failed on a state with X error.");
                    (Adjoint StatePrep_WithError)(register, alpha, true);
                    AssertAllZero(register);
                }
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Task 04
    //////////////////////////////////////////////////////////////////////////

    operation BindErrorCorrectionRoundImpl (
        encoder : (Qubit[] => () : Adjoint), 
        error : Pauli[],
        logicalOp : (Qubit[] => ()),
        correction : (Qubit[] => ()),

        dataRegister : Qubit[]
    ) : () {
        body {
            using (auxiliary = Qubit[2]) {
                let register = dataRegister + auxiliary;

                // encode the logical qubit (dataRegister) into physical representation (register)
                encoder(register);

                // apply error (or no error)
                ApplyPauli(error, register);

                // perform logical operation on (possibly erroneous) state
                logicalOp(register);

                // apply correction to get the state back to correct one
                correction(register);

                // apply decoding to get back to 1-qubit state
                (Adjoint encoder)(register);

                AssertAllZero(auxiliary);
            }
        }
    }

    function BindErrorCorrectionRound (
            encoder : (Qubit[] => () : Adjoint), 
            error : Pauli[],
            logicalOp : (Qubit[] => ()),
            correction : (Qubit[] => ())
        ) : (Qubit[] => ()) {

        return BindErrorCorrectionRoundImpl(encoder, error, logicalOp, correction, _);
    }

    // list of errors which can be corrected by the code (the first element corresponds to no error)
    function PauliErrors() : Pauli[][] {
        return [
                [PauliI; PauliI; PauliI];
                [PauliX; PauliI; PauliI];
                [PauliI; PauliX; PauliI];
                [PauliI; PauliI; PauliX]
            ];
    }

    operation T04_CorrectErrorOnLeftQubit_Test () : () {
        body {
            let partialBind =
                BindErrorCorrectionRound(Encode_Reference, _, NoOp, CorrectErrorOnLeftQubit);

            let errors = PauliErrors();
            for (idxError in 0..1) {
                AssertOperationsEqualReferenced(partialBind(errors[idxError]), NoOp, 1);
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Task 05
    //////////////////////////////////////////////////////////////////////////

    operation T05_DetectErrorOnAnyQubit_Test () : () {
        body {
            let errors = PauliErrors();
            using (register = Qubit[3]) {

                for (idxError in 0..Length(errors) - 1) {
                    let θ = RandomReal(12);
                    let statePrep = BindA([H; Rz(θ, _)]);
                    mutable errorStr = "no error";
                    if (idxError > 0) {
                        set errorStr = $"error on qubit {idxError}";
                    }
                    Message($"Testing with {errorStr}.");
                    statePrep(Head(register));
                    Encode_Reference(register);
                    ApplyPauli(errors[idxError], register);
                    AssertIntEqual(DetectErrorOnAnyQubit(register), idxError, $"Failed on state with {errorStr}.");
                    ApplyPauli(errors[idxError], register);
                    (Adjoint Encode_Reference)(register);
                    (Adjoint statePrep)(Head(register));

                    AssertAllZero(register);
                }
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Task 06
    //////////////////////////////////////////////////////////////////////////

    operation T06_CorrectErrorOnAnyQubit_Test () : () {
        body {
            let partialBind =
                BindErrorCorrectionRound(Encode_Reference, _, NoOp, CorrectErrorOnAnyQubit);

            let errors = PauliErrors();
            for (idxError in 0..Length(errors) - 1) {
                Message($"Task 06: Testing on {errors[idxError]}...");
                AssertOperationsEqualReferenced(partialBind(errors[idxError]), NoOp, 1);
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Task 07
    //////////////////////////////////////////////////////////////////////////

    operation T07_LogicalX_Test () : () {
        body {
            let partialBind =
                BindErrorCorrectionRound(Encode_Reference, _, LogicalX, CorrectErrorOnAnyQubit_Reference);

            let errors = PauliErrors();
            for (idxError in 0..Length(errors) - 1) {
                Message($"Task 07: Testing on {errors[idxError]}...");
                AssertOperationsEqualReferenced(partialBind(errors[idxError]), ApplyPauli([PauliX], _), 1);
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Task 08
    //////////////////////////////////////////////////////////////////////////

    operation T08_LogicalZ_Test () : () {
        body {
            let partialBind =
                BindErrorCorrectionRound(Encode_Reference, _, LogicalZ, CorrectErrorOnAnyQubit_Reference);

            let errors = PauliErrors();
            for (idxError in 0..Length(errors) - 1) {
                Message($"Task 08: Testing on {errors[idxError]}...");
                AssertOperationsEqualReferenced(partialBind(errors[idxError]), ApplyToEachA(Z, _), 1);
            }
        }
    }
}