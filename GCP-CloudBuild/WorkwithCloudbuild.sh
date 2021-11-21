nano quickstart.sh

#!/bin/sh
echo "Hello, world! The time is $(date)."

    nano Dockerfile
    FROM alpine
    COPY quickstart.sh /
    CMD ["/quickstart.sh"]



chmod +x quickstart.sh

# build the Docker container image in Cloud Build.

gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/quickstart-image .


### Building Containers with a build configuration file and Cloud Build

