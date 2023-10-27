# Triton Deployment on GKE

---

This README contains step-by-step instructions to manually deploy the Triton Inference Server on a Google Kubernetes Engine (GKE) cluster. 
Utilizing this script facilitates an automated setup process. The terraform script is designed to handle the provisioning and management of the required GCP resources, as well as the deployment of the Triton Inference Server on the GKE cluster, the script can also be used in a standalone way with an existing cluster.

## Table of Contents

- [Prerequesites](#prerequisites)
- [Quickstart](#quickstart)
- [Terraform script overview](#terraform-script-overview)
- [Collaboration and feedback](#collaboration)


## Prerequisites

- Ensure you have the required credentials and access to a GCP account.
- Install the Google Cloud SDK
- Install Helm and kubectl
- An existing GKE cluster with Workload Identity enabled.
- When running in standalone mode, ensure the `KUBE_CONFIG_PATH` environment is set with a valid path to a Kubernetes configuration for the Helm provider to work correctly.

## <span id="quickstart">Quickstart</span>

1. Navigate to the `triton` module directory:
```bash
cd ai-on-gke/modules/triton
```

2. Initialize terraform configuration:
```bash
terraform init
```

3. Update the terraform.tfvars with the appropriate values for your GCP environment.

4. Apply the terraform script:
```bash
terraform apply
```

5. Upon successfull completion, the Triton Inference Server will be deployed and accessible on your GKE cluster, you can send an inference request with:

```bash
docker run -it --rm --net=host -w /workspace/install/bin nvcr.io/nvidia/tritonserver:23.09-py3-sdk image_client -u $(kubectl get svc -l app=triton-inference-server -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}'):8000 -m inception_graphdef -s INCEPTION -c3 ../../images/mug.jpg;
```

## <span id="terraform-script-overview">Terraform script overview</span>

- **Random ID Generation**: Generates a random ID suffix for naming the Google Cloud Storage (GCS) bucket.
- **GCS Bucket Creation**: Creates a GCS bucket for storing sample model data.

- **Bucket Access Control**: Modifies the permissions of the GCS bucket to allow access through workload identity.

- **Model Data Upload**: Uploads the model data to the GCS bucket.

- **GMP Metrics modification**: Modifies the GMP metrics settings in the service.yaml template file.

- **Triton Server Deployment**: Deploys the Triton Inference server on the GKE cluster using a local Helm chart.

## <span id="collaboration">Collaboration and feedback</span>

[Placeholder]