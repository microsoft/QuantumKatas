# Welcome!

This folder contains a Notebook tutorial that introduces circuit-centric quantum classification and the [QML library](https://docs.microsoft.com/quantum/user-guide/libraries/machine-learning/) included in the Microsoft Quantum Development Kit.

The paper ['Circuit-centric quantum classifiers', by Maria Schuld, Alex Bocharov, Krysta Svore and Nathan Wiebe](https://arxiv.org/abs/1804.00633) describes the original proposal behind this type of classifiers.

To run this tutorial, you can [install Jupyter and Q#](https://docs.microsoft.com/quantum/install-guide/qjupyter) and 
[qsharp package for Python](https://docs.microsoft.com/en-us/quantum/install-guide/pyinstall). 
Note that this tutorial requires `matplotlib` and `numpy` Python packages to be installed. 
After this you can run the tutorial locally by navigating to this folder and starting the notebook from command line using the following command: 

    jupyter notebook ExploringQuantumClassificationLibrary.ipynb

Alternatively, you can run the tutorial online [here](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=tutorials%2FQuantumClassification%2FExploringQuantumClassificationLibrary.ipynb). Be warned that this tutorial includes some heavy computations, so we recommend to run it locally and to use the online version only for reading.

The Q# project in this folder contains the back-end of the tutorial and is not designed for direct use.
