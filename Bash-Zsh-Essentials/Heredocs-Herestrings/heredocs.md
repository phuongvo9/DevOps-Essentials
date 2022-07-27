# Introduction to heredocs

## DELIMITER with " "
First init
```
#!/bin/bash
echo "
The user is: $USER
The home for this $USER is: $HOME
"
```

## DELIMITER with EOF
````
#!/bin/bash
cat << EOF
The user is: $USER
The home for this $USER is: $HOME
EOF
````

## DELIMITER with any
````
#!/usr/bin/env bash
cat << PHUONGVO
This repos is initialized by $USER from $HOME
PHUONGVO
````