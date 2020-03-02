# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/set-env.ps1"

# Install iqsharp if not installed yet.

Write-Host ("Installing IQ# tool.")
$install = $False

# Install iqsharp if not installed yet.
try {
    dotnet iqsharp --version
    $install = ($LastExitCode -ne 0)
} catch {
    Write-Host ("`dotnet iqsharp --version` threw Exception.")
    $install = $True
}

if ($install) {
    Write-Host ("Installing Microsoft.Quantum.IQSharp at $Env:TOOLS_DIR")
    dotnet tool install Microsoft.Quantum.IQSharp --version 0.10.1911.1607 --tool-path $Env:TOOLS_DIR

    $path = (Get-Item "$Env:TOOLS_DIR\dotnet-iqsharp*").FullName
    Write-Host "iq# installed at $path"
    & $path install --user --path-to-tool $path
} else {
    Write-Host ("Microsoft.Quantum.IQSharp is already installed in this host.")
}

