#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $Version
);

<#
    .SYNOPSIS
        Updates the contents of this repo to use a given version of
        the Quantum Development Kit.
        
    .PARAMETER Version
        The version that this repo should be updated to. This version should be
        a valid NuGet package version as well as a valid tag for the
        mcr.microsoft.com/quantum/iqsharp-base Docker image.
        
    .EXAMPLE
    
        PS> ./Update-QDKVersion.ps1 -Version 0.24.210930
#>

$katasRoot = Join-Path $PSScriptRoot "\..\"

# old version regular expression accounts for possible suffixes like "-beta"
$versionRegex = "(?<oldVersion>[0-9|\.|\-|a-z]+)"

$csStringPackage = 'PackageReference Include=\"Microsoft\.Quantum\.[a-zA-Z\.]+\" Version=\"' + $versionRegex + '\"'
$csStringProject = 'Project Sdk=\"Microsoft.Quantum.Sdk/' + $versionRegex + '\"'
$csFiles = (Get-ChildItem -Path $katasRoot -file -Recurse -Include "*.csproj" | ForEach-Object { Select-String -Path $_ -Pattern "Microsoft.Quantum" } | Select-Object -Unique Path)
$csFiles | ForEach-Object {
    (Get-Content -Encoding UTF8 $_.Path) | ForEach-Object {
         $isQuantumPackage = $_ -match $csStringPackage
         $isQuantumProject = $_ -match $csStringProject
         if ($isQuantumPackage -or $isQuantumProject) {
             $_ -replace $Matches.oldVersion, $Version
         } else {
             $_
         }
    } | Set-Content -Encoding UTF8 $_.Path
}

function FindPatternAndReplaceQDKVersion() {
    param (
        [string]$patternToSearch,
        [string]$targetPath
    )

    (Get-Content -Path $targetPath) | ForEach-Object {
        $isQuantumPackage = $_ -match $patternToSearch
        if ($isQuantumPackage) {
            $_ -replace $Matches.oldVersion, $Version
        } else {
            $_
        }
    } | Set-Content -Path $targetPath
}

$dockerString = "FROM mcr.microsoft.com/quantum/iqsharp-base:$versionRegex"
$dockerPath = Join-Path $katasRoot "Dockerfile"
FindPatternAndReplaceQDKVersion -patternToSearch $dockerString -targetPath $dockerPath

$ps1String = "Microsoft.Quantum.IQSharp --version $versionRegex"
$ps1Path = Join-Path $katasRoot "scripts\install-iqsharp.ps1"
FindPatternAndReplaceQDKVersion -patternToSearch $ps1String -targetPath $ps1Path

$updateps1String = "PS> ./Update-QDKVersion.ps1 -Version $versionRegex"
$updateps1Path = Join-Path $katasRoot "scripts\Update-QDKVersion.ps1"
FindPatternAndReplaceQDKVersion -patternToSearch $updateps1String -targetPath $updateps1Path

$contributingString = "PS> ./scripts/Update-QDKVersion.ps1 $versionRegex"
$contributingPath = Join-Path $katasRoot ".github\CONTRIBUTING.md"
FindPatternAndReplaceQDKVersion -patternToSearch $contributingString -targetPath $contributingPath

$jsonString = "`"Microsoft.Quantum.Sdk`": `"$versionRegex`""
$globalJsonPath = Join-Path $katasRoot "global.json"
FindPatternAndReplaceQDKVersion -patternToSearch $jsonString -targetPath $globalJsonPath
