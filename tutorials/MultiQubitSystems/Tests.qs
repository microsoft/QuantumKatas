namespace Quantum.Kata.MultiQubitSystems {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    
    operation ArrayWrapperOperation (op : ((Qubit, Qubit) => Unit is Adj), qs : Qubit[]) : Unit is Adj {
        op(qs[0], qs[1]);
    }

    operation T1_BasisState_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(BasisState, _), ArrayWrapperOperation(BasisState_Reference, _));
    }

    operation T2_EvenSuperposition_Test () : Unit {
        AssertOperationsEqualReferenced(2, ArrayWrapperOperation(EvenSuperposition, _), ArrayWrapperOperation(EvenSuperposition_Reference, _));
    }
}