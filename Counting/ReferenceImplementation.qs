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
    
    // Task 1.1. The Sprinkler oracle
	// Let us consider an example inspired by the sprinkler problem of (Pearl 1988): 
	// we have three Boolean variable, s, r, w representing respectively propositions 
	// “the sprinkler was on”, "ıt rained last night” and “the grass is wet”. 
	// We know that if the sprinkler was on the grass is wet (s → w), 
	// if it rained last night the grass is wet (r → w) 
	//and that the the sprinkler being on and rain last night cannot be true at the same time (s, r →).
	// Transformed in conjunctive normal formal we obtain formula (¬s ∨ w) ∧ (¬r ∨ w) ∧ (¬s ∨ ¬r)
	// Let s,r,w=queryRegister[0],queryRegister[1],queryRegister[2]
    operation Oracle_Sprinkler_Reference (queryRegister : Qubit[], target : Qubit, ancilla : Qubit[]) : Unit
    {    
	       body (...) {
				X(queryRegister[2]);
				X(ancilla[0]);
				X(ancilla[1]);
				X(ancilla[2]);
                
				CCNOT(queryRegister[0],queryRegister[1],ancilla[0]);
				CCNOT(queryRegister[1],queryRegister[2],ancilla[1]);
				CCNOT(queryRegister[0],queryRegister[2],ancilla[2]);
				(Controlled X)([ancilla[0],ancilla[1],ancilla[2]],target);
				CCNOT(queryRegister[0],queryRegister[2],ancilla[2]);
				CCNOT(queryRegister[1],queryRegister[2],ancilla[1]);
				CCNOT(queryRegister[0],queryRegister[1],ancilla[0]);

				X(ancilla[2]);
				X(ancilla[1]);
				X(ancilla[0]);            
           }
			adjoint invert;
			controlled auto;
			controlled adjoint auto;
    }
    
    
    
    
    // Arbitrary bit pattern oracle
    operation Oracle_ArbitraryPattern_Reference (queryRegister : Qubit[], target : Qubit, pattern : Bool[]) : Unit
    is Adj+Ctl {        
        (ControlledOnBitString(pattern, X))(queryRegister, target);
    }
    
    
    // Oracle converter
    operation OracleConverterImpl (markingOracle : ((Qubit[], Qubit) => Unit is Adj+Ctl), register : Qubit[]) : Unit
    is Adj+Ctl {
        
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
    
    
    function OracleConverter (markingOracle : ((Qubit[], Qubit) => Unit is Adj+Ctl)) : (Qubit[] => Unit is Adj+Ctl) {
        return OracleConverterImpl(markingOracle, _);
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part II. The Grover iteration
    //////////////////////////////////////////////////////////////////
    
    // The Hadamard transform
    operation HadamardTransform (register : Qubit[]) : Unit
    is Adj+Ctl {
        
        // ApplyToEachA(H, register);

        // ApplyToEach is a library routine that is equivalent to the following code:
        let nQubits = Length(register);
        for (idxQubit in 0..nQubits - 1) {
             H(register[idxQubit]);
        }
    }
    
    
    // Conditional phase flip
    operation ConditionalPhaseFlip (register : Qubit[]) : Unit {
        
        body (...) {
            // Define a marking oracle which detects an all zero state
            let allZerosOracle = Oracle_ArbitraryPattern_Reference(_, _, new Bool[Length(register)]);
            
            // Convert it into a phase-flip oracle and apply it
            let flipOracle = OracleConverter(allZerosOracle);
            flipOracle(register);
			R(PauliI, 2.0 * PI(), register[0]);
        }
        
        adjoint self;
        controlled  auto;
		controlled adjoint auto;    
	}
    
 
    
    
    // The Grover iteration
    operation GroverIteration (register : Qubit[], oracle : (Qubit[] => Unit is Adj+Ctl)) : Unit
    {
        body (...) {
			oracle(register);
			HadamardTransform(register);
			ConditionalPhaseFlip(register);
			HadamardTransform(register);
		}
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
	}
    
    
    //////////////////////////////////////////////////////////////////
    // Part III. Putting it all together: Quantum Counting
    //////////////////////////////////////////////////////////////////
    
    operation UnitaryPowerImpl (U : (Qubit[] => Unit  is Adj+Ctl), power : Int, q : Qubit[]) : Unit {
        body (...) {
            for (i in 1..power) {
                U(q);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

	operation Counting_Reference() : Double {
        mutable phase = -1.0;
        let n=4;
        using ((reg,phaseRegister,ancilla)=(Qubit[3],Qubit[n],Qubit[3]))
                                           {
        // Construct a phase estimation oracle from the unitary
        let phaseOracle = OracleConverter(Oracle_Sprinkler_Reference(_,_,ancilla));

        let oracle = DiscreteOracle(UnitaryPowerImpl(GroverIteration(_, phaseOracle), _, _));


        // Allocate qubits to hold the eigenstate of U and the phase in a big endian register 
            
            let phaseRegisterBE = BigEndian(phaseRegister);
            // Prepare the eigenstate of U
                HadamardTransform(reg);
//should return 0.5
            // Call library
            QuantumPhaseEstimation(oracle, reg, phaseRegisterBE);
            // Read out the phase
            set phase = IntAsDouble(MeasureInteger(BigEndianAsLittleEndian(phaseRegisterBE))) / IntAsDouble(1 <<< (n));

            ResetAll(reg);
            ResetAll(phaseRegister);
        }
        let angle = PI()*phase;
        let res = (PowD(Sin(angle),2.0));

        return 8.0*res;
    }

    
}
