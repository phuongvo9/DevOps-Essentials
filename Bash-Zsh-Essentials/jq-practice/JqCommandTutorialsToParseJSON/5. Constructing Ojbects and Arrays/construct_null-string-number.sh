#!/usr/env/bin bash

# jq -n Don't read any input at all! Instead, the filter is run once using null as the input. This is useful when using jq as a simple calculator or to construct JSON data from scratch
# jq  -n ‘’     --> null
jq -n ''
null

# jq  ‘null’ inputFile --> null
#jq 'null' <<< "{\"myKey\":\"myValue\"}"
null

jq -n "{jq}"
{
  "jq": null
}


# jq  -n ’4’   --> number
# jq  -n ‘”jq”’  --> string
# jq   ‘filter/function’ inputFile --> string 
# jq  -n ‘true/false’ -->  boolean
