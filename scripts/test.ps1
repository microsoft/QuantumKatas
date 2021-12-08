# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

& "$PSScriptRoot/set-env.ps1"
$all_ok = $True

function Test-One {
    Param($project)

    $TestsLogs = Join-Path $Env:LOGS_OUTDIR log-tests-quantum-katas.txt

    Write-Host "##[info]Testing $project"
    dotnet test $project --diag:"$TestsLogs" `
        -c $Env:BUILD_CONFIGURATION `
        -v $Env:BUILD_VERBOSITY `
        --no-build `
        --logger trx `
        /property:DefineConstants=$Env:ASSEMBLY_CONSTANTS `
        /property:InformationalVersion=$Env:SEMVER_VERSION `
        /property:Version=$Env:ASSEMBLY_VERSION

    if  ($LastExitCode -ne 0) {
        Write-Host "##vso[task.logissue type=error;]Failed to test $project"
        $script:all_ok = $False
    }
}

Write-Host "Testing Katas binaries:"

Test-One '..\utilities\DumpUnitary\DumpUnitary.sln'
Test-One '..\utilities\Microsoft.Quantum.Katas\Microsoft.Quantum.Katas.sln'

if (-not $all_ok) {
    throw "At least one test failed execution. Check the logs."
}