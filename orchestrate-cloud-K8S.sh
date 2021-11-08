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




