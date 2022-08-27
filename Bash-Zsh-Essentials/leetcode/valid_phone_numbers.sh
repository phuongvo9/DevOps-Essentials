#!/usr/bin/env bash
# https://leetcode.com/problems/valid-phone-numbers/
while read line; do
    if [[ "${line}" =~ ^((\([0-9]{3}\) )|[0-9]{3}-)[0-9]{3}-[0-9]{4}$ ]]; then
        echo $line
    fi
done < "file.txt"

