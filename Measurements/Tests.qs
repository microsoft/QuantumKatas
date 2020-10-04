// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Measurements {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Random;

    open Quantum.Kata.Utils;

    //////////////////////////////////////////////////////////////////

    // "Framework" operation for testing single-qubit tasks for distinguishing states of one qubit
    // with Bool return
    operation DistinguishTwoStates_OneQubit (statePrep : ((Qubit, Int) => Unit), testImpl : (Qubit => Bool), stateName : String[]) : Unit {
        let nTotal = 100;
        let nStates = 2;
        mutable misclassifications = new Int[nStates];
        
        using (q = Qubit()) {
            for (i in 1 .. nTotal) {
                // get a random bit to define whether qubit will be in a state corresponding to true return (1) or to false one (0)
                // state = 0 false return
                // state = 1 true return
                let state = DrawRandomInt(0, 1);

                // do state prep: convert |0⟩ to outcome with false return or to outcome with true return depending on state
                statePrep(q, state);

                // get the solution's answer and verify if NOT a match, then differentiate what kind of mismatch
                let ans = testImpl(q);
                if (ans != (state == 1)) {
                    set misclassifications w/= state <- misclassifications[state] + 1;
                }

                // we're not checking the state of the qubit after the operation
                Reset(q);
            }
        }
        
        mutable totalMisclassifications = 0;
        for (i in 0 .. nStates - 1) {
            if (misclassifications[i] != 0) {
                set totalMisclassifications += misclassifications[i];
                Message($"Misclassified {stateName[i]} as {stateName[1 - i]} in {misclassifications[i]} test runs.");   
            }
        }
        
        // This check will tell the total number of failed classifications
        Fact(totalMisclassifications == 0, $"{totalMisclassifications} test runs out of {nTotal} returned incorrect state (see output for details).");
    }


    // ------------------------------------------------------
    operation StatePrep_IsQubitOne (q : Qubit, state : Int) : Unit {
        if (state != 0) {
            // convert |0⟩ to |1⟩
            X(q);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T101_IsQubitOne_Test () : Unit {
        DistinguishTwoStates_OneQubit(StatePrep_IsQubitOne, IsQubitOne, ["|0⟩", "|1⟩"]);
    }


    // ------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T102_InitializeQubit_Test () : Unit {
        using (q = Qubit()) {
            for (i in 0 .. 36) {
                let alpha = ((2.0 * PI()) * IntAsDouble(i)) / 36.0;
                Ry(2.0 * alpha, q);

                // Test Task 1
                InitializeQubit(q);

                // Confirm that the state is |0⟩.
                AssertQubit(Zero, q);
            }
        }
    }


    // ------------------------------------------------------
    operation StatePrep_IsQubitPlus (q : Qubit, state : Int) : Unit {
        if (state == 0) {
            // convert |0⟩ to |-⟩
            X(q);
            H(q);
        } else {
            // convert |0⟩ to |+⟩
            H(q);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T103_IsQubitPlus_Test () : Unit {
        DistinguishTwoStates_OneQubit(StatePrep_IsQubitPlus, IsQubitPlus, ["|-⟩", "|+⟩"]);
    }


    // ------------------------------------------------------
    // |A⟩ =   cos(alpha) * |0⟩ + sin(alpha) * |1⟩,
    // |B⟩ = - sin(alpha) * |0⟩ + cos(alpha) * |1⟩.
    operation StatePrep_IsQubitA (alpha : Double, q : Qubit, state : Int) : Unit {
        if (state == 0) {
            // convert |0⟩ to |B⟩
            X(q);
            Ry(2.0 * alpha, q);
        } else {
            // convert |0⟩ to |A⟩
            Ry(2.0 * alpha, q);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T104_IsQubitA_Test () : Unit {
        // cross-test
        // alpha = 0.0 or PI() => !isQubitOne
        // alpha = PI() / 2.0 => isQubitOne
        DistinguishTwoStates_OneQubit(StatePrep_IsQubitOne, IsQubitA(PI() / 2.0, _), 
            [$"|B⟩=(-sin(π/2)|0⟩ + cos(π/2)|1⟩)", $"|A⟩=(cos(π/2)|0⟩ + sin(π/2)|1⟩)"]);

        // alpha = PI() / 4.0 => isQubitPlus
        DistinguishTwoStates_OneQubit(StatePrep_IsQubitPlus, IsQubitA(PI() / 4.0, _), 
            [$"|B⟩=(-sin(π/4)|0⟩ + cos(π/4)|1⟩)", $"|A⟩=(cos(π/4)|0⟩ + sin(π/4)|1⟩)"]);

        for (i in 0 .. 10) {
            let alpha = (PI() * IntAsDouble(i)) / 10.0;
            DistinguishTwoStates_OneQubit(StatePrep_IsQubitA(alpha, _, _), IsQubitA(alpha, _), 
                [$"|B⟩=(-sin({i}π/10)|0⟩ + cos({i}π/10)|1⟩)", $"|A⟩=(cos({i}π/10)|0⟩ + sin({i}π/10)|1⟩)"]);
        }
    }


    // ------------------------------------------------------

    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return
    operation DistinguishStates_MultiQubit (nQubits : Int,
                                            nStates : Int,
                                            statePrep : ((Qubit[], Int) => Unit),
                                            testImpl : (Qubit[] => Int),
                                            measurementsPerRun : Int,
                                            stateNames : String[]) : Unit {
        let nTotal = 100;
        // misclassifications will store the number of times state i has been classified as state j (dimension nStates^2)
        mutable misclassifications = new Int[nStates * nStates];
        // unknownClassifications will store the number of times state i has been classified as some invalid state (index < 0 or >= nStates)
        mutable unknownClassifications = new Int[nStates];
                
        using (qs = Qubit[nQubits]) {
            for (i in 1 .. nTotal) {
                // get a random integer to define the state of the qubits
                let state = DrawRandomInt(0, nStates - 1);

                // do state prep: convert |0...0⟩ to outcome with return equal to state
                statePrep(qs, state);

                if (measurementsPerRun > 0) {
                    ResetOracleCallsCount();
                }
                // get the solution's answer and verify that it's a match, if not, increase the exact mismatch count
                let ans = testImpl(qs);
                if ((ans >= 0) and (ans < nStates)) {
                    // classification result is a valid state index - check if is it correct
                    if (ans != state) {
                        set misclassifications w/= ((state * nStates) + ans) <- (misclassifications[(state * nStates) + ans] + 1);
                    }
                }
                else {
                    // classification result is an invalid state index - file it separately
                    set unknownClassifications w/= state <- (unknownClassifications[state] + 1);  
                }
                // if we have a max number of measurements per solution run specified, check that it is not exceeded
                if (measurementsPerRun > 0) {
                    let nm = GetOracleCallsCount(M) + GetOracleCallsCount(Measure);
                    EqualityFactB(nm <= 1, true, $"You are allowed to do at most one measurement, and you did {nm}");
                }

                // we're not checking the state of the qubit after the operation
                ResetAll(qs);
            }
        }
        
        mutable totalMisclassifications = 0;
        for (i in 0 .. nStates - 1) {
            for (j in 0 .. nStates - 1) {
                if (misclassifications[(i * nStates) + j] != 0) {
                    set totalMisclassifications += misclassifications[i * nStates + j];
                    Message($"Misclassified {stateNames[i]} as {stateNames[j]} in {misclassifications[(i * nStates) + j]} test runs.");
                }
            }
            if (unknownClassifications[i] != 0) {
                set totalMisclassifications += unknownClassifications[i];
                Message($"Misclassified {stateNames[i]} as Unknown State in {unknownClassifications[i]} test runs.");
            }
        }
        // This check will tell the total number of failed classifications
        Fact(totalMisclassifications == 0, $"{totalMisclassifications} test runs out of {nTotal} returned incorrect state (see output for details).");
    }


    // ------------------------------------------------------
    operation StatePrep_ZeroZeroOrOneOne (qs : Qubit[], state : Int) : Unit {
        if (state == 1) {
            // |11⟩
            X(qs[0]);
            X(qs[1]);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T105_ZeroZeroOrOneOne_Test () : Unit {
        DistinguishStates_MultiQubit(2, 2, StatePrep_ZeroZeroOrOneOne, ZeroZeroOrOneOne, 0, ["|00⟩", "|11⟩"]);
    }


    // ------------------------------------------------------
    operation StatePrep_BasisStateMeasurement (qs : Qubit[], state : Int) : Unit {

        if (state / 2 == 1) {
            // |10⟩ or |11⟩
            X(qs[0]);
        }

        if (state % 2 == 1) {
            // |01⟩ or |11⟩
            X(qs[1]);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T106_BasisStateMeasurement_Test () : Unit {
        DistinguishStates_MultiQubit(2, 4, StatePrep_BasisStateMeasurement, BasisStateMeasurement, 0, ["|00⟩", "|01⟩", "|10⟩", "|11⟩"]);
    }


    // ------------------------------------------------------
    operation StatePrep_Bitstring (qs : Qubit[], bits : Bool[]) : Unit {
        for (i in 0 .. Length(qs) - 1) {
            if (bits[i]) {
                X(qs[i]);
            }
        }
    }


    operation StatePrep_TwoBitstringsMeasurement (qs : Qubit[], bits1 : Bool[], bits2 : Bool[], state : Int) : Unit {
        let bits = state == 0 ? bits1 | bits2;
        StatePrep_Bitstring(qs, bits);
    }


    // Helper function to convert a boolean array to its ket state representation
    function BoolArrayAsKetState (bits : Bool[]) : String {
        mutable stateName = "|";
        for (i in 0 .. Length(bits) - 1) {
            set stateName += (bits[i] ? "1" | "0");
        }
        return stateName + "⟩";
    }


    operation CheckTwoBitstringsMeasurement (b1 : Bool[], b2 : Bool[]) : Unit {
        DistinguishStates_MultiQubit(Length(b1), 2, StatePrep_TwoBitstringsMeasurement(_, b1, b2, _), 
            TwoBitstringsMeasurement(_, b1, b2), 1, 
            [BoolArrayAsKetState(b1), BoolArrayAsKetState(b2)]);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T107_TwoBitstringsMeasurement_Test () : Unit {
        mutable b1 = [false, true];
        mutable b2 = [true, false];
        CheckTwoBitstringsMeasurement(b1, b2);

        set b1 = [true, true, false];
        set b2 = [false, true, true];
        CheckTwoBitstringsMeasurement(b1, b2);

        set b1 = [false, true, true, false];
        set b2 = [false, true, true, true];
        CheckTwoBitstringsMeasurement(b1, b2);
        
        set b1 = [true, false, false, false];
        set b2 = [true, false, true, true];
        CheckTwoBitstringsMeasurement(b1, b2);
    }


    // ------------------------------------------------------
    operation StatePrep_FindFirstDiff (bits1 : Bool[], bits2 : Bool[]) : Int {
        for (i in 0 .. Length(bits1) - 1) {
            if (bits1[i] != bits2[i]) {
                return i;
            }
        }
        return -1;
    }


    // a combination of tasks 14 and 15 from the Superposition kata
    operation StatePrep_BitstringSuperposition (qs : Qubit[], bits : Bool[][]) : Unit {
        let L = Length(bits);
        Fact(L == 1 or L == 2 or L == 4, "State preparation only supports arrays of 1, 2 or 4 bit strings");
        if (L == 1) {
            for (i in 0 .. Length(qs) - 1) {
                if (bits[0][i]) {
                    X(qs[i]);
                }
            }
        }
        if (L == 2) {
            // find the index of the first bit at which the bit strings are different
            let firstDiff = StatePrep_FindFirstDiff(bits[0], bits[1]);

            // Hadamard corresponding qubit to create superposition
            H(qs[firstDiff]);

            // iterate through the bit strings again setting the final state of qubits
            for (i in 0 .. Length(qs) - 1) {
                if (bits[0][i] == bits[1][i]) {
                    // if two bits are the same, apply X or nothing
                    if (bits[0][i]) {
                        X(qs[i]);
                    }
                } else {
                    // if two bits are different, set their difference using CNOT
                    if (i > firstDiff) {
                        CNOT(qs[firstDiff], qs[i]);
                        if (bits[0][i] != bits[0][firstDiff]) {
                            X(qs[i]);
                        }
                    }
                }
            }
        }
        if (L == 4) {
            let N = Length(qs);

            using (anc = Qubit[2]) {
                // Put two ancillas into equal superposition of 2-qubit basis states
                ApplyToEachA(H, anc);

                // Set up the right pattern on the main qubits with control on ancillas
                for (i in 0 .. 3) {
                    for (j in 0 .. N - 1) {
                        if ((bits[i])[j]) {
                            (ControlledOnInt(i, X))(anc, qs[j]);
                        }
                    }
                }

                // Uncompute the ancillas, using patterns on main qubits as control
                for (i in 0 .. 3) {
                    if (i % 2 == 1) {
                        (ControlledOnBitString(bits[i], X))(qs, anc[0]);
                    }
                    if (i / 2 == 1) {
                        (ControlledOnBitString(bits[i], X))(qs, anc[1]);
                    }
                }
            }
        }
    }


    operation StatePrep_SuperpositionMeasurement (qs : Qubit[], bits1 : Bool[][], bits2 : Bool[][], state : Int) : Unit {
        let bits = state == 0 ? bits1 | bits2;
        StatePrep_BitstringSuperposition(qs, bits);
    }


    // Helper function to convert an array of bit strings to its ket state representation
    function IntArrayAsStateName (qubits : Int, bitStrings : Bool[][]) : String {
        mutable statename = "";
        for (i in 0 .. Length(bitStrings) - 1) {
            if (i > 0) {
                set statename += " + ";
            }
            set statename += BoolArrayAsKetState(bitStrings[i]);
        }
        return statename;
    }


    operation CheckSuperpositionBitstringsOneMeasurement (nQubits : Int, ints1 : Int[], ints2 : Int[]): Unit {
        let bits1 = Mapped(IntAsBoolArray(_, nQubits), ints1);
        let bits2 = Mapped(IntAsBoolArray(_, nQubits), ints2);

        DistinguishStates_MultiQubit(nQubits, 2, StatePrep_SuperpositionMeasurement(_, bits1, bits2, _), 
                                     SuperpositionOneMeasurement(_, bits1, bits2), 1, 
                                     [IntArrayAsStateName(nQubits, bits1), IntArrayAsStateName(nQubits, bits2)]);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T108_SuperpositionOneMeasurement_Test () : Unit {
        // note that bit strings in the comments (big endian) are the reverse of the bit strings passed to the solutions (little endian)
        CheckSuperpositionBitstringsOneMeasurement(2, [2],  // [10]
                                                      [1]); // [01]

        CheckSuperpositionBitstringsOneMeasurement(2, [2,3],    // [10,11]
                                                      [1,0]);   // [01,00]

        CheckSuperpositionBitstringsOneMeasurement(2, [2],    // [10]
                                                      [1,0]); // [01,00]

        CheckSuperpositionBitstringsOneMeasurement(4, [15,7],    // [1111,0111]
                                                      [0,8]);    // [0000,1000]

        CheckSuperpositionBitstringsOneMeasurement(4, [15,7],       // [1111,0111]
                                                      [0,8,10,12]); // [0000,1000,1010,1100]

        CheckSuperpositionBitstringsOneMeasurement(5, [30,14,10,6],     // [11110,01110,01010,00110]
                                                      [1,17,21,25]);    // [00001,10001,10101,11001]

        CheckSuperpositionBitstringsOneMeasurement(2, [0,2],       // [00,10]
                                                      [3]); // [11]

        CheckSuperpositionBitstringsOneMeasurement(3, [5,7],       // [101,111]
                                                      [2]); // [010]

        CheckSuperpositionBitstringsOneMeasurement(4, [13,11,7,3], // [1101,1011,0111,0011]
                                                      [2,4]); // [0010,0100]
    }


    // ------------------------------------------------------
    operation CheckSuperpositionBitstringsMeasurement (nQubits : Int, ints1 : Int[], ints2 : Int[]): Unit {
        let bits1 = Mapped(IntAsBoolArray(_, nQubits), ints1);
        let bits2 = Mapped(IntAsBoolArray(_, nQubits), ints2);

        DistinguishStates_MultiQubit(nQubits, 2, StatePrep_SuperpositionMeasurement(_, bits1, bits2, _), 
                                     SuperpositionMeasurement(_, bits1, bits2), 0, 
                                     [IntArrayAsStateName(nQubits, bits1), IntArrayAsStateName(nQubits, bits2)]);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T109_SuperpositionMeasurement_Test () : Unit {
        // note that bit strings in the comments (big endian) are the reverse of the bit strings passed to the solutions (little endian)
        CheckSuperpositionBitstringsMeasurement(2, [2],  // [10]
                                                   [1]); // [01]

        CheckSuperpositionBitstringsMeasurement(2, [2,1],  // [10,01]
                                                   [3,0]); // [11,00]

        CheckSuperpositionBitstringsMeasurement(2, [2],    // [10]
                                                   [3,0]); // [11,00]

        CheckSuperpositionBitstringsMeasurement(4, [15,6], // [1111,0110]
                                                   [0,14]); // [0000,1110]

        CheckSuperpositionBitstringsMeasurement(4, [15,7],       // [1111,0111]
                                                   [0,8,10,13]); // [0000,1000,1010,1101]

        CheckSuperpositionBitstringsMeasurement(5, [30,14,10,7],  // [11110,01110,01010,00111]
                                                   [1,17,21,27]); // [00001,10001,10101,11011]

        CheckSuperpositionBitstringsMeasurement(2, [2,1],       // [10,01]
                                                   [3]); // [11]

        CheckSuperpositionBitstringsMeasurement(3, [7,5],       // [111,101]
                                                   [2]); // [010]
                                                   
        CheckSuperpositionBitstringsMeasurement(4, [13,11,7,3], // [1101,1011,0111,0011]
                                                   [5,2]); // [0101,0010]
    }


    // ------------------------------------------------------
    operation WState_Arbitrary_Reference (qs : Qubit[]) : Unit is Adj + Ctl {
        let N = Length(qs);

        if (N == 1) {
            // base case of recursion: |1⟩
            X(qs[0]);
        } else {
            // |W_N⟩ = |0⟩|W_(N-1)⟩ + |1⟩|0...0⟩
            // do a rotation on the first qubit to split it into |0⟩ and |1⟩ with proper weights
            // |0⟩ -> sqrt((N-1)/N) |0⟩ + 1/sqrt(N) |1⟩
            let theta = ArcSin(1.0 / Sqrt(IntAsDouble(N)));
            Ry(2.0 * theta, qs[0]);

            // do a zero-controlled W-state generation for qubits 1..N-1
            X(qs[0]);
            Controlled WState_Arbitrary_Reference(qs[0 .. 0], qs[1 .. N - 1]);
            X(qs[0]);
        }
    }

    operation StatePrep_AllZerosOrWState (qs : Qubit[], state : Int) : Unit {

        if (state == 1) {
            // prep W state
            WState_Arbitrary_Reference(qs);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T110_AllZerosOrWState_Test () : Unit {

        for (i in 2 .. 6) {
            DistinguishStates_MultiQubit(i, 2, StatePrep_AllZerosOrWState, AllZerosOrWState, 0, ["|0...0⟩", "|W⟩"]);
        }
    }


    // ------------------------------------------------------
    operation GHZ_State_Reference (qs : Qubit[]) : Unit is Adj {
        H(Head(qs));
        for (q in Rest(qs)) {
            CNOT(Head(qs), q);
        }
    }


    operation StatePrep_GHZOrWState (qs : Qubit[], state : Int) : Unit {

        if (state == 0) {
            // prep GHZ state
            GHZ_State_Reference(qs);
        } else {
            // prep W state
            WState_Arbitrary_Reference(qs);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T111_GHZOrWState_Test () : Unit {
        for (i in 2 .. 6) {
            DistinguishStates_MultiQubit(i, 2, StatePrep_GHZOrWState, GHZOrWState, 0, ["|GHZ⟩", "|W⟩"]);
        }
    }


    // ------------------------------------------------------
    // 0 - |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
    // 1 - |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
    // 2 - |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
    // 3 - |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
    operation StatePrep_BellState (qs : Qubit[], state : Int) : Unit {
        H(qs[0]);
        CNOT(qs[0], qs[1]);

        // now we have |00⟩ + |11⟩ - modify it based on state arg
        if (state % 2 == 1) {
            // negative phase
            Z(qs[1]);
        }
        if (state / 2 == 1) {
            X(qs[1]);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T112_BellState_Test () : Unit {
        DistinguishStates_MultiQubit(2, 4, StatePrep_BellState, BellState, 0, ["|Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)", 
                                                                               "|Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)", 
                                                                               "|Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)", 
                                                                               "|Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)"]);
    }

    // ------------------------------------------------------
    // 0 - (|00⟩ + |01⟩ + |10⟩ + |11⟩) / 2
    // 1 - (|00⟩ - |01⟩ + |10⟩ - |11⟩) / 2
    // 2 - (|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2
    // 3 - (|00⟩ - |01⟩ - |10⟩ + |11⟩) / 2
    operation StatePrep_TwoQubitState (qs : Qubit[], state : Int) : Unit {
        // start with state prep of basis vectors
        StatePrep_BasisStateMeasurement(qs, state);
        H(qs[0]);
        H(qs[1]);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T113_TwoQubitState_Test () : Unit {
        DistinguishStates_MultiQubit(2, 4, StatePrep_TwoQubitState, TwoQubitState, 0, ["(|00⟩ + |01⟩ + |10⟩ + |11⟩) / 2", 
                                                                                       "(|00⟩ - |01⟩ + |10⟩ - |11⟩) / 2", 
                                                                                       "(|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2", 
                                                                                       "(|00⟩ - |01⟩ - |10⟩ + |11⟩) / 2"]);
    }


    // ------------------------------------------------------
    // 0 - ( |00⟩ - |01⟩ - |10⟩ - |11⟩) / 2
    // 1 - (-|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2
    // 2 - (-|00⟩ - |01⟩ + |10⟩ - |11⟩) / 2
    // 3 - (-|00⟩ - |01⟩ - |10⟩ + |11⟩) / 2
    operation StatePrep_TwoQubitStatePartTwo (qs : Qubit[], state : Int) : Unit {

        // start with state prep of basis vectors
        StatePrep_BasisStateMeasurement(qs, state);

        // now apply all gates for unitary in reference impl (in reverse + adjoint)
        within {
            ApplyToEachA(X, qs);
            Controlled Z([qs[0]], qs[1]);
            ApplyToEachA(X, qs);
        } apply {
            ApplyToEach(H, qs);
        }
        SWAP(qs[0], qs[1]);
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T114_TwoQubitStatePartTwo_Test () : Unit {
        DistinguishStates_MultiQubit(2, 4, StatePrep_TwoQubitStatePartTwo, TwoQubitStatePartTwo, 0, ["(+|00⟩ - |01⟩ - |10⟩ - |11⟩) / 2", 
                                                                                                     "(-|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2", 
                                                                                                     "(-|00⟩ - |01⟩ + |10⟩ - |11⟩) / 2", 
                                                                                                     "(-|00⟩ - |01⟩ - |10⟩ + |11⟩) / 2"]);
    }


    // ------------------------------------------------------
    operation StatePrep_ThreeQubitMeasurement (qs : Qubit[], state : Int) : Unit is Adj {

        WState_Arbitrary_Reference(qs);

        if (state == 0) {
            // prep 1/sqrt(3) ( |100⟩ + ω |010⟩ + ω² |001⟩ )
            R1(2.0 * PI() / 3.0, qs[1]);
            R1(4.0 * PI() / 3.0, qs[2]);
        } else {
            //  prep 1/sqrt(3) ( |100⟩ + ω² |010⟩ + ω |001⟩ )
            R1(4.0 * PI() / 3.0, qs[1]);
            R1(2.0 * PI() / 3.0, qs[2]);
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T115_ThreeQubitMeasurement_Test () : Unit {
        DistinguishStates_MultiQubit(3, 2, StatePrep_ThreeQubitMeasurement, ThreeQubitMeasurement, 0, 
            ["1/sqrt(3) (|100⟩ + ω |010⟩ + ω² |001⟩)", 
             "1/sqrt(3) (|100⟩ + ω² |010⟩ + ω |001⟩)"]);
    }


    //////////////////////////////////////////////////////////////////
    // Part II*. Discriminating Nonorthogonal States
    //////////////////////////////////////////////////////////////////

    operation StatePrep_IsQubitZeroOrPlus (q : Qubit, state : Int) : Unit {

        if (state != 0) {
            // convert |0⟩ to |+⟩
            H(q);
        }
    }


    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return. Framework tests against a threshold parameter for the fraction of runs that must succeed.
    operation DistinguishStates_MultiQubit_Threshold (Nqubit : Int, Nstate : Int, threshold : Double, statePrep : ((Qubit, Int) => Unit), testImpl : (Qubit => Bool)) : Unit {
        let nTotal = 1000;
        mutable nOk = 0;

        using (qs = Qubit[Nqubit]) {
            for (i in 1 .. nTotal) {
                // get a random integer to define the state of the qubits
                let state = DrawRandomInt(0, Nstate - 1);

                // do state prep: convert |0⟩ to outcome with return equal to state
                statePrep(qs[0], state);

                // get the solution's answer and verify that it's a match
                let ans = testImpl(qs[0]);
                if (ans == (state == 0)) {
                    set nOk += 1;
                }

                // we're not checking the state of the qubit after the operation
                ResetAll(qs);
            }
        }

        if (IntAsDouble(nOk) < threshold * IntAsDouble(nTotal)) {
            fail $"{nTotal - nOk} test runs out of {nTotal} returned incorrect state which does not meet the required threshold of at least {threshold * 100.0}%.";
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T201_IsQubitZeroOrPlus_Test () : Unit {
        DistinguishStates_MultiQubit_Threshold(1, 2, 0.8, StatePrep_IsQubitZeroOrPlus, IsQubitPlusOrZero);
    }


    // ------------------------------------------------------
    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return. Framework tests against a threshold parameter for the fraction of runs that must succeed.
    // Framework tests in the USD scenario, i.e., it is allowed to respond "inconclusive" (with some probability)
    // up to given threshold, but it is never allowed to err if an actual conclusive response is given.
    operation USD_DistinguishStates_MultiQubit_Threshold (Nqubit : Int, Nstate : Int, thresholdInconcl : Double, thresholdConcl : Double, statePrep : ((Qubit, Int) => Unit), testImpl : (Qubit => Int)) : Unit {
        let nTotal = 10000;

        // counts total inconclusive answers
        mutable nInconc = 0;

        // counts total conclusive |0⟩ state identifications
        mutable nConclOne = 0;

        // counts total conclusive |+> state identifications
        mutable nConclPlus = 0;

        using (qs = Qubit[Nqubit]) {
            for (i in 1 .. nTotal) {

                // get a random integer to define the state of the qubits
                let state = DrawRandomInt(0, Nstate - 1);

                // do state prep: convert |0⟩ to outcome with return equal to state
                statePrep(qs[0], state);

                // get the solution's answer and verify that it's a match
                let ans = testImpl(qs[0]);

                // check that the answer is actually in allowed range
                if (ans < -1 or ans > 1) {
                    fail $"state {state} led to invalid response {ans}.";
                }

                // keep track of the number of inconclusive answers given
                if (ans == -1) {
                    set nInconc += 1;
                }

                if (ans == 0 and state == 0) {
                    set nConclOne += 1;
                }

                if (ans == 1 and state == 1) {
                    set nConclPlus += 1;
                }

                // check if upon conclusive result the answer is actually correct
                if (ans == 0 and state == 1 or ans == 1 and state == 0) {
                    fail $"state {state} led to incorrect conclusive response {ans}.";
                }

                // we're not checking the state of the qubit after the operation
                ResetAll(qs);
            }
        }

        if (IntAsDouble(nInconc) > thresholdInconcl * IntAsDouble(nTotal)) {
            fail $"{nInconc} test runs out of {nTotal} returned inconclusive which does not meet the required threshold of at most {thresholdInconcl * 100.0}%.";
        }

        if (IntAsDouble(nConclOne) < thresholdConcl * IntAsDouble(nTotal)) {
            fail $"Only {nConclOne} test runs out of {nTotal} returned conclusive |0⟩ which does not meet the required threshold of at least {thresholdConcl * 100.0}%.";
        }

        if (IntAsDouble(nConclPlus) < thresholdConcl * IntAsDouble(nTotal)) {
            fail $"Only {nConclPlus} test runs out of {nTotal} returned conclusive |+> which does not meet the required threshold of at least {thresholdConcl * 100.0}%.";
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T202_IsQubitZeroOrPlusSimpleUSD_Test () : Unit {
        USD_DistinguishStates_MultiQubit_Threshold(1, 2, 0.8, 0.1, StatePrep_IsQubitZeroOrPlus, IsQubitPlusZeroOrInconclusiveSimpleUSD);
    }


    // ------------------------------------------------------
    operation StatePrep_IsQubitNotInABC (q : Qubit, state : Int) : Unit {
        let alpha = (2.0 * PI()) / 3.0;
        H(q);

        if (state == 0) {
            // convert |0⟩ to 1/sqrt(2) (|0⟩ + |1⟩)
        }
        elif (state == 1) {
            // convert |0⟩ to 1/sqrt(2) (|0⟩ + ω |1⟩), where ω = exp(2iπ/3)
            R1(alpha, q);
        }
        else {
            // convert |0⟩ to 1/sqrt(2) (|0⟩ + ω² |1⟩), where ω = exp(2iπ/3)
            R1(2.0 * alpha, q);
        }
    }


    // "Framework" operation for testing multi-qubit tasks for distinguishing states of an array of qubits
    // with Int return. Framework tests instances of the Peres/Wootters game. In this game, one of three
    // "trine" states is presented and the algorithm must answer with a label that does not correspond
    // to one of the label of the input state.
    operation ABC_DistinguishStates_MultiQubit_Threshold (Nqubit : Int, Nstate : Int, statePrep : ((Qubit, Int) => Unit), testImpl : (Qubit => Int)) : Unit {

        let nTotal = 1000;

        using (qs = Qubit[Nqubit]) {

            for (i in 1 .. nTotal) {
                // get a random integer to define the state of the qubits
                let state = DrawRandomInt(0, Nstate - 1);

                // do state prep: convert |0⟩ to outcome with return equal to state
                statePrep(qs[0], state);

                // get the solution's answer and verify that it's a match
                let ans = testImpl(qs[0]);

                // check that the value of ans is 0, 1 or 2
                if (ans < 0 or ans > 2) {
                    fail "You can not return any value other than 0, 1 or 2.";
                }

                // check if upon conclusive result the answer is actually correct
                if (ans == state) {
                    fail $"State {state} led to incorrect conclusive response {ans}.";
                }

                // we're not checking the state of the qubit after the operation
                ResetAll(qs);
            }
        }
    }

    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T203_IsQubitNotInABC_Test () : Unit {
        ABC_DistinguishStates_MultiQubit_Threshold(1, 3, StatePrep_IsQubitNotInABC, IsQubitNotInABC);
    }
}
