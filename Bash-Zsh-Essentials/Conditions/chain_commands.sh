#!/usr/bin/env bash

# Command chaining operators: ; && ||
# cmd1 ; cmd2 -- cmd2 run whether cmd1 success or not
# cmd1 && cmd2 -- cmd2 only run after cmd1's success
# cmd1 || cmd2 -- cmd2 only run if cmd1's failed

echo "Hello" ; echo "We did say hello"
which apache2 && apache2 -v

which docker && echo "docker is installed" || echo "docker is not installed"


# ---

# cmd1 | { cmd2 ; cmd3 ; }if cmd1 's success, execute block of code in { }