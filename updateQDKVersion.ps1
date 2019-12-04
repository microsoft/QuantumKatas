$ver = $args[0]
Write-Host $ver

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



