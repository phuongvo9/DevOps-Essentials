#!/usr/env/bin bash

#Accessing All Array Elements Using Iterator Filter/Array Filter:    jq “.[ ]” filename
cat array1.json | jq .tools
[
  "jenkins",
  "bamboo",
  "stackstorm",
  "git",
  "maven"
]

cat array1.json | jq .tools[]
"jenkins"
"bamboo"
"stackstorm"
"git"
"maven"
#Accessing Required Array Item:  jq ‘.[indexOfTheItem]’ fileName
cat array1.json | jq .tools[2]
"stackstorm"



# Slicing - get sub-array in original array
    # jq ‘.[startIndex:endIndex]’ filename
    # jq  ‘.[:endIndex]’ filename
    # Jq. ‘[startIndex:]’ fileName
cat array1.json | jq .tools[:2]
[
  "jenkins",
  "bamboo"
]
