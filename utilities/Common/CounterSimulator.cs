// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;
using System.Collections.Generic;

using Microsoft.Quantum.Simulation.Common;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

using Quantum.Kata.Utils;

namespace Microsoft.Quantum.Katas
{
    /// <summary>
    ///     This custom quantum simulator keeps track of the number of times each operation is executed
    ///     and the maximum number of qubits allocated at any point during program execution.
    /// </summary>
    public class CounterSimulator : QuantumSimulator
    {
        private Dictionary<ICallable, int> _operationsCount = new Dictionary<ICallable, int>();
        private long _qubitsAllocated = 0;
        private long _maxQubitsAllocated = 0;
        private long _multiQubitOperations = 0;

        /// <param name="throwOnReleasingQubitsNotInZeroState">If set to true, the exception is thrown when trying to release qubits not in zero state.</param>
        /// <param name="randomNumberGeneratorSeed">Seed for the random number generator used by a simulator for measurement outcomes and Primitives.Random operation.</param>
        /// <param name="disableBorrowing">If true, Borrowing qubits will be disabled, and a new qubit will be allocated instead every time borrowing is requested. Performance may improve.</param>
        public CounterSimulator(
            bool throwOnReleasingQubitsNotInZeroState = true, 
            uint? randomNumberGeneratorSeed = null, 
            bool disableBorrowing = false) : 
            base(throwOnReleasingQubitsNotInZeroState, randomNumberGeneratorSeed, disableBorrowing)
        {
            this.OnOperationStart += CountOperationCalls;
        }

        #region Counting operations
        /// <summary>
        /// Callback method for the OnOperationStart event.
        /// </summary>
        public void CountOperationCalls(ICallable op, IApplyData data)
        {
            // Count all operations, grouped by operation
            if (_operationsCount.ContainsKey(op))
            {
                _operationsCount[op]++;
            }
            else
            {
                _operationsCount[op] = 1;
            }

            // Check if the operation has multiple qubit parameters, if yes, count it
            int nQubits = 0;
            using (IEnumerator<Qubit> enumerator = data?.Qubits?.GetEnumerator())
            {
                if (enumerator is null)
                {
                    // The operation doesn't have qubit parameters
                    return;
                }
                while (enumerator.MoveNext() && nQubits < 2)
                    nQubits++;
            }
            if (nQubits >= 2)
            {
                _multiQubitOperations++;
            }
        }

        /// <summary>
        /// Custom Native operation to reset the oracle counts back to 0.
        /// </summary>
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
                _sim._multiQubitOperations = 0;
                return QVoid.Instance;
            };
        }

        /// <summary>
        /// Custom Native operation to get the number of operation calls.
        /// </summary>
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
                if (op == null) 
                    throw new InvalidOperationException($"Expected an operation as the argument, got: {oracle}");

                var actual = _sim._operationsCount.ContainsKey(op) ? _sim._operationsCount[op] : 0;
                
                return actual;
            };
        }

        /// <summary>
        /// Custom operation to get the number of multi-qubit operations.
        /// </summary>
        public class GetMultiQubitOpCountImpl : GetMultiQubitOpCount
        {
            CounterSimulator _sim;

            public GetMultiQubitOpCountImpl(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Func<QVoid, long> Body => (__in) =>
            {
                return _sim._multiQubitOperations;
            };
        }
        #endregion

        #region Counting allocated qubits
        /// <summary>
        /// Custom operation to update the number of allocated qubits upon qubit allocation.
        /// </summary>
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

        /// <summary>
        /// Custom operation to update the number of allocated qubits upon qubit release.
        /// </summary>
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

        /// <summary>
        /// Custom operation to reset the numbers of allocated qubits.
        /// </summary>
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

        /// <summary>
        /// Custom operation to get the maximal number of allocated qubits.
        /// </summary>
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
