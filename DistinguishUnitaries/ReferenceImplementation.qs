// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DistinguishUnitaries {    
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Oracles;
    
    // Task 1.1. Identity or Pauli X?
    // Output: 0 if the given operation is the I gate,
    //         1 if the given operation is the X gate.
    operation DistinguishIfromX_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply operation to the |0⟩ state and measure: |0⟩ means I, |1⟩ means X
        using (q = Qubit()) {
            unitary(q);
            return M(q) == Zero ? 0 | 1;
        }
    }


    // Task 1.2. Identity or Pauli Z?
    // Output: 0 if the given operation is the I gate,
    //         1 if the given operation is the Z gate.
    operation DistinguishIfromZ_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply operation to the |+⟩ state and measure: |+⟩ means I, |-⟩ means Z
        using (q = Qubit()) {
            H(q);
            unitary(q);
            H(q);
            return M(q) == Zero ? 0 | 1;
        }
    }


    // Task 1.3. Z or S?
    // Output: 0 if the given operation is the Z gate,
    //         1 if the given operation is the S gate.
    operation DistinguishZfromS_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply operation twice to |+⟩ state and measure: |+⟩ means Z, |-⟩ means S
        // X will end up as XXX = X, H will end up as HXH = Z (does not change |0⟩ state)
        using (q = Qubit()) {
            H(q);
            unitary(q);
            unitary(q);
            H(q);
            return M(q) == Zero ? 0 | 1;
        }
    }


    // Task 1.4. Hadamard or Pauli X?
    // Output: 0 if the given operation is the H gate,
    //         1 if the given operation is the X gate.
    operation DistinguishHfromX_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply operation unitary - X - unitary to |0⟩ state and measure: |0⟩ means H, |1⟩ means X
        // X will end up as XXX = X, H will end up as HXH = Z (does not change |0⟩ state)
        using (q = Qubit()) {
            within {
                unitary(q);
            } apply {
                X(q);
            }
            return M(q) == Zero ? 0 | 1;
        }
    }
    

    // Task 1.5. Z or -Z?
    // Output: 0 if the given operation is the Z gate,
    //         1 if the given operation is the -Z gate.
    operation DistinguishZfromMinusZ_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply Controlled unitary to (|0⟩ + |1⟩) ⊗ |0⟩ state: Z will leave it unchanged while -Z will make it into (|0⟩ + |1⟩) ⊗ |0⟩
        using (qs = Qubit[2]) {
            // prep (|0⟩ + |1⟩) ⊗ |0⟩
            H(qs[0]);

            Controlled unitary(qs[0..0], qs[1]);

            H(qs[0]);
            // |0⟩ means it was Z, |1⟩ means -Z

            return M(qs[0]) == Zero ? 0 | 1;
        }
    }


    // Task 1.6. Rz or R1 (arbitrary angle)?
    // Output: 0 if the given operation is the Rz gate,
    //         1 if the given operation is the R1 gate.
    operation DistinguishRzFromR1_Reference (unitary : ((Double, Qubit) => Unit is Adj+Ctl)) : Int {
        using (qs = Qubit[2]) {
            within {
                H(qs[0]);
            } apply {
                Controlled unitary(qs[0..0], (2.0 * PI(), qs[1]));
            }
            return M(qs[0]) == Zero ? 1 | 0;
        }
    }


    // Task 1.7. Y or XZ?
    // Output: 0 if the given operation is the Y gate,
    //         1 if the given operation is the XZ gate.
    operation DistinguishYfromXZ_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // Y = iXZ
        // Controlled Y introduces an extra phase of i (if applied to any state) compared to XZ
        // applying it twice introduces an extra phase of -1
        // It actually doesn't matter to which state to apply it!
        using (qs = Qubit[2]) {
            // prep (|0⟩ + |1⟩) ⊗ |0⟩
            within { H(qs[0]); }
            apply {  
                Controlled unitary(qs[0..0], qs[1]);
                Controlled unitary(qs[0..0], qs[1]);
            }

            // 0 means it was Y
            return M(qs[0]) == Zero ? 0 | 1;
        }
    }
    

    operation Oracle_Reference (U : (Qubit => Unit is Adj + Ctl), power : Int, target : Qubit[]) : Unit is Adj + Ctl {
        for (i in 1 .. power) {
            U(target[0]);
        }
    }


    // Task 1.8. Y, XZ, -Y or -XZ?
    // Output: 0 if the given operation is the Y gate,
    //         1 if the given operation is the -XZ gate,
    //         2 if the given operation is the -Y gate,
    //         3 if the given operation is the XZ gate.
    operation DistinguishYfromXZWithPhases_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // Run phase estimation on the unitary and the +1 eigenstate of the Y gate |0⟩ + i|1⟩

        // Construct a phase estimation oracle from the unitary
        let oracle = DiscreteOracle(Oracle_Reference(unitary, _, _));

        // Allocate qubits to hold the eigenstate of U and the phase in a big endian register 
        mutable phaseInt = 0;
        using ((eigenstate, phaseRegister) = (Qubit[1], Qubit[2])) {
            let phaseRegisterBE = BigEndian(phaseRegister);
            // Prepare the eigenstate of U
            H(eigenstate[0]); 
            S(eigenstate[0]);
            // Call library
            QuantumPhaseEstimation(oracle, eigenstate, phaseRegisterBE);
            // Read out the phase
            set phaseInt = MeasureInteger(BigEndianAsLittleEndian(phaseRegisterBE));

            ResetAll(eigenstate);
            ResetAll(phaseRegister);
        }

        // Convert the measured phase into return value
        return phaseInt;
    }


    // ------------------------------------------------------
    internal function ComputeRepetitions(angle : Double, offset : Int, accuracy : Double) : Int {
        mutable pifactor = 0;
        while (true) {
            let pimultiple = PI() * IntAsDouble(2 * pifactor + offset);
            let times = Round(pimultiple / angle);
            if (AbsD(pimultiple - (IntAsDouble(times) * angle)) / PI() < accuracy) {
                return times;
            }
            set pifactor += 1;
        }
        return 0;
    }

    // Task 1.9. Rz or Ry (fixed angle)?
    // Output: 0 if the given operation is the Rz(θ) gate,
    //         1 if the given operation is the Ry(θ) gate.
    operation DistinguishRzFromRy_Reference (theta : Double, unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        using (q = Qubit()) {
            let times = ComputeRepetitions(theta, 1, 0.1);
            mutable attempt = 1;
            mutable measuredOne = false;
            repeat {
                for (_ in 1..times) {
                    unitary(q);
                }
                // for Rz, we'll never venture away from |0⟩ state, so as soon as we got |1⟩ we know it's not Rz
                if (MResetZ(q) == One) {
                    set measuredOne = true;
                }
                // if we try several times and still only get |0⟩s, chances are that it is Rz
            } until (attempt == 5 or measuredOne) 
            fixup {
                set attempt += 1;
            }
            return measuredOne ? 1 | 0;
        }
    }


    // Task 1.10*. Rz or R1 (fixed angle)?
    // Output: 0 if the given operation is the Rz(θ) gate,
    //         1 if the given operation is the R1(θ) gate.
    operation DistinguishRzFromR1WithAngle_Reference (theta : Double, unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // library solution that uses direct access to the simulator for speedup and reliability
        return Floor(EstimateRealOverlapBetweenStates(ApplyToEachA(H, _), ApplyToEachCA(unitary, _), ApplyToEachCA(R1(theta, _), _), 1, 100000));
    }


    // Task 1.11. Distinguish 4 Pauli unitaries
    // Output: 0 if the given operation is the I gate,
    //         1 if the given operation is the X gate,
    //         2 if the given operation is the Y gate,
    //         3 if the given operation is the Z gate,
    operation DistinguishPaulis_Reference (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // apply operation to the 1st qubit of a Bell state and measure in Bell basis
        using (qs = Qubit[2]) {
            within {
                H(qs[0]);
                CNOT(qs[0], qs[1]);
            } apply {
                unitary(qs[0]);
            }

            // after this I -> 00, X -> 01, Y -> 11, Z -> 10
            let ind = MeasureInteger(LittleEndian(qs));
            let returnValues = [0, 3, 1, 2];
            return returnValues[ind];
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Multi-Qubit Gates
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1. I ⊗ X or CNOT?
    // Output: 0 if the given operation is I ⊗ X,
    //         1 if the given operation is the CNOT gate.
    operation DistinguishIXfromCNOT_Reference (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // apply to |00⟩ and measure 2nd qubit: CNOT will do nothing, I ⊗ X will change to |01⟩
        using (qs = Qubit[2]) {
            unitary(qs);
            return M(qs[1]) == One ? 0 | 1;
        }
    }


    // Task 2.2. Figure out the direction of CNOT
    // Output: 0 if the given operation is CNOT₁₂,
    //         1 if the given operation is CNOT₂₁.
    operation CNOTDirection_Reference (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // apply to |01⟩ and measure 1st qubit: CNOT₁₂ will do nothing, CNOT₂₁ will change to |11⟩
        using (qs = Qubit[2]) {
            within { X(qs[1]); }
            apply { unitary(qs); }
            return M(qs[0]) == Zero ? 0 | 1;
        }
    }


    // Task 2.3. CNOT₁₂ or SWAP?
    // Output: 0 if the given operation is the CNOT₁₂ gate,
    //         1 if the given operation is the SWAP gate.
    operation DistinguishCNOTfromSWAP_Reference (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // apply to |01⟩ and measure 1st qubit: CNOT will do nothing, SWAP will change to |10⟩
        using (qs = Qubit[2]) {
            X(qs[1]);
            unitary(qs);
            Reset(qs[1]);
            return M(qs[0]) == Zero ? 0 | 1;
        }
    }


    // Task 2.4. Identity, CNOTs or SWAP?
    // Output: 0 if the given operation is the I ⊗ I gate,
    //         1 if the given operation is the CNOT₁₂ gate,
    //         2 if the given operation is the CNOT₂₁ gate,
    //         3 if the given operation is the SWAP gate.
    operation DistinguishTwoQubitUnitaries_Reference (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // first run: apply to |11⟩; CNOT₁₂ will give |10⟩, CNOT₂₁ will give |01⟩, II and SWAP will remain |11⟩
        using (qs = Qubit[2]) {
            ApplyToEach(X, qs);
            unitary(qs);
            let ind = MeasureInteger(LittleEndian(qs));
            if (ind == 1 or ind == 2) {
                // respective CNOT
                return ind;
            }
        }
        // second run: distinguish II from SWAP, apply to |01⟩: II will remain |01⟩, SWAP will become |10⟩
        using (qs = Qubit[2]) {
            X(qs[1]);
            unitary(qs);
            let ind = MeasureInteger(LittleEndian(qs));
            return ind == 1 ? 3 | 0;
        }
    }
}
