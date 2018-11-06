# Welcome!

This kata covers Simon's algorithm. This algorithm solves Simon's problem - an oracle problem of finding a hidden bit vector. This problem is an example of an oracle problem that can be solved exponentially faster by a quantum algorithm than any known classical algorithm.

Simon's algorithm consists of two parts - a quantum circuit and a classical post-processing routine which calls the quantum circuit repeatedly and extracts the answer from the results of the runs. In this kata we focus on implementing the oracles to encode the Simon's problem and the quantum part of the algorithm; the classical part has already been implemented for you.

#### Simon’s algorithm
* A good place to start is [the Wikipedia article](https://en.wikipedia.org/wiki/Simon%27s_problem).
* [Lecture 6: Simon’s algorithm](https://cs.uwaterloo.ca/~watrous/CPSC519/LectureNotes/06.pdf) has a somewhat clearer description of the measurement part of the quantum circuit.
