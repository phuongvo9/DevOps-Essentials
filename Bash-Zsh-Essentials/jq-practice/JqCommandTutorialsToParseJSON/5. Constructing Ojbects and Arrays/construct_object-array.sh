#!/bin/bash

# jq  ‘{}’ <<< ‘{}’
jq .tools[:2] <<< $(cat array1.json)
[
  "jenkins",
  "bamboo"
]

# jq  ‘{}’ filename
jq {}  <<< $(cat array1.json)
{

}
# jq ‘{“myKey”: “myValue” }’ <<< ‘{}’
jq "{\"myKey\": \"myValue\" }" <<< "{\"yourkey\": \"yourValue\"}"
{
  "myKey": "myValue"
}

# jq  ‘{“myKey”: “myValue” }’ filename
# jq  ‘{“myKey” : .key }’ filename

# jq  ‘[ ]’ filename
# jq  ’[ 2,3,4, “value4”]’ filename
# jq  ‘[ .key ]’ fileName
