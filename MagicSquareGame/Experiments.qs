namespace Quantum.Kata.MagicSquareGame {

    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Testing;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;

    operation WinRateExperiment() : Unit {
        mutable result = true;
        mutable runs = 10000;
        mutable wins = 0;
        for (i in 1..runs) {
            mutable aliceMoves = new Int[3];
            mutable bobMoves = new Int[3];
            let row = RandomInt(3);
            let col = RandomInt(3);
            using (qs = Qubit[4]) {
                CreateAliceAndBobQubits_Reference(qs[0..1], qs[2..3]);
                set aliceMoves = AliceStrategyOptimalClassical_Reference(row);
                set bobMoves = BobStrategyOptimalClassical_Reference(col);
                if (verify(row, col, aliceMoves, bobMoves, false)) {
                    set wins = wins + 1;
                }
                ResetAll(qs);
            }
        }
        let rate = ToDouble(wins) / ToDouble(runs);
        Message($"Win rate was: {rate}");
    }

}