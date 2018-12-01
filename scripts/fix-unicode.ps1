$files = Select-String -Path "**\*.qs" -pattern "[〉〈]" | Select-Object -Unique Path

$files | ForEach-Object {
    # Get-Content by default reads file in UTF8 encoding
    $Content = (Get-Content -Encoding UTF8 $_.Path) | ForEach-Object { $_ -Replace "〉", "⟩" } | ForEach-Object { $_ -replace "〈", "⟨" }
    # Make sure the file is written without BOM
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($_.Path, $Content, $Utf8NoBomEncoding)
}
