#!/bin/bash
# First file accessed

IFS='/' read -r -a working_directory <<< "$PWD"
user="${working_directory[2]}"
cd "/home/$user/project" || exit

# installing requirements
pip3 install -r requirements.txt
if [[ -f optional.txt ]]
then
    pip3 install torch==1.11.0
    pip3 install torch-scatter==2.0.9
    pip3 install -r optional.txt
fi

# moving to the docs folder
cd "docs" || exit

# syncing current folder with the container's result folder to get results in this folder
rsync -rav /home/"$user"/global_docs/* .

# generate the documentation
./_make_docs.sh "$@"

# delete the code
./remove_files.sh

rm -rf remove_files.sh