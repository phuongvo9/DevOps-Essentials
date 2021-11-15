# Set up your environment by launching Google Cloud Shell, creating a Kubernetes Engine cluster, and configuring your identity and user management scheme.

# Download a sample application, create a Git repository then upload it to a Google Cloud Source Repository.

# Deploy Spinnaker to Kubernetes Engine using Helm.

# Build your Docker image.

# Create triggers to create Docker images when your application changes.

# Configure a Spinnaker pipeline to reliably and continuously deploy your application to Kubernetes Engine.

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