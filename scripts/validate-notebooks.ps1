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

#>

[CmdletBinding()]
Param(
    [Parameter(Position=1)]
    $Notebook = ""
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

    #  convert %kata to %check_kata. run Jupyter nbconvert to execute the kata.
    (Get-Content $Notebook -Raw) | ForEach-Object { $_.replace('%kata', '%check_kata') } | Set-Content $CheckNotebook -NoNewline

    if ($env:SYSTEM_DEBUG -eq "true") {
        jupyter nbconvert $CheckNotebook --execute  --ExecutePreprocessor.timeout=120 --log-level=DEBUG
    } else {
        jupyter nbconvert $CheckNotebook --execute  --ExecutePreprocessor.timeout=120
    } 

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
    'GraphColoring.ipynb',
    'MagicSquareGame.ipynb',
    'SolveSATWithGrover.ipynb',
    'ExploringGroversAlgorithmTutorial.ipynb',
    'VisualizingGroversAlgorithm.ipynb',
    'ComplexArithmetic.ipynb',
    'LinearAlgebra.ipynb'
)

$errors = $false

if ($Notebook -ne "") {
    # Validate only the notebook provided as the parameter (do not exclude blacklisted notebooks)
    Get-ChildItem $Notebook `
        | ForEach-Object { $errors = (Validate $_) -or $errors }
} else {
    # Validate all notebooks in the folder from which the script was executed
    Get-ChildItem (Join-Path $PSScriptRoot '..') `
        -Recurse `
        -Include '*.ipynb' `
        -Exclude $not_ready `
            | ForEach-Object { $errors = (Validate $_) -or $errors }
}

if (-not $all_ok) {
    Write-Host "##vso[task.logissue type=error;]Validation errors for Jupyter notebooks."
    throw "At least one test failed execution. Check the logs."
}
