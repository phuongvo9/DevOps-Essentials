#!/bin/bash
# Test connection to IP and Port

PORT=1521

for SERVER in $( cat ./servers.txt )
do
    </dev/tcp/$SERVER/$PORT
    if [ "$?" -ne 0 ]; then
        echo "Connection to $SERVER on port $PORT failed" >> test-logs.txt
        echo "$SERVER:$PORT" >> failure.csv
    else
        echo "Connection to $SERVER on port $PORT succeeded" >> test-logs.txt
        echo "$SERVER:$PORT" >> success.csv
    fi
done
echo "Finished testing"
exit 0