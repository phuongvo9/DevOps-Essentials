# Set up our environment by launching Google Cloud Shell, creating a Kubernetes Engine cluster, and configuring our identity and user management scheme.

# Download a sample application, create a Git repository then upload it to a Google Cloud Source Repository.

# Deploy Spinnaker to Kubernetes Engine using Helm.

# Build our Docker image.

# Create triggers to create Docker images when our application changes.

# Configure a Spinnaker pipeline to reliably and continuously deploy our application to Kubernetes Engine.

# Deploy a code change, triggering the pipeline, and watch it roll out to production.




gcloud config set compute/zone us-central1-f
# Create GKE
gcloud container clusters create spinnaker-tutorial \
    --machine-type=n1-standard-2
### Configure identity and access management

# Create service account
gcloud iam service-accounts create spinnaker-account \
    --display-name spinnaker-account

# Store the service account email address and the current project ID in environment variables
export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')
export PROJECT=$(gcloud info --format='value(config.project)')

# Bind the storage.admin role to the service account:
gcloud projects add-iam-policy-binding $PROJECT \
    --role roles/storage.admin \
    --member serviceAccount:$SA_EMAIL

# Download the service account key to install Spinnaker and upload key to GKE
gcloud iam service-accounts keys create spinnaker-sa.json \
     --iam-account $SA_EMAIL

############################################
### Set up Cloud Pub/Sub to trigger Spinnaker pipelines
############################################

# Create the Cloud Pub/Sub topic for notifications from Container Registry.
gcloud pubsub topics create projects/$PROJECT/topics/gcr

# Create a subscription that Spinnaker can read from to receive notifications of images being pushed.
gcloud pubsub subscriptions create gcr-triggers \
    --topic projects/${PROJECT}/topics/gcr


# Give Spinnaker's service account permissions to read from the gcr-triggers subscription.

export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')
gcloud beta pubsub subscriptions add-iam-policy-binding gcr-triggers \
    --role roles/pubsub.subscriber --member serviceAccount:$SA_EMAIL

############################################
#### Deploying Spinnaker using Helm
############################################

# Configure Helm
kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account)
# Grant Spinnaker the cluster-admin role so it can deploy resources across all namespaces
kubectl create clusterrolebinding --clusterrole=cluster-admin \
    --serviceaccount=default:default spinnaker-admin


# Add the stable charts deployments to Helm's usable repositories (includes Spinnaker)
helm repo add stable https://charts.helm.sh/stable
helm repo update



############################################
#### Configure Spinnaker
############################################

    #create a bucket for Spinnaker to store its pipeline configuration
export PROJECT=$(gcloud info \
    --format='value(config.project)')


export BUCKET=$PROJECT-spinnaker-config

gsutil mb -c regional -l us-central1 gs://$BUCKET


#  create a spinnaker-config.yaml 

export SA_JSON=$(cat spinnaker-sa.json)
export PROJECT=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT-spinnaker-config
cat > spinnaker-config.yaml <<EOF
gcs:
  enabled: true
  bucket: $BUCKET
  project: $PROJECT
  jsonKey: '$SA_JSON'
dockerRegistries:
- name: gcr
  address: https://gcr.io
  username: _json_key
  password: '$SA_JSON'
  email: 1234@5678.com
# Disable minio as the default storage backend
minio:
  enabled: false
# Configure Spinnaker to enable GCP services
halyard:
  spinnakerVersion: 1.19.4
  image:
    repository: us-docker.pkg.dev/spinnaker-community/docker/halyard
    tag: 1.32.0
    pullSecrets: []
  additionalScripts:
    create: true
    data:
      enable_gcs_artifacts.sh: |-
        \$HAL_COMMAND config artifact gcs account add gcs-$PROJECT --json-path /opt/gcs/key.json
        \$HAL_COMMAND config artifact gcs enable
      enable_pubsub_triggers.sh: |-
        \$HAL_COMMAND config pubsub google enable
        \$HAL_COMMAND config pubsub google subscription add gcr-triggers \
          --subscription-name gcr-triggers \
          --json-path /opt/gcs/key.json \
          --project $PROJECT \
          --message-format GCR
EOF

############################################
##### Deploy the Spinnaker chart using Helm
############################################
helm install -n default cd stable/spinnaker -f spinnaker-config.yaml \
           --version 2.0.0-rc9 --timeout 10m0s --wait

# set up port forwarding to Spinnaker from Cloud Shell (8080)
export DECK_POD=$(kubectl get pods --namespace default -l "cluster=spin-deck" \
    -o jsonpath="{.items[0].metadata.name}")

kubectl port-forward --namespace default $DECK_POD 8080:9000 >> /dev/null &

############################################
##### Building the Docker image
############################################



#-------------Create our source code repository-----------------
gsutil -m cp -r gs://spls/gsp114/sample-app.tar .
mkdir sample-app
# Unpack the source code
tar xvf sample-app.tar -C ./sample-app
cd sample-app

git config --global user.email "$(gcloud config get-value core/account)"
git config --global user.name "student 88f19ede"

# Make the initial commit to the source code repository
git init
git add .

git commit -m "Initial commit"

# Create a repository to host our code:
gcloud source repos create sample-app
git config credential.helper gcloud.sh

# Add our newly created repository as remote

export PROJECT=$(gcloud info --format='value(config.project)')
git remote add origin https://source.developers.google.com/p/$PROJECT/r/sample-app


# Push our code to the new repository's master branch:

git push origin master

#-------------Configure the build triggers----------------
    #Configure Container Builder to build and push our Docker images every time you push Git tags to our source repository



# GC console GUI > Cloud Build > Triggers.


#-----------------Prepare your Kubernetes Manifests for use in Spinnaker----------

# Create the bucket
export PROJECT=$(gcloud info --format='value(config.project)')
gsutil mb -l us-central1 gs://$PROJECT-kubernetes-manifests

# Enable versioning on the bucket so that you have a history of your manifests

gsutil versioning set on gs://$PROJECT-kubernetes-manifests

# Set the correct project ID in your kubernetes deployment manifests
sed -i s/PROJECT/$PROJECT/g k8s/deployments/*

# Commit the changes to the repository
git commit -a -m "Set project ID"


# ------------------- Build your image ------------------------
git tag v1.0.0
git push --tags

# ------------------Configuring your deployment pipelines--------------
# Install the spin CLI for managing Spinnaker
curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/1.14.0/linux/amd64/spin
chmod +x spin
# Create the deployment pipeline

./spin application save --application-name sample \
                        --owner-email "$(gcloud config get-value core/account)" \
                        --cloud-providers kubernetes \
                        --gate-endpoint http://localhost:8080/gate

#  upload an example pipeline to your Spinnaker instance
export PROJECT=$(gcloud info --format='value(config.project)')
sed s/PROJECT/$PROJECT/g spinnaker/pipeline-deploy.json > pipeline.json
./spin pipeline save --gate-endpoint http://localhost:8080/gate -f pipeline.json

# Output: Pipeline save succeeded

# ------------------- Manually Trigger and View your pipeline execution


