
##common variables  
## Need to pull this variables from tf output from previous platform stage
project_id = "ai-sandbox-5"
region     = "us-central1"

## this is required for terraform to connect to GKE master and deploy workloads
cluster_name   = "demo-cluster-4"
cluster_location = "us-central1"

# If private cluster used will use connect gateway to connect GKE master
private_cluster = false
cluster_membership_id = "demo-cluster-2-us-central1"  # Used for private cluster only

#######################################################
####    APPLICATIONS
#######################################################

## GKE environment variables
namespace       = "myray"
service_account = "myray-system-account"
enable_tpu      = false
enable_autopilot = false    # If false, creates GKE standard cluster # Needed to install or not nvidia driver # If = true, functionality not created yet.

## Ray variables
create_ray       = true  

## JupyterHub variables
create_jupyterhub           = true    # Default = true, creates JupyterHub
create_jupyterhub_namespace = false   # Default = false, uses default ray namespace "myray". 
jupyterhub_namespace        = "myray" # If create_jupyterhub_namespace = false, then keep this same as namespace (from GKE variables)


## Triton variables