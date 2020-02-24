# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/set-env.ps1"

# Install iqsharp if not installed yet.
dotnet iqsharp --version
If ($LastExitCode -ne 0) {
    dotnet tool install Microsoft.Quantum.IQSharp --version 0.10.1911.1607 --tool-path $Env:TOOLS_DIR

    $path = (Get-Item "$Env:TOOLS_DIR\dotnet-iqsharp*").FullName
    Write-Host "iq# installed at $path"
    & $path install --user --path-to-tool $path
}

