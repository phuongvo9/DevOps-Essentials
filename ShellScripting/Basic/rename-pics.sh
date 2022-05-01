#!/bin/bash

# rename files with jpg in the ends to today-$filename.jpg
PICTURES=$(ls *jpg)
DATE=$(date +%F)

for PICTURE in $PICTURES; do
    echo "Renaming ${PICTURE} to ${DATE}-${PICTURE}"
    mv ${PICTURE} ${DATE}-${PICTURE}
done