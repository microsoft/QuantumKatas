namespace Quantum.Kata.CHSHGame {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Primitive;

    // Suboptimal quantum strategy experiments.
    
    operation PlaySuboptimalQuantumStrategy_Reference (aliceBit : Bool,
                                                       bobBit : Bool,
                                                       aliceMeasuresFirst : Bool,
                                                       rotationFactor : Int) : Bool {
        mutable aliceResult = Zero;
        mutable bobResult = Zero;

        using ((aliceQubit, bobQubit) = (Qubit(), Qubit())) {
            CreateEntangledPair_Reference([aliceQubit, bobQubit]);

            if (aliceMeasuresFirst) {
                set aliceResult = MeasureAliceQubit_Reference(aliceBit, aliceQubit);
                set bobResult = MeasureBobQubitSuboptimal_Reference(bobBit, bobQubit,
                                                                    rotationFactor);
            } else {
                set bobResult = MeasureBobQubitSuboptimal_Reference(bobBit, bobQubit,
                                                                    rotationFactor);
                set aliceResult = MeasureAliceQubit_Reference(aliceBit, aliceQubit);
            }

            Reset(aliceQubit);
            Reset(bobQubit);
        }

        return BoolFromResult(aliceResult) != BoolFromResult(bobResult);
    }

    operation MeasureBobQubitSuboptimal_Reference (bit : Bool,
                                                   qubit : Qubit,
                                                   rotationFactor : Int) : Result {
        RotateBobQubitSuboptimal_Reference(not bit, qubit, rotationFactor);
        return M(qubit);
    }

    operation RotateBobQubitSuboptimal_Reference (clockwise : Bool,
                                                  qubit : Qubit,
                                                  rotationFactor : Int) : Unit {
        if (clockwise) {
            Ry(ToDouble(rotationFactor) * -2.0 * PI() / 8.0, qubit);
        } else {
            Ry(ToDouble(rotationFactor) * 2.0 * PI() / 8.0, qubit);
        }
    }

}