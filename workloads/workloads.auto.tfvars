#######################################################
####    WORKLOADS REQUIRED VARIABLES
#######################################################

## Common variables
project_id = "ai-sandbox-4"
region     = "us-central1"

## GKE variables
namespace       = "myray"
service_account = "myray-system-account"
enable_tpu      = false

## JupyterHub variables
create_jupyterhub = true                # Default = true, creates JupyterHub
create_jupyterhub_namespace = false     # Default = false, uses default ray namespace "myray". 
jupyterhub_namespace = "myray"          # If create_jupyterhub_namespace = false, then keep this same as namespace (from GKE variables)