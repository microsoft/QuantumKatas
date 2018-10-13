// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SimonsAlgorithm
{
    using System.Collections.Generic;

    using Microsoft.Quantum.Simulation.Core;
    using Microsoft.Quantum.Simulation.Simulators;

    /// <summary>
    ///     This custom quantum simulator keeps track of the number of times 
    ///     each operation is executed, by providing a custom native operation: 
    ///     `AssertOracleCallsCount` which asserts the number of times
    ///     the given oracle (operation) has been called.
    /// </summary>
    public class OracleCounterSimulator : QuantumSimulator
    {
        private Dictionary<ICallable, int> _operationsCount = new Dictionary<ICallable, int>();

        public OracleCounterSimulator(
            bool throwOnReleasingQubitsNotInZeroState = true, 
            uint? randomNumberGeneratorSeed = null, 
            bool disableBorrowing = false) : 
            base(throwOnReleasingQubitsNotInZeroState, randomNumberGeneratorSeed, disableBorrowing)
        {
            OnOperationStart += CountOperationCalls;
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
        
        public int GetOperationCount(ICallable op)
        {
            return _operationsCount.TryGetValue(op, out var value) ? value : 0;
        }
    }
}
