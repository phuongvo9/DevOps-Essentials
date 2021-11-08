# build, run, and debug Docker containers.
# pull Docker images from Docker Hub and Google Container Registry.
# push Docker images to Google Container Registry.

docker run hello-world

docker images

docker ps

mkdir test && cd test

##################################################
### BUILD
##################################################
# Create a docker file
cat > Dockerfile <<EOF
# Use an official Node runtime as the parent image
FROM node:6
# Set the working directory in the container to /app
WORKDIR /app
# Copy the current directory contents into the container at /app
ADD . /app
# Make the container's port 80 available to the outside world
EXPOSE 80
# Run app.js using node when the container launches
CMD ["node", "app.js"]
EOF


# Create a node application
cat > app.js <<EOF
const http = require('http');
const hostname = '0.0.0.0';
const port = 80;
const server = http.createServer((req, res) => {
    res.statusCode = 200;
      res.setHeader('Content-Type', 'text/plain');
        res.end('Hello World\n');
});
server.listen(port, hostname, () => {
    console.log('Server running at http://%s:%s/', hostname, port);
});
process.on('SIGINT', function() {
    console.log('Caught interrupt signal and will exit');
    process.exit();
});
EOF

# The -t is to name and tag an image with the name:tag syntax. The name of the image is node-app and the tag is 0.1. The tag is highly recommended when building Docker images. If you don't specify a tag, the tag will default to latest and it becomes more difficult to distinguish newer images from older ones. Also notice how each line in the Dockerfile above results in intermediate container layers as the image is built.

docker images


##################################################
### RUN
##################################################

# Run container based on the image

docker run -p 4000:80 --name my-app node-app:0.1

# Check the process is listening
curl http://localhost:4000

# Stop and remove container
docker stop my-app && docker rm my-app

# Start container from background -d
docker run -p 4000:80 --name my-app -d node-app:0.1
docker ps

# check logs
docker logs [container_id]

# BUILD NEW IMAGE WITH TAGS 0.2
nano app.js
    # ....
    # const server = http.createServer((req, res) => {
    #     res.statusCode = 200;
    #     res.setHeader('Content-Type', 'text/plain');
    #         res.end('Welcome to Cloud\n');
    # });
    # ....

docker build -t node-app:0.2 .

docker images

docker run -p 8080:80 --name my-app-2 -d node-app:0.2
docker ps

curl http://localhost:8080

#Output: Welcome to Cloud

##################################################
### DEBUG
##################################################

#  logs of a container using docker logs [container_id]. If you want to follow the log's output as the container is running, use the -f

docker logs -f [container_id]

# Sometimes you will want to start an interactive Bash session inside the running container. You can use docker exec to do

docker exec -it [container_id] bash  
    ls
    exit
# You can examine a container's metadata in Docker by using Docker inspec
docker inspect [container_id]

# Use --format to inspect specific fields from the returned JSON

docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [container_id]
# Output: 192.168.9.3

##################################################
### PUBLISH
##################################################

#  push the image to the Google Container Registry (gcr).
gcloud config list project
    #Tag node-app:0.2. Replace [project-id] with your configuration..
        # format is [hostname]/[project-id]/[image]:[tag].
docker tag node-app:0.2 gcr.io/[project-id]/node-app:0.2

docker tag node-app:0.2 gcr.io/qwiklabs-gcp-03-0192380e21ba/node-app:0.2

# Push this image to gcr. 

docker push gcr.io/[project-id]/node-app:0.2
docker push gcr.io/qwiklabs-gcp-03-0192380e21ba/node-app:0.2


# Stop and remove all containers:

docker stop $(docker ps -q)
docker rm $(docker ps -aq)

#  have to remove the child images (of node:6) before we remove the node image - new fresh environment

docker rmi node-app:0.2 gcr.io/qwiklabs-gcp-03-0192380e21ba/node-app node-app:0.1
docker rmi node:6
docker rmi $(docker images -aq) # remove remaining images
docker images


# At this point you should have a pseudo-fresh environment. 
    # Pull the image and run

docker pull gcr.io/[project-id]/node-app:0.2
docker run -p 4000:80 -d gcr.io/qwiklabs-gcp-03-0192380e21ba/node-app:0.2
curl http://localhost:4000




