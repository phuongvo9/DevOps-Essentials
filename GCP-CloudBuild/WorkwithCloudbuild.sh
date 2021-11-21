nano quickstart.sh

#!/bin/sh
echo "Hello, world! The time is $(date)."

    nano Dockerfile
    FROM alpine
    COPY quickstart.sh /
    CMD ["/quickstart.sh"]



