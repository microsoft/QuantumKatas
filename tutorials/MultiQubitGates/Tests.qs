namespace Quantum.Kata.MultiQubitGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    operation ArrayOperationWrapper (op : ((Qubit, Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(qs[0], qs[1]);
    }

    operation ArrayOperationWrapper3 (op : ((Qubit, Qubit, Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(qs[0], qs[1], qs[2]);
    }
    
    operation ArrayControlledOperationWrapper (op : ((Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(Most(qs), Tail(qs));
    }

    operation T1_CompoundGate_Test () : Unit {
        AssertOperationsEqualReferenced(3, ArrayOperationWrapper3(CompoundGate, _), ArrayOperationWrapper3(CompoundGate_Reference, _));
    }

    operation T2_BellState_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayOperationWrapper(BellState, _), ArrayOperationWrapper(BellState_Reference, _));
    }

    operation T3_QubitSwap_Test () : Unit {
        for (i in 2 .. 5) {
            for (j in 0 .. i-2) {
                for (k in j+1 .. i-1) {
                    AssertOperationsEqualReferenced(i, QubitSwap(_, j, k), QubitSwap_Reference(_, j, k));
                }
            }
        }
    }

    operation T4_ControlledRotation_Test () : Unit {
        for (i in 0 .. 20) {
            let angle = IntAsDouble(i) / 10.0;
            AssertOperationsEqualReferenced(2, ArrayOperationWrapper(ControlledRotation(_, _, angle), _), ArrayOperationWrapper(ControlledRotation_Reference(_, _, angle), _));
        }
    }

    operation T5_MultiControls_Test () : Unit {
        for (i in 0 .. (2 ^ 4) - 1) {
            let bits = IntAsBoolArray(i, 4);
            AssertOperationsEqualReferenced(5, ArrayControlledOperationWrapper(MultiControls(_, _, bits), _), ArrayControlledOperationWrapper(MultiControls_Reference(_, _, bits), _));
        }
    }
}