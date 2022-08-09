#!/usr/bin/env bash
curl 'https://api.github.com/repos/stedolan/jq/commits?per_page=5' > commit.json
cat commit.json | jq '.'