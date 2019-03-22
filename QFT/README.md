# Welcome!

The "QFT (Quantum Fourier Transform)" quantum kata is a series of
exercises designed to teach you the basics of Quantum Fourier Transform.
It covers the following topics:
 - Basic Quantum Fourier Transform,
 - Ancillary Qubit Free Quantum Addition,
 - Approximate Quantum Fourier Transform,
 - Discrete Logarithm

Each task is wrapped in one operation preceded by the description of the task.
Each task (except tasks in which you have to write a test) has a unit test associated with it,
which initially fails. Your goal is to fill in the blank (marked with // ... comment)
with some Q# code to make the failing test pass.

#### Quantum Fourier Transform

We follow the standard algorithm described here:

* Nielsen, M. A. & Chuang, I. L. (2010). Quantum Computation and Quantum Information. pp.217-221

Here is a clear lecture note on the topic for reference:

* [Lecture 9 Phase estimation (continued); the quantum Fourier transform](https://cs.uwaterloo.ca/~watrous/LectureNotes/CPSC519.Winter2006/09.pdf)

#### Quantum Arithmetic

For the QFT based quantum addition, see this paper:

* [Thomas G Draper. (2000). "Addition on a quantum computer". arXiv preprint quant-ph/0008033.](https://arxiv.org/abs/quant-ph/0008033)

For the QFT based multiplication, see this paper:

* [Ruiz-Perez, L., & Garcia-Escartin, J. C. (2017). Quantum arithmetic with the quantum Fourier transform. Quantum Information Processing, 16(6), 152.](https://arxiv.org/abs/1411.5949)

#### Approximate Quantum Fourier Transform

See this paper for a description and discussion of the algorithm:

* [Cheung, D. (2004, January). Improved bounds for the approximate QFT. In Proceedings of the winter international synposium on Information and communication technologies (pp. 1-6). Trinity College Dublin.](https://arxiv.org/abs/quant-ph/0403071)

#### Discrete Logarithm, a.k.a. Shor's Algorithm

We only ask the you to implement the oracle of the algorithm, and have supplied the implementation
of the Shor's algorithm. However, the simulation runtime of the algorithm is prohibitive on most
computers and we do not encourage one to wait for it to finish (or run it at all if you want your laptop 
to last longer). We would like to show you Shor's algorithm at work, and have made some modification to the original
 hor's algorithm so that it exploits special characteristics of certain number. It keeps the essence of Shor's
 algorithm, can run on certain numbers and finish the execution on most laptops.

 Below you can find a description of the Shor's discrete logarithm algorithm (please do exercises the authors
 asks to really understand why the algorithm works).

 * Nielsen, M. A. & Chuang, I. L. (2010). Quantum Computation and Quantum Information. pp.238-240

You can also refer to Shor's original 1994 paper for the genesis of the algorithm. Please do note that
the original description does not make use of 2^n QFT and is not our intended implementation (see code and tests
for details). Otherwise, the paper presents the working of the algorithm (as well as the order finding algorithm)
cleanly. The papers listed below might be useful additional readings.

* [Shor, P. W. (1994, November). Algorithms for quantum computation: Discrete logarithms and factoring. In Proceedings 35th annual symposium on foundations of computer science (pp. 124-134). Ieee.](https://ieeexplore.ieee.org/abstract/document/365700)
* [Proos, J., & Zalka, C. (2003). Shor's discrete logarithm quantum algorithm for elliptic curves. arXiv preprint quant-ph/0301141.](https://arxiv.org/abs/quant-ph/0301141)
* [Roetteler, M., Naehrig, M., Svore, K. M., & Lauter, K. (2017, December). Quantum resource estimates for computing elliptic curve discrete logarithms. In International Conference on the Theory and Application of Cryptology and Information Security (pp. 241-270). Springer, Cham.](https://arxiv.org/abs/1706.06752)
