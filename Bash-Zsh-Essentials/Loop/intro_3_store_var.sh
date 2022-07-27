#!/usr/bin/env bash
COLORS="red green yellow blue purple white black"

for COLOR in $COLORS
do
    echo "I like $COLOR"
done

<<OUTPUT
$ ./intro_3_store_var.sh 
I like red
I like green 
I like yellow
I like blue  
I like purple
I like white
I like black
OUTPUT