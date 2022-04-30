#!/bin/bash

#echo hello && echo goodbye

#echo hello || echo goodbye
echo "Please enter a day in a month: "
declare -i days
read days

if [ $days -lt 1 ] && [ $days -gt 31 ]; then
    echo "Please enter correct value"
else echo "Your value is acceptable"
fi

declare -p days

echo "Please enter a day in a week: "
declare -i dayweek
read dayweek
if ((dayweek > 7 || dayweek < 2)); then
    echo "Please enter the correct day in  a week!"
    exit 1
else echo "Yes, today is $dayweek"
fi

