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