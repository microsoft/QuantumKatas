# List of Notebooks that can't be validated for various reasons:
#  * Check.ipynb is a validation artifact and not an actual kata notebook.
#  * ComplexArithmetic and LinearAlgebra have tasks with deliberately invalid Python code.
$not_ready = 
@(
    'Check.ipynb',
    'ComplexArithmetic.ipynb',
    'LinearAlgebra.ipynb'
)

# Get the list of all notebooks in the folder from which the script was executed
$AllItems = Get-ChildItem (Join-Path $PSScriptRoot '..') `
    -Recurse `
    -Include '*.ipynb' `
    -Exclude $not_ready `
    | Sort-Object Name

echo "Number of nb : "
echo $AllItems.Length