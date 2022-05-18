#!/bin/bash

# cover to lower case
declare -l DIR
echo -n "Enter a directory to create: "
read DIR
if [[ -e $DIR ]]; then
    echo "$DIR already exists"
    exit 1
else
    if [[ -w $PWD ]]; then
        mkdir $DIR
        echo "Successfully created the directory $DIR"
    else
        echo "You don't have the permisison to write in $PWD"
    fi
fi
exit 