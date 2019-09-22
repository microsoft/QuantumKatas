# Welcome!

This kata explores ripple-carry addition on a quantum computer.

The simplest quantum adder closely mirrors its classical counterpart,
using the same basic components and the same algorithm.
A more complex version covered in part 3 of the kata uses a somewhat different algorithm
to reduce the number of ancillary qubits needed.

#### Theory

* [Classical binary adder on Wikipedia](https://en.wikipedia.org/wiki/Adder_(electronics)).
* [Paper on quantum binary addition](https://arxiv.org/pdf/quant-ph/0008033.pdf) by Thomas G. Draper - part 2 explains how to adapt the classical adder to a quantum environment.
* [Paper on improved ripple carry addition](https://arxiv.org/pdf/quant-ph/0410184.pdf) by Steven A. Cuccaro, Thomas G. Draper, Samuel A. Kutin, and David Petrie Moulton - explains the principle behind the adder in part 3 of the kata.

#### Q#

It is recommended to complete the [BasicGates kata](./../BasicGates/) before this one to get familiar with the basic gates used in quantum computing.
The list of basic gates available in Q# can be found at [Microsoft.Quantum.Intrinsic](https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.intrinsic).

For the syntax of flow control statements in Q#, see [the Q# documentation](https://docs.microsoft.com/quantum/language/statements#control-flow).