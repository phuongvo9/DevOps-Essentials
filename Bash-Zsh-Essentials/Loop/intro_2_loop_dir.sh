#!/usr/bin/env bash
SOURCE_DIR="./../Conditions"
for file in $(ls $SOURCE_DIR)
do
  echo $file
  echo "------------"
done


<<OUTPUT
$ ./intro_2_loop_dir.sh
chain_commands.sh
------------
condition-0.sh
------------
condition-1.sh
------------
dir.sh
------------
season.sh
------------
OUTPUT