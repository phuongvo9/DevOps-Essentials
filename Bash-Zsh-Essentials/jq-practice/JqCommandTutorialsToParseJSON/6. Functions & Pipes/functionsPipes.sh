#!/bin/bash
MYJSON="/home/phuongvo/DevOps-Essentials/Bash-Zsh-Essentials/jq-practice/JqCommandTutorialsToParseJSON/4. Working With Arrays/array1.json"
ls "${MYJSON}"
jq . "${MYJSON}"
<<MYJSON
{
  "technology": "devops",
  "tools": [
     "jenkins",
     "bamboo",
     "stackstorm",
     "git",
     "maven"
 ]
}
MYJSON

# keys        To get keys for a json object
jq . "${MYJSON}" | jq 'keys'
[
  "technology",
  "tools"
]


# length     To find the number of keys for an object or length of an array
jq . "${MYJSON}" | jq length
2

# min/max  To find min or max value from an array 
jq . "${MYJSON}" | jq .[] 
[
  "technology",
  "tools"
]

jq . "${MYJSON}" | jq .[] | jq length
6
5
# reverse     it reverse an array
# sort           To sort the values in an array
# unique      It removes duplicate values from an array and data is sorted
# del            It deletes key value pair from json object 
# Note: only in output not in input json
