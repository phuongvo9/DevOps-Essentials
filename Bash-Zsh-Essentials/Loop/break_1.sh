#!/usr/bin/env bash
# Breaking a loop

for i in 1 2 3 4 5 6 7 8 9 10
do
 if [ $i -eq 9 ]; then
    echo "Yes, break from here"
    break
 fi
    echo "This is for number: $i"
done