# Introduction

The Quantum Katas are a series of self-paced tutorials to help you learn about quantum computing and Q# programming.

:new: *(July 2019)* The Quantum Katas now include Jupyter Notebook tutorials on quantum computing! Each tutorial combines theoretical explanations with Q# code snippets and programming exercises. See [index.ipynb](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=index.ipynb) for the list of all Notebook tutorials and instructions to run them online.

:new: *(April 2019)* The Quantum Katas are now available as Jupyter Notebooks! See [index.ipynb](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=index.ipynb) for the list of all Kata Notebooks and instructions on running them online.

Each kata is a separate project that includes:

* A sequence of tasks progressing from easy to hard.
  Each task requires you to fill in some code. The first task might require just one line, and the last one might require many lines of code.
* A testing framework that sets up, runs, and validates your solutions.
  Each task is covered by a [unit test](https://docs.microsoft.com/en-us/visualstudio/test/getting-started-with-unit-testing) which initially fails. When you provide the code to make it pass, move on to the next task.
* Links to quantum computing and Q# reference material you might need to solve the tasks.
* Reference solutions when all else fails.

## Table of contents ##

* [List of notebook tutorials](#tutorial-topics)
* [List of katas](#kata-topics)
* [Run the katas and tutorials as Jupyter Notebooks](#run-as-notebook)
* [Run the katas locally](#kata-locally)
  * [Download the Quantum Katas](#download)
  * [Run a kata as a Q# project](#kata-as-project)
  * [Run kata tests](#tests)
  * [Run katas locally with Docker](#docker)
* [Contributing](#contributing)
* [Code of Conduct](#code-of-conduct)

## List of notebook tutorials <a name="tutorial-topics" /> ##

* **[Complex arithmetic](./tutorials/ComplexArithmetic/)**.
  Learn about complex numbers and the mathematics required to work with quantum computing.
* **[Linear algebra](./tutorials/LinearAlgebra/)**.
  Learn about about matrices and vectors used to represent quantum states and quantum operations.
* **[The qubit](./tutorials/Qubit/)**.
  Learn what a quibit is.
* **[Single-qubit gates](./tutorials/SingleQubitGates/)**.
  Learn what a quantum gate is and about the most common single-qubit gates.
* **[Multi-qubit systems](./tutorials/MultiQubitSystems/)**.
  Learn about the representation of multi-qubit systems.
* **[Multi-qubit gates](./tutorials/MultiQubitGates/)**.
  Learn about the most common multi-qubit gates.
* **[Exploring Deutsch–Jozsa algorithm](./tutorials/ExploringDeutschJozsaAlgorithm/)**.
  Learn how to implement classical functions and equivalent quantum oracles, about the classical
  solution to the Deutsch–Jozsa problem, and get an introduction to the Deutsch and Deutsch–Jozsa algorithms.
* **[Exploring Grover's search algorithm](./tutorials/ExploringGroversAlgorithm/)**.
  Learn more about Grover's search algorithm, picking up where the [Grover's algorithm kata](./GroversAlgorithm/) left off.

## List of Katas <a name="kata-topics" /> ##

#### Quantum computing concepts

* **[Basic quantum computing gates](./BasicGates/)**.
  Learn about the single-qubit and multi-qubit gates used in quantum computing.
* **[Superposition](./Superposition/)**.
  Learn about preparing a superposition state on one or more qubits.
* **[Measurements](./Measurements/)**.
  Learn to distinguish quantum states using measurements.
* **[Joint measurements](./JointMeasurements/)**.
  Learn about using joint (parity) measurements to distinguish quantum states and performing gates.

#### Simple algorithms

* **[Teleportation](./Teleportation/)**.
  Learn about standard teleportation protocol and variations.
* **[Superdense coding](./SuperdenseCoding/)**.
  Learn about the Superdense coding protocol.
* **[Deutsch–Jozsa algorithm](./DeutschJozsaAlgorithm/)**.
  Learn about quantum oracles which implement classical functions, and get an introduction to the Bernstein–Vazirani and Deutsch–Jozsa algorithms.
* **[Simon's algorithm](./SimonsAlgorithm/)**.
  Learn about Simon's algorithm.

#### Grover's algorithm

* **[Grover's algorithm](./GroversAlgorithm/)**.
  Learn about Grover's search algorithm and how to write quantum oracles to use with it.
* **[Solving SAT problems using Grover's algorithm](./SolveSATWithGrover/)**.
  Continue the exploration of Grover's search algorithm, using SAT problems as an example. Learn about implementing quantum oracles based on the problem description instead of a hard-coded answer. Use Grover's algorithm to solve problems with an unknown number of solutions.
* **[Solving graph coloring problems using Grover's algorithm](./GraphColoring/)**.
  Continue the exploration of Grover's search algorithm, using graph coloring problems as an example.

#### Entanglement games

* **[CHSH game](./CHSHGame/)**.
* **[GHZ game](./GHZGame/)**.
* **[Mermin-Peres magic square game](./MagicSquareGame)**.

#### Miscellaneous

* **[BB84 protocol](./KeyDistribution_BB84/)**.
  Learn about the BB84 key distribution algorithm.
* **[Phase estimation](./PhaseEstimation/)**.
  Learn about Phase estimation algorithms.
* **[Bit-flip error correcting code](./QEC_BitFlipCode/)**.
  Learn about a 3-qubit error correcting code for protecting against bit-flip errors.
* **[Ripple-carry adder](./RippleCarryAdder/)**.
  Learn how to build a ripple-carry adder on a quantum computer.
* **[Unitary Patterns*](./UnitaryPatterns/)**.
  Learn about implementing unitaries with matrices that follow certain patterns of zero and non-zero elements.

## Run the katas and tutorials as Jupyter Notebooks <a name="run-as-notebook" /> ##

The Quantum Katas are now available as Jupyter Notebooks! See [index.ipynb](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/master?filepath=index.ipynb) for the list of all katas, tutorial notebooks, and instructions to run them online.

## Run katas locally <a name="kata-locally" /> ##

To use the Quantum Katas locally, first install the [Quantum Development Kit](https://docs.microsoft.com/quantum), available for Windows 10, macOS, and Linux.
If you don't already have the Quantum Development Kit installed, see [install guide for the Quantum Development Kit](https://docs.microsoft.com/quantum/install-guide/).

For a quick Q# programming language reference sheet, see [Q# Language Quick Reference](./quickref/qsharp-quick-reference.pdf).

### Download the Quantum Katas <a name="download" /> ###

If you have Git installed, clone the Microsoft/QuantumKatas repository:

```bash
$ git clone https://github.com/Microsoft/QuantumKatas.git
```

> [!TIP]
> Both Visual Studio 2017 and Visual Studio Code make it easy to clone repositories from within your development environment.
> For details, see the [Visual Studio 2017](https://docs.microsoft.com/en-us/vsts/git/tutorial/clone?view=vsts&tabs=visual-studio#clone-from-another-git-provider) and [Visual Studio Code](https://code.visualstudio.com/docs/editor/versioncontrol#_cloning-a-repository) documentation.

If you don't have Git installed, download the katas from https://github.com/Microsoft/QuantumKatas/archive/master.zip.

### Run a kata as a Q# project <a name="kata-as-project" /> ###

Each kata is in its own directory as a self-contained Q# solution and project pair.
For instance, the BasicGates directory structure is:

```bash
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

To open the **BasicGates** kata in Visual Studio 2017, open the **QuantumKatas/BasicGates/BasicGates.sln** solution file.

To open the **BasicGates** kata in Visual Studio Code, open the **QuantumKatas/BasicGates/** folder.
Press **Ctrl + Shift + P** (or **⌘ + Shift + P** on macOS) to open the **Command Palette**. Type **Open Folder** on Windows 10 or Linux or **Open** on macOS.

> [!TIP]
> Almost all commands available in Visual Studio Code are in the Command Palette.
> If you get stuck, press **Ctrl + Shift + P** (or **⌘ + Shift + P** on macOS) and start typing to search through all available commands.
>
> You can also launch Visual Studio Code from the command line:
> ```bash
> $ code QuantumKatas/BasicGates/
> ```

### Run kata tests <a name="tests" /> ###

Once you have a kata open, it's time to run the tests using the following instructions.
Initially all tests will fail. Don't panic!
Open **Tasks.qs** and start filling in the code to complete the tasks. Each task is covered by a unit test. Once you fill in the correct code for a task, rebuild the project and re-run the tests, and the corresponding unit test will pass.

#### Visual Studio 2017

1. Build the solution.
2. From the main menu, open **Test Explorer** (**Test** > **Windows**) and select **Run All** to run all unit tests at once.
3. Work on the tasks in the **Tasks.qs** file.
4. To test your code changes for a task, rebuild the solution and re-run all unit tests using **Run All**, or run just the test for that task by right-clicking the test and selecting **Run Selected Tests**.

#### Visual Studio Code

1. Press **Ctrl + \`** (or **⌘ + \`** on macOS) to open the integrated terminal.
   The terminal should open to the kata directory. If it doesn't, navigate to the folder containing the *.csproj file for the kata.
2. Run `dotnet test` in the integrated terminal.
   This should build the kata project and run all of the unit tests. All of the unit tests should fail.
3. Work on the tasks in the **Tasks.qs** file.
4. To test your code changes for a task, from the integrated terminal run `dotnet test` again.

For convenience, a tasks.json configuration file exists for each kata. It allows Visual Studio Code to run the build and test steps from the Command Palette.
Press **Ctrl + Shift + P** (or **⌘ + Shift + P** on macOS) to open the Palette and type **Run Build Task** or **Run Test Task** and press **Enter**.

## Run katas locally with Docker <a name="docker" /> ##

You can use the included [Dockerfile](./Dockerfile) to create a docker image with all the necessary libraries to run the katas from the command line or Jupyter.

1. First, install [Docker](https://docs.docker.com/install/).
2. Build the docker image and tag it `katas`:

```bash
docker build -t katas .
```

3. Run the image in the container named `katas-container` with interactive command-line and redirect container port `8888` to local port `8888` (needed to run Jupyter):

```bash
docker run -it --name katas-container -p 8888:8888 katas /bin/bash
```

4. From the same command line that you used to run the container, run the C# version of the **BasicGates** kata:

```bash
cd ~/BasicGates/
dotnet test
```

5. Start a Jupyter Notebook within the image for the **BasicGates** kata:

```bash
cd ~/BasicGates/ && jupyter notebook --ip=0.0.0.0 --no-browser
```

6. Once Jupyter has started, use your browser to open the kata in notebook format. You
will need a token generated by Jupyter when it started on the previous step:

```
http://localhost:8888/notebooks/BasicGates.ipynb
```

To exit a docker container without killing it (daemon mode), press **Ctrl+P, Ctrl+Q**

To re-enter the existing `katas-container` (in daemon mode):

```bash
docker attach katas-container
```

Once you're done, remove the `katas-container`:

```bash
docker rm --force katas-container
```

# Contributing <a name="contributing" /> #

This project welcomes contributions and suggestions.  See [How Can I Contribute?](.github/CONTRIBUTING.md) for details.

# Code of Conduct <a name="code-of-conduct" /> #

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
