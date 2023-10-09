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
- [Step 6: Deploy Prometheus and Grafana (Optional)](#step-6)
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

BUCKET_NAME=triton-inference-server-repository

gcloud storage buckets create gs://$BUCKET_NAME

## <span id="step-4">Step 4: Upload Model Data to GCS Bucket    </span>

git clone https://github.com/triton-inference-server/server.git

gsutil cp -r docs/examples/model_repository gs://triton-inference-server-repository/model_repository

./server/docs/examples/fetch_models.sh


cp -r model_repository/ server/docs/examples/

## <span id="step-5">Step 5: Modify GCS Permissions    </span>

[Placeholder]

## <span id="step-6">Step 6: Deploy Prometheus and Grafana  (Optional)  </span>

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install example-metrics --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false prometheus-community/kube-prometheus-stack --set prometheus.prometheusSpec.image.repository=prometheus-engine/prometheus --set prometheus.prometheusSpec.image.tag=v2.35.0-gmp.2-gke.0 --set prometheus.prometheusSpec.image.registry=gke.gcr.io

kubectl port-forward service/example-metrics-grafana 8080:80

## <span id="step-7">Step 7: Install Triton Server </span>

helm install example server/deploy/gcp

## <span id="step-8">Step 8: Send an Inference Request </span>

docker run -it --rm --net=host -w /workspace/install/bin nvcr.io/nvidia/tritonserver:23.09-py3-sdk

image_client -u <LB_EXTERNAL_IP>:8000 -m inception_graphdef -s INCEPTION -c3 ../../images/mug.jpg

docker run -it --rm --net=host -w /workspace/install/bin nvcr.io/nvidia/tritonserver:23.09-py3-sdk image_client -u $(kubectl get svc -l app=triton-inference-server -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}'):8000 -m inception_graphdef -s INCEPTION -c3 ../../images/mug.jpg;
