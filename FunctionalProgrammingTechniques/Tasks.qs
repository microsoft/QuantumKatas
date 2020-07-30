// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.FunctionalProgrammingTechniques {
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    //TODO:  write up intro
    
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Classical Functional Techniques in Q#
    //////////////////////////////////////////////////////////////////

    //Additional function for Task 1.1
    function Add7 ( addend: Int ) : Int {
        return addend + 7;
    }

    // Task 1.1. Functions as first-class citizens
    // Input: An Integer
    // Goal:  Add 7 to the input Integer, by using the adder variable, defined below.
    //        The adder variable is assigned to the Add7 function, defined above.
    // 
    // Hint:  For this first task, all you have to do is comment out the current return statement 
    //        and uncomment the statement below it.
    function SimpleAdder ( addend: Int ) : Int {
        let adder = Add7;
    
        return addend;
        //return adder(addend);
	}


    //Additional functions for Task 1.2 and 1.3
    function Sum ( a: Double , b: Double) : Double {
        return a + b;
	}

    function Product ( a: Double , b: Double) : Double {
        return a * b;
	}

    // Task 1.2. Higher-Order Functions: Fold (Sum)
    // Input: An Array of Double
    // Goal:  Sum all of the elements of the input Array, without expicitly enumerating them.  You can use the Sum 
    //        function above to help you with this task.
    //        
    // This is a common task in Functional programming, so much so that non-functional languages have also encorpated
    // this capability.
    // This higher-order function is often called Fold (see:  https://en.wikipedia.org/wiki/Fold_%28higher-order_function%29 )
    // In the Q# Library, under the Microsoft.Quantum.Arrays namespace you will also find documentation on a Fold function.
    // (see: https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arrays.fold )
    // 
    function Fold_Sum ( xs: Double[] ) : Double {
        // ...

        return 0.0;
	}


    // Task 1.3. Higher-Order Functions: Fold (Product)
    // Input: An Array of Double
    // Goal:  Multiply all of the elements of the input Array togather, without expicitly enumerating them.  You can use the Product 
    //        function above to help you with this task.
    // 
    function Fold_Product ( xs: Double[] ) : Double {
        // ...

        return 0.0;
	}


    //Additional functions for Task 1.4
    function FractionPi_to_Radians ( fractionPiNumerator: Int , fractionPiDenominator: Int ) : Double {
        return IntAsDouble(fractionPiNumerator) * PI() / IntAsDouble(fractionPiDenominator); 
	}

    function Radians_to_Degrees ( radians: Double ) : Double {
        return radians * 180.0 / PI();
	}

    function ComposeImpl ( outerfn: (Double -> Double), innerfn: ( (Int, Int) -> Double ), fractionPiNumerator: Int, fractionPiDenominator: Int ) : Double {
        return outerfn(innerfn(fractionPiNumerator, fractionPiDenominator));
	}

    function DummyFn(dummyvar1: Int, dummyvar2: Int) : Double {
        return 0.0;
	}

    function Compose ( outerfn: (Double -> Double), innerfn: ( (Int, Int) -> Double )) : ( (Int, Int) -> Double ) {
        // ...
        return DummyFn;
	}


    // Task 1.4. Composing Functions and Partial Function Application
    // Input: Two Integers which represent the numerator and denominator of a fraction of Pi for an angle.  For 3Pi/2 the inputs would be 3 and 2, respectively 
    // Goal:  You are provided a function that maps from the numerator and denominator of a fraction of Pi (the measure of an angle) to Radians.  You are also provided 
    //        a function that maps from Radians to Degrees.  The goal is to compose those functions together, into a function which takes the fractional components and
    //        converts them to Degrees.  The main function below is written for you, as well.  Your task is to write the Compose function, by calling the ComposeImpl function.
    // 
    // For a general discussion of Partial Function Application from a computer-science theoretical perspective, see:  https://en.wikipedia.org/wiki/Partial_application.
    // For details on Q# function composition, see: https://docs.microsoft.com/en-us/quantum/user-guide/using-qsharp/operations-functions  
    //
    function Compose_Functions (fractionPiNumerator: Int, fractionPiDenominator: Int) : Double {
        let FractionPi_to_Degrees = Compose(Radians_to_Degrees, FractionPi_to_Radians);
        return FractionPi_to_Degrees(fractionPiNumerator, fractionPiDenominator);
	}




    //////////////////////////////////////////////////////////////////
    // Part II. Quantum Functional Techniques in Q#
    //////////////////////////////////////////////////////////////////


    // Task 2.1. Creating a Uniform Superposition on a Register of Qubits

    // Task 2.2. Operating on Multiple Pairs of Qubits in a Register of Qubits

    // Task 2.3. Assembling Parts of the Deutsch-Jozsa Algorithm from Oracles (Functions)

    // Task 2.4. Other Feats of Strength from Quantum Blog Post on Q#

}
