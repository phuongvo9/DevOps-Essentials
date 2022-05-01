#!/bin/bash

echo "Check if the passwd file exists"
sleep 2
echo "Checking"
sleep 2
echo -n ". "
sleep 2
echo -n ". ."
sleep 2
echo -n ". . ."
sleep 2
if [ -e /etc/passwd ]; then
    echo "The passwd file exists on this system"
    return 0
else
    echo "The passwd file does not exist on this system"
    return 1
fi 
echo "See you later!"
