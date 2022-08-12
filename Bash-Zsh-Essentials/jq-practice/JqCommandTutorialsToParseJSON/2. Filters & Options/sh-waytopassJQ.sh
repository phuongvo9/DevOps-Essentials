#!/bin/bash

# Pass string
jq . <<<  '{\"name\": \"jqCommand\"}'
jq . <<< "$(echo '{"name": "jqCommand"}')"
echo '{"name": "jqCommand"}' | jq .

# Pass file
cat demo.json | jq .
jq . <<< "$(cat demo.json)"
jq . demo.json

# Passing REST API Response
curl -sX GET https://gorest.co.in/public/v2/users | jq .
jq . <<< "$(curl -sX GET https://gorest.co.in/public/v2/users)"



