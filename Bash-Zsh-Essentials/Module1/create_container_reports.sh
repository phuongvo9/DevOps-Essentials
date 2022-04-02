#!/bin/bash/

# Create a report file for a single shipping container
mkdir -p reports
grep H9 shipments.csv > reports/H9.csv

echo Report created.