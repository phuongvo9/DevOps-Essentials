#!/bin/bash



if [[ ! $1 ]]; then
    echo "Error: missing argument - container name"
    exit 1
fi

if [[ ! $2 ]]; then
    echo "Error: missing argument - directory"
    exit 1
fi

$container="$1"
$directory="$2"

mkdir -p $directory
grep -- "$container" ./shipments.csv > "$directory/${container}_reports.csv"
echo report created
exit 0
