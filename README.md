# Introduction

The Quantum Katas are a series of self-paced tutorials aimed at teaching you elements of quantum computing and Q# programming at the same time.

:new: *(July 2019)* The Quantum Katas are expanding to include Jupyter Notebook tutorials on quantum computing! Each tutorial combines theoretical explanations with Q# code snippets and programming exercises. See [index.ipynb](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=index.ipynb) for the list of all Notebook tutorials and instructions on running them online.

:new: *(April 2019)* The Quantum Katas are now available as Jupyter Notebooks! See [index.ipynb](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=index.ipynb) for the list of all Kata Notebooks and instructions on running them online.

Each kata is a separate project which includes:

* A sequence of tasks on the topic progressing from trivial to challenging.
  Each task requires you to fill in some code; the first task might require just one line, and the last one might require a sizable fragment of code.
* A testing framework that sets up, runs and validates your solutions.
  Each task is covered by a [*unit test*](https://docs.microsoft.com/en-us/visualstudio/test/getting-started-with-unit-testing) which initially fails; once the test passes, you can move on to the next task!
* Pointers to reference materials you might need to solve the tasks, both on quantum computing and on Q#.
* Reference solutions, for when all else fails.


## Table of Contents ##

* [List of Notebook tutorials](#tutorial-topics)
* [List of Katas](#kata-topics)
* [Running the Katas and tutorials as Jupyter Notebooks](#run-as-notebook)
* [Running the Katas locally](#kata-locally)
  * [Downloading the Quantum Katas](#download)
  * [Running a kata as a Q# project](#kata-as-project)
  * [Running kata tests](#tests)
  * [Running the Katas locally with Docker](#docker)
* [Contributing](#contributing)
* [Code of Conduct](#code-of-conduct)


## List of Notebook tutorials <a name="tutorial-topics" /> ##

* **[Deutsch–Jozsa algorithm](./tutorials/DeutschJozsaAlgorithm/)**.
  This tutorial teaches you to implement classical functions and equivalent quantum oracles, 
  discusses the classical solution to the Deutsch–Jozsa problem, and introduces the Deutsch and Deutsch–Jozsa algorithms.

## List of Katas <a name="kata-topics" /> ##

Each kata covers one topic.
Currently covered topics are:

#### Quantum computing concepts
* **[Basic quantum computing gates](./BasicGates/)**.
  This kata focuses on main single-qubit and multi-qubit gates used in quantum computing.
* **[Superposition](./Superposition/)**.
  The tasks focus on preparing a certain superposition state on one or multiple qubits.
* **[Measurements](./Measurements/)**.
  The tasks focus on distinguishing quantum states using measurements.
* **[Joint measurements](./JointMeasurements/)**.
  The tasks focus on using joint (parity) measurements for distinguishing quantum states and performing gates.

#### Simple algorithms
* **[Teleportation](./Teleportation/)**.
  This kata walks you through the standard teleportation protocol and several variations.
* **[Superdense coding](./SuperdenseCoding/)**.
  This kata walks you through the superdense coding protocol.
* **[Deutsch–Jozsa algorithm](./DeutschJozsaAlgorithm/)**.
  This kata starts with writing quantum oracles which implement classical functions, and continues to introduce the Bernstein–Vazirani and Deutsch–Jozsa algorithms.
* **[Simon's algorithm](./SimonsAlgorithm/)**.
  This kata introduces Simon's algorithm.

#### Grover's algorithm
* **[Grover's algorithm](./GroversAlgorithm/)**.
  This kata introduces Grover's search algorithm and writing quantum oracles to be used with it.
* **[Solving SAT problems using Grover's algorithm](./SolveSATWithGrover/)**.
  This kata continues the exploration of Grover's search algorithm, using SAT problems as an example. It covers implementing quantum oracles based on the problem description instead of a hard-coded answer and using Grover's algorithm to solve problems with unknown number of solutions.
* **[Solving graph coloring problems using Grover's algorithm](./GraphColoring/)**.
  This kata continues the exploration of Grover's search algorithm, using graph coloring problems as an example.

#### Entanglement games
* **[CHSH game](./CHSHGame/)**.
* **[GHZ game](./GHZGame/)**.
* **[Mermin-Peres magic square game](./MagicSquareGame)**.

#### Miscellaneous
* **[Phase estimation](./PhaseEstimation/)**.
  This kata covers phase estimation algorithms.
* **[Bit-flip error correcting code](./QEC_BitFlipCode/)**.
  This kata introduces a 3-qubit error correcting code for protecting against bit-flip errors.
* **[Unitary Patterns*](./UnitaryPatterns/)**.
  This unusual kata offers tasks on implementing unitaries with matrices that follow certain patterns of zero and non-zero elements.


## Running the Katas and tutorials as Jupyter Notebooks <a name="run-as-notebook" /> ##

The Quantum Katas are now available as Jupyter Notebooks! See [index.ipynb](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=index.ipynb) for the list of all Kata and tutorial Notebooks and for instructions on running them online.


## Running the Katas locally <a name="kata-locally" /> ##

To use the Quantum Katas locally, you'll first need to install the [Quantum Development Kit](https://docs.microsoft.com/quantum), available for Windows 10, macOS, and Linux.
Please see the [install guide for the Quantum Development Kit](https://docs.microsoft.com/quantum/install-guide/) if you do not already have the Quantum Development Kit installed.

A quick reference sheet for Q# programming language is available [here](./quickref/qsharp-quick-reference.pdf).


### Downloading the Quantum Katas <a name="download" /> ###

If you have Git installed, go on and clone the Microsoft/QuantumKatas repository.
From your favorite command line:

```bash
$ git clone https://github.com/Microsoft/QuantumKatas.git
```

> **TIP**: Both Visual Studio 2017 and Visual Studio Code make it easy to clone repositories from within your development environment.
> See the [Visual Studio 2017](https://docs.microsoft.com/en-us/vsts/git/tutorial/clone?view=vsts&tabs=visual-studio#clone-from-another-git-provider) and [Visual Studio Code](https://code.visualstudio.com/docs/editor/versioncontrol#_cloning-a-repository) documentation for details.

Alternatively, if you don't have Git installed, you can manually download a standalone copy of the katas from https://github.com/Microsoft/QuantumKatas/archive/master.zip.


### Running a kata as a Q# project <a name="kata-as-project" /> ###

Each individual kata is placed in its own directory as a self-contained Q# solution and project pair.
For instance, the **BasicGates** kata is laid out as below.

```
QuantumKatas/
  BasicGates/
    README.md                  # Instructions specific to this kata.
    .vscode/                   # Metadata used by Visual Studio Code.
    BasicGates.sln             # Visual Studio 2017 solution file.
    BasicGates.csproj          # Project file used to build both classical and quantum code.

    Tasks.qs                   # Q# source code that you will fill as you solve each task.
    Tests.qs                   # Q# tests that verify your solutions.
    TestSuiteRunner.cs         # C# source code used to run the Q# tests.
    ReferenceImplementation.qs # Q# source code containing solutions to the tasks.
```

To open the **BasicGates** kata in Visual Studio 2017, open the `QuantumKatas/BasicGates/BasicGates.sln` solution file.

To open the **BasicGates** kata in Visual Studio Code, open the `QuantumKatas/BasicGates/` folder.
Press Ctrl + Shift + P (or ⌘ + Shift + P on macOS) to open the Command Palette. Type "Open Folder" on Windows 10 or Linux or "Open" on macOS.

> **TIP**: Almost all commands available in Visual Studio Code can be found in the Command Palette.
> If you ever get stuck, press Ctrl + Shift + P (or ⌘ + Shift + P on macOS) and type some letters to search through all available commands.

> **TIP**: You can also launch Visual Studio Code from the command line if you prefer:
> ```bash
> $ code QuantumKatas/BasicGates/
> ```


### Running kata tests <a name="tests" /> ###

Once you have a kata open, it's time to run the tests using the instructions below.
Initially all tests will fail; do not panic!
Open the `Tasks.qs` file and start filling in the code to complete the tasks. Each task is covered by a unit test; once you fill in the correct code for a task, rebuild the project and re-run the tests, and the corresponding unit test will pass.


#### Visual Studio 2017

1. Build solution.
2. Open Test Explorer (found in `Test` > `Windows` menu) and select "Run All" to run all unit tests at once.
3. Work on the tasks in the `Tasks.qs` file.
4. To test your code changes for a task, rebuild solution and re-run all unit tests using "Run All" or the unit test which covers that task by right-clicking on that test and selecting "Run Selected Tests".

#### Visual Studio Code

1. Press Ctrl + \` (or ⌘ + \` on macOS) to open the integrated terminal.
   The terminal should already start in the kata directory, but if not, use `cd` to navigate to the folder containing the `*.csproj` file for the kata.
2. Run `dotnet test` in the integrated terminal.
   This should automatically build the kata project and run all unit tests; initially, all unit tests should fail.
3. Work on the tasks in the `Tasks.qs` file.
4. To test your code changes for a task, run `dotnet test` again.

For convenience, we also provide a `tasks.json` configuration for each kata that allows Visual Studio Code to run the build and test steps from the Command Palette.
Press Ctrl + Shift + P (or ⌘ + Shift + P on macOS) to open the Palette and type "Run Build Task" or "Run Test Task," then press Enter.


## Running the Katas locally with Docker <a name="docker" /> ##

You can use the included [Dockerfile](./Dockerfile) to create a docker image 
with all the necessary libraries to run the Katas from the command line or Jupyter.

The first step is to install [Docker](https://docs.docker.com/install/).

To build the docker image and tag it `katas`:
```
docker build -t katas .
```

To run the image in the container named `katas-container` with interactive command-line and 
redirect container port `8888` to local port `8888` (needed to run jupyter):
```
docker run -it --name katas-container -p 8888:8888 katas /bin/bash
```

From the corresponding container command line, you can run the C# version of the BasicGates kata using: 
```
cd ~/BasicGates/
dotnet test
```

To start Jupyter Notebook within the image for the BasicGates kata, use:
```
cd ~/BasicGates/ && jupyter notebook --ip=0.0.0.0 --no-browser 
```

Once Jupyter has started, you can open in your browser the kata in notebook format (you
will need a token generated by Jupyter when it started on the previous step):

```
http://localhost:8888/notebooks/BasicGates.ipynb
```

To escape a docker container without killing it (daemon mode): 
```
Ctrl+P, Ctrl+Q
```

To re-enter the existing `katas-container` (in daemon mode): 
```
docker attach katas-container
```

Once you're done, to remove the `katas-container`:
```
docker rm --force katas-container
```


# Contributing <a name="contributing" /> #

This project welcomes contributions and suggestions.  For details, see [How Can I Contribute?](.github/CONTRIBUTING.md)


# Code of Conduct <a name="code-of-conduct" /> #

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
