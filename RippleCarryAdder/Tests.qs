// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.RippleCarryAdder {
    
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    
    open Quantum.Kata.Utils;

    // ------------------------------------------------------
    function Adder (max : Int, a : Int, b : Int) : (Int, Bool) {
        let sum = a + b;
        return (sum % max, sum >= max);
    }

    function Subtractor_F (max : Int, a : Int, b : Int) : (Int, Bool) {
        let diff = b - a;
        return ((diff + max) % max, diff < 0);
    }

    function BinaryAdder (input : Bool[], N : Int) : Bool[] {
        let max = 1 <<< N;
        let bitsa = input[0 .. N-1];
        let bitsb = input[N ...];
        let a = BoolArrayAsInt(bitsa);
        let b = BoolArrayAsInt(bitsb);
        let (sum, carry) = Adder(max, a, b);
        return IntAsBoolArray(sum, N) + [carry];
    }

    function BinarySubtractor (input : Bool[], N : Int) : Bool[] {
        let max = 1 <<< N;
        let bitsa = input[0 .. N-1];
        let bitsb = input[N ...];
        let a = BoolArrayAsInt(bitsa);
        let b = BoolArrayAsInt(bitsb);
        let (diff, borrow) = Subtractor_F(max, a, b);
        return IntAsBoolArray(diff, N) + [borrow];
    }
    
    function BinaryXor (bits : Bool[]) : Bool {
        let N = Length(bits);
        mutable ans = false;
        for (i in 0 .. N-1) {
            if (bits[i]) {
                set ans = not ans;
            }
        }
        return ans;
    }

    // ------------------------------------------------------
    // Wrapper operations to make the tasks usable with AssertOperationsEqualReferenced
    operation QubitArrayOperationWrapper2 (op : ((Qubit, Qubit) => Unit is Adj), arr : Qubit[]) : Unit is Adj {
        op(Head(arr), Tail(arr));
    }

    operation QubitArrayOperationWrapper3 (op : ((Qubit, Qubit, Qubit) => Unit is Adj), arr : Qubit[]) : Unit is Adj {
        op(arr[0], arr[1], arr[2]);
    }

    operation QubitArrayOperationWrapper4 (op : ((Qubit, Qubit, Qubit, Qubit) => Unit is Adj), arr : Qubit[]) : Unit is Adj {
        op(arr[0], arr[1], arr[2], arr[3]);
    }

    operation QubitArrayAdderWrapper (N : Int, op : ((Qubit[], Qubit[], Qubit[], Qubit) => Unit is Adj), arr : Qubit[]) : Unit is Adj {
        let splits = Partitioned([N, N, N, 1], arr);
        op(splits[0], splits[1], splits[2], Tail(arr));
    }

    operation QubitArrayInPlaceAdderWrapper (N : Int, op : ((Qubit[], Qubit[], Qubit) => Unit is Adj), arr : Qubit[]) : Unit is Adj {
        let splits = Partitioned([N, N, 1], arr);
        op(splits[0], splits[1], Tail(arr));
    }


    // ------------------------------------------------------
    // Helper operations to prepare qubits from an input and compare them to the output
    operation PrepareRegister (register : Qubit[], state : Int) : Bool[] {
        let bits = IntAsBoolArray(state, Length(register));
        ApplyPauliFromBitString(PauliX, true, bits, register);
        return bits;
    }

    operation VerifyRegister (register : Qubit[], state : Bool[], errorPrefix : String) : Unit {
        let results = MultiM(register);
        let resultsb = ResultArrayAsBoolArray(results);
        AllEqualityFactB(resultsb, state, errorPrefix + $"expected {BoolArrayAsResultArray(state)}, but got {results}");
    }

    // ------------------------------------------------------
    // Function to generate more readable error messages
    function GenerateErrorPrefix (bits : Bool[]) : String {
        let N = Length(bits);
        let astr = $"Inputs a:{BoolArrayAsResultArray(bits[0 .. (N/2)-1])}";
        let postfix = " produce unexpected output: ";
        if (N % 2 == 0) {
            // Only a and b inputs
            return astr + $" and b:{BoolArrayAsResultArray(bits[N/2 ...])}" + postfix;
        }
        else {
            // 3 inputs - a, b, and carry
            return astr + $", b:{BoolArrayAsResultArray(bits[N/2 .. N-2])}, and c:{BoolArrayAsResultArray(bits[N-1 ...])}" + postfix;
        }
    }

    // ------------------------------------------------------
    // Assertion to compare a binary function with its quantum counterpart
    operation AssertOperationImplementsBinaryFunction (op : ((Qubit[]) => Unit is Adj), fun : ((Bool[]) -> Bool[]), Nbits : Int, Nverify : Int) : Unit {
        let max = 1 <<< Nbits;

        using ((qinput, qoutput) = (Qubit[Nbits], Qubit[Nverify])) {
            let qs = qinput + qoutput;
            for (i in 0 .. max-1) {
                let inbits = PrepareRegister(qinput, i);
                let outbits = fun(inbits);
                
                op(qs);
                
                VerifyRegister(qinput, inbits, "Inputs should not be modified: ");
                VerifyRegister(qoutput, outbits, GenerateErrorPrefix(inbits));
                ResetAll(qs);
            }
        }
    }

    // Assertion to compare a binary function with its in-place quantum counterpart
    operation AssertInPlaceOperationImplementsBinaryFunction (op : ((Qubit[]) => Unit is Adj), fun : ((Bool[]) -> Bool[]), N : Int, targetStart : Int, targetEnd : Int, extra : Int) : Unit {
        let max = 1 <<< N;
        using ((qinput, qextra) = (Qubit[N], Qubit[extra])) {
            let qs = qinput + qextra;
            let target = qinput[targetStart .. targetEnd] + qextra;
            let beforeTarget = qinput[0 .. targetStart-1];
            let afterTarget = qinput[targetEnd+1 ...];
            for (i in 0 .. max-1) {
                let inbits = PrepareRegister(qinput, i);
                let outbits = fun(inbits);

                op(qs);
                
                VerifyRegister(beforeTarget, inbits[0 .. targetStart-1], "Input a should not be modified: ");
                VerifyRegister(afterTarget, inbits[targetEnd+1 ...], "The carry input should not be modified: ");
                VerifyRegister(target, outbits, GenerateErrorPrefix(inbits));
                ResetAll(qs);
            }
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part I. Simple adder outputting to empty Qubits
    //////////////////////////////////////////////////////////////////

    // ------------------------------------------------------
    function LowestBitSum_F (bits : Bool[]) : Bool[] {
        return [BinaryXor(bits)];
    }

    operation T11_LowestBitSum_Test () : Unit {
        let testOp = QubitArrayOperationWrapper3(LowestBitSum, _);
        let refOp = QubitArrayOperationWrapper3(LowestBitSum_Reference, _);

        AssertOperationImplementsBinaryFunction(testOp, LowestBitSum_F, 2, 1);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }

    // ------------------------------------------------------
    function LowestBitCarry_F (bits : Bool[]) : Bool[] {
        return [bits[0] and bits[1]];
    }

    operation T12_LowestBitCarry_Test () : Unit {
        let testOp = QubitArrayOperationWrapper3(LowestBitCarry, _);
        let refOp = QubitArrayOperationWrapper3(LowestBitCarry_Reference, _);

        AssertOperationImplementsBinaryFunction(testOp, LowestBitCarry_F, 2, 1);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T13_OneBitAdder_Test () : Unit {
        let testOp = QubitArrayOperationWrapper4(OneBitAdder, _);
        let refOp = QubitArrayOperationWrapper4(OneBitAdder_Reference, _);

        AssertOperationImplementsBinaryFunction(testOp, BinaryAdder(_, 1), 2, 2);
        AssertOperationsEqualReferenced(4, testOp, refOp);
    }

    // ------------------------------------------------------
    function HighBitSum_F (bits : Bool[]) : Bool[] {
        return [BinaryXor(bits)];
    }

    operation T14_HighBitSum_Test () : Unit {
        let testOp = QubitArrayOperationWrapper4(HighBitSum, _);
        let refOp = QubitArrayOperationWrapper4(HighBitSum_Reference, _);

        AssertOperationImplementsBinaryFunction(testOp, HighBitSum_F, 3, 1);
        AssertOperationsEqualReferenced(4, testOp, refOp);
    }

    // ------------------------------------------------------
    function HighBitCarry_F (bits : Bool[]) : Bool[] {
        return [(bits[0] and bits[1]) or (bits[2] and (bits[0] or bits[1]))];
    }

    operation T15_HighBitCarry_Test () : Unit {
        let testOp = QubitArrayOperationWrapper4(HighBitCarry, _);
        let refOp = QubitArrayOperationWrapper4(HighBitCarry_Reference, _);

        AssertOperationImplementsBinaryFunction(testOp, HighBitCarry_F, 3, 1);
        AssertOperationsEqualReferenced(4, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T16_TwoBitAdder_Test () : Unit {
        let testOp = QubitArrayAdderWrapper(2, TwoBitAdder, _);
        let refOp = QubitArrayAdderWrapper(2, TwoBitAdder_Reference, _);

        AssertOperationImplementsBinaryFunction(testOp, BinaryAdder(_, 2), 4, 3);
        AssertOperationsEqualReferenced(7, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T17_ArbitraryAdder_Test () : Unit {
        // 4 bits seems reasonable - any more than that will take forever
        for (nQubitsInRegister in 1 .. 4) {
            let testOp1 = QubitArrayAdderWrapper(nQubitsInRegister, ArbitraryAdder, _);

            AssertOperationImplementsBinaryFunction(testOp1, BinaryAdder(_, nQubitsInRegister), 2 * nQubitsInRegister, nQubitsInRegister + 1);

            using ((reference, target, sum) = (Qubit[2 * nQubitsInRegister + 1], Qubit[2 * nQubitsInRegister + 1], Qubit[nQubitsInRegister])) {
                let a = target[0 .. nQubitsInRegister - 1];
                let b = target[nQubitsInRegister .. 2 * nQubitsInRegister - 1];
                let carry = Tail(target);

                PrepareEntangledState(reference, target);
                ArbitraryAdder(a, b, sum, carry);
                Adjoint ArbitraryAdder_Reference(a, b, sum, carry);
                Adjoint PrepareEntangledState(reference, target);
                AssertAllZero(reference + target);
            }
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Simple in-place adder
    //////////////////////////////////////////////////////////////////

    // ------------------------------------------------------
    operation T21_LowestBitSumInPlace_Test () : Unit {
        let testOp = QubitArrayOperationWrapper2(LowestBitSumInPlace, _);
        let refOp = QubitArrayOperationWrapper2(LowestBitSumInPlace_Reference, _);

        AssertInPlaceOperationImplementsBinaryFunction(testOp, LowestBitSum_F, 2, 1, 1, 0);
        AssertOperationsEqualReferenced(2, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T22_OneBitAdderInPlace_Test () : Unit {
        let testOp = QubitArrayOperationWrapper3(OneBitAdderInPlace, _);
        let refOp = QubitArrayOperationWrapper3(OneBitAdderInPlace_Reference, _);

        AssertInPlaceOperationImplementsBinaryFunction(testOp, BinaryAdder(_, 1), 2, 1, 1, 1);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T23_HighBitSumInPlace_Test () : Unit {
        let testOp = QubitArrayOperationWrapper3(HighBitSumInPlace, _);
        let refOp = QubitArrayOperationWrapper3(HighBitSumInPlace_Reference, _);

        AssertInPlaceOperationImplementsBinaryFunction(testOp, HighBitSum_F, 3, 1, 1, 0);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T24_TwoBitAdderInPlace_Test () : Unit {
        let testOp = QubitArrayInPlaceAdderWrapper(2, TwoBitAdderInPlace, _);
        let refOp = QubitArrayInPlaceAdderWrapper(2, TwoBitAdderInPlace_Reference, _);

        AssertInPlaceOperationImplementsBinaryFunction(testOp, BinaryAdder(_, 2), 4, 2, 3, 1);
        AssertOperationsEqualReferenced(5, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T25_ArbitraryAdderInPlace_Test () : Unit {
        for (i in 1 .. 4) {
            let testOp = QubitArrayInPlaceAdderWrapper(i, ArbitraryAdderInPlace, _);
            let refOp = QubitArrayInPlaceAdderWrapper(i, ArbitraryAdderInPlace_Reference, _);
            AssertInPlaceOperationImplementsBinaryFunction(testOp, BinaryAdder(_, i), 2 * i, i, (2 * i) - 1, 1);
            AssertOperationsEqualReferenced((2 * i) + 1, testOp, refOp);
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part III*. Improved in-place adder
    //////////////////////////////////////////////////////////////////

    // ------------------------------------------------------
    function Majority_F (bits : Bool[]) : Bool[] {
        let a = bits[0];
        let b = bits[1];
        let c = bits[2];
        let ab = XOR(a, b);
        let ac = XOR(a, c);
        let cout = XOR(ab and ac, a);
        return [cout, ab, ac];
    }

    operation T31_Majority_Test () : Unit {
        let testOp = QubitArrayOperationWrapper3(Majority, _);
        let refOp = QubitArrayOperationWrapper3(Majority_Reference, _);

        AssertInPlaceOperationImplementsBinaryFunction(testOp, Majority_F, 3, 0, 2, 0);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }

    // ------------------------------------------------------
    function UnMajorityAdd_F (bits : Bool[]) : Bool[] {
        let a = bits[0];
        let b = bits[1];
        let c = bits[2];
        let a2 = XOR(b and c, a);
        let c2 = XOR(a2, c);
        let b2 = XOR(c2, b);
        return [a2, b2, c2];
    }
    
    operation T32_UnMajorityAdd_Test () : Unit {
        let testOp = QubitArrayOperationWrapper3(UnMajorityAdd, _);
        let refOp = QubitArrayOperationWrapper3(UnMajorityAdd_Reference, _);

        AssertInPlaceOperationImplementsBinaryFunction(testOp, UnMajorityAdd_F, 3, 0, 2, 0);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T33_OneBitMajUmaAdder_Test () : Unit {
        let testOp = QubitArrayOperationWrapper3(OneBitMajUmaAdder, _);
        let refOp = QubitArrayOperationWrapper3(OneBitMajUmaAdder_Reference, _);
        AssertInPlaceOperationImplementsBinaryFunction(testOp, BinaryAdder(_, 1), 2, 1, 1, 1);
        AssertOperationsEqualReferenced(3, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T34_TwoBitMajUmaAdder_Test () : Unit {
        // Commented out lines check that this task uses a specific number of Majority and UMA gates
        // (as opposed to using an adder from part II).
        // Reverted to old test, since operation call counting doesn't work for counting task operations defined in notebooks.
        // ResetOracleCallsCount();
        let testOp = QubitArrayInPlaceAdderWrapper(2, TwoBitMajUmaAdder, _);
        let refOp = QubitArrayInPlaceAdderWrapper(2, TwoBitMajUmaAdder_Reference, _);
        AssertInPlaceOperationImplementsBinaryFunction(testOp, BinaryAdder(_, 2), 4, 2, 3, 1);
        // let sumCalls = GetOracleCallsCount(HighBitSumInPlace);
        // let carryCalls = GetOracleCallsCount(HighBitCarry);
        // let majCalls = GetOracleCallsCount(Majority);
        // let umaCalls = GetOracleCallsCount(UnMajorityAdd);
        // Fact((sumCalls == 0) and (carryCalls == 0), "You shouldn't be calling the old sum/carry operations for this task.");
        // Fact((majCalls > 0) and (umaCalls > 0), "Are you sure you're using the Majority and UMA gates?");

        AssertOperationsEqualReferenced(5, testOp, refOp);
    }

    // ------------------------------------------------------
    operation T35_ArbitraryMajUmaAdder_Test () : Unit {
        // This algorithm is much faster, so a 5 qubit test is feasible
        for (i in 1 .. 5) {
            let testOp = QubitArrayInPlaceAdderWrapper(i, ArbitraryMajUmaAdder, _);
            let refOp = QubitArrayInPlaceAdderWrapper(i, ArbitraryMajUmaAdder_Reference, _);

            ResetQubitCount();
            AssertInPlaceOperationImplementsBinaryFunction(testOp, BinaryAdder(_, i), 2 * i, i, (2 * i) - 1, 1);
            let used = GetMaxQubitCount();
            Fact(used <= (2 * (i + 1)), "Too many qubits used");
            
            AssertOperationsEqualReferenced((2 * i) + 1, testOp, refOp);
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part IV*. In-place subtractor
    //////////////////////////////////////////////////////////////////

    // ------------------------------------------------------
    operation T41_Subtractor_Test () : Unit {
        for (i in 1 .. 5) {
            let testOp = QubitArrayInPlaceAdderWrapper(i, Subtractor, _);
            let refOp = QubitArrayInPlaceAdderWrapper(i, Subtractor_Reference, _);
            AssertInPlaceOperationImplementsBinaryFunction(testOp, BinarySubtractor(_, i), 2 * i, i, (2 * i) - 1, 1);
            AssertOperationsEqualReferenced((2 * i) + 1, testOp, refOp);
        }
    }
}
