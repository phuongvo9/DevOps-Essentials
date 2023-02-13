#!/bin/bash
# shell array
files=("f1.txt" "f2.txt" "f3.txt" "f4.txt" "f5.txt")
echo ${files[2]} # access 3rd item
echo ${files[*]} # access all items
echo ${#files[@]} # '#' size of array - length
files+=("f6.txt") # add new item to existing array
unset files[3] # remove 4th item
unset files # remove all array