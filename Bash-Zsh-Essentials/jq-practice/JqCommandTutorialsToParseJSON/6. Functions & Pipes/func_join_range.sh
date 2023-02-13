#!/usr/bin/env bash
<<RANGE_DEF
The range function produces a range of numbers. range(4;10) produces 6 numbers, from 4 (inclusive) to 10 (exclusive).
The numbers are produced as separate outputs. Use [range(4;10)] to get a range as an array.
RANGE_DEF
jq 'range(2;4)'
#OUTPUT:
    #2
    #3
jq '[range(2;5)]'
#OUTPUT: [2,3,4]

jq '[range(0;10;3)]'
#OUTPUT: [0,3,6,9]
