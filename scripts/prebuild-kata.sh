# prebuild-kata.sh <kata-folder> <kata-notebook>
KATA_FOLDER=$1
KATA_NOTEBOOK=${2:-$1.ipynb}

echo "Prebuilding: $KATA_NOTEBOOK in $KATA_FOLDER kata..."

count=`ls -1 *.csproj 2>/dev/null | wc -l`
if [ $count != 0 ]
then 
dotnet build $KATA_FOLDER
fi

jupyter nbconvert $KATA_FOLDER/$KATA_NOTEBOOK --execute --to markdown  --allow-errors  --ExecutePreprocessor.timeout=120
