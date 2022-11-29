#!/bin/bash

# tonero91@gmail.com

# clone the repository
git clone https://github.com/frontendtony/deploying-apps-to-gcp.git

# Change to the deploying-apps-to-gcp folder
cd deploying-apps-to-gcp


# Deploy to App Engine

gcloud app create --region=us-central

gcloud app deploy --version=one --quiet


# Deploy to Kubernetes Engine

# add your project id as an environment variable in your terminal $DEVSHELL_PROJECT_ID
# $(gcloud config get-value project) returns the default gcp project
export DEVSHELL_PROJECT_ID=$(gcloud config get-value project)

# Create a cluster
gcloud beta container --project $DEVSHELL_PROJECT_ID clusters create "gads-cluster" --zone "us-central1-c" --no-enable-basic-auth --cluster-version "1.23.12-gke.100" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/gads-370102/global/networks/default" --subnetwork "projects/gads-370102/regions/us-central1/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations "us-central1-c"

# Test connection
kubectl get nodes

# Apply Kubernetes config
kubectl apply -f kubernetes-config.yaml

# Verify pods creation
kubectl get pods

# Verify load balancer creation
kubectl get services


# Deploy to Cloud Run

# deploy already created image to cloud run
gcloud run deploy devops-image \
--image=gcr.io/gads-370102/devops-image@sha256:a04e4b72bfe0b03f3eace69715eb2d1ac87c3995550efba849126904e432012a \
--allow-unauthenticated \
--region=us-central1