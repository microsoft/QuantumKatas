# Welcome!

This kata covers hierarchical reversible logic synthesis, i.e., building networks as cascades of reversible gates.

* Tasks 1 and 2 are basic examples of reversible circuits (i.e., circuits implementing 2-input XOR and AND functions).
* Task 3 requires designing a 3-input majority function as a reversible circuit.
* Task 4 optimizes the 3-input majority reversible function from Task 3 .

#### Background
To complete this kata, one should be familiar with basic quantum gates (in particular, the CNOT and Toffoli gate). Their description can be found in [this Wikipedia article](https://en.wikipedia.org/wiki/Quantum_logic_gate). 

#### Q# materials
* Basic gates provided in Q# belong to the `Microsoft.Quantum.Primitive` namespace and are listed [here](https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.intrinsic).
* CNOT gate description is given [here](https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.intrinsic.cnot).
* Toffoli gate description is given [here](https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.intrinsic.ccnot).

#### Literature on reversible synthesis
* Mathias Soeken, Martin Roetteler, Nathan Wiebe, and Giovanni De Micheli, "Hierarchical reversible logic synthesis using LUTs", Proceedings of the 54th Annual Design Automation Conference 2017, Austin, TX, pp. 78:1-78:6.

* Vivek V. Shende, Aditya K. Prasad, Igor L. Markov, and John P. Hayes, "Synthesis of Reversible Logic Circuits", Transactions on Computer-Aided Design of Integrated Circuits and Systems 2003,  pp. 318-323.

