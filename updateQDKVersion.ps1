$ver = $args[0]
Write-Host $ver
try
{
    git | Out-Null
   Write-Host "Git is installed"
   git submodule update --init
}
catch [System.Management.Automation.CommandNotFoundException]
{
    Write-Host "No git"
}

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
$full_string = 'Include="{0}" Version=' -f $pkgs[$i]
Write-Host  $full_string
$file = (Get-ChildItem -recurse -Name -include "BasicGates/*.csproj")
Write-Host $file
$sentence = (Get-ChildItem -recurse | Select-String -pattern $full_string -Context 0).Line
Write-Host (($sentence -split 'Version=')[1] | %{$_.split('"')[1]})
$old_version = (($sentence -split 'Version=')[1] | %{$_.split('"')[1]})
Write-Host  "Changing Version from $old_version to $ver"

$configFiles = (Get-ChildItem -recurse -include "*.csproj", "*.ipynb", "install-iqsharp.ps1","Dockerfile")
foreach ($file in $configFiles)
{
    (Get-Content $file.PSPath) |
    Foreach-Object { $_ -replace $old_version, $ver } |
    Set-Content $file.PSPath
}



