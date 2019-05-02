$ErrorActionPreference = 'Stop'

function validate {
    Param($folder)

    pushd $folder
    $CheckNotebook = 'Check.ipynb'

    if (Test-Path $CheckNotebook) 
    {
        Remove-Item $CheckNotebook
    }

    $Notebook = (Get-ChildItem *.ipynb)
    Write-Host "Checking notebook $Notebook."

    (Get-Content $Notebook -Raw) |  ForEach-Object { $_.replace('%kata', '%check_kata') } | Set-Content $CheckNotebook -NoNewline
    jupyter nbconvert $CheckNotebook --execute  --ExecutePreprocessor.timeout=120

    popd
}

validate ..\BasicGates
validate ..\Measurements
validate ..\Superposition
validate ..\DeutschJozsaAlgorithm