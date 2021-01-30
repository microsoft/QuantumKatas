// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.PhaseEstimation {
    
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Quantum phase estimation (QPE)
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. Inputs to QPE: eigenstates of Z/S/T gates.
    operation Eigenstates_ZST_Reference (q : Qubit, state : Int) : Unit is Adj {
        if (state == 1) {
            X(q);
        }
    }


    // ------------------------------------------------------
    operation UnitaryPowerImpl_Reference (U : (Qubit => Unit is Adj + Ctl), power : Int, q : Qubit) : Unit is Adj + Ctl {
        for _ in 1 .. power {
            U(q);
        }
    }

    // Task 1.2. Inputs to QPE: powers of Z/S/T gates.
    function UnitaryPower_Reference (U : (Qubit => Unit is Adj + Ctl), power : Int) : (Qubit => Unit is Adj + Ctl) {
        return UnitaryPowerImpl_Reference(U, power, _);
    }


    // ------------------------------------------------------
    // Task 1.3. Validate inputs to QPE
    operation AssertIsEigenstate_Reference (U : (Qubit => Unit), P : (Qubit => Unit is Adj)) : Unit {
        use q = Qubit();
        // Prepare the state |ψ⟩
        P(q);
        // Apply the given unitary
        U(q);
        // If the given state is an eigenstate, the current state of the qubit should be |ψ⟩ (up to a global phase).
        // So un-preparing it should bring the state back to |0⟩
        Adjoint P(q);
        AssertQubit(Zero, q);
    }


    // ------------------------------------------------------
    operation Oracle_Reference (U : (Qubit => Unit is Adj + Ctl), power : Int, target : Qubit[]) : Unit is Adj + Ctl{
        for _ in 1 .. power {
            U(target[0]);
        }
    }

    // Task 1.4. QPE for single-qubit unitaries
    operation QPE_Reference (U : (Qubit => Unit is Adj + Ctl), P : (Qubit => Unit is Adj), n : Int) : Double {
        // Construct a phase estimation oracle from the unitary
        let oracle = DiscreteOracle(Oracle_Reference(U, _, _));
        // Allocate qubits to hold the eigenstate of U and the phase in a big endian register 
        use (eigenstate, phaseRegister) = (Qubit[1], Qubit[n]);
        let phaseRegisterBE = BigEndian(phaseRegister);
        // Prepare the eigenstate of U
        P(eigenstate[0]);
        // Call library
        QuantumPhaseEstimation(oracle, eigenstate, phaseRegisterBE);
        // Read out the phase
        let phase = IntAsDouble(MeasureInteger(BigEndianAsLittleEndian(phaseRegisterBE))) / IntAsDouble(1 <<< n);

        ResetAll(eigenstate);
        return phase;
    }

    // A reference solution to Task 1.4 that uses a lower level library primitive, QFTLE.
    // Follows the algorithm as given in
    // https://en.wikipedia.org/w/index.php?title=Quantum_phase_estimation_algorithm&oldid=953506229
    // We let exp(2πiθ) denote the eigenvalue of U corresponding to eigenstate P|0⟩.
    // This function will return an approximation of θ.
    operation QPE_Reference_QFT (U : (Qubit => Unit is Adj + Ctl), P : (Qubit => Unit is Adj), n : Int) : Double {
        
        use (eigenstate, phaseRegister) = (Qubit(), Qubit[n]);
        // Prepare the eigenstate of U
        P(eigenstate);

        // Put phaseRegister into a uniform superposition of all computational basis states.
        ApplyToEachA(H, phaseRegister);

        // Apply controlled U gates so that |k⟩ gets transformed into exp(2πikθ)|k⟩.
        // Here |k⟩ is encoded in little-endian format in phaseRegister.
        for i in 0 .. n - 1 {
            let powU = UnitaryPower_Reference(U, 1 <<< i); // powU = U^(2ⁱ)
            Controlled powU([phaseRegister[i]], eigenstate);
        }

        // Apply an inverse QFT to phaseRegister.
        // We use QFTLE because phaseRegister is little-endian encoded.
        // This leaves phaseRegister in a superposition of integers which are close to θ*2^n.
        // See the linked Wikipedia article on the details of this superposition.
        Adjoint QFTLE(LittleEndian(phaseRegister));

        // Measure out an integer that is close to θ*2^n.
        let phaseRegisterMeasurement = MeasureInteger(LittleEndian(phaseRegister));

        // Clean up eigenstate qubits
        Reset(eigenstate);

        // Scale our measurement down to [0, 1) and return our estimate.
        let phaseEstimate = IntAsDouble(phaseRegisterMeasurement) / IntAsDouble(1 <<< n);
        return phaseEstimate;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Iterative phase estimation
    //////////////////////////////////////////////////////////////////
    
    // Task 2.1. Single-bit phase estimation
    operation SingleBitPE_Reference (U : (Qubit => Unit is Adj + Ctl), P : (Qubit => Unit is Adj)) : Int {
        
        use (control, eigenstate) = (Qubit(), Qubit());
        // prepare the eigenstate |ψ⟩
        P(eigenstate);

        within {
            H(control);     
        } apply {
            Controlled U([control], eigenstate);
        }

        let eigenvalue = M(control) == Zero ? 1 | -1;
        Reset(eigenstate);
        return eigenvalue;
    }


    // Task 2.2. Two bit phase estimation
    operation TwoBitPE_Reference (U : (Qubit => Unit is Adj + Ctl), P : (Qubit => Unit is Adj)) : Double {

        // Start by using the same circuit as in task 2.1.
        // For eigenvalues +1 and -1, it produces measurement results Zero and One, respectively, 100% of the time;
        // for eigenvalues +i and -i, it produces both results with 50% probability, so a different circuit is required.
        use (control, eigenstate) = (Qubit(), Qubit()) {
            // prepare the eigenstate |ψ⟩
            P(eigenstate);

            mutable (measuredZero, measuredOne) = (false, false); 
            mutable iter = 0;
            repeat {
                set iter += 1;

                within {
                    H(control);     
                } apply {
                    Controlled U([control], eigenstate);
                }

                let meas = MResetZ(control);
                set (measuredZero, measuredOne) = (measuredZero or meas == Zero, measuredOne or meas == One);
            } 
            // repeat the loop until we get both Zero and One measurement outcomes
            // or until we're reasonably certain that we won't get a different outcome
            until (iter == 10 or measuredZero and measuredOne);
            Reset(eigenstate);

            if (not measuredZero or not measuredOne) {
                // all measurements yielded Zero => eigenvalue +1
                // all measurements yielded One => eigenvalue -1
                return measuredOne ? 0.5 | 0.0;
            }
        }

        // To distinguish between eigenvalues i and -i, we need a circuit with an extra S gate on control qubit
        use (control, eigenstate) = (Qubit(), Qubit()) {
            // prepare the eigenstate |ψ⟩
            P(eigenstate);

            H(control);
            Controlled U([control], eigenstate);
            S(control);
            H(control);

            let eigenvalue = M(control) == Zero ? 0.75 | 0.25;
            Reset(eigenstate);

            return eigenvalue;
        }
        
    }
}
