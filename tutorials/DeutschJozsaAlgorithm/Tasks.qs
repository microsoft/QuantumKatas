// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////
// This file is a back end for the tasks in Deutsch-Jozsa algorithm tutorial.
// We strongly recommend to use the Notebook version of the tutorial
// to enjoy the full experience.
//////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Classical algorithm
    //////////////////////////////////////////////////////////////////

    // Exercise 1. 
    function IsFunctionConstant_Classical (N : Int, f : (Int -> Int)) : Bool {
        // ...
        return false;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Quantum algorithm
    //////////////////////////////////////////////////////////////////
    
    // Exercise 2.
    operation DeutschJozsaAlgorithm (N : Int, oracle : (Qubit[] => Unit)) : Bool {
        // ...
        return false;
    }
}