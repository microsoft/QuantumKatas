namespace CounterSimulatorTests {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    open Quantum.Kata.Utils;

    // Unlike tests for AllowAtMostNQubits and AllowAtMostNCallsCA from
    // https://github.com/microsoft/QuantumLibraries/blob/main/Standard/tests/Diagnostics/AllowTests.qs,
    // CounterSimulator itself never throws exceptions, so there is no need for tests to cover that;
    // all tests check that the return of the counting functions matches the expectations.
    
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation TestQubitCounting () : Unit {
        ResetQubitCount();
        Fact(GetMaxQubitCount() == 0, "Max number of qubits should be 0");
        use outer = Qubit[4] {
            Fact(GetMaxQubitCount() == 4, "Max number of qubits should be 4");
            use inner1 = Qubit();
            Fact(GetMaxQubitCount() == 5, "Max number of qubits should be 5");
            use inner2 = (Qubit(), Qubit[1]);
            Fact(GetMaxQubitCount() == 7, "Max number of qubits should be 7");
        }
        Fact(GetMaxQubitCount() == 7, "Max number of qubits should be 7");
        use after = Qubit[8];
        Fact(GetMaxQubitCount() == 8, "Max number of qubits should be 8");

        Message("Test passed.");
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation TestIntrinsicGateCounting () : Unit {
        ResetOracleCallsCount();
        use qs = Qubit[3];
        X(qs[0]);
        X(qs[1]);
        Adjoint X(qs[2]);
        CNOT(qs[0], qs[1]);
        Controlled X([qs[0]], qs[1]);
        Controlled X(qs[0..1], qs[2]);
        EqualityFactI(GetOracleCallsCount(X), 2, "Incorrect count of X gate calls");
        EqualityFactI(GetOracleCallsCount(CNOT), 1, "Incorrect count of CNOT gate calls");
        // CNOT is internally represented as Controlled X
        EqualityFactI(GetOracleCallsCount(Controlled X), 3, "Incorrect count of Controlled X gate calls");
        EqualityFactI(GetOracleCallsCount(Adjoint X), 1, "Incorrect count of Adjoint X gate calls");

        ResetAll(qs);
        Message("Test passed.");
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation TestMeasurementsCounting () : Unit {
        ResetOracleCallsCount();
        use qs = Qubit[2];
        let m1 = M(qs[0]);
        let m2 = Measure([PauliX], [qs[0]]);
        let m3 = Measure([PauliX, PauliZ], qs);
        let m4 = MResetZ(qs[1]);
        EqualityFactI(GetOracleCallsCount(M), 2, "Incorrect count of M calls");
        // All measurements are decomposed into Measure
        EqualityFactI(GetOracleCallsCount(Measure), 4, "Incorrect count of Measure calls");

        ResetAll(qs);
        Message("Test passed.");
    }


    // Helper operation to test counting custom operations 
    // and operations that act on a certain number of qubits.
    operation CustomOp (qs : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(X, qs);
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation TestCustomOperationCounting () : Unit {
        ResetOracleCallsCount();
        use qs = Qubit[4];
        CustomOp(qs[0 .. 1]);
        CustomOp(qs[0 .. 2]);
        CustomOp(qs);
        Controlled CustomOp(qs[... 0], qs[1 ...]);
        Controlled CustomOp(qs[... 1], qs[2 ...]);
        Controlled CustomOp(qs[... 2], qs[3 ...]);
        EqualityFactI(GetOracleCallsCount(CustomOp), 3, "Incorrect count of CustomOp calls");
        EqualityFactI(GetOracleCallsCount(Controlled CustomOp), 3, "Incorrect count of Controlled CustomOp calls");

        ResetAll(qs);
        Message("Test passed.");
    }


    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation TestArityOperationCounting () : Unit {
        ResetNQubitOpCount();
        use qs = Qubit[3];
        
        X(qs[0]);               // 1 x 1
        let m1 = M(qs[0]);      // 1 x 2 (calls Measure internally)
        let m2 = MResetZ(qs[1]);// 1 x 3 (calls M and Measure internally)
        
        CNOT(qs[0], qs[1]);     // 2 x 2 (calls Controlled X internally)
        CustomOp(qs[... 1]);    // 2 x 2 (calls ApplyToEachCA) + 1 x 2 (calls X for each qubit)
        CustomOp(qs);           // 3 x 2 (calls ApplyToEachCA) + 1 x 3 (calls X for each qubit)

        EqualityFactI(GetExactlyNQubitOpCount(1), 11, "Incorrect count of 1-qubit operation calls");
        EqualityFactI(GetExactlyNQubitOpCount(2), 4, "Incorrect count of 2-qubit operation calls");
        EqualityFactI(GetExactlyNQubitOpCount(3), 2, "Incorrect count of 3-qubit operation calls");

        EqualityFactI(GetNPlusQubitOpCount(1), 17, "Incorrect count of (1+)-qubit operation calls");
        EqualityFactI(GetNPlusQubitOpCount(2), 6, "Incorrect count of (2+)-qubit operation calls");
        EqualityFactI(GetNPlusQubitOpCount(3), 2, "Incorrect count of (3+)-qubit operation calls");
        EqualityFactI(GetNPlusQubitOpCount(4), 0, "Incorrect count of (4+)-qubit operation calls");
        
        // Make sure deprecated operation is counted correctly
        EqualityFactI(GetMultiQubitOpCount(), GetNPlusQubitOpCount(2), "Incorrect count of multi-qubit operation calls");

        ResetAll(qs);
        Message("Test passed.");
    }


    // ----------------------------------------------------
    // A unit test that reproduces the checks used in DeutschJozsaAlgorithm kata - 
    // counting operations called with different parameters.
    operation OracleProductFunction (x : Qubit[], y : Qubit, r : Int[]) : Unit is Adj {        
        for i in 0 .. Length(x) - 1 {
            if r[i] == 1 {
                CNOT(x[i], y);
            }
        }
    }


    operation BernsteinVaziraniAlgorithm (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Int[] {
        use (x, y) = (Qubit[N], Qubit());
            
        ApplyToEach(H, x + [y]);
        Z(y);
            
        Uf(x, y);
            
        ApplyToEach(H, x);
        Reset(y);
            
        mutable r = new Int[N];
        for i in 0 .. N - 1 {
            if (M(x[i]) != Zero) {
                set r w/= i <- 1;
            }
        }
            
        return r;
    }


    operation AssertBVAlgorithmWorks (r : Int[]) : Unit {
        let oracle = OracleProductFunction(_, _, r);
        AllEqualityFactI(BernsteinVaziraniAlgorithm(Length(r), oracle), r, "Bernstein-Vazirani algorithm failed");

        // Oracle calls with each parameter should be counted separately,
        // since the result of partial application with each parameter is a different callable.
        let nu = GetOracleCallsCount(oracle);
        EqualityFactB(nu <= 1, true, $"You are allowed to call the oracle for {r} at most once, and you called it {nu} times");
    }


    function IntArrFromPositiveInt (n : Int, bits : Int) : Int[] {
        let rbool = IntAsBoolArray(n, bits);
        mutable r = new Int[bits];
        
        for i in 0 .. bits - 1 {
            if rbool[i] {
                set r w/= i <- 1;
            }
        }
        
        return r;
    } 
    
    
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation TestOperationsWithArgumentsCounting () : Unit {
        ResetOracleCallsCount();
        
        for bits in 1 .. 4 {
            for n in 0 .. 2 ^ bits - 1 {
                let r = IntArrFromPositiveInt(n, bits);
                AssertBVAlgorithmWorks(r);
            }
        }
    }

}
