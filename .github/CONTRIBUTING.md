# How Can I Contribute?

We're so glad you asked!

**Table of Contents**

* [Reporting Bugs](#reporting-bugs)

* [Improving Documentation](#improving-documentation)

* [Contributing Code](#contributing-code)
   * [Improving Existing Katas](#improving-existing-katas)
   * [Contributing New Katas](#contributing-new-katas)
   * [Testing the Katas](#testing-the-katas)
   * [Style Guide](#style-guide)

* [Contributor License Agreement](#contributor-license-agreement)

* [Code of Conduct](#code-of-conduct)

## Reporting Bugs

The Quantum Development Kit is distributed across multiple repositories. If you have found a bug in one of the parts of the Quantum Development Kit, try to file the issue against the correct repository.
Check the list [in the contribution guide](https://docs.microsoft.com/quantum/contributing/#where-do-contributions-go) if you aren't sure which repo is correct.

If you think you've found a bug in one of the tasks, start by looking through [the existing issues](https://github.com/Microsoft/QuantumKatas/issues?q=is%3Aissue) in case it has already been reported (or it's not a bug at all). 

If there are no issues describing the problem you found, [open a new issue](https://github.com/Microsoft/QuantumKatas/issues/new).

You can also [create a pull request](https://help.github.com/articles/about-pull-requests/) to fix the bug directly, if it's very straightforward and is not worth the discussion (for example, a typo).

## Improving Documentation

If you are interested in contributing to conceptual documentation about the Quantum Development Kit, please see the [MicrosoftDocs/quantum-docs-pr](https://github.com/MicrosoftDocs/quantum-docs-pr) repository.

Besides, each kata has a README.md file with a brief description of the topic covered in the kata and a list of useful links on that topic. If you have come across a paper/tutorial/lecture which was really helpful for solving some of the kata's tasks, feel free to create a pull request to add it to the corresponding README file.

## Contributing Code

Whether you want to contribute a new task to an existing kata, to improve the testing harness for one of the tasks or to create a completely new kata, start by opening an issue describing your intended contribution. 
This way you'll get feedback on your idea faster and easier than if you go all the way to implementing it first.
This will also ensure that you're not working on the same thing as somebody else.

We're always happy to discuss new ideas and to offer advice, be it on the test harness implementation or on the best breakdown of a topic into tasks.

#### Improving Existing Katas

Each kata is a sequence of tasks on the topic progressing from very simple to quite challenging. If you have an idea for a task which fits nicely in the sequence, filling a gap between other tasks or expanding the sequence with harder tasks, bring it forward!

Note that most of the katas have a Jupyter Notebook front-end, so if you are modifying a task or adding a new one in the Q# project, you have to update the Jupyter Notebook for this kata as well.

You are also welcome to browse through the list of issues labeled as ["help wanted"](https://github.com/Microsoft/QuantumKatas/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22) and pick up any of them to work on it.

#### Contributing New Katas

We aim for the Quantum Katas to be a proper companion for any "Introduction to Quantum Computing" course, and eventually go beyond that.
Obviously, there is a lot of work to be done to get there! 

We welcome contributions of katas covering new topics. 
We are keeping a list of topics we already have covered, topics people are working on, and topics we'd like to have covered in the future at [the Roadmap](https://github.com/Microsoft/QuantumKatas/wiki/Roadmap) wiki page. 
This list is by no means complete or final; we will expand it as new topics come in.

If you want to create a kata for some topic, start by checking the roadmap to see whether there is anybody already working on it (duplicating work is not fun). 
If somebody is already working on this topic, you can try to find them (using the repository issues) and coordinate with them.
If the topic you want is not claimed, or is not on the list, go ahead and let us know you'll be working on it by creating an issue.

### Testing the Katas

You can use Jupyter Notebook front-end of the kata you're working on to validate the kata (i.e., to check that all tasks have correct reference solutions for them, and that all tests used in the notebook actually exist in the project.

To validate the kata, use the [`scripts/validate-notebooks.ps1`](../scripts/validate-notebooks.ps1) script. 
For example, to validate BasicGates kata run the following command from the PowerShell prompt from the root directory of the QuantumKatas project:

```powershell
   PS> ./scripts/validate-notebooks.ps1 ./BasicGates/BasicGates.ipynb
```

To use this script, you need to be able to [run Q# Jupyter notebooks locally](https://docs.microsoft.com/quantum/install-guide/jupyter) 
and to [have PowerShell installed](https://github.com/PowerShell/PowerShell#get-powershell).

### Style Guide

* We try to adhere to [the general Q# Style Guide](https://docs.microsoft.com/quantum/contributing/style-guide) in our Q# code. 
* We also try to maintain a uniform style across the katas and most importantly within each kata. 
  If you're adding a new task to an existing kata, it should be styled the same way as the rest of its tasks. 
  If you're creating a new kata, model it after the style of the existing katas. 
  This includes naming conventions, argument conventions, task description style etc.
* Each task should be covered by a test which verifies the solution, and each task should be accompanied by a reference solution which allows this test to pass.
* All code should build, and the tests should fail. Be careful not to carry this habit over to other projects, though!
* Avoid code duplication within one kata as much as possible. Most katas have series of similar tasks which are covered with similar test code; 
  it's usually better to extract this code into a generalized "framework" operation and use it in several tests than to duplicate it with small variations in each test.
* Avoid platform-dependent code: all katas should work on Windows 10, macOS and Linux, and both in Visual Studio and in Visual Studio Code/command line.

### Contributor License Agreement

Most code contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

### Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
