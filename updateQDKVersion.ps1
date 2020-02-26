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

function changeVersion($keywords, $splitstring, $file, $ver)
{
    write-output $keywords, $splitstring, $file.PSPath, $ver
    write-output $file.PSPath
    $sentence = ($file | Select-String -pattern $keywords -Context 0).Line
    write-output $splitstring
    $old_ver = (($sentence -split $splitstring)[1].Split('"')[0])
    write-output ($sentence -split $splitstring)[1]
    (Get-Content $file.PSPath).Replace($old_ver, $ver) | Set-Content $file.PSPath
  
}

$i = 0
$csproj_string = 'Include="{0}" Version=' -f $pkgs[$i]

$csFiles = (Get-ChildItem -recurse -include "*.csproj")
foreach ($csfile in $csFiles)
{
    changeVersion($csproj_string,'Version=',$csfile,$ver)
}

<#
#foreach ($file in $csFiles)
{
    $sentence = (Get-ChildItem -recurse | Select-String -pattern $csproj_string -Context 0).Line
    $old_ver = (($sentence -split 'Version=')[1] | %{$_.split('"')[1]})
    #Write-Output "The current version of $file is $old_ver"
    (Get-Content $file.PSPath) |
    Foreach-Object { $_ -replace $old_ver, $ver } |
    Set-Content $file.PSPath
}
#>

$ipynb_string = "%package Microsoft.Quantum.Katas::"
$ipynbFiles = (Get-ChildItem -recurse -include "*.ipynb")
foreach ($ipynbfile in $ipynbFiles)
{
    changeVersion($ipynb_string, "::", $ipynbfile, $ver)
}

<#
$ipynb_string = "%package Microsoft.Quantum.Katas::"
$ipynbFiles = (Get-ChildItem -recurse -include "*.ipynb")
foreach ($file in $ipynbFiles)
{
    write-output "Changing $file with $ipynb_string string"
    $sentence = ($file | Select-String -pattern $ipynb_string -Context 0).Line
    $old_ver = (($sentence -split '::')[1].Split('"')[0])
    Write-Output "The current version of the $file is $old_ver"
    (Get-Content $file.PSPath) |
    Foreach-Object { $_ -replace $old_ver, $ver } |
    Set-Content $file.PSPath
}
#>

$docker_string = 'FROM mcr.microsoft.com/quantum/iqsharp-base:'
$dockerFiles = (Get-ChildItem -recurse -include "Dockerfile")
changeVersion($docker_string,"/iqsharp-base:",$dockerFiles, $ver)

$dockerSentence = ($dockerfiles | Select-String -pattern $docker_string -Context 0).Line
$dockerOld = (($dockerSentence -split '/iqsharp-base:')[1].Split('"')[0])

(Get-Content $DockerFiles.PSPath) |
    Foreach-Object { $_ -replace $dockerOld , $ver } |
    Set-Content $DockerFiles.PSPath

$ps1_string = 'Microsoft.Quantum.IQSharp --version'
$ps1Files = (Get-ChildItem -recurse -include "install-iqsharp.ps1")
changeVersion($ps1_string, '--version ', $ps1Files, $ver)

<#
#for .csproj files - "<PackageReference Include="Microsoft.Quantum.???" Version="___" />"
#for .ipynb files - "%package Microsoft.Quantum.???::___"
#for Dockerfile - "FROM mcr.microsoft.com/quantum/iqsharp-base:___"
#for install-iqsharp.ps1 - dotnet tool install Microsoft.Quantum.IQSharp --version ___ --tool-path $Env:TOOLS_DIR

$configFiles = (Get-ChildItem -recurse -include "*.csproj", "*.ipynb", "install-iqsharp.ps1","Dockerfile")
foreach ($file in $configFiles)
{
    #Write-Output "The current version of this file is $old_ver"
    (Get-Content $file.PSPath) |
    Foreach-Object { $_ -replace $csproj_old, $ver } |
    Set-Content $file.PSPath
}

#>


