nano quickstart.sh

    #!/bin/sh
    echo "Hello, world! The time is $(date)."

nano Dockerfile
    nano Dockerfile
    FROM alpine
    COPY quickstart.sh /
    CMD ["/quickstart.sh"]



chmod +x quickstart.sh

# build the Docker container image in Cloud Build.

gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/quickstart-image .


### Building Containers with a build configuration file and Cloud Build

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

# Create a soft link as a shortcut to the working directory
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/Cloud_Build/a

cat cloudbuild.yaml

# steps:
# - name: 'gcr.io/cloud-builders/docker'
#   args: [ 'build', '-t', 'gcr.io/$PROJECT_ID/quickstart-image', '.' ]
# images:
# - 'gcr.io/$PROJECT_ID/quickstart-image'

# tag it with gcr.io/$PROJECT_ID/quickstart-image

#start a Cloud Build using cloudbuild.yaml as the build configuration file
gcloud builds submit --config cloudbuild.yaml .



### Building and Testing Containers with a build configuration file and Cloud Build


cd ~/ak8s/Cloud_Build/b

cat cloudbuild.yaml

    steps:
    - name: 'gcr.io/cloud-builders/docker'
    args: [ 'build', '-t', 'gcr.io/$PROJECT_ID/quickstart-image', '.' ]
    - name: 'gcr.io/$PROJECT_ID/quickstart-image'
    args: ['fail']
    images:
    - 'gcr.io/$PROJECT_ID/quickstart-image'

# start a Cloud Build using cloudbuild.yaml as the build configuration file

echo $?