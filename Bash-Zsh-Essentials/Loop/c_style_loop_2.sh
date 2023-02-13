#!/usr/bin/env bash

# Breaking out from an inner loop
for (( a = 0; a < 5; a++ ))
do
    echo "Outer loop a: $a"
    for (( b=1; b < 100; b++ ))
    do
        echo "Inner loop b: $b"
        if [[ $b -eq 5 ]]; then
            echo "Break the inner loop meets condition"
            break
        fi
    done
done