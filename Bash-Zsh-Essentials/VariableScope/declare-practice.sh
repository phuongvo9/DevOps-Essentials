#!/bin/bash

declare -i days
read days

if (( days < 1 || days > 30)); then
    echo "Please enter correct value"
fi
