﻿// Copyright (c) Microsoft Corporation. All rights reserved.
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
        private Dictionary<String, int> _operationsCount = new Dictionary<String, int>();
        private Dictionary<long, long> _arityOperationsCount = new Dictionary<long, long>();
        private long _qubitsAllocated = 0;
        private long _maxQubitsAllocated = 0;

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
        
        /// <summary>
        /// Getter method for _operationsCount designed to be accessed from C# code.
        /// See GetOracleCallsCount for accessing within Q#.
        /// </summary>
        public int GetOperationCount(ICallable op)
        {
            return _operationsCount.TryGetValue(op.ToString(), out var value) ? value : 0;
        }

        #region Counting operations upon each operation call
        /// <summary>
        /// Callback method for the OnOperationStart event.
        /// </summary>
        public void CountOperationCalls(ICallable op, IApplyData data)
        {
            // Count all operations, grouped by operation
            if (_operationsCount.ContainsKey(op.ToString()))
            {
                _operationsCount[op.ToString()]++;
            }
            else
            {
                _operationsCount[op.ToString()] = 1;
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
                while (enumerator.MoveNext())
                    nQubits++;
            }

            // Add the operation to the count of operations of corresponding arity
            if (_arityOperationsCount.ContainsKey(nQubits))
            {
                _arityOperationsCount[nQubits]++;
            }
            else
            {
                _arityOperationsCount[nQubits] = 1;
            }
        }
        #endregion

        #region Implementations of Q# operations for specific operation counting
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

            public override Func<QVoid, QVoid> __Body__ => (__in) =>
            {
                _sim._operationsCount.Clear();
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

            public override Func<T, long> __Body__ => (__in) =>
            {
                var oracle = __in;

                var op = oracle as ICallable;
                if (op == null) 
                    throw new InvalidOperationException($"Expected an operation as the argument, got: {oracle}");

                var actual = _sim._operationsCount.ContainsKey(op.ToString()) ? _sim._operationsCount[op.ToString()] : 0;
                
                return actual;
            };
        }
        #endregion

        #region Implementations of Q# operations for counting operations of certain arity
        /// <summary>
        /// Custom Native operation to reset the operation counts back to 0.
        /// </summary>
        public class ResetNQubitOpCountImpl : ResetNQubitOpCount
        {
            CounterSimulator _sim;

            public ResetNQubitOpCountImpl(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Func<QVoid, QVoid> __Body__ => (__in) =>
            {
                _sim._arityOperationsCount.Clear();
                return QVoid.Instance;
            };
        }


        /// <summary>
        /// Custom operation to get the number of operations that take exactly nQubit qubits.
        /// </summary>
        public class GetExactlyNQubitOpCountImpl : GetExactlyNQubitOpCount
        {
            CounterSimulator _sim;

            public GetExactlyNQubitOpCountImpl(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Func<long, long> __Body__ => (__in) =>
            {
                long nQubit = __in;
                return _sim._arityOperationsCount.ContainsKey(nQubit) ? _sim._arityOperationsCount[nQubit] : 0;
            };
        }


        /// <summary>
        /// Custom operation to get the number of operations that take exactly nQubit qubits.
        /// </summary>
        public class GetNPlusQubitOpCountImpl : GetNPlusQubitOpCount
        {
            CounterSimulator _sim;

            public GetNPlusQubitOpCountImpl(CounterSimulator m) : base(m)
            {
                _sim = m;
            }

            public override Func<long, long> __Body__ => (__in) =>
            {
                long nQubit = __in;
                long total = 0;
                foreach (var pair in _sim._arityOperationsCount)
                {
                    if (pair.Key >= nQubit)
                    {
                        total += pair.Value;
                    }
                }
                return total;
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

            public override Func<QVoid, QVoid> __Body__ => (__in) =>
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

            public override Func<QVoid, long> __Body__ => (__in) =>
            {
                return _sim._maxQubitsAllocated;
            };
        }
        #endregion
    }
}
