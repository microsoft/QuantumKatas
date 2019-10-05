namespace Quantum.Kata.MultiQubitGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation CompoundGate_Reference (q1 : Qubit, q2 : Qubit, q3 : Qubit) : Unit is Adj {
        S(q1);
        Y(q3);
    }

    operation BellState_Reference (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        H(q1);
        CNOT(q1, q2);
    }

    operation QubitSwap_Reference (qs : Qubit[], index1 : Int, index2 : Int) : Unit is Adj {
        SWAP(qs[index1], qs[index2]);
    }

    operation ControlledRotation_Reference (control : Qubit, target : Qubit, theta : Double) : Unit is Adj {
        Controlled Rx([control], (theta, target));
    }

    operation MultiControls_Reference (controls : Qubit[], target : Qubit, controlBits : Bool[]) : Unit is Adj {
        (ControlledOnBitString(controlBits, X))(controls, target);
    }
}