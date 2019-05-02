// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using Microsoft.Quantum.Simulation.Common;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

using Xunit;

namespace Quantum.Kata.GroversAlgorithm
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
        private long _qubitsAllocated = 0;
        private long _maxQubitsAllocated = 0;

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
        new public class Allocate : SimulatorBase.Allocate
        {
            CounterSimulator _sim;

            public Allocate(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Qubit Apply()
            {
                _sim._qubitsAllocated++;
                if (_sim._qubitsAllocated > _sim._maxQubitsAllocated)
                {
                    _sim._maxQubitsAllocated = _sim._qubitsAllocated;
                }
                return base.Apply();
            }

            public override IQArray<Qubit> Apply(long count)
            {
                _sim._qubitsAllocated += count;
                if (_sim._qubitsAllocated > _sim._maxQubitsAllocated)
                {
                    _sim._maxQubitsAllocated = _sim._qubitsAllocated;
                }
                return base.Apply(count);
            }
        }

        new public class Release : SimulatorBase.Release
        {
            CounterSimulator _sim;

            public Release(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override void Apply(Qubit q)
            {
                _sim._qubitsAllocated--;
                base.Apply(q);
            }

            public override void Apply(IQArray<Qubit> qubits)
            {
                _sim._qubitsAllocated -= qubits.Length;
                base.Apply(qubits);
            }
        }

        public class ResetQubitCountImpl : ResetQubitCount
        {
            CounterSimulator _sim;

            public ResetQubitCountImpl(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Func<QVoid, QVoid> Body => (__in) =>
            {
                _sim._qubitsAllocated = 0;
                _sim._maxQubitsAllocated = 0;
                return QVoid.Instance;
            };
        }

        public class GetMaxQubitCountImpl : GetMaxQubitCount
        {
            CounterSimulator _sim;

            public GetMaxQubitCountImpl(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Func<QVoid, long> Body => (__in) =>
            {
                return _sim._maxQubitsAllocated;
            };
        }
        #endregion
    }
}
