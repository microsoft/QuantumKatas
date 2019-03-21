// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Arithmetic {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    open Microsoft.Quantum.Extensions.Diagnostics;
    

    //////////////////////////////////////////////////////////////////////
    // This file contains testing harness for all tasks.
    // You should not modify anything in this file.
    // The tasks themselves can be found in Tasks.qs file.
    //////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////
    // Part I: One bit RCA
    //////////////////////////////////////////////////////////////////

    operation T11_oneBitCarry_Test() : Unit {
        using ((a,b,c) = (Qubit(), Qubit(), Qubit())) {
            
            // a = b = 0
            oneBitCarry(a,b,c);
            AssertQubit(Zero, c);
            
            // a = 0, b = 1
            X(b);
            oneBitCarry(a,b,c);
            AssertQubit(Zero,c); 
            X(b);

            //a = 1, b = 0
            X(a);
            oneBitCarry(a,b,c);
            AssertQubit(Zero, c);

            //a = 1, b = 1
            X(b);
            oneBitCarry(a,b,c);
            AssertQubit(One, c);
            ResetAll([a,b,c]);
        }
    }

    // ------------------------------------------------------

    operation T12_oneBitSum_Test() : Unit {
        using ((a,b,c) = (Qubit(), Qubit(), Qubit())) {
            
            // a = b = 0
            oneBitSum(a,b,c);
            AssertQubit(Zero, c);
            
            // a = 0, b = 1
            X(b);
            oneBitSum(a,b,c);
            AssertQubit(One,c); 
            X(b);
            X(c);

            //a = 1, b = 0
            X(a);
            oneBitSum(a,b,c);
            AssertQubit(One, c);
            X(c);

            //a = 1, b = 1
            X(b);
            oneBitSum(a,b,c);
            AssertQubit(Zero, c);
            ResetAll([a,b,c]);
        }
    }

    // ------------------------------------------------------

    operation T13_oneBitRCA_Test() : Unit {
        using ((a,b,c, s) = (Qubit(), Qubit(), Qubit(), Qubit())) {
            
            // a = b = 0
            oneBitRCA(a,b,s,c);
            AssertQubit(Zero, s);
            AssertQubit(Zero, c);
            
            // a = 0, b = 1
            X(b);
            oneBitRCA(a,b,s,c);
            AssertQubit(One, s); 
            AssertQubit(Zero, c);
            X(b);
            X(s);

            //a = 1, b = 0
            X(a);
            oneBitRCA(a,b,s,c);
            AssertQubit(One, s);
            AssertQubit(Zero, c);
            X(s);
            //a = 1, b = 1
            X(b);
            oneBitRCA(a,b,s,c);
            AssertQubit(Zero, s);
            AssertQubit(One, c);
            ResetAll([a,b,s,c]);
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part II: Two bit RCA + subtraction
    //////////////////////////////////////////////////////////////////


    operation T21_OneBitCarryArbitrary_Test() : Unit {
        using ((a,b,cin,cout)=(Qubit(), Qubit(), Qubit(), Qubit())) {
            // a = b = c = 0
            oneBitCarryArbitrary(a, b, cin, cout);
            AssertQubit(Zero, cout);

            // a = b = 0,  c = 1
            X(cin);
            oneBitCarryArbitrary(a, b, cin, cout);
            AssertQubit(Zero, cout);
            

            // a = 0, b = c = 1
            X(b);
            oneBitCarryArbitrary(a, b, cin, cout);
            AssertQubit(One, cout);
            X(cout);

            // a = 0, b = 1, c = 0
            X(cin);
            oneBitCarryArbitrary(a, b, cin, cout);
            AssertQubit(Zero, cout);

            // a = b = c = 1
            X(a);
            X(cin);
            oneBitCarryArbitrary(a, b, cin, cout);
            AssertQubit(One, cout);
            ResetAll([a,b,cin,cout]);

        }

    }

    // ------------------------------------------------------

    operation T22_OneBitSumArbitrary_Test() : Unit {
        using ((a,b,cin,sum)=(Qubit(), Qubit(), Qubit(), Qubit())) {
            // a = b = c = 0
            oneBitSumArbitrary(a, b, cin, sum);
            AssertQubit(Zero, sum);

            // a = b = 0,  c = 1
            X(cin);
            oneBitSumArbitrary(a, b, cin, sum);
            AssertQubit(One, sum);
            X(sum);
            

            // a = 0, b = c = 1
            X(b);
            oneBitSumArbitrary(a, b, cin, sum);
            AssertQubit(Zero, sum);

            // a = 0, b = 1, c = 0
            X(cin);
            oneBitSumArbitrary(a, b, cin, sum);
            AssertQubit(One, sum);
            X(sum);

            // a = b = c = 1
            X(a);
            X(cin);
            oneBitSumArbitrary(a, b, cin, sum);
            AssertQubit(One, sum);


            ResetAll([a,b,cin,sum]);
        }
    }

    // ------------------------------------------------------
    operation T23_twoBitRCA_Test() : Unit {
        using ((a,b,sum,c)=(Qubit[2], Qubit[2], Qubit[2], Qubit())) {
                for (i in 0 .. 1) {
                    H(a[i]);
                    H(b[i]);
                }
                twoBitRCA(a,b,sum, c);
                Adjoint twoBitRCA_Reference(a,b,sum, c);
                AssertAllZero(sum);
                AssertQubit(Zero, c);
                Reset(c);
                ResetAll(a);
                ResetAll(b);
            }
    }

    // ------------------------------------------------------

    operation T24_twoBitSubtraction_Test() : Unit {
        using ((a,b,sum,c)=(Qubit[2], Qubit[2], Qubit[2], Qubit())) {
            for (i in 0 .. 1) {
                H(a[i]);
                H(b[i]);
            }
            twoBitSubtraction(a,b,sum);
            Adjoint twoBitSubtraction_Reference(a,b,sum);
            AssertAllZero(sum);
            AssertQubit(Zero, c);
            Reset(c);
            ResetAll(a);
            ResetAll(b);
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part III: N bit RCA + subtraction
    //////////////////////////////////////////////////////////////////

    operation T31_nBitCarry_Test() : Unit {
        nBitCarryTestHelper(3);
        nBitCarryTestHelper(4);
        nBitCarryTestHelper(5);
    }

    operation nBitCarryTestHelper(N : Int ) : Unit {
        using ((a,b,c)=(Qubit[N], Qubit[N], Qubit())) {
            ApplyToEach(H,a);
            ApplyToEach(H,b);
            nBitCarry(a,b,c);
            Adjoint nBitCarry_Reference(a,b,c);
            AssertQubit(Zero, c);
            ResetAll(a);
            ResetAll(b);
        }
    }

    // ------------------------------------------------------
    operation T32_nBitSum_Test() : Unit {
        nBitSumTestHelper(3);
        nBitSumTestHelper(4);
        nBitSumTestHelper(5);
    }
    operation nBitSumTestHelper(N : Int) : Unit {
        using ((a,b,c)=(Qubit[N], Qubit[N], Qubit[N])) {
            ApplyToEach(H,a);
            ApplyToEach(H,b);
            nBitSum(a,b,c);
            Adjoint nBitSum_Reference(a,b,c);
            AssertAllZero(c);
            ResetAll(a);
            ResetAll(b);
        }
    }

    // ------------------------------------------------------

    operation T33_nBitRCA_Test() : Unit {
        nBitRCATestHelper(3);
        nBitRCATestHelper(4);
    
    }

    operation nBitRCATestHelper(N : Int) : Unit {
        using ((a,b,sum, carry)=(Qubit[N], Qubit[N], Qubit[N], Qubit())) {
            ApplyToEach(H,a);
            ApplyToEach(H,b);
            nBitRCA(a,b,sum, carry);
            Adjoint nBitRCA_Reference(a,b,sum, carry);
            AssertAllZero(sum);
            AssertQubit(Zero, carry);
            ResetAll(a);
            ResetAll(b);
        }
    }

    // ------------------------------------------------------

    operation T34_nBitSubtraction_Test() : Unit {
        nBitSubtractionHelper(3);
        nBitSubtractionHelper(4);
    }

    operation nBitSubtractionHelper(N : Int) : Unit {
        using ((a,b,diff)=(Qubit[N], Qubit[N], Qubit[N])) {
            ApplyToEach(H,a);
            ApplyToEach(H,b);
            nBitSubtraction(a,b,diff);
            Adjoint nBitSubtraction_Reference(a,b,diff);
            AssertAllZero(diff);
            ResetAll(a);
            ResetAll(b);
        }
    }
}
