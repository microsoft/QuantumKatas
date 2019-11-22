# Welcome!

This kata covers phase estimation algorithms, which are some of the most fundamental building blocks of quantum algorithms.

Phase estimation is the task of estimating the eigenvalue of an eigenvector of a unitary operator. Since the absolute value of the eigenvalue is always 1, the eigenvalue can be represented as exp(2iπφ), and phase estimation algorithms are usually formulated in terms of estimating the phase φ.

You can [run the Phase Estimation kata as a Jupyter Notebook](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=PhaseEstimation%2FPhaseEstimation.ipynb)!

#### Theory

Eigenvalues and eigenvectors:

* [Wikipedia article](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors).

Quantum phase estimation:

* Wikipedia article on [quantum phase estimation](https://en.wikipedia.org/wiki/Quantum_phase_estimation_algorithm).
* Lectures [8](https://cs.uwaterloo.ca/~watrous/LectureNotes/CPSC519.Winter2006/08.pdf) and [9](https://cs.uwaterloo.ca/~watrous/LectureNotes/CPSC519.Winter2006/09.pdf) by John Watrous.
* [Quantum Phase Estimation](https://docs.microsoft.com/quantum/libraries/standard/algorithms) in Q# documentation.

Iterative phase estimation:

* [Faster Phase Estimation](https://arxiv.org/pdf/1304.0741.pdf) paper gives an overview of several different approaches.
* [Iterative Phase Estimation](https://docs.microsoft.com/quantum/libraries/standard/characterization) in Q# documentation.

#### Q# materials

* [Quantum phase estimation tests](https://github.com/microsoft/QuantumLibraries/blob/master/Standard/tests/QuantumPhaseEstimationTests.qs)
* [Bayesian (iterative) phase estimation sample](https://github.com/microsoft/Quantum/tree/master/samples/characterization/phase-estimation)

