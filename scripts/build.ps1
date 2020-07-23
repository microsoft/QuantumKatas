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
}

Write-Host "Building Katas binaries:"

Build-One '..\utilities\DumpUnitary\DumpUnitary.sln'
Build-One '..\utilities\Microsoft.Quantum.Katas\Microsoft.Quantum.Katas.sln'

if (-not $all_ok) {
    throw "At least one project failed building. Check the logs."
}