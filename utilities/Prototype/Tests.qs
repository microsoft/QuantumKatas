// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness to verify
// if the `%kata` and `%check_kata` magics work as expected.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Prototype {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Quantum.Kata.Utils;

    /// # Summary
    /// The operation below checks if all qubits in the register have been
    /// successfully converted from zeros to ones
    /// #Input
    /// ## N
    /// The number of qubits in the register
    operation Check_FlipZerosToOnes(N : Int) : Unit {

        use qs = Qubit[N];

        FlipZerosToOnes(qs);

        for q in qs
        {
            AssertQubit(One, q);
        }

        ResetAll(qs);

        Message($"Test passed for {N} qubits");
    }

    /// #Summary
    /// This operation allows user to use only one H gate to convert |0> to |+> state
    /// using ResetOracleCallsCount() and GetOracleCallsCount(H) respectively.
    /// This can only be run on a CounterSimulator.
    operation CounterSimulatorCheck() : Unit {
        use q = Qubit();
        H(q);

        ResetOracleCallsCount();

        FlipZeroToPlusRestriction(q);
        let nu = GetOracleCallsCount(H);

        AssertQubit(Zero, q);

        EqualityFactI(nu, 1, $"You are allowed to call H gate exactly once, and you called it {nu} times");

        Message("Test passed...");
    }

    /// #Summary
    /// This operation imposes no limitation on the number of H gates that can be
    /// called by the user to convert |0> to |+> state.
    /// This test can't be run on ToffoliSimulator, since Toffoli simulator
    /// allows for only `X`, `CNOT`, `CCNOT` and controlled version of `X` gates.
    operation QuantumSimulatorCheck() : Unit {
        use q = Qubit();

        H(q);

        FlipZeroToPlusNoRestriction(q);

        AssertQubit(Zero, q);

        Message("Test passed...");
    }

    // ------------------------------------------------------
    // Toffoli Simulator
    // - Toffoli simulator can support a large number of qubits.
    // - However, it can only support the X, CNOT, CCNOT and controlled variants of X gates.
    // ------------------------------------------------------

    /// # Summary
    /// The test below allocates and manipulates 150 qubits.
    /// We can use only Toffoli simulator for this test.
    /// A full state simulator will run out of memory during the qubit allocation
    /// if large number of qubits are allocated.
    /// Below is an example of passing test.
    @Test("ToffoliSimulator")
    operation T11_PassOnToffoliSimulator() : Unit {
        Check_FlipZerosToOnes(150);
	}

    /// # Summary
    /// The test below allocates and manipulates 150 qubits.
    /// We can use only Toffoli simulator for this test.
    /// A full state simulator will run out of memory during the qubit allocation
    /// if large number of qubits are allocated, and hence the test would fail
    /// Below is an example of failing test.
    @Test("QuantumSimulator")
    operation T12_FailOnQuantumSimulator() : Unit {
        Check_FlipZerosToOnes(150);
	}

    /// # Summary
    /// The test below allocates and manipulates 150 qubits.
    /// We can use only Toffoli simulator for this test.
    /// A full state simulator will run out of memory during the qubit allocation
    /// if large number of qubits are allocated, and hence the test would fail
    /// Below is an example of failing test.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T13_FailOnCounterSimulator() : Unit {
        Check_FlipZerosToOnes(150);
	}

    // ------------------------------------------------------
    // Counter Simulator
    // ------------------------------------------------------
    // This simulator is designed especially for the purpose of imposing
    // limits on the learner while they think of solutions.
    //
    // Note : Any test using the custom functionalities of CounterSimulator would
    // fail on Toffoli and Quantum Simulator due to lack of support
    // For details about custom functionalities offered by CounterSimulator,
    // check the operations in Utils.qs file here()

    /// #Summary
    /// This test below uses ResetOracleCallsCount() and GetOracleCallsCount(H)
    /// from the CounterSimulator respectively to allow user to use only one H gate
    /// Below is an example of passing test
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T21_PassOnCounterSimulator() : Unit {
        CounterSimulatorCheck();
    }

    /// #Summary
    /// This test below uses ResetOracleCallsCount() and GetOracleCallsCount(H)
    /// and hence would fail on simulators other than CounterSimulator.
    @Test("QuantumSimulator")
    operation T22_FailOnQuantumSimulator() : Unit {
        CounterSimulatorCheck();
    }

    /// #Summary
    /// This test below uses ResetOracleCallsCount() and GetOracleCallsCount(H)
    /// and hence would fail on simulators other than CounterSimulator.
    @Test("ToffoliSimulator")
    operation T23_FailOnToffoliSimulator() : Unit {
        CounterSimulatorCheck();
    }

    // ------------------------------------------------------
    // Quantum Simulator
    // ------------------------------------------------------

    /// # Summary
    /// This test imposes no limitation on the number of H gates that can be
    /// called by the user to convert |0> to |+> state.
    ///
    /// Note : We are using mutltiple @Test attributes to check if the test succeeded
    /// on both QuantumSimulator and CounterSimulator since we can't design a test
    /// that passes on QuantumSimulator but fails on CounterSimulator
    /// This is because latter offers all the functionality of the former.
    @Test("QuantumSimulator")
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T31_PassOnQuantumSimulator() : Unit {
        QuantumSimulatorCheck();
    }

    /// # Summary
    /// This test fails on `ToffoliSimulator` because it allows to simulate
    /// `X`, `CNOT`, `CCNOT` and controlled version of `X` gates.
    @Test("ToffoliSimulator")
    operation T32_FailOnToffoliSimulator() : Unit {
        QuantumSimulatorCheck();
    }

    // ------------------------------------------------------
    // Multiple Simulators
    // ------------------------------------------------------

    /// #Summary
    /// This test uses multiple `@Test` attrributes to simulate on multiple simulators
    /// The test succeeds if its successful on simulators in the set
    /// {`QuantumSimulator`, `CounterSimulator` , `ToffoliSimulator`}
    ///
    /// For succcess, the user needs to succesfully convert
    /// all qubits from |0..0> to |1..1> state using `X`, `CNOT`, `CCNOT`
    /// and controlled versions of `X` gates
    @Test("QuantumSimulator")
    @Test("ToffoliSimulator")
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation MultipleSimulatorCheck() : Unit {
        Check_FlipZerosToOnes(2);
	}

}
