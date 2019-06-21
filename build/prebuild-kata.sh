# prebuild-kata.sh <kata-folder> <kata-notebook>
KATA_FOLDER=$1
KATA_NOTEBOOK=${2:-$1.ipynb}

dotnet build $1
jupyter nbconvert $1/$2 --execute --stdout --to markdown  --allow-errors  --ExecutePreprocessor.timeout=120
