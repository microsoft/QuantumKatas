// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Counting {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arithmetic;    
    open Microsoft.Quantum.Characterization;


    //////////////////////////////////////////////////////////////////
    // Part I. Oracle for Counting
    //////////////////////////////////////////////////////////////////
    
	operation Oracle_SolutionCount_Reference (queryRegister : Qubit[], target : Qubit, nSol : Int) : Unit is Ctl+ Adj {
    // Designate first nSol integers solutions (since we don't really care which ones are solutions)
		for (i in 0 .. nSol - 1) {
        (ControlledOnInt(i, X))(queryRegister, target);
		}
	}
    
    //////////////////////////////////////////////////////////////////
    // Part II. The Grover iteration
    //////////////////////////////////////////////////////////////////
   

    // Helper operation which converts marking oracle into phase oracle using an extra qubit
    operation ApplyMarkingOracleAsPhaseOracle (markingOracle : ((Qubit[], Qubit) => Unit is Ctl+Adj), register : Qubit[]) : Unit is Adj+Ctl {
        using (target = Qubit()) {
            // Put the target into the |-⟩ state
            X(target);
            H(target);
                
            // Apply the marking oracle; since the target is in the |-⟩ state,
            // flipping the target if the register satisfies the oracle condition will apply a -1 factor to the state
            markingOracle(register, target);
                
            // Put the target back into |0⟩ so we can return it
            H(target);
            X(target);
        }
    }
    
    // The Grover iteration
    operation GroverIteration (register : Qubit[], oracle : ((Qubit[],Qubit) => Unit is Ctl+Adj)) : Unit  is Ctl+Adj
    {

            // apply oracle
            ApplyMarkingOracleAsPhaseOracle(oracle, register);
            // apply inversion about the mean
            ApplyToEachCA(H, register);
            ApplyToEachCA(X, register);
            Controlled Z(Most(register), Tail(register));
            ApplyToEachCA(X, register);
            ApplyToEachCA(H, register);
	}
    
    
    //////////////////////////////////////////////////////////////////
    // Part III. Putting it all together: Quantum Counting
    //////////////////////////////////////////////////////////////////
    

	operation Counting_Reference(n_bit : Int, n_sol: Int, precision: Int) : Double {
        mutable phase = -1.0;

        using ((reg,phaseRegister)=(Qubit[n_bit],Qubit[precision]))
        {                                  
        let oracle = OracleToDiscrete(GroverIteration(_, Oracle_SolutionCount_Reference(_,_,n_sol)));


        // Allocate qubits to hold the eigenstate of U and the phase in a big endian register 
            
            let phaseRegisterBE = BigEndian(phaseRegister);
            // Prepare the eigenstate of U
                ApplyToEach(H, reg);
            // Call library
            QuantumPhaseEstimation(oracle, reg, phaseRegisterBE);
            // Read out the phase
            set phase = IntAsDouble(MeasureInteger(BigEndianAsLittleEndian(phaseRegisterBE))) / IntAsDouble(1 <<< (n_bit));

            ResetAll(reg);
            ResetAll(phaseRegister);
        }
        let angle = PI()*phase;
        let res = (PowD(Sin(angle),2.0));

        return PowD(2.0,IntAsDouble(n_bit))*res;
    }

     operation CR(): Double {
	   return  Counting_Reference(4, 4, 3);
	 }
}
