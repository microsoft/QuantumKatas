# Introduction

The Quantum Katas are a series of self-paced tutorials aimed at teaching you elements of quantum computing and Q# programming at the same time.

Each kata covers one topic.
Currently covered topics are:

* **[Basic quantum computing gates](./BasicGates/)**.
  This kata focuses on main single-qubit and multi-qubit gates used in quantum computing.
* **[Superposition](./Superposition/)**.
  The tasks focus on preparing a certain superposition state on one or multiple qubits.
* **[Measurements](./Measurements/)**.
  The tasks focus on distinguishing quantum states using measurements.
* **[Teleportation](./Teleportation/)**.
  This kata walks you through the standard teleportation protocol and several variations.
* **[Deutsch–Jozsa algorithm](./DeutschJozsaAlgorithm/)**.
  This kata starts with writing quantum oracles which implement classical functions, and continues to introduce the Bernstein–Vazirani and Deutsch–Jozsa algorithms.
* **[Bit-flip error correcting code](./QEC_BitFlipCode/)**.
  This kata introduces a 3-qubit error correcting code for protecting against bit-flip errors.

Each kata is a separate project which includes:

* A sequence of tasks on the topic progressing from trivial to challenging.
  Each task requires you to fill in some code; the first task might require just one line, and the last one might require a sizable fragment of code.
* A testing framework that sets up, runs and validates your solutions.
  Each task is covered by a [*unit test*](https://docs.microsoft.com/en-us/visualstudio/test/getting-started-with-unit-testing) which initially fails; once the test passes, you can move on to the next task!
* Pointers to reference materials you might need to solve the tasks, both on quantum computing and on Q#.
* Reference solutions, for when all else fails.

# Installing and Getting Started #

To get started with the Quantum Katas, you'll first need to install the [Quantum Development Kit](https://docs.microsoft.com/quantum), available for Windows 10, macOS, and for Linux.
Please see the [install guide for the Quantum Development Kit](https://docs.microsoft.com/en-us/quantum/quantum-installconfig) if you do not already have the Quantum Development Kit installed.

A quick reference sheet for Q# programming language is available [here](./quickref/qsharp-quick-reference.pdf).

### Downloading the Quantum Katas ###

If you have Git installed, go on and clone the Microsoft/QuantumKatas repository.
From your favorite command line:

```bash
$ git clone https://github.com/Microsoft/QuantumKatas.git
```

> **TIP**: Both Visual Studio 2017 and Visual Studio Code make it easy to clone repositories from within your development environment.
> See the [Visual Studio 2017](https://docs.microsoft.com/en-us/vsts/git/tutorial/clone?view=vsts&tabs=visual-studio#clone-from-another-git-provider) and [Visual Studio Code](https://code.visualstudio.com/docs/editor/versioncontrol#_cloning-a-repository) documentation for details.

Alternatively, if you don't have Git installed, you can manually download a standalone copy of the katas from https://github.com/Microsoft/QuantumKatas/archive/master.zip.

### Opening a Tutorial ###

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

To open the **BasicGates** kata in Visual Studio 2017, open the `QuantumKatas/BasicGates.sln` solution file.

To open the **BasicGates** kata in Visual Studio Code, open the `QuantumKatas/BasicGates/` folder.
Press Ctrl + Shift + P (or ⌘ + Shift + P on macOS) to open the Command Palette. Type "Open Folder" on Windows 10 or Linux or "Open" on macOS.

> **TIP**: Almost all commands available in Visual Studio Code can be found in the Command Palette.
> If you ever get stuck, press Ctrl + Shift + P (or ⌘ + Shift + P on macOS) and type some letters to search through all available commands.

> **TIP**: You can also launch Visual Studio Code from the command line if you prefer:
> ```bash
> $ code QuantumKatas/BasicGates/
> ```

### Running Kata Tests ###

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

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
