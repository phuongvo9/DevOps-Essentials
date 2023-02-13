#!/usr/bin/env bash
# https://leetcode.com/problems/valid-phone-numbers/
while read line; do
    if [[ "${line}" =~ ^((\([0-9]{3}\) )|[0-9]{3}-)[0-9]{3}-[0-9]{4}$ ]]; then
        echo $line
    fi
done < "file.txt"


#my code
# Read from the file file.txt and output all valid phone numbers to stdout.

# while read line; do
#     if [[ "${line}" =~ ^(\([0-9]{3}\)|[0-9]{3})-[0-9]{3}-[0-9]{4}$ ]]; then
#         echo "${line}"
#     fi
# done < "file.txt"


^(\([0-9]{3}\) )|[0-9]{3}-[0-9]{3}-[0-9]{4}$
^(\([0-9]{3}\)|[0-9]{3})-[0-9]{3}-[0-9]{4}$
^(\([0-9]{3}\)|[0-9]{3})