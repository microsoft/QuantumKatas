#!/usr/bin/env pwsh

#Requires -PSEdition Core

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
    
        PS> ./Update-QDKVersion.ps1 -Version 0.10.2002.2610
#>

$csString = 'PackageReference Include=\"Microsoft\.Quantum\.[a-zA-Z\.]+\" Version=\"(?<oldVersion>[0-9|\.]+)\"'
$csFiles = (Select-String -Path "..\**\*.csproj" -pattern "Microsoft.Quantum" | Select-Object -Unique Path)
$csFiles | ForEach-Object {
    (Get-Content -Encoding UTF8NoBom $_.Path) | ForEach-Object {
         $isQuantumPackage = $_ -match $csString
         if ($isQuantumPackage) {
             $_ -replace $Matches.oldVersion, $Version
         } else {
             $_
         }
    } | Set-Content -Encoding UTF8NoBom $_.Path
}

$ipynbString = '%package Microsoft.Quantum.Katas::(?<oldVersion>[0-9|\.]+)'
$ipynbFiles =  (Select-String -Path "..\**\*.ipynb" -pattern "Microsoft.Quantum" | Select-Object -Unique Path)

Write-Output (Get-ChildItem -Recurse "*.ipynb" `
| ForEach-Object { Select-String -Path $_ -Pattern $ipynbString } `
| Select-Object -Unique Path)

$ipynbFiles | ForEach-Object {
    if ($_)
    {
        (Get-Content $_.Path) | ForEach-Object {
            $isQuantumPackage = $_ -match $ipynbString
            if ($isQuantumPackage) {
                $_ -replace $Matches.oldVersion, $Version
            } else {
                $_
            }
        } | Set-Content $_.Path
    }
}
$dockerString = 'FROM mcr.microsoft.com/quantum/iqsharp-base:(?<oldVersion>[0-9|\.]+)'
$dockerFiles =  (Select-String -Path "..\Dockerfile" -pattern "microsoft.com/quantum" | Select-Object -Unique Path)
Get-Content $dockerFiles.Path | ForEach-Object {
         $isQuantumPackage = $_ -match $dockerString
         if ($isQuantumPackage) {
             $_ -replace $Matches.oldVersion, $Version
         } else {
             $_
         }
    } | Set-Content $dockerFiles.Path


$ps1String = 'Microsoft.Quantum.IQSharp --version (?<oldVersion>[0-9|\.]+)'
$ps1Files = (Select-String -Path "..\scripts\install-iqsharp.ps1" -pattern "Microsoft.Quantum.IQSharp" | Select-Object -Unique Path)
Get-Content $ps1Files.Path | ForEach-Object {
         $isQuantumPackage = $_ -match $ps1String
         if ($isQuantumPackage) {
             $_ -replace $Matches.oldVersion, $Version
         } else {
             $_
         }
    } | Set-Content $ps1Files.Path


