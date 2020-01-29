# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$ErrorActionPreference = 'Stop'

& "$PSScriptRoot/set-env.ps1"

& "$PSScriptRoot/validate-unicode.ps1"

# Validating all katas projects can be disables with the ENABLE_KATAS 
if ($Env:ENABLE_KATAS -ne "false") {
  & "$PSScriptRoot/validate-notebooks.ps1"
} else {
  Write-Host "##vso[task.logissue type=warning;]Skipping testing Katas notebooks. Env:ENABLE_KATAS is '$Env:ENABLE_KATAS'."
}
