#!/bin/bash
<<EOF
cat ernst.json | jq '.'
cat ernst.json | jq '.[]'
cat ernst.json | jq '.[1]'
EOF

# cat joni-ernst.json | jq '.id'
## get netsed object
#cat joni-ernst.json | jq '.id.lis'
#cat joni-ernst.json | jq '.terms'

# Accessing array item
cat joni-ernst.json | jq '.terms[].url'

cat joni-ernst.json | jq '.terms[] .url'