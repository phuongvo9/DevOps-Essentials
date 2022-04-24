#!/bin/bash

# cover to lower case
declare -l DIR
echo -n "Enter a directory to create: "
read DIR
if [[ -e $DIR ]]; then
    echo "$DIR already exists"
    exit 1
fi