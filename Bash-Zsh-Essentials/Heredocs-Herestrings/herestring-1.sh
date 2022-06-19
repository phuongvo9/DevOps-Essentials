#!/usr/bin/env bash

# One string from echo
echo "hello world, my name is $USER" | tr [a-z] [A-Z]

# Using <<< to provide a string
tr [a-z] [A-Z] <<< "hello world, my name is $USER"

TIP="BASH SHELL SCRIPTING"
tr [a-z] [A-Z] <<< $TIP

