# Provision a complete Kubernetes cluster using Kubernetes Engine.
# Deploy and manage Docker containers using kubectl.
# Break an application into microservices using Kubernetes' Deployments and Services.

# GKE

gcloud config set compute/zone us-central1-b

# Create K8S GKE cluster
gcloud container clusters create io

# Clone the GitHub repository from the Cloud Shell

gsutil cp -r gs://spls/gsp021/* .

cd orchestrate-with-kubernetes/kubernetes
ls
##################################################
### QUICK Kubernetes Demo
##################################################

kubectl create deployment nginx --image=nginx:1.10.0

kubectl get pods

# Expose it outside of Kubernetes
kubectl expose deployment nginx --port 80 --type LoadBalancer

kubectl get services

curl http://<External IP>:80


##################################################
###         PODS
##################################################

# Create PODS with pod configuration file

cat pods/monolith.yaml
    # apiVersion: v1
    # kind: Pod
    # metadata:
    # name: monolith
    # labels:
    #     app: monolith
    # spec:
    # containers:
    #     - name: monolith
    #     image: kelseyhightower/monolith:1.0.0
    #     args:
    #         - "-http=0.0.0.0:80"
    #         - "-health=0.0.0.0:81"
    #         - "-secret=secret"
    #     ports:
    #         - name: http
    #         containerPort: 80
    #         - name: health
    #         containerPort: 81
    #     resources:
    #         limits:
    #         cpu: 0.2
    #         memory: "10Mi"


kubectl create -f pods/monolith.yaml

# Examine your pods
kubectl get pods

# get more information about the monolith pod:
kubectl describe pods monolith


##################################################
###         Interacting with Pods
##################################################

# By default, pods are allocated a private IP address and cannot be reached outside of the cluster.
#  Use the kubectl port-forward command to map a local port to a port inside the monolith pod.


# In 2nd Terminal

kubectl port-forward monolith 10080:80


# In 1st Terminal
curl http://127.0.0.1:10080

# Hit a secure endpoint
curl http://127.0.0.1:10080/secure

# Try logging in to get auth token from monolith
curl -u user http://127.0.0.1:10080/login

#OUTPUT: //127.0.0.1:10080/login Enter host password for user 'user':

# Logging in caused a JWT token to print out. Since Cloud Shell does not handle copying long strings well, create an environment variable for the token.
TOKEN=$(curl http://127.0.0.1:10080/login -u user|jq -r '.token')

# Copy and then use token to hit the secure endpoint

curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:10080/secure

# Open a 3rd terminal and use the -f flag to get a stream of the logs happening in real-time:
kubectl logs -f monolith


# Use the kubectl exec command to run an interactive shell inside the Monolith Pod
# Troubleshoot from within a container

kubectl exec monolith --stdin --tty -c monolith /bin/sh

    # test external connectivity
    ping -c 3 google.com
    exit




##################################################
###         SERVICES
##################################################


# What happens if you want to communicate with a set of Pods? When they get restarted they might have a different IP address.
# Services solves this problem - Providing stable endpoints for Pods


##################################################
###         SERVICES - # Creating a Service
##################################################

cd ~/orchestrate-with-kubernetes/kubernetes
cat pods/secure-monolith.yaml

# Create the secure-monolith pods and their configuration data
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
kubectl create -f pods/secure-monolith.yaml

cat services/monolith.yaml

# TAKES NOTES
    # There's a selector which is used to automatically find and expose any pods with the labels app: monolith and secure: enabled.
    # Now you have to expose the nodeport here because this is how you'll forward external traffic from port 31000 to nginx (on port 443).
kubectl create -f services/monolith.yaml

# To allow traffic to the monolith service on the exposed nodeport:

gcloud compute firewall-rules create allow-monolith-nodeport \
  --allow=tcp:31000

# First, get an external IP address for one of the nodes.
gcloud compute instances list
#  Try hitting the secure-monolith service using curl:

curl -k https://34.68.184.215:31000

### ERROR curl: (7) Failed to connect to 34.68.184.215 port 31000: Connection refused

## ERROR on Labels


##################################################
###         Adding Labels to Pods
##################################################

# Currently the monolith service does not have endpoints. One way to troubleshoot an issue like this is to use the kubectl get pods command with a label query.

    # few pods running with the monolith label.
kubectl get pods -l "app=monolith"
    # "app=monolith" and "secure=enabled"??? - Nothing
kubectl get pods -l "app=monolith,secure=enabled"

# It seems like I need to add the "secure=enabled" label to them.

kubectl label pods secure-monolith 'secure=enabled'
kubectl get pods secure-monolith --show-labels

# View the list of endpoints on the monolith service
kubectl describe services monolith | grep Endpoints

gcloud compute instances list
curl -k https://<EXTERNAL_IP>:31000
# curl -k https://34.68.184.215:31000 {"message":"Hello"}


#######################################################
###         Deploying Applications with Kubernetes
#######################################################

# Goal:scaling and managing containers in production

    # break the monolith app into three separate pieces:
        # auth - Generates JWT tokens for authenticated users.
        # hello - Greet authenticated users.
        # frontend - Routes traffic to the auth and hello services.
cat deployments/auth.yaml

#  create deployment for AUTH
kubectl create -f deployments/auth.yaml
# create service for AUTH
kubectl create -f services/auth.yaml

#  create deployment for Hello
kubectl create -f deployments/hello.yaml
# create service for Hello
kubectl create -f services/hello.yaml

#  create and expose the frontend Deployment.
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml


curl -k https://<EXTERNAL-IP>