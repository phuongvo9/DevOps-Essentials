#!/bin/bash

cat ernst.json | jq '.'
cat ernst.json | jq '.[]'
cat ernst.json | jq '.[1]'