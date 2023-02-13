#!/usr/bin/env bash
# https://stedolan.github.io/jq/tutorial/


curl 'https://api.github.com/repos/stedolan/jq/commits?per_page=5' > commit.json
cat commit.json | jq '.'


# get first item
cat commit.json | jq '.[0]'
# commit name and message in first item
cat commit.json | jq '.[0] | {commit_name: .commit.author.name, commit_message: .commit.message}'

# commit name and message in all items (iterate)
cat commit.json | jq '.[] | {commit_name: .commit.author.name, commit_message: .commit.message}'

# Wrap []: [commit name and message in all items (iterate)]
cat commit.json | jq '[.[] | {commit_name: .commit.author.name, commit_message: .commit.message}]'

# Wrap []: [commit name and message + parents[] in all items (iterate)]
cat commit.json | jq '[.[] | {commit_name: .commit.author.name, commit_message: .commit.message, parents: [.parents[].html_url]}]'

# Filter field with comma and raw
cat commit.json | jq ".[0].sha,.[1].sha"
cat commit.json | jq -r ".[0].sha,.[1].sha"