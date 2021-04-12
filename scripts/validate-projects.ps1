# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$ErrorActionPreference = 'Stop'

& "$PSScriptRoot/set-env.ps1"
$all_ok = $True

function Build-One {
    param(
        $project
    );

    Write-Host "##[info]Building $project..."
    dotnet build $project `
        -c $Env:BUILD_CONFIGURATION `
        -v $Env:BUILD_VERBOSITY `
        /property:DefineConstants=$Env:ASSEMBLY_CONSTANTS `
        /property:Version=$Env:ASSEMBLY_VERSION `
        /property:QsharpDocsOutDir=$Env:DOCS_OUTDIR

    $script:all_ok = ($LastExitCode -eq 0) -and $script:all_ok

    # Force cleanup of generated bin and obj folders for this project.
    Write-Host "##[info]Cleaning up bin/obj from $(Split-Path $project -Parent)..."
    Get-ChildItem -Path (Split-Path $project -Parent) -Recurse `
    | Where-Object { ($_.name -eq "bin" -or $_.name -eq "obj") -and $_.attributes -eq "Directory" } `
    | Remove-Item -recurse -force
}

# Build all Katas solutions
Get-ChildItem (Join-Path $PSScriptRoot '..') -Recurse -Include '*.sln' -Exclude 'Microsoft.Quantum.Katas.sln' `
| ForEach-Object { Build-One $_.FullName }

if (-not $all_ok) {
    throw "At least one project failed building. Check the logs."
}