# Script to validate Jupyter notebooks.

#
# This function takes a folder with Katas. Copies the corresponding 
# jupyter notebook into a "Check.ipynb" that replaces the %kata magic
# with a %check_kata magic that runs the kata not with the user-supplied code
# but with the Reference implementation.
# If the execution fails or has warnings, the execution of the notebook
# will fail.
function validate {
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
    jupyter nbconvert $CheckNotebook --execute  --ExecutePreprocessor.timeout=120

    # if jupyter returns an error code, return that this notebook is invalid:
    $invalid = ($LastExitCode -ne 0)
    Write-Host "Result for $Notebook -" $LastExitCode

    popd
    return $invalid
}

# List of Notebooks that can't be validated as they required user-input
# other than the kata answer:
$not_ready = 
@(
    'Check.ipynb',
    'CHSHGame.ipynb',
    'DeutschJozsaAlgorithm.ipynb',
    'GHZGame.ipynb',
    'MagicSquareGame.ipynb',
    'SolveSATWithGrover.ipynb'
)

$errors = $false
Get-ChildItem (Join-Path $PSScriptRoot '..') `
    -Recurse `
    -Include '*.ipynb' `
    -Exclude $not_ready `
        | ForEach-Object { $errors = (validate $_) -or $errors }

$result = 0
if ($errors) { 
    Write-Host "##vso[task.logissue type=error;]Validation errors for Jupyter notebooks."
    $result = 1 
}

exit($result)