#!/bin/bash

# Using Arithmetic evaluation with (( )) instead of test  [ ]

echo "Please enter a day in a month: "
declare -i days
read days
# Arithmetic evaluation
if (( days < 1 || days > 30)); then
    echo "Please enter correct value"
else echo "Your value is acceptable"
fi

declare -p days