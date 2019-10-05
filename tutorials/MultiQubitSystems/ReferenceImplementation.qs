namespace Quantum.Kata.MultiQubitSystems {
    open Microsoft.Quantum.Intrinsic;

    operation BasisState_Reference (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        X(q1);
    }

    operation EvenSuperposition_Reference (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        H(q1);
        H(q2);
    }
}