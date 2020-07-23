# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#!/usr/bin/env pwsh

& "$PSScriptRoot/set-env.ps1"

@{
    Packages = @(
        "Microsoft.Quantum.Katas"
    );
    Assemblies = @(
        "..\utilities\Common\bin\$Env:BUILD_CONFIGURATION\netstandard2.1\Microsoft.Quantum.Katas.Common.dll",
        "..\utilities\Microsoft.Quantum.Katas\bin\$Env:BUILD_CONFIGURATION\netstandard2.1\Microsoft.Quantum.Katas.dll"
    ) | ForEach-Object { Get-Item (Join-Path $PSScriptRoot $_) };
} | Write-Output;
