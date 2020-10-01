# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

<#

    .SYNOPSIS
        This script validates katas represented as Jupyter notebooks.

    .NOTES
        A kata is validated as follows: 
          * corresponding Jupyter notebook is copied into a "Check.ipynb",
          * %kata magic is replaced with %check_kata magic that runs 
            the tasks with their reference implementations instead of the stubs.
          * if the execution of the notebook with %check_kata magic fails,
            the validation of the kata fails.

    .PARAMETER Notebook
        Path to the notebook to be validated.
        If not set, defaults to validating all notebooks in the current directory.
    .PARAMETER StartIndex
        The index of the first notebook to be checked (in the list of all possible notebooks)
        If not set, will default to 0 to validate all notebooks from the beginning of the list
    .PARAMETER EndIndex
        The index of the last notebook to be checked (in the list of all possible notebooks)
        If not set, will default to the index of the last notebook in the list to validate all notebooks to the end of the list
#>

[CmdletBinding()]
Param(
    [Parameter(Position=1)]
    $Notebook = "",
    [int]$StartIndex = -1.0,
    [int]$EndIndex = -1.0
)


& "$PSScriptRoot/install-iqsharp.ps1"
$all_ok = $True

function Validate {
    Param($Notebook)

    # Name of the notebook that will be used for checking katas.
    $CheckNotebook = 'Check.ipynb'

    $folder = Resolve-Path($Notebook.Directory)
    pushd $folder


    # Make sure old versions are removed.
    if (Test-Path $CheckNotebook)  {
        Remove-Item $CheckNotebook
    }

    # Find the name of the kata's notebook.
    Write-Host "Checking notebook $Notebook."

    # Convert %kata to %check_kata
    (Get-Content $Notebook -Raw) | ForEach-Object { $_.replace('%kata', '%check_kata') } | Set-Content $CheckNotebook -NoNewline

    # Run Jupyter nbconvert to execute the kata.
    # dotnet-iqsharp writes some output to stderr, which causes PowerShell to throw
    # unless $ErrorActionPreference is set to 'Continue'.
    $ErrorActionPreference = 'Continue'
    if ($env:SYSTEM_DEBUG -eq "true") {
        # Redirect stderr output to stdout to prevent an exception being incorrectly thrown.
        jupyter nbconvert $CheckNotebook --execute --to html --ExecutePreprocessor.timeout=180 --log-level=DEBUG 2>&1 | %{ "$_"}
    } else {
        # Redirect stderr output to stdout to prevent an exception being incorrectly thrown.
        jupyter nbconvert $CheckNotebook --execute --to html --ExecutePreprocessor.timeout=180 2>&1 | %{ "$_"}
    }
    $ErrorActionPreference = 'Stop'

    # if jupyter returns an error code, report that this notebook is invalid:
    if ($LastExitCode -ne 0) {
        Write-Host "##vso[task.logissue type=error;]Validation errors for $Notebook ."        
        $script:all_ok = $false
    }

    popd
}


# List of Notebooks that can't be validated for various reasons:
#  * Check.ipynb is a validation artifact and not an actual kata notebook.
#  * CHSH and MagicSquare games require implementing two code cells at once before running the test, 
#    so the first of the cells implemented is guaranteed to fail.
#  * GraphColoring and SolveSATWithGrover have tasks for which the correct solution fails or times out with relatively high probability.
#  * ExploringGroversAlgorithm has tasks with deliberately invalid Q# code.
#  * ComplexArithmetic and LinearAlgebra have tasks with deliberately invalid Python code.
# 
$not_ready = 
@(
    'Check.ipynb',
    'CHSHGame.ipynb',
    'Workbook_CHSHGame.ipynb',
    'GraphColoring.ipynb',
    'MagicSquareGame.ipynb',
    'SolveSATWithGrover.ipynb',
    'ExploringGroversAlgorithmTutorial.ipynb',
    'VisualizingGroversAlgorithm.ipynb',
    'ComplexArithmetic.ipynb',
    'LinearAlgebra.ipynb'
)


if ($Notebook -ne "") {
    # Validate only the notebook provided as the parameter (do not exclude blacklisted notebooks)
    Get-ChildItem $Notebook `
        | ForEach-Object { Validate $_ }
} else {
    # Get the list of all notebooks in the folder from which the script was executed
    $AllItems = Get-ChildItem (Join-Path $PSScriptRoot '..') `
        -Recurse `
        -Include '*.ipynb' `
        -Exclude $not_ready `
        | Sort-Object Name

    # If the start index is not set, set it to 0 to check all notebooks
    if ($StartIndex -lt 0) {
        $StartIndex = 0
    }

    # If the end index is not set, set it to (the number of notebooks - 1) to check all notebooks
    if ($EndIndex -lt 0) {
        $EndIndex = $AllItems.Length - 1
    }

    for ($i = $StartIndex; $i -le $EndIndex -and $i -le $AllItems.Length - 1; $i++) {
        Validate $AllItems[$i]
    }
}

if (-not $all_ok) {
    Write-Host "##vso[task.logissue type=error;]Validation errors for Jupyter notebooks."
    throw "At least one test failed execution. Check the logs."
}
