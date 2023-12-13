# AI on GKE

This repository contains assets related to AI/ML workloads on
[Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/).

## Architecture
Defaults:
- Creates a new VPC & subnet (can be disabled)
- Creates Private Clusters with external endpoints disabled
- Registers the cluster with fleet in current project
- Solution uses Anthos Connect Gateway to connect to private clusters

## Getting Started

### 0. Deployment Options
There are 3 options for using this repository. You can use any of these.

1. Deploy with Terraform commands
2. Deploy with Cloudshell  
3. Deploy with Infrastructure Manager

### 1. Deploy with Terraform commands

#### Create Infrastructure (optional) 
Platform module can be used to create a GKE cluster. Please check README file

```commandline
cd platform
```
Update `platform.auto.tfvars` with project_id, cluster_name and other required variables

```commandline
terraform init
terraform apply
```

#### Deploy Workloads

The repository supports the following workload deployments
- Jupyterhub
- Ray Clusters
- Triton Inference Server
- (TODO) Feast feature store

** TODO: add readme files for individual workload modules & link it here **


```commandline
cd ../workloads
```
Update `workloads.auto.tfvars` with project_id, workloads to install flag and other required variables

```commandline
terraform init
terraform apply
```

#### Delete the deployment

```commandline
cd workloads
terraform destroy

cd platform
terraform destroy
```

### Accessing Deployments
 Lorum Ipsum

### 2. Deploy with Cloudshell

Deploy the platform & workloads using cloud shell. Follow the tutorial side pannel for instructions.

[![Deploy using Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/umeshkumhar/ai-on-gke&cloudshell_tutorial=tutorial.md&cloudshell_workspace=./)



### 3. Deploy with Infrastructure Manager

```commandline
PROJECT_ID=<your-project-id>
SERVICE_ACCOUNT_NAME=<sa-name>
```

```commandline
gcloud  infra-manager deployments apply projects/$PROJECT_ID/locations/us-central1/deployments/aiongke-deployment \
    --service-account=projects/$PROJECT_ID/serviceAccounts/$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
    --git-source-repo=https://github.com/umeshkumhar/ai-on-gke \
    --git-source-directory=platform \
    --git-source-ref=main \
    --input-values=project_id=$PROJECT_ID,cluster_name=ml-cluster0
```

Check the status of deployment

```commandline
gcloud infra-manager deployments describe projects/$PROJECT_ID/locations/us-central1/deployments/aiongke-deployment
```





## Important Note
The use of the assets contained in this repository is subject to compliance with [Google's AI Principles](https://ai.google/responsibility/principles/)

## Licensing

* See [LICENSE](/LICENSE)



## Test Commands for Autopush
DEPLOYMENT_ID=triton
curl \
    -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json" \
    "https://autopush-config.sandbox.googleapis.com/v1alpha2/projects/ai-on-gke-jss-sandbox/locations/us-central1/deployments/deployment_id=${DEPLOYMENT_ID}" \
    --data '{
      "service_account": "projects/ai-on-gke-jss-sandbox/serviceAccounts/aiongke@ai-on-gke-jss-sandbox.iam.gserviceaccount.com",
      "terraform_blueprint": {
        "gcs_source": "gs://ai-on-gke-jss-sandbox/triton",
        "input_values": {
         "project_id": {
          "input_value": "ai-on-gke-jss-sandbox"
         },
         "cluster_name": {
          "input_value": "ml-cluster1"
         },
         "cluster_location": {
          "input_value": "us-central1"
         },
         "goog_cm_deployment_name": {
          "input_value": "triton-helm"
         },
        }
      }
    }'


DEPLOYMENT_ID=jupyterhub
curl \
    -X DELETE \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json" \
    "https://autopush-config.sandbox.googleapis.com/v1alpha2/projects/ai-on-gke-jss-sandbox/locations/us-central1/deployments/${DEPLOYMENT_ID}?force=true"




DEPLOYMENT_ID=triton
curl \
    -X PATCH \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json" \
    "https://autopush-config.sandbox.googleapis.com/v1alpha2/projects/ai-on-gke-jss-sandbox/locations/us-central1/deployments/${DEPLOYMENT_ID}" \
    --data '{
      "service_account": "projects/ai-on-gke-jss-sandbox/serviceAccounts/aiongke@ai-on-gke-jss-sandbox.iam.gserviceaccount.com",
      "terraform_blueprint": {
        "gcs_source": "gs://ai-on-gke-jss-sandbox/triton",
        "input_values": {
         "project_id": {
          "input_value": "ai-on-gke-jss-sandbox"
         },
         "bucket_name": {
          "input_value": "ai-on-gke-jss-sandbox"
         },
         "cluster_name": {
          "input_value": "ml-cluster1"
         },
         "cluster_location": {
          "input_value": "us-central1"
         },
         "goog_cm_deployment_name": {
          "input_value": "triton-helm"
         },
        }
      }
    }'