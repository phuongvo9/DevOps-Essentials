gcloud config set compute/zone us-east1-d

git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

cd continuous-deployment-on-kubernetes

# Provisioning Jenkins
# Creating a Kubernetes cluster
gcloud container clusters create jenkins-cd \
--num-nodes 2 \
--machine-type n1-standard-2 \
--scopes "https://www.googleapis.com/auth/source.read_write,cloud-platform"

gcloud container clusters list
# get the credentials for our cluster:
gcloud container clusters get-credentials jenkins-cd

kubectl cluster-info

# Setup Helm
#  use Helm to install Jenkins from the Charts repository.

helm repo add jenkins https://charts.jenkins.io

helm repo update
####################################################################################
#################### Configure and Install Jenkins
####################################################################################
gsutil cp gs://spls/gsp330/values.yaml jenkins/values.yaml

# use a custom values file to automatically configure your Kubernetes Cloud and add the following necessary plugins:
# Kubernetes:1.29.4
# Workflow-multibranch:latest
# Git:4.7.1
# Configuration-as-code:1.51
# Google-oauth-plugin:latest
# Google-source-plugin:latest
# Google-storage-plugin:latest

gsutil cp gs://spls/gsp330/values.yaml jenkins/values.yaml

helm install cd jenkins/jenkins -f jenkins/values.yaml --wait

kubectl get pods


# Configure the Jenkins service account to be able to deploy to the cluster
kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-jenkins



# setup port forwarding to the Jenkins UI from the Cloud Shell

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

kubectl get svc

##
#Connect to Jenkins

# The Jenkins chart will automatically create an admin password

printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

#   8daRfEdtef0lEP4rS9XKXP
# Access to web port  port 8080


# have Jenkins set up in your Kubernetes cluster! Jenkins will drive your automated CI/CD pipelines in the next sections
#Understanding the Application

#deploy sample application :gceme  in your continuous deployment pipeline

    # The application mimics a microservice by supporting two operation modes.

    # In backend mode: gceme listens on port 8080 and returns Compute Engine instance metadata in JSON format.
    # In frontend mode: gceme queries the backend gceme service and renders the resulting JSON in the user interface.

cd sample-app
# Create the Kubernetes namespace to logically isolate the deployment:
kubectl create ns production

# Create the production and canary deployments,
kubectl apply -f k8s/production -n production
kubectl apply -f k8s/canary -n production
kubectl apply -f k8s/services -n production

# Scale up the production environment frontends 
kubectl scale deployment gceme-frontend-production -n production --replicas 4


# Now confirm that you have 5 pods running for the frontend, 4 for production traffic and 1 for canary releases (changes to the canary release will only affect 1 out of 5 (20%) of users):

kubectl get pods -n production -l app=gceme -l role=frontend

#  confirm that you have 2 pods for the backend, 1 for production and 1 for canary:

kubectl get pods -n production -l app=gceme -l role=backend

# Retrieve the external IP for the production services
kubectl get service gceme-frontend -n production

# store the frontend service load balancer IP in an environment variable for use later
export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)

curl http://$FRONTEND_SERVICE_IP/version



