# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$ErrorActionPreference = 'Stop'


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

& "$PSScriptRoot/set-env.ps1"

# Validating all katas projects can be disables with the ENABLE_KATAS flag:
if ($Env:ENABLE_KATAS -ne "false") {
  & "$PSScriptRoot/validate-unicode.ps1"

  Get-ChildItem (Join-Path $PSScriptRoot '..') -Recurse -Include '*.sln' -Exclude 'Microsoft.Quantum.Katas.sln' `
  | ForEach-Object { Build-One $_.FullName }

  & "$PSScriptRoot/validate-notebooks.ps1"
} else {
  Write-Host "##vso[task.logissue type=warning;]Skipping Katas validation. Env:ENABLE_KATAS is '$Env:ENABLE_KATAS'."
}
