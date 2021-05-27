namespace Quantum.Kata.Prototype {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation QsharpUnit() : Unit{

    }

    operation FlipZeroToPlusNoRestriction(q : Qubit) : Unit{
        H(q);
        H(q);
        H(q);
    }

    operation FlipZeroToPlusRestriction(q : Qubit) : Unit{
        H(q);
    }

    operation FlipZerosToOnes(qs : Qubit[]) : Unit{
        ApplyToEach(X, qs);
    }
}
