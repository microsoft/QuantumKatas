namespace Quantum.Kata.Arithmetic {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;

    //////////////////////////////////////////////////////////////////
    // Part I: One bit RCA
    //////////////////////////////////////////////////////////////////

    operation oneBitCarry_Reference(a : Qubit, b : Qubit, carry : Qubit) : Unit {
        body(...) {
            Controlled X([a, b], carry);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation oneBitSum_Reference(a : Qubit, b : Qubit, sum : Qubit) : Unit {
        body(...) {
            Controlled X([a], sum);
            Controlled X([b], sum);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation oneBitRCA_Reference(a : Qubit, b : Qubit, sum : Qubit, carry : Qubit) : Unit {
        body(...) {
            oneBitCarry_Reference(a, b, carry);
            oneBitSum_Reference(a, b, sum);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part II: Two bit RCA + subtraction
    //////////////////////////////////////////////////////////////////

    operation oneBitCarryArbitrary_Reference(a : Qubit, b : Qubit, carryin : Qubit, carryout : Qubit) : Unit {
        body(...) {
            Controlled X([a, b], carryout);
            Controlled X([b, carryin], carryout);
            Controlled X([a, carryin], carryout);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation oneBitSumCarry_Reference(a : Qubit, b : Qubit, carryin: Qubit, sum : Qubit) : Unit {
        body(...) {
            Controlled X([a], sum);
            Controlled X([b], sum);
            Controlled X([carryin], sum);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation twoBitRCA_Reference(a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit) : Unit {
        body(...) {
            using (carry_temp = Qubit()) {
                oneBitCarry_Reference(a[0], b[0], carry_temp);
                oneBitSum_Reference(a[0], b[0], sum[0]);

                oneBitCarryArbitrary_Reference(a[1], b[1], carry_temp, carry);
                oneBitSumCarry_Reference(a[1], b[1], carry_temp, sum[1]);
                Adjoint oneBitCarry_Reference(a[0], b[0], carry_temp); 
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation twoBitSubtraction_Reference(a : Qubit[], b : Qubit[], sum : Qubit[]) : Unit {
        body(...) {    
            using ((c, temp) = (Qubit(), Qubit[Length(sum)])) {
                ApplyToEachCA(X, a);
                twoBitRCA_Reference(a, b, temp, c);
                ApplyToEachCA(X, a);
                ApplyToEachCA(X, temp);
                for (i in 0 .. 1) {
                    CNOT(temp[i], sum[i]);
                }
                
                ApplyToEachCA(X, temp);
                ApplyToEachCA(X, a);
                Adjoint twoBitRCA_Reference(a, b, temp, c);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part III: N bit RCA + subtraction
    //////////////////////////////////////////////////////////////////

    operation nBitCarry_Reference(a : Qubit[], b : Qubit[], carry : Qubit) : Unit {
        body (...) {
            using ((temp, tempcarries) = (Qubit(), Qubit[Length(a) - 1])) {
                nBitCarryHelper_Reference(a,b,tempcarries,temp);
                CNOT(temp, carry);
                Adjoint nBitCarryHelper_Reference(a,b,tempcarries,temp);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation nBitCarryHelper_Reference(a : Qubit[], b : Qubit[], temp: Qubit[], carry : Qubit) : Unit {
        body (...) {
            let N = Length(a);
            oneBitCarry_Reference(a[0], b[0], temp[0]);
            for (i in 1 .. N - 2) {
                oneBitCarryArbitrary_Reference(a[i], b[i], temp[i - 1], temp[i]);
            }
            oneBitCarryArbitrary_Reference(a[N - 1], b[N - 1], temp[N - 2], carry);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation oneBitSumCarryInOut_Reference(a : Qubit, b : Qubit, carryin: Qubit, carryout : Qubit, sum : Qubit) : Unit {
        body (...) {
            oneBitCarryArbitrary_Reference(a, b, carryin, carryout);
            oneBitSumCarry_Reference(a, b, carryin, sum);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation nBitSum_Reference(a : Qubit[], b : Qubit[], sum : Qubit[]) : Unit {
        body (...) {
            using ((tempsum,tempcarry) = (Qubit[Length(a)], Qubit[Length(a)-1])) {
                nBitSumHelper_Reference(a,b,tempsum, tempcarry);
                for (i in 0..Length(a) -1){
                    CNOT(tempsum[i], sum[i]);
                }
                Adjoint nBitSumHelper_Reference(a,b,tempsum,tempcarry);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation nBitSumHelper_Reference(a : Qubit[], b : Qubit[], sum : Qubit[], temp : Qubit[]) : Unit {
        body(...) {
            let N = Length(a);
            oneBitRCA_Reference(a[0], b[0], temp[0], sum[0]);
            for (i in 1 .. N - 2) {
                oneBitSumCarryInOut_Reference(a[i], b[i], temp[i - 1], temp[i], sum[i]);
            }
            oneBitSumCarry_Reference(a[N - 1], b[N - 1], temp[N - 2], sum[N - 1]);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    operation nBitRCA_Reference(a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit) : Unit {
        body (...) {
            using ((tempsum, tempcarries, tempcarry) = (Qubit[Length(a)], Qubit[Length(a) - 1], Qubit())) {
                nBitRCAHelper_Reference(a,b,tempsum, tempcarry, tempcarries);
                CNOT(tempcarry, carry);
                for (i in 0 .. Length(a) -1 ) {
                    CNOT(tempsum[i], sum[i]);
                }
                Adjoint nBitRCAHelper_Reference(a,b,tempsum, tempcarry, tempcarries);
            }
        }
        controlled auto;
        adjoint auto;
        controlled adjoint auto;
    }

    operation nBitRCAHelper_Reference(a : Qubit[], b : Qubit[], sum : Qubit[], carry : Qubit, tempcarries : Qubit[]) : Unit {
        body(...) {
            let N = Length(a);
                oneBitRCA_Reference(a[0], b[0], tempcarries[0], sum[0]);
                for (i in 1 .. N - 2) {
                    oneBitSumCarryInOut_Reference(a[i], b[i], tempcarries[i - 1], tempcarries[i], sum[i]);
                }
                oneBitSumCarryInOut_Reference(a[N - 1], b[N - 1], tempcarries[N - 2], sum[N - 1], carry);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;  
    }

    operation nBitSubtraction_Reference(a : Qubit[], b : Qubit[], sum : Qubit[]) : Unit {
        body(...) {
            using ((tempsum, tempcarries, tempcarry) = (Qubit[Length(a)], Qubit[Length(a) - 1], Qubit())) {
                ApplyToEachCA(X, a);
                nBitRCAHelper_Reference(a,b,tempsum, tempcarry, tempcarries);
                ApplyToEachCA(X, a);
                ApplyToEachCA(X, tempsum);
                for (i in 0 .. Length(a) -1 ) {
                    CNOT(tempsum[i], sum[i]);
                }
                ApplyToEachCA(X, a);
                ApplyToEachCA(X, tempsum);
                Adjoint nBitRCAHelper_Reference(a,b,tempsum, tempcarry, tempcarries);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}


