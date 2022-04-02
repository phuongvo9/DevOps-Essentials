#!/bin/bash/

# Create a report file for a single shipping container
directory=reports
mkdir -p $directory

grep H9 shipments.csv > $directory/H9.csv

echo Report created.