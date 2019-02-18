using System;
using Microsoft.Quantum.Extensions.Math;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using Xunit;

namespace Quantum.Kata.QFT
{
    public class TestSimulator : QuantumSimulator
    {
        public class AssertRegisterStateImpl : AssertRegisterState
        {
            TestSimulator _sim;

            public AssertRegisterStateImpl(TestSimulator sim) : base(sim)
            {
                _sim = sim;
            }

            public override Func<(QArray<Qubit>, QArray<Complex>, double), QVoid> Body => (__in) =>
            {
                var (qubits, expected, tolerance) = __in;

                if (expected.Length != (long)Math.Pow(2.0, (double)qubits.Length))
                {
                    throw new ArgumentException(
                        $"expected array should have 2^{qubits.Length} entries, but actually has " +
                        $"{expected.Length}");
                }

                AssertRegisterDumper dumper = new AssertRegisterDumper(_sim, expected, tolerance);
                dumper.Dump(qubits);

                return QVoid.Instance;
            };
        }

        public class AssertRegisterDumper : QuantumSimulator.StateDumper
        {
            QArray<Complex> _expected;
            double _tolerance;
            bool _flipGlobalPhase = false;
            bool _sawNonZeroAmplitude = false;

            public AssertRegisterDumper(TestSimulator sim, QArray<Complex> expected,
                                        double tolerance) : base(sim)
            {
                _expected = expected;
                _tolerance = tolerance;
            }

            public override bool Callback(uint idx, double real, double img)
            {
                if (idx >= _expected.Length)
                {
                    return false;
                }

                var (expectedReal, expectedImg) = _expected[idx];
                CheckGlobalPhase(idx, real, img, expectedReal, expectedImg);
                Assert.InRange(_flipGlobalPhase ? -real : real,
                               expectedReal - _tolerance, expectedReal + _tolerance);
                Assert.InRange(_flipGlobalPhase ? -img : img,
                               expectedImg - _tolerance, expectedImg + _tolerance);
                return true;
            }

            void CheckGlobalPhase(uint idx, double real, double img, double expectedReal,
                                  double expectedImg)
            {
                // Try to fix the global phase using the first non-zero amplitude we see.  It only
                // works if the expected global phase is off by a factor of -1, but that's the only
                // factor I've seen so far.
                if (!_sawNonZeroAmplitude &&
                    (Math.Abs(real) > _tolerance || Math.Abs(img) > _tolerance))
                {
                    _flipGlobalPhase = !SameSign(real, expectedReal) || !SameSign(img, expectedImg);
                    _sawNonZeroAmplitude = true;
                }
            }

            static bool SameSign(double x, double y)
            {
                return (x >= 0.0 && y >= 0.0) || (x < 0.0 && y < 0.0);
            }
        }
    }
}