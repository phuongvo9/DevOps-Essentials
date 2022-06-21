#!/usr/bin/env bash

# Command chaining operators: ; && ||
# cmd1 ; cmd2 -- cmd2 run whether cmd1 success or not
# cmd1 && cmd2 -- cmd2 only run after cmd1's success
# cmd1 || cmd2 -- cmd1's success or cmd'2 success?


which apache2 && apache2 -v