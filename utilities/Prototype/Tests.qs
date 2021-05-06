// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Prototype {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;

    @Test("QuantumSimulator")
    operation QuantumSimulatorCheck() : Unit {
        Message("Test passed...");
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation CounterSimulatorCheck() : Unit {
        Message("Test passed...");
    }

    @Test("ResourcesEstimator")
    operation ResourcesEstimatorCheck() : Unit {
        Message("Test passed...");
    }

    // Toffoli Simulator check
    @Test("ToffoliSimulator")
    operation ToffoliSimulatorCheck() : Unit {
        Message("Test passed...");
	}

    // MultiSimulator on all three ExecutionTargets
    @Test("QuantumSimulator")
    @Test("ToffoliSimulator")
    @Test("ResourcesEstimator")
    operation ExecutionTargetCheck() : Unit {
        Message("Test passed...");
	}

    // MultiSimulator on multiple simulators
    @Test("QuantumSimulator")
    @Test("ToffoliSimulator")
    @Test("ResourcesEstimator")
    @Test("Microsoft.Quantum.Simulation.Simulators.QCTraceSimulators.QCTraceSimulator")
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation MultipleSimulatorCheck() : Unit {
        Message("Test passed...");
	}

}
