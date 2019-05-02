# Script to validate Jupyter notebooks.

#
# This function takes a folder with Katas. Copies the corresponding 
# jupyter notebook into a "Check.ipynb" that replaces the %kata magic
# with a %check_kata magic that runs the kata not with the user-supplied code
# but with the Reference implementation.
# If the execution fails or has warnings, the execution of the notebook
# will fail.
function validate {
    Param($folder)
    pushd $folder

    # Name of the notebook that will be used for checking katas.
    $CheckNotebook = 'Check.ipynb'

    # Make sure old versions are removed.
    if (Test-Path $CheckNotebook)  {
        Remove-Item $CheckNotebook
    }

    # Find the name of the kata's notebook.
    $Notebook = (Get-ChildItem *.ipynb)
    Write-Host "Checking notebook $Notebook."

    #  convert %kata to %check_kata. run Jupyter nbconvert to execute the kata.
    (Get-Content $Notebook -Raw) |  ForEach-Object { $_.replace('%kata', '%check_kata') } | Set-Content $CheckNotebook -NoNewline
    jupyter nbconvert $CheckNotebook --execute  --ExecutePreprocessor.timeout=120

    # if jupyter returns an error code, return that this notebook is invalid:
    $invalid = ($LastExitCode -ne 0)
    Write-Host "Result: " $LastExitCode

    popd
    return $invalid
}

# List of Katas to verify:
$errors = $false
$errors = (validate ..\Measurements) -or $errors
$errors = (validate ..\BasicGates) -or $errors
$errors = (validate ..\Superposition) -or $errors
$errors = (validate ..\DeutschJozsaAlgorithm) -or $errors

$result = 0
if ($errors) { 
    Write-Host "##vso[task.logissue type=error;]Validation errors for Jupyter notebooks."
    $result = 1 
}

exit($result)