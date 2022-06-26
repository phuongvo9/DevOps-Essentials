#!/usr/bin/env bash

<<REQUIRE
prompts the user for a name of a file or directory and reports if it is a regular file,
a directory, or another type of file.
Also perform an ls command again
REQUIRE

read -p "Enter a name of file/directory: " NAME
if [[ ! -e $NAME ]]; then
  echo "ERROR: The $NAME does not exists"
  exit 1
fi

if [[ -f $NAME ]]; then
  echo "The $NAME is a regular file"
elif [[ -d $NAME ]]; then
  echo "The $NAME is a directory"
else
  echo "The $NAME is a not a regular file nor a directory"
fi

exit 0

<<OUTPUT
$ ./ex6_prompt_type.sh
Enter a name of file/directory: intro_1.sh
The type of the input is
The intro_1.sh is a regular file

---
/Loop (main)
$ ./ex6_prompt_type.sh
Enter a name of file/directory: intr_2_loop_dir.sh
The intr_2_loop_dir.sh is a not a regular file nor a directory
OUTPUT