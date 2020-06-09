// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains some Q# intrinsic operations
// needed for the validation of some Katas' answers.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Utils {
    
    /// # Summary
    /// Returns how many times a given oracle is executed.
    /// # Input
    /// ## oracle
    /// The operation whose call count is being requested.
    operation GetOracleCallsCount<'T> (oracle : 'T) : Int { body intrinsic; }
    
    /// # Summary
    /// Resets the variable that tracks how many times an oracle
    /// is executed back to 0.
    operation ResetOracleCallsCount () : Unit { body intrinsic; }


    /// # Summary
    /// Returns the max number of qubits allocated at any given point by the simulator.
    operation GetMaxQubitCount () : Int { body intrinsic; }

    /// # Summary
    /// Resets the variable that tracks the max number of qubits
    /// allocated at any given point by the simulator.
    operation ResetQubitCount () : Unit { body intrinsic; }


    /// # Summary
    /// Returns the number of multi-qubit operations used by the simulator.
    operation GetMultiQubitOpCount () : Int { body intrinsic; }
}
