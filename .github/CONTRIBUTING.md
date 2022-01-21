# How Can I Contribute?

We're so glad you asked!

**Table of Contents**

* [Reporting Bugs](#reporting-bugs)
* [Improving Documentation](#improving-documentation)
* [Contributing Code](#contributing-code)
   * [The structure of a kata/tutorial](#the-structure-of-a-katatutorial)
   * [Adding new tasks to existing katas](#adding-new-tasks-to-existing-katas)
   * [Contributing workbooks](#contributing-workbooks)
   * [Contributing new katas](#contributing-new-katas)
   * [Style guide](#style-guide)
   * [Updating the Katas to the new QDK version](#updating-the-katas-to-the-new-qdk-version)
   * [Validating your changes](#validating-your-changes)
      * [Excluding individual tasks from validation](#excluding-individual-tasks-from-validation)
      * [Validating changes to `%kata` and `%check_kata` magics on local machine](#validating-changes-to-kata-and-check_kata-magics-on-local-machine)
* [Contributor License Agreement](#contributor-license-agreement)
* [Code of Conduct](#code-of-conduct)

## Reporting Bugs

The Quantum Development Kit is distributed across multiple repositories. If you have found a bug in one of the parts of the Quantum Development Kit, try to file the issue against the correct repository.
Check the list [in the contribution guide](https://docs.microsoft.com/azure/quantum/contributing-overview#where-do-contributions-go) if you aren't sure which repo is correct.

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

You are also welcome to browse through the list of issues labeled as ["help wanted"](https://github.com/Microsoft/QuantumKatas/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22) and pick up any of them to work on it.

We're always happy to discuss new ideas and to offer advice, be it on the test harness implementation or on the best breakdown of a topic into tasks.

### The structure of a kata/tutorial

Each kata has a fixed structure that includes tasks, reference solutions and testing harnesses. You can find an overview of this structure in 
[this blog post](https://devblogs.microsoft.com/qsharp/inside-the-quantum-katas-part-1/).

Tutorials follow a similar structure; the key difference between a kata and a tutorial is that a kata offers only programming exercises, while a tutorial offers the theory on some topic, complimented by some exercises (possibly easier ones than a kata on a similar topic would have). 
The katas can offer advanced tasks that rely on the theory not presented in the tutorials (in this case they should offer a link to an external resource covering this topic). 
The theory offered in a tutorial should be presented in a manner consistent with other tutorials, using knowledge and terminology introduced in the previous tutorials - assume that a learner is going through the tutorials without in-depth study of other resources.

### Adding new tasks to existing katas

Each kata is a sequence of tasks on the topic progressing from very simple to quite challenging. If you have an idea for a task which fits nicely in the sequence, filling a gap between other tasks or expanding the sequence with harder tasks, bring it forward!

Note that most of the katas have a Jupyter Notebook front-end, so if you are modifying a task or adding a new one in the Q# project, you have to update the Jupyter Notebook for this kata as well.
If you're adding a task anywhere but in the end of the section, you'll also need to renumerate the tasks that follow it and the tests that cover it.

[#177](https://github.com/microsoft/QuantumKatas/pull/177) is an example pull request that touches all 4 files that need to be modified and includes task and test renumeration to accommodate the new task in the middle of the sequence.

### Contributing workbooks

A lot of katas and tutorials have *workbooks* - worked out solutions to the exercises presented in Jupyter Notebook format and cross-linked with the Jupyter Notebook "frontend" of the kata. 

The explanations focus on the logical steps required to solve a problem; they illustrate the concepts that need to be applied to come up with a solution to the problem, explaining the mathematical steps required, and occasionally the Q# concepts and features used to implement the mathematical solution in the code. 
The workbook should not be the primary source of knowledge on the subject matter; it assumes that the learner has already read a tutorial or a textbook and that is now seeking to improve their problem-solving skills. The learner should attempt solving the tasks of the respective kata first, and turn to the workbook only if stuck. While a textbook emphasizes knowledge acquisition, a workbook emphasizes skill acquisition.

The workbook solutions can parallel the ones in `ReferenceImplementation.qs` or follow an original approach. Sometimes a workbook will present several different solutions for one problem if they illustrate different strategies to solving this type of problems.

[#509](https://github.com/microsoft/QuantumKatas/pull/509/) is an example pull request that adds a workbook to a kata.

### Contributing new katas

We aim for the Quantum Katas to be a proper companion for any "Introduction to Quantum Computing" course, and eventually go beyond that.
Obviously, there is a lot of work to be done to get there! 

We welcome contributions of katas covering new topics. 
We are keeping a list of topics we already have covered, topics people are working on, and topics we'd like to have covered in the future at [the Roadmap](https://github.com/Microsoft/QuantumKatas/wiki/Roadmap) wiki page. 
This list is by no means complete or final; we will expand it as new topics come in.

If you want to create a kata for some topic, start by checking the roadmap to see whether there is anybody already working on it (duplicating work is not fun). 
If somebody is already working on this topic, you can try to find them (using the repository issues) and coordinate with them.
If the topic you want is not claimed, or is not on the list, go ahead and let us know you'll be working on it by creating an issue.

[#378](https://github.com/microsoft/QuantumKatas/pull/378/) is an example pull request that adds a new kata with Jupyter Notebook "frontend" and a workbook. (Note that it predates our changes to the way the kata tests are defined. The best way to add a new kata is to copy an existing one and follow its structure exactly.)

### Style guide

* We try to adhere to [the general Q# Style Guide](https://docs.microsoft.com/azure/quantum/contributing-style-guide) in our Q# code. 
* We also try to maintain a uniform style across the katas and most importantly within each kata. 
  If you're adding a new task to an existing kata, it should be styled the same way as the rest of its tasks. 
  If you're creating a new kata, model it after the style of the existing katas. 
  This includes naming conventions, argument conventions, task description style etc.
* Each task should be covered by a test which verifies the solution, and each task should be accompanied by a reference solution which allows this test to pass.
* All code should build, and the tests should fail. Be careful not to carry this habit over to other projects, though!
* Avoid code duplication within one kata as much as possible. Most katas have series of similar tasks which are covered with similar test code; 
  it's usually better to extract this code into a generalized "framework" operation and use it in several tests than to duplicate it with small variations in each test.
* Avoid platform-dependent code: all katas should work on Windows 10, macOS and Linux, and both in Visual Studio and in Visual Studio Code/command line.

### Updating the Katas to the new QDK version

The Quantum Development Kit is updated monthly (you can find the latest releases in the [release notes](https://docs.microsoft.com/azure/quantum/qdk-relnotes). After each new release the Katas have to be updated to use the newly released QDK version. 

Updating the Katas to a different QDK version can be done using PowerShell script [Update-QDKVersion](https://github.com/microsoft/QuantumKatas/blob/main/scripts/Update-QDKVersion.ps1). It takes one parameter, the version to be used, so the command looks like this:

```powershell
   PS> ./scripts/Update-QDKVersion.ps1 0.21.2112181770-beta 
```

After running this script you should validate that the update didn't introduce any breaking changes; see the next section for how to do this.

### Validating your changes

When you contribute any code to the Katas, you need to validate that everything works the way it is supposed to work. Here are the key points to check (they might or might not be applicable to your change, depending on what you modified):

1. **Local development**  
   1. Check that the kata/tutorial you modified builds using `dotnet build` (if you modified the files in the project).
   2. Check that the notebook version of the kata/tutorial opens using `jupyter notebook` (if you modified the notebook file).
   3. Check that the reference solutions for the tasks pass the tests.  
      You can use Jupyter Notebook front-end of the kata you're working on to validate this (i.e., to check that all tasks have correct reference solutions for them, and that all tests used in the notebook actually exist in the project).  
      
      To validate the kata, use the [`scripts/validate-notebooks.ps1`](../scripts/validate-notebooks.ps1) script. 
      For example, to validate BasicGates kata run the following command from the PowerShell prompt from the root directory of the QuantumKatas project:

      ```powershell
         PS> ./scripts/validate-notebooks.ps1 ./BasicGates/BasicGates.ipynb
      ```

      To use this script, you need to be able to [run Q# Jupyter notebooks locally](https://docs.microsoft.com/azure/quantum/install-jupyter-qdk) 
and to [have PowerShell installed](https://github.com/PowerShell/PowerShell#get-powershell).

   4. If you do a bulk update of the katas, testing each of them individually will take too much time; you can streamline the testing using the scripts used by our continuous integration. 
   It is also a good idea to check a representative kata (we recommend [Measurements](https://github.com/microsoft/QuantumKatas/tree/main/Measurements)) manually to see if there is any issue not covered by automated checks, such as different error format, a dramatic performance degradation etc.

2. **Running on Binder**  
   The Katas can be run online on [Binder](https://mybinder.org); when you make a potentially breaking change (such as an update to the new QDK version or modifying any package dependencies), you need to make sure that this still works.  
   You can check this by pushing your changes to a branch on GitHub and navigating to the Binder link used for the Katas (https://mybinder.org/v2/gh/Microsoft/QuantumKatas/main?urlpath=/notebooks/index.ipynb) and change account name (`microsoft`) and branch (`main`) in the url to your GitHub username and branch name, respectively. After that you can navigate to the kata you want to check using the links from index notebook.

3. **Continuous integration**  
   When you open a pull request or add a commit to it, continuous integration pipeline is executed to validate your changes. You can see the details of jobs executed in the "Checks" section on the pull request page; make sure to monitor the results, and if the run fails, try to figure out the reason and fix it.

#### Excluding individual tasks from validation

Currently some tasks are excluded from validation performed as part of continuous integration done by the [`scripts/validate-notebooks.ps1`](../scripts/validate-notebooks.ps1) script.
This can happen for several reasons: 
 - Some tasks require implementing several code cells at once before running the test, so the first of the cells implemented is guaranteed to fail the associated test (`multicell_solution`).
 - For some tasks the correct solution is randomized and fails (`randomized_solution`) or times out (`timeout`) with relatively high probability.
 - Some code cells contain deliberately invalid code (`invalid_code`) that the learner is supposed to fix.

> Currently all tags are excluded from validation in the same way: the corresponding cells are not executed when the notebook is validated.
> The different tags are introduced as a form of documenting the reasons for excluding the tasks.
> If there is a new reason, you can update the `exclude_from_validation` set of tags in the [`scripts/validate-notebooks.ps1`](../scripts/validate-notebooks.ps1) script and add an explanation for the new tag in this contribution guide.

To exclude a task from validation, open the corresponding Jupyter notebook and choose ```View -> Cell Toolbar -> Tags``` to see and edit the tags for each cell. Add the tag that is the most fitting description of the failure cause to the cell. 
After you are done with editing the notebook, choose ```View -> Cell Toolbar -> None``` to turn off tags editing view for the subsequent users of this notebook. Finally, save the notebook.

#### Validating changes to `%kata` and `%check_kata` magics on local machine
1. Do your changes in the [`KataMagic.cs`](../utilities/Microsoft.Quantum.Katas/KataMagic.cs) and [`CheckKataMagic.cs`](../utilities/Microsoft.Quantum.Katas/CheckKataMagic.cs), for example, add logging statements:
   ```
   Logger.LogDebug($"Value : {val}");
   ```
2. Generate a custom NuGet package `Microsoft.Quantum.Katas`.
   1. Build the Microsoft.Quantum.Katas project to produce a NuGet package. To do this, you can add the following field to the [Microsoft.Quantum.Katas.csproj](../utilities/Microsoft.Quantum.Katas/Microsoft.Quantum.Katas.csproj) under the `<PropertyGroup>` tag:
      ```
      <GeneratePackageOnBuild>true</GeneratePackageOnBuild>
      ```
      If you need to get a version other than 1.0.0, add a field `<Version>version-number</Version>` under the same tag.
   2. Copy the generated .nupkg file from the `Microsoft.Quantum.Katas\bin\Debug` folder to the folder in which the test kata project resides (such as PhaseEstimation kata).
   3. Remove the package reference to `Microsoft.Quantum.Katas` package from the .csproj file of your project.
      > This might cause your project to fail build, for example, if it uses CounterSimulator functionality. It will build successfully from the Q# Notebook once you add this package dynamically.
   4. Set up NuGet.config file in the project folder to allow the project to discover a NuGet package in the current folder in addition to the standard sources. Here's an example file:
      ```
      <?xml version="1.0" encoding="utf-8"?>
      <configuration>
        <packageSources>
          <add key="Local Folder" value="." />
        </packageSources>
      </configuration>
      ```
3. To observe your changes when running Q# Jupyter Notebook:
   1. Set the environment variable `IQSHARP_LOG_LEVEL=Debug`.
      > The environment variable is case-sensitive.
   2. Navigate to your project folder and run the following command:
      ```
      $ start jupyter notebook <your notebook name>
      ```
      > This will launch Q# Jupyter Notebooks server in a new window, which is
      > helpful in debugging the magics since logging is quite noisy.
   3. In the Q# Jupyter Notebook you opened, use `%package` magic to load the new NuGet package `Microsoft.Quantum.Katas` by adding and executing the following cell:
      ```
      %package Microsoft.Quantum.Katas::<package-version>
      ```
   2. Reload the workspace by adding and executing the following cell:
      ```
      %workspace reload
      ```

> To validate changes to the `CheckKataMagic` using the `validate-notebooks.ps1` script, update the NuGet.config file being written [by the script](../scripts/validate-notebooks.ps1#L88) to include the local folder instead of `<clear />` by replacing it with `<add key=""Local Folder"" value=""."" />`

## Contributor License Agreement

Most code contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
