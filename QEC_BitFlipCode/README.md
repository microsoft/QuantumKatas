# Welcome!

This kata covers the simplest of the quantum error-correction (QEC) codes - the three-qubit bit-flip code. This code encodes each logical qubit in three physical qubits and protects against single bit-flip error (equivalent to applying an X gate). In practice quantum systems can have other types of errors, which will be considered in the subsequent katas on quantum error correction.

This code is a quantum equivalent of the classical [repetition code](https://en.wikipedia.org/wiki/Repetition_code), adjusted to take into account the impossibility of simply cloning the quantum state.

You can [run the QEC_BitFlipCode kata as a Jupyter Notebook](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=QEC_BitFlipCode%2FQEC_BitFlipCode.ipynb)!

* This code is described in [the error correction article](https://docs.microsoft.com/quantum/libraries/standard/error-correction) in the Q# documentation.
* Another description can be found in [the Wikipedia article](https://en.wikipedia.org/wiki/Quantum_error_correction#The_bit_flip_code).
* An introduction to QEC can be found in ["Quantum Error Correction for Beginners"](https://arxiv.org/pdf/0905.2794.pdf), see section IV for more information on the 3-qubit code.
