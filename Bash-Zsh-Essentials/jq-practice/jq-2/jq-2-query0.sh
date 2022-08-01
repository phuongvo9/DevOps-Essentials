cat openlib.json | jq .docs[] | jq {title}
# output?

cat openlib.json | jq .docs[] | jq .title
#output?

cat openlib.json | jq ".docs[] | {title, author_name, publish_year}"
cat openlib.json | jq ".docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]}"

# select function
cat openlib.json | jq ".docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]} \
                        | select ( .publish_year != null and .author_name != null)"

# sort_by function
cat openlib.json | jq ".docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]} \
    | select ( .publish_year != null and .author_name != null) | sort_by (.publish_year)"
    ## Output: Error - Cannot index string with string "publish_year" - sort_by accepts ARRAY
# sort_by function - Fixed with array
cat openlib.json | jq "[.docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]} \
    | select ( .publish_year != null and .author_name != null) ] | sort_by (.publish_year)"
# sort_by function - Desending order
cat openlib.json | jq "[.docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]} \
    | select ( .publish_year != null and .author_name != null) ] | sort_by (.publish_year) | reverse"

# Get Length
cat openlib.json | jq "[.docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]} \
    | select ( .publish_year != null and .author_name != null) ] | sort_by (.publish_year) | reverse | length"
# limit with expression
cat openlib.json | jq "[.docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]} \
    | select ( .publish_year != null and .author_name != null) ] | sort_by (.publish_year) | reverse | limit(3;.[])"

# transform (limit funtion return array)
cat openlib.json | jq "[.docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]} \
    | select ( .publish_year != null and .author_name != null) ] | sort_by (.publish_year) | reverse | [limit(3;.[])]"