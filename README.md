# DEPRECATION NOTICE

>**We are modernizing the quantum katas experience.   Please visit https://quantum.microsoft.com/experience/quantum-katas to try the new online Azure Quantum katas experience, with integrated assistance from Copilot in Azure Quantum.** 

For the Modern QDK repository, please visit [Microsoft/qsharp](https://github.com/microsoft/qsharp).

For more information about the Modern QDK and Azure Quantum, visit [https://aka.ms/AQ/Documentation](https://aka.ms/AQ/Documentation).

## Introduction ##

The Quantum Katas are a collection of self-paced tutorials and programming exercises to help you learn quantum computing and Q# programming.

Each kata is a separate set of exercises that includes:

* A sequence of tasks progressing from easy to hard.
  Each task requires you to fill in some code. The first task might require just one line, and the last one might require rather complicated code.
* A testing framework that sets up, runs, and validates your solutions.
  Each task is covered by a [unit test](https://docs.microsoft.com/visualstudio/test/getting-started-with-unit-testing) which initially fails. Once you write the code to make the test pass, you can move on to the next task.
* Links to quantum computing and Q# reference material you might need to solve the tasks.
* Hints, reference solutions and detailed explanations to help you if you're stuck.

The Quantum Katas also include *tutorials* that introduce the learner to the basic concepts and algorithms used in quantum computing, starting with the necessary math (complex numbers and linear algebra). They follow the same pattern of supplementing the theory with Q# demos and hands-on programming exercises. 

## Table of contents ##

* [Learning path](#learning-path)
* [Run the katas and tutorials online](#run-online)
* [Run the katas locally](#kata-locally)
  * [Quantum Development Kit installation](#install)
  * [Download the Quantum Katas](#download)
  * [Run a kata as a Jupyter Notebook](#kata-as-notebook)
  * [Run a kata as a Q# project](#kata-as-project)
  * [Run kata tests](#tests)
  * [Run katas locally with Docker](#docker)
* [Contributing](#contributing)
* [Code of Conduct](#code-of-conduct)

## Learning path <a name="learning-path" /> ##

Here is the learning path we suggest you to follow if you are starting to learn quantum computing and quantum programming. Once you're comfortable with the basics, you're welcome to jump ahead to the topics that pique your interest!

#### Quantum Computing Concepts: Qubits and Gates

* **[Complex arithmetic (tutorial)](./tutorials/ComplexArithmetic/)**.
  Learn about complex numbers and the mathematics required to work with quantum computing.
* **[Linear algebra (tutorial)](./tutorials/LinearAlgebra/)**.
  Learn about vectors and matrices used to represent quantum states and quantum operations.
* **[The qubit (tutorial)](./tutorials/Qubit/)**.
  Learn what a qubit is.
* **[Single-qubit gates (tutorial)](./tutorials/SingleQubitGates/)**.
  Learn what a quantum gate is and about the most common single-qubit gates.
* **[Basic quantum computing gates](./BasicGates/)**.
  Learn to apply the most common gates used in quantum computing.
* **[Multi-qubit systems (tutorial)](./tutorials/MultiQubitSystems/)**.
  Learn to represent multi-qubit systems.
* **[Multi-qubit gates (tutorial)](./tutorials/MultiQubitGates/)**.
  Learn about the most common multi-qubit gates.
* **[Superposition](./Superposition/)**.
  Learn to prepare superposition states.

#### Quantum Computing Concepts: Measurements

* **[Single-qubit measurements (tutorial)](./tutorials/SingleQubitSystemMeasurements/)**.
  Learn what quantum measurement is and how to use it for single-qubit systems.
* **[Multi-qubit measurements (tutorial)](./tutorials/MultiQubitSystemMeasurements/)**.
  Learn to use measurements for multi-qubit systems.
* **[Measurements](./Measurements/)**.
  Learn to distinguish quantum states using measurements.
* **[Distinguish unitaries](./DistinguishUnitaries/)**.
  Learn to distinguish unitaries by designing and performing experiments with them.
* **[Joint measurements](./JointMeasurements/)**.
  Learn about using joint (parity) measurements to distinguish quantum states and to perform state transformations.

#### Q\# and Microsoft Quantum Development Kit Tools

* **[Visualization tools (tutorial)](./tutorials/VisualizationTools/)**.
  Learn to use the various tools for visualizing elements of Q# programs.

#### Simple Algorithms

* **[Random number generation (tutorial)](./tutorials/RandomNumberGeneration/)**.
  Learn to generate random numbers using the principles of quantum computing.
* **[Teleportation](./Teleportation/)**.
  Implement standard teleportation protocol and its variations.
* **[Superdense coding](./SuperdenseCoding/)**.
  Implement the superdense coding protocol.

#### Quantum Oracles and Simple Oracle Algorithms

* **[Quantum oracles (tutorial)](./tutorials/Oracles/)**.
  Learn to implement classical functions as equivalent quantum oracles. 
* **[Marking oracles](./MarkingOracles/)**.
  Practice implementing marking oracles for a variety of classical functions.
* **[Exploring Deutsch and Deutsch–Jozsa algorithms (tutorial)](./tutorials/ExploringDeutschJozsaAlgorithm/)**.
  Learn to implement classical functions and equivalent quantum oracles, and compare the quantum
  solution to the Deutsch–Jozsa problem to a classical one.
* **[Deutsch–Jozsa algorithm](./DeutschJozsaAlgorithm/)**.
  Learn about quantum oracles which implement classical functions, and implement Bernstein–Vazirani and Deutsch–Jozsa algorithms.
* **[Simon's algorithm](./SimonsAlgorithm/)**.
  Learn about Simon's algorithm.

#### Grover's Search Algorithm

* **[Implementing Grover's algorithm](./GroversAlgorithm/)**.
  Learn about Grover's search algorithm and how to write quantum oracles to use with it.
* **[Exploring Grover's search algorithm (tutorial)](./tutorials/ExploringGroversAlgorithm/)**.
  Learn more about Grover's search algorithm, picking up where the [Grover's algorithm kata](./GroversAlgorithm/) left off.
* **[Solving SAT problems using Grover's algorithm](./SolveSATWithGrover/)**.
  Explore Grover's search algorithm, using SAT problems as an example. Learn to implement quantum oracles based on the problem description instead of a hard-coded answer. Use Grover's algorithm to solve problems with an unknown number of solutions.
* **[Solving graph coloring problems using Grover's algorithm](./GraphColoring/)**.
  Continue the exploration of Grover's search algorithm, using graph coloring problems as an example.
* **[Solving bounded knapsack problem using Grover's algorithm](./BoundedKnapsack/)**.
  Learn how solve the variants of knapsack problem with Grover's search.

#### Tools and Libraries/Building up to Shor's Algorithm

* **[Quantum Fourier transform](./QFT/)**.
  Learn to implement quantum Fourier transform and to use it to perform simple state transformations.
* **[Phase estimation](./PhaseEstimation/)**.
  Learn about phase estimation algorithms.

#### Entanglement Games

* **[CHSH game](./CHSHGame/)**.
* **[GHZ game](./GHZGame/)**.
* **[Mermin-Peres magic square game](./MagicSquareGame)**.

#### Reversible Computing

* **[Truth tables](./TruthTables/)**.
  Learn to represent and manipulate Boolean functions as truth tables and to implement them as quantum operations.
* **[Ripple-carry adder](./RippleCarryAdder/)**.
  Build a ripple-carry adder on a quantum computer.

#### Miscellaneous

* **[BB84 protocol](./KeyDistribution_BB84/)**.
  Implement the BB84 key distribution algorithm.
* **[Bit-flip error correcting code](./QEC_BitFlipCode/)**.
  Learn about a 3-qubit error correcting code for protecting against bit-flip errors.
* **[Unitary patterns](./UnitaryPatterns/)**.
  Learn to implement unitaries with matrices that follow certain patterns of zero and non-zero elements.
* **[Quantum classification (tutorial)](./tutorials/QuantumClassification/)**.
  Learn about circuit-centric classifiers and the quantum machine learning library included in the QDK.

> For a Q# programming language quick reference sheet, see [Q# Language Quick Reference](./quickref/qsharp-quick-reference.pdf).

## Run the katas and tutorials online <a name="run-online" /> ##

The Quantum Katas are now available as Jupyter Notebooks online! See [index.ipynb](https://mybinder.org/v2/gh/Microsoft/QuantumKatas/main?urlpath=/notebooks/index.ipynb) for the list of all katas and tutorials, and instructions for running them online.

> Note that mybinder.org is running with reduced capacity, so getting a virtual machine and launching the notebooks on it might take several attempts. 
> While running the Katas online is the easiest option to get started, if you want to save your progress and enjoy better performance, we recommend you to choose the local setup option. 

## Run the katas locally <a name="kata-locally" /> ##

### Quantum Development Kit Installation <a name="install" /> ###

To use the Quantum Katas locally, you'll need the [Quantum Development Kit](https://docs.microsoft.com/azure/quantum), available for Windows 10, macOS, and Linux.
If you don't already have the Quantum Development Kit installed, see the [install guide for the Quantum Development Kit](https://docs.microsoft.com/azure/quantum/install-command-line-qdk).

**If you want to run the katas and tutorials locally as Jupyter Notebooks**:
1. Follow the steps in the [QDK install guide for Python](https://docs.microsoft.com/azure/quantum/install-python-qdk) 
  and the [QDK install guide for Jupyter Notebooks](https://docs.microsoft.com/en-us/azure/quantum/install-command-line-qdk#q-and-jupyter-notebooks).
2. Several tutorials require installing additional Python packages:
   * "Complex arithmetic" and "Linear algebra" require the [`pytest` package](https://docs.pytest.org/en/latest/getting-started.html).
   * "Exploring Grover's search algorithm" requires the [`matplotlib` package](https://matplotlib.org/3.1.1/users/installing.html).
   * "Quantum classification" requires [`matplotlib`](https://matplotlib.org/3.1.1/users/installing.html) and [`numpy`](https://numpy.org/install/) packages.
> Refer to [Updating IQ# kernel](https://docs.microsoft.com/azure/quantum/install-update-qdk#update-the-iq-jupyter-kernel) for updating IQ# kernel to a new version with monthly QDK releases.

**If you want to run the katas and tutorials locally as Q# projects**:

Follow the steps in the [QDK install guide](https://docs.microsoft.com/en-us/azure/quantum/install-command-line-qdk#q-and-other-ides) for Visual Studio, Visual Studio Code or other editors.

Running the Q# projects of the Katas locally requires downloading and installing the [.NET 6.0 SDK](https://dotnet.microsoft.com/download). You can do this even if you have another .NET version installed, since multiple versions are supported side-by-side.

Since Visual Studio 2019 does not support .NET 6.0 projects, you will need to upgrade to Visual Studio 2022 and install the corresponding [Microsoft Quantum Development Kit](https://marketplace.visualstudio.com/items?itemName=quantum.DevKit64) extension.

### Download the Quantum Katas <a name="download" /> ###

If you have Git installed, clone the Microsoft/QuantumKatas repository:

```bash
$ git clone https://github.com/Microsoft/QuantumKatas.git
```

> **TIP**  
> Both Visual Studio 2022 and Visual Studio Code make it easy to clone repositories from within your development environment.
> For details, see the [Visual Studio](https://docs.microsoft.com/azure/devops/repos/git/clone?view=azure-devops&tabs=visual-studio#clone-from-another-git-provider) and [Visual Studio Code](https://code.visualstudio.com/docs/editor/versioncontrol#_cloning-a-repository) documentation.

If you don't have Git installed, download the katas from https://github.com/Microsoft/QuantumKatas/archive/main.zip.


### Run a kata as a Jupyter Notebook <a name="kata-as-notebook" /> ###

The best way to run the katas as Jupyter Notebooks is to navigate to the root folder of the repository and to open `index.ipynb` using Jupyter:

```bash
$ cd QuantumKatas/
$ jupyter notebook index.ipynb
```

This will open the notebook that contains a list of all katas and tutorials, and you will be able to navigate to the one you want using links.

> **NOTE:** 
> This will start Jupyter Notebooks server in the same command line window you used to run the command. If you want to keep using that window for navigation, you can launch Jupyter Notebooks server in a new window using the following commands:   
>
> **For Windows:**
> ```bash
> $ cd QuantumKatas/
> $ start jupyter notebook index.ipynb
> ```
>  
> **For Ubuntu:**
> ```bash
> $ cd QuantumKatas/
> $ gnome-terminal -- start jupyter notebook index.ipynb
> ```

You can also open an individual notebook directly, but this might render internal links invalid:

```bash
$ cd QuantumKatas/tutorials/ComplexArithmetic
$ jupyter notebook ComplexArithmetic.ipynb
```


### Run a kata as a Q# project <a name="kata-as-project" /> ###

Each kata is in its own directory as a self-contained Q# project, solution and Jupyter Notebook triplet.
For instance, the BasicGates directory structure is:

```bash
QuantumKatas/
  BasicGates/
    README.md                  # Instructions specific to this kata.
    .vscode/                   # Metadata used by Visual Studio Code.
    BasicGates.sln             # Visual Studio solution file.
    BasicGates.csproj          # Project file used to build both classical and quantum code.

    BasicGates.ipynb           # Jupyter Notebook front-end for this kata.
    Workbook_BasicGates.ipynb  # Jupyter Notebook workbook for this kata.

    Tasks.qs                   # Q# source code that you will fill as you solve each task.
    Tests.qs                   # Q# tests that verify your solutions.
    ReferenceImplementation.qs # Q# source code containing solutions to the tasks.
```

To open the **BasicGates** kata in Visual Studio 2022, open the **QuantumKatas/BasicGates/BasicGates.sln** solution file.

To open the **BasicGates** kata in Visual Studio Code, open the **QuantumKatas/BasicGates/** folder.
Press **Ctrl + Shift + P** (or **⌘ + Shift + P** on macOS) to open the **Command Palette**. Type **Open Folder** on Windows 10 or Linux or **Open** on macOS.

> **TIP**  
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

#### Visual Studio 2022

1. Build the solution.
2. From the main menu, open **Test Explorer** (**Test** > **Windows**) and select **Run All** to run all unit tests at once.
3. Work on the tasks in the **Tasks.qs** file.
4. To test your code changes for a task, rebuild the solution and re-run all unit tests using **Run All**, or run just the test for that task by right-clicking the test and selecting **Run Selected Tests**.

#### Visual Studio Code

1. Press **Ctrl + \`** (or **⌘ + \`** on macOS) to open the integrated terminal.
   The terminal should open to the kata directory. If it doesn't, navigate to the folder containing the *.csproj file for the kata using `cd` command.
2. Run `dotnet test` in the integrated terminal.
   This should build the kata project and run all of the unit tests. All of the unit tests should fail.
3. Work on the tasks in the **Tasks.qs** file.
4. To test your code changes for a task, from the integrated terminal run `dotnet test` again.

For convenience, a tasks.json configuration file exists for each kata. It allows Visual Studio Code to run the build and test steps from the Command Palette.
Press **Ctrl + Shift + P** (or **⌘ + Shift + P** on macOS) to open the Palette and type **Run Build Task** or **Run Test Task** and press **Enter**.

## Run katas locally with Docker <a name="docker" /> ##

You can use the included [Dockerfile](./Dockerfile) to create a docker image with all the necessary tools to run the katas from the command line or Jupyter.

1. Install [Docker](https://docs.docker.com/install/).
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
