#!/bin/bash/

# Create a report file for a single shipping container

if [[ ! $1 ]]; then
    echo "Error: missing parameter: container name"
    exit 1
else
    container="$1"
fi

if [[ ! $2 ]]; then
    echo "Set ${HOME} as the default directory to generate reports"
    directory="$HOME"
else
    directory="$2"
fi
## Set $HOME as default if there is no directory
##
mkdir -p $directory
if grep -- "$container" "$input_file"> "$directory/${container}_reports.csv"; then
    echo Report created.
    echo Wrote report $directory/$1.csv
    exit 0
else
    echo There was a error happened!
    exit 1
fi

