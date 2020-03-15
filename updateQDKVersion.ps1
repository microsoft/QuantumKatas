$ver = $args[0]
Write-Host $ver

<<<<<<< HEAD
$pkgs=@(
"Microsoft.Quantum.Standard",
"Microsoft.Quantum.Development.Kit",
"Microsoft.Quantum.Xunit",
"Microsoft.Quantum.Katas",
"Microsoft.Quantum.IQSharp",
"Microsoft.Quantum.Development.Kit", 
"Microsoft.Quantum.Chemistry",
"Microsoft.Quantum.Chemistry.Jupyter",
"Microsoft.Quantum.Compiler",
"Microsoft.Quantum.IQSharp.Core",
"Microsoft.Quantum.Numerics",
"Microsoft.Quantum.Research",
"Microsoft.Quantum.CsharpGeneration",
"Microsoft.Quantum.Simulators")

#Look at the first package and find its version
$i = 0
$csproj_string = 'Include="{0}" Version=' -f $pkgs[$i]
Write-Host $csproj_string
$file = (Get-ChildItem -recurse -Name -include "BasicGates/*.csproj")
Write-Host $file
$sentence = (Get-ChildItem -recurse | Select-String -pattern $csproj_string -Context 0).Line
Write-Host (($sentence -split 'Version=')[1] | %{$_.split('"')[1]})
$csproj_old = (($sentence -split 'Version=')[1] | %{$_.split('"')[1]})
Write-Host  "Changing Version from $csproj_old to $ver"

for .csproj files - <PackageReference Include="Microsoft.Quantum.???" Version="___" />
for .ipynb files - "%package Microsoft.Quantum.???::___"
for Dockerfile - FROM mcr.microsoft.com/quantum/iqsharp-base:___
for install-iqsharp.ps1 - dotnet tool install Microsoft.Quantum.IQSharp --version ___ --tool-path $Env:TOOLS_DIR

$configFiles = (Get-ChildItem -recurse -include "*.csproj", "*.ipynb", "install-iqsharp.ps1","Dockerfile")
foreach ($file in $configFiles)
{
    (Get-Content $file.PSPath) |
    Foreach-Object { $_ -replace $csproj_old, $ver } |
    Set-Content $file.PSPath
}

=======
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
>>>>>>> 5eebcc6449f8ace237188da6c2f8c2272489c2ff


