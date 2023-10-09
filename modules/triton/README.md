# Triton Deployment on GKE

---

This README contains step-by-step instructions to manually deploy the Triton Inference Server on a Google Kubernetes Engine (GKE) cluster. These instructions are intended as a temporary guide to get users started with the setup while the terraform automation is set up.

## Table of Contents

- [Prerequesites](#prerequisites)
- [Step 1: Create a GKE Cluster](#step-1)
- [Step 2: Add GPU Node Pools](#step-2)
- [Step 3: Create a GCS Bucket](#step-3)
- [Step 4: Upload Model Data to GCS Bucket](#step-4)
- [Step 5: Modify GCS Permissions](#step-5)
- [Step 6: Deploy Prometheus and Grafana](#step-2)
- [Step 7: Install Triton Server](#step-7)
- [Step 8: Send an Inference Request](#step-8)


## Prerequisites

- Ensure you have the required credentials and access to a GCP account.
- Install the Google Cloud SDK
- Install Helm and kubectl

## <span id="step-1">Step 1: Create a GKE Cluster</span>

gcloud container clusters create triton-cluster --release-channel regular --region us-central1 --node-locations us-central1-a,us-central1-c

## <span id="step-2">Step 2: Add GPU Node Pools</span>

gcloud container node-pools create gpu-pool \
  --accelerator type=nvidia-tesla-t4,count=2,gpu-driver-version=latest \
  --machine-type n1-standard-8 \
  --region us-central1 --cluster  triton-cluster \
  --node-locations us-central1-a,us-central1-c \
  --num-nodes 2 \
  --enable-autoscaling \
   --min-nodes 0 \
   --max-nodes 2

## <span id="step-3">Step 3: Create a GCS Bucket</span>

gcloud storage buckets create gs://triton_bucket-$DEVSHELL_PROJECT_ID

## <span id="step-4">Step 4: Upload Model Data to GCS Bucket    </span>

