# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

Write-Host "Validating unicode characters in Q# files"

# Find all lines with bad bra or ket characters
$lines = Select-String -Path "**\*.qs" -Pattern "[〉〈]"
$lines

# If there are any, print them and exit with an error
if ($lines.Count -gt 0) {
    Write-Host "$("##vso[task.logissue type=error;]")Please use U+27E9 for ket symbol and U+27E8 for bra symbol"
    Write-Host "$("##vso[task.logissue type=warning;]")You can use script /scripts/fix-unicode.ps1 to perform the replacement automatically"
    exit 1
}
