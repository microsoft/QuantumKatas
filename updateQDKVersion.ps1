$ver = $args[0]
Write-Host $ver

$csString = 'PackageReference Include=\"Microsoft\.Quantum\.[a-zA-Z\.]+\" Version=\"(?<oldVersion>[0-9|\.]+)\"'
$csFiles = (Select-String -Path "**\*.csproj" -pattern "Microsoft.Quantum" | Select-Object -Unique Path)
$csFiles | ForEach-Object {
    (Get-Content -Encoding UTF8 $_.Path) | ForEach-Object {
         $isQuantumPackage = $_ -match $csString
         if ($isQuantumPackage) {
             $_ -replace $Matches.oldVersion, $ver
         } else {
             $_
         }
    } | Set-Content -Encoding UTF8 $_.Path
}

$ipynb_string = '%package Microsoft.Quantum.Katas::(?<oldVersion>[0-9|\.]+)'
$ipynbFiles =  (Select-String -Path "**\*.ipynb" -pattern "Microsoft.Quantum" | Select-Object -Unique Path)

$ipynbFiles | ForEach-Object {
    if ($_)
    {
        (Get-Content -Encoding UTF8 $_.Path) | ForEach-Object {
            $isQuantumPackage = $_ -match $ipynb_string
            if ($isQuantumPackage) {
                $_ -replace $Matches.oldVersion, $ver
            } else {
                $_
            }
        } | Set-Content $_.Path
    }
}

$docker_string = 'FROM mcr.microsoft.com/quantum/iqsharp-base:(?<oldVersion>[0-9|\.]+)'
$dockerFiles =  (Select-String -Path "Dockerfile" -pattern "microsoft.com/quantum" | Select-Object -Unique Path)
$dockerFiles | ForEach-Object {
    (Get-Content -Encoding UTF8 $_.Path) | ForEach-Object {
         $isQuantumPackage = $_ -match $docker_string
         if ($isQuantumPackage) {
             $_ -replace $Matches.oldVersion, $ver
         } else {
             $_
         }
    } | Set-Content $_.Path
}

$ps1_string = 'Microsoft.Quantum.IQSharp --version (?<oldVersion>[0-9|\.]+)'
$ps1Files = (Select-String -Path "**\install-iqsharp.ps1" -pattern "Microsoft.Quantum.IQSharp" | Select-Object -Unique Path)
$ps1Files | ForEach-Object {
    
    (Get-Content -Encoding UTF8 $_.Path) | ForEach-Object {
         $isQuantumPackage = $_ -match $ps1_string
         if ($isQuantumPackage) {
             $_ -replace $Matches.oldVersion, $ver
         } else {
             $_
         }
    } | Set-Content $_.Path
}


