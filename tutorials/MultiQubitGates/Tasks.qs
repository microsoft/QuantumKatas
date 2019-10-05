namespace Quantum.Kata.MultiQubitGates {
    open Microsoft.Quantum.Intrinsic;

    operation CompoundGate (q1 : Qubit, q2 : Qubit, q3 : Qubit) : Unit is Adj {
        // ...
        
    }

    operation BellState (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        // ...
        
    }

    operation QubitSwap (qs : Qubit[], index1 : Int, index2 : Int) : Unit is Adj {
        // ...
        
    }

    operation ControlledRotation (control : Qubit, target : Qubit, theta : Double) : Unit is Adj {
        // ...
        
    }

    operation MultiControls (controls : Qubit[], target : Qubit, controlBits : Bool[]) : Unit is Adj {
        // ...
        
    }
}