#!/bin/bash

$container="$1"
$directory="$2"

if [[ ! $1 ]]; then
    echo "Error: missing argument - container name"
    exit 1
fi