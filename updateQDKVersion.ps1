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

function changeVersion
{
    Param(
        [parameter(position=0)]$file, 
        [parameter(position=1)]$old_ver, 
        [parameter(position=2)]$new_ver)
    
    Write-Output "The current version of the $file is $old_ver"
    (Get-Content $file) -replace $old_ver, $new_ver | Set-Content $file -Encoding "windows-1251"
  
}

$i = 0
$csproj_string = 'Include="{0}" Version=' -f $pkgs[$i]
$csFiles = (Get-ChildItem -recurse -include "*.csproj")
foreach ($csfile in $csFiles)
{
    $cs_sentence = (Get-ChildItem -recurse | Select-String -pattern $csproj_string -Context 0).Line
    $cs_ver = (($cs_sentence -split 'Version=')[1] | %{$_.split('"')[1]})
    changeVersion "$csfile" "$cs_ver" "$ver"
}


$ipynb_string = "%package Microsoft.Quantum.Katas::"
$ipynbFiles = (Get-ChildItem -recurse -include "*.ipynb")
foreach ($ipynbfile in $ipynbFiles)
{
    $ipynb_sentence = ($ipynbfile | Select-String -pattern $ipynb_string -Context 0).Line
    if ($ipynb_sentence)
    {    
    $ipynb_ver = (($ipynb_sentence -split '::')[1].Split('"')[0])
    changeVersion "$ipynbfile" "$ipynb_ver" "$ver" 
    }
}


$docker_string = 'FROM mcr.microsoft.com/quantum/iqsharp-base:'
$dockerFiles = (Get-ChildItem -recurse -include "Dockerfile")
$dockerSentence = ($dockerfiles | Select-String -pattern $docker_string -Context 0).Line
$dockerOld = (($dockerSentence -split '/iqsharp-base:')[1].Split('"')[0])
changeVersion "$dockerFiles" "$dockerOld" "$ver"

$ps1_string = 'Microsoft.Quantum.IQSharp --version'
$ps1Files = Get-ChildItem -recurse -include "*install-iqsharp.ps1"
$ps1Sentence = ($ps1Files | Select-String -pattern $ps1_string -Context 0).Line
$ps1Old = (($ps1Sentence -split "--version ")[1].Split(' --tool-path')[0].Split('"')[0])
changeVersion "$ps1Files" "$ps1Old" "$ver"


