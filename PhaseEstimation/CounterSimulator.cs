// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

using Xunit;

namespace Quantum.Kata.PhaseEstimation
{
    /// <summary>
    ///     This custom quantum simulator keeps track of the number of times 
    ///     each operation is executed, by providing a custom native operation: 
    ///     `AssertOracleCallsCount` which asserts the number of times
    ///     the given oracle (operation) has been called.
    /// </summary>
    public class CounterSimulator : QuantumSimulator
    {
        private Dictionary<ICallable, int> _operationsCount = new Dictionary<ICallable, int>();
        private static long _qubitsAllocated = 0;
        private static long _maxQubitsAllocated = 0;

        #region Counting operations
        public CounterSimulator(
            bool throwOnReleasingQubitsNotInZeroState = true, 
            uint? randomNumberGeneratorSeed = null, 
            bool disableBorrowing = false) : 
            base(throwOnReleasingQubitsNotInZeroState, randomNumberGeneratorSeed, disableBorrowing)
        {
            this.OnOperationStart += CountOperationCalls;
        }

        /// <summary>
        /// Callback method for the OnOperationStart event.
        /// </summary>
        public void CountOperationCalls(ICallable op, IApplyData data)
        {
            if (_operationsCount.ContainsKey(op))
            {
                _operationsCount[op]++;
            }
            else
            {
                _operationsCount[op] = 1;
            }
        }

        // Custom Native operation to reset the oracle counts back to 0.
        public class ResetOracleCallsImpl : ResetOracleCallsCount
        {
            CounterSimulator _sim;

            public ResetOracleCallsImpl(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Func<QVoid, QVoid> Body => (__in) =>
            {
                _sim._operationsCount.Clear();
                return QVoid.Instance;
            };
        }

        public class GetOracleCallsImpl<T> : GetOracleCallsCount<T>
        {
            CounterSimulator _sim;

            public GetOracleCallsImpl(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Func<T, long> Body => (__in) =>
            {
                var oracle = __in;

                var op = oracle as ICallable;
                Assert.NotNull(op);

                var actual = _sim._operationsCount.ContainsKey(op) ? _sim._operationsCount[op] : 0;
                
                return actual;
            };
        }
        #endregion

        #region Counting allocated qubits
        new public class Allocate : Microsoft.Quantum.Simulation.Simulators.SimulatorBase.Allocate
        {
            public Allocate(SimulatorBase m) : base(m) { }

            public override Qubit Apply()
            {
                _qubitsAllocated++;
                if (_qubitsAllocated > _maxQubitsAllocated)
                {
                    _maxQubitsAllocated = _qubitsAllocated;
                }
                return base.Apply();
            }

            public override QArray<Qubit> Apply(long count)
            {
                _qubitsAllocated += count;
                if (_qubitsAllocated > _maxQubitsAllocated)
                {
                    _maxQubitsAllocated = _qubitsAllocated;
                }
                return base.Apply(count);
            }
        }

        new public class Release : Microsoft.Quantum.Simulation.Simulators.SimulatorBase.Release
        {
            public Release(SimulatorBase m) : base(m) { }

            public override void Apply(Qubit q)
            {
                _qubitsAllocated--;
                base.Apply(q);
            }

            public override void Apply(QArray<Qubit> qubits)
            {
                _qubitsAllocated -= qubits.Length;
                base.Apply(qubits);
            }
        }

        public class ResetQubitCountImpl : ResetQubitCount
        {

            public ResetQubitCountImpl(CounterSimulator m) : base(m) { }

            public override Func<QVoid, QVoid> Body => (__in) =>
            {
                _qubitsAllocated = 0;
                _maxQubitsAllocated = 0;
                return QVoid.Instance;
            };
        }

        public class GetMaxQubitCountImpl : GetMaxQubitCount
        {
            public GetMaxQubitCountImpl(CounterSimulator m) : base(m) { }

            public override Func<QVoid, long> Body => (__in) =>
            {
                return _maxQubitsAllocated;
            };
        }
        #endregion
    }
}
