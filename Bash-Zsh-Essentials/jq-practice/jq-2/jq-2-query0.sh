cat openlib.json | jq .docs[] | jq {title}
# output?

cat openlib.json | jq .docs[] | jq .title
#output?

cat openlib.json | jq ".docs[] | {title, author_name, publish_year}"
cat openlib.json | jq ".docs[] | {title, author_name: .author_name[0], publish_year: .publish_year[0]}"
