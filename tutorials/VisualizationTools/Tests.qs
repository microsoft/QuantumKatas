// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.VisualizationTools {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Convert;
    

    @Test("QuantumSimulator")
    operation T1_LearnSingleQubitState () : Unit {
        use q = Qubit();

        // Prepare the state that will be passed to the solution.
        let angle = 0.5;
        Ry(angle, q);

        // Call the solution and get the answer.
        let (α, β) = LearnSingleQubitState(q);

        // Calculate the expected values based on the rotation angle.
        let (α_exp, β_exp) = (Cos(0.5 * angle), Sin(0.5 * angle));

        Fact(AbsD(α - α_exp) <= 0.001 and AbsD(β - β_exp) <= 0.001, 
            "One of the amplitudes was too far from the expected value");

        Reset(q);
    }
    

    // -------------------------------------------------------------------
    @Test("QuantumSimulator")
    operation T2_LearnBasisStateAmplitudes () : Unit {
        use qs = Qubit[2];

        // Prepare the state that will be passed to the solution.
        H(qs[0]);
        ControlledOnInt(0, Ry)([qs[0]], (1.0, qs[1]));
        ControlledOnInt(1, Ry)([qs[0]], (2.0, qs[1]));

        // Call the solution and get the answer.
        let (x1, x2) = LearnBasisStateAmplitudes(qs);

        // Calculate the expected values based on the rotation angle.
        // We convert |00⟩ + |10⟩ to |0⟩ Ry(1.0)|0⟩ + |1⟩ Ry(2.0)|0⟩, so 
        // * the amplitude of |1⟩ = |10⟩ is 1st amp of Ry(2.0)|0⟩
        // * the amplitude of |2⟩ = |01⟩ is 2nd amp of Ry(1.0)|0⟩
        let (x1_exp, x2_exp) = (1.0/Sqrt(2.0) * Cos(0.5 * 2.0), 1.0/Sqrt(2.0) * Sin(0.5 * 1.0));

        Fact(AbsD(x1 - x1_exp) <= 0.001 and AbsD(x2 - x2_exp) <= 0.001, 
            "One of the amplitudes was too far from the expected value");

        ResetAll(qs);
    }


    // -------------------------------------------------------------------
    @Test("QuantumSimulator")
    operation T3_HighProbabilityBasisStates () : Unit {
        let N = 5;
        use qs = Qubit[N];

        // Prepare a superposition state which has most of the amplitudes present, some big and some small.
        let amplitudes = [0.1, 0.01, 0.05, 0.002, 
                          0.0, 0.007, 0.015, 0.003,
                          0.02, 0.9, 0.0, 0.3,
                          0.01, 0.006, 0.001, 0.7,
                          0.0, 0.001, 0.2, 0.003,
                          0.8, 0.0, 0.18, 0.005,
                          0.012, 0.6, 0.0001, 0.0012,
                          0.4, 0.012, 0.0, 0.0
                         ];
        PrepareArbitraryStateD(amplitudes, LittleEndian(qs));

        mutable actual = HighProbabilityBasisStates(qs);
        ResetAll(qs);

        // Normalize the amplitudes, to check the answer programmatically.
        let amplitudesNorm = PNormalized(2.0, amplitudes);
        // Filter out the amplitudes bigger than the threshold.
        mutable expected = [];
        for i in IndexRange(amplitudes) {
            if amplitudesNorm[i] > 0.01 {
                set expected += [i];
            }
        }

        // Compare returned basis states with expected ones.
        set expected = Sorted(LessThanOrEqualI, expected);
        set actual = Sorted(LessThanOrEqualI, actual);

        // Reimplement AllEqualityFactI so as not to give away the expected array.
        if Length(expected) != Length(actual) {
            fail "The returned array has unexpected number of elements";
        }
        for (e, a) in Zipped(expected, actual) {
            if e != a {
                fail "The returned array differed from the expected one.";
            }
        }
    }


    // -------------------------------------------------------------------
    // The operation that is used in the task (not passed to the test for now).
    operation MysteryOperation1 (qs : Qubit[]) : Unit is Adj {
        H(qs[0]);
        Ry(1.0, qs[0]);
        CNOT(qs[0], qs[1]);
        Ry(2.0, qs[1]);
    }


    @Test("QuantumSimulator")
    operation T4_ReadOperationMatrix () : Unit {
        let actual = ReadMysteryOperationMatrix();

        if AbsD(actual - 0.5184) > 1E-3 {
            fail "The returned value was too far from the expected value";
        }
    }


    // -------------------------------------------------------------------
    // The operation that is used in the task (not passed to the test).
    // The regular Deutsch-Jozsa algorithm under the hood, 
    // with an oracle implemented via phase kickback trick that uses a couple of CNOTs.
    operation MysteryOperation2 (N : Int) : Unit {
        // We want to use an oracle that adds up every other bit.
        let r = RangeAsIntArray(0 .. 2 .. N - 1);
        // Define a phase oracle using this array of indices.
        let phaseOracle = ApplyMarkingOracleAsPhaseOracle(MarkingOracleSumOfBits(_, _, r), _);
        // Deutsch-Jozsa algorithm itself.
        mutable isConstant = true;
        use qubits = Qubit[N];
        // Apply the H gates, the oracle and the H gates again.
        within {
            ApplyToEachA(H, qubits);
        } apply {
            phaseOracle(qubits);
        }
        // Measure all qubits.
        // If any of measurement results are 1, the function is balanced.
        for q in qubits {
            if M(q) == One {
                set isConstant = false;
            }
        }
        Message($"The function is {isConstant ? "constant" | "balanced"}"); 
    }


    // Marking oracle implementing a balanced function f(x) = Σᵢ rᵢ xᵢ modulo 2
    // (see DeutschJozsaAlgorithm kata, task 1.5)
    operation MarkingOracleSumOfBits (inputRegister : Qubit[], target : Qubit, r : Int[]) : Unit {
        for ind in r {
            CNOT(inputRegister[ind], target);
        }
    }


    // Phase kickback trick.
    operation ApplyMarkingOracleAsPhaseOracle (markingOracle : (Qubit[], Qubit) => Unit, inputRegister : Qubit[]) : Unit {
        use target = Qubit();
        // Put the target into the |-⟩ state
        within {
            X(target);
            H(target);
        } apply {
            // Apply the marking oracle; since the target is in the |-⟩ state,
            // this will apply a -1 factor to the states that satisfy the oracle condition
            markingOracle(inputRegister, target);
        }
    }    


    @Test("QuantumSimulator")
    operation T5_ReadOperationTrace () : Unit {
        let (expectedQ, expectedH, expectedCNOT) = (4, 8, 2);
        let (actualQ, actualH, actualCNOT) = ReadMysteryOperationTrace();

        if expectedQ != actualQ or expectedH != actualH or expectedCNOT != actualCNOT {
            fail "One of the returned values differed from the expected value";
        }
    }
}
