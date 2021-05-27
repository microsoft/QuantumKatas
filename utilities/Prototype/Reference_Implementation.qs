namespace Quantum.Kata.Prototype {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation QsharpUnit_Reference() : Unit{

    }

    operation FlipZeroToPlusNoRestriction_Reference(q : Qubit) : Unit{
        H(q);
        H(q);
        H(q);
    }

    operation FlipZeroToPlusRestriction_Reference(q : Qubit) : Unit{
        H(q);
    }

    operation FlipZerosToOnes_Reference(qs : Qubit[]) : Unit{
        ApplyToEach(X, qs);
    }
}