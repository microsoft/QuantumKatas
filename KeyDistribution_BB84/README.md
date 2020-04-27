# Welcome!

The **Quantum Key Distribution** kata is a series of exercises designed to teach you about a neat quantum technology where you can use qubits to exchange secure cryptographic keys. In particular, you will work through implementing and testing a quantum key distribution protocol called [BB84](https://en.wikipedia.org/wiki/BB84).

You can [run the KeyDistribution_BB84 kata as a Jupyter Notebook](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=KeyDistribution_BB84%2FKeyDistribution_BB84.ipynb)!

### Background

What does a key distribution protocol look like in general? Normally there are two parties, commonly referred to as Alice and Bob, who want to share a random, secret string of bits called a _key_. This key can then be used for a variety of different [cryptographic protocols](https://en.wikipedia.org/wiki/Cryptographic_protocol) like encryption or authentication. Quantum versions of key exchange protocols look very similar, and utilize qubits as a way to securely transmit the bit string.

<img src="./img/qkd-concept.png" alt="General schematic for QKD protocol" width="60%"/>

You can see in the figure above that Alice and Bob have two connections, one quantum channel and one bidirectional classical channel. In this kata you will simulate what happens on the quantum channel by preparing and measuring a sequence of qubits and then perform classical operations to transform the measurement results to a usable, binary key.

There are a variety of different quantum key distribution protocols, however the most common is called [BB84](https://en.wikipedia.org/wiki/BB84) after the initials of the authors and the year it was published. It is used in many existing commercial quantum key distribution devices that implement BB84 with single photons as the qubits.

#### For more information:

* [Introduction to quantum cryptography and BB84](https://www.youtube.com/watch?v=UiJiXNEm-Go).
* [QKD summer school lecture on quantum key distribution](https://www.youtube.com/watch?v=oEJOtu0joXk).
* [Key Distribution Wikipedia article](https://en.wikipedia.org/wiki/Quantum_key_distribution)
* [BB84 Protocol Wikipedia article](https://en.wikipedia.org/wiki/BB84)
* [Short animated video introducing BB84 protocol](https://www.youtube.com/watch?v=UVzRbU6y7Ks)
* [Updated version of the BB84 paper](https://www.sciencedirect.com/science/article/pii/S0304397514004241?via%3Dihub).
