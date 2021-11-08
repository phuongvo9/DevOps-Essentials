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









