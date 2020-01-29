# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$ErrorActionPreference = 'Stop'

& "$PSScriptRoot/set-env.ps1"

& "$PSScriptRoot/validate-unicode.ps1"

& "$PSScriptRoot/validate-notebooks.ps1"
