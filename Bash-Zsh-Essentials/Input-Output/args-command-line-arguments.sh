#!/usr/bin/bash

<< MYCOMMENT
  echo "$0 - the script name itself"
  echo "$1"
  echo "$2"
  echo "$3"
  echo "${10} - please use ${} from args 10th or above"
MYCOMMENT

echo "The number of arguments that are passed: $#"
echo "All command line arguments are: $*"
echo "All command line arguments are: $@"
