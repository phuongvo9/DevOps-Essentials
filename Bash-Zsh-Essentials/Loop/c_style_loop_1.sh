#!/usr/bin/env bash

count=1
for each_file in $(ls *.sh)
do
    echo "$each_file"
    if [[ $count -eq 5 ]]; then
        echo "stop"
        break
    fi
    ((count++))
done

echo "Done looping"