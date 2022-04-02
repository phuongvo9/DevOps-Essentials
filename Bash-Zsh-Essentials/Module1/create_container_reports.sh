#!/bin/bash/

# Create a report file for a single shipping container
directory=reports
mkdir -p $directory

grep $1 shipments.csv > $directory/$1.csv

echo Report created.

echo Wrote report $directory/$1.csv