
##common variables  
## Need to pull this variables from tf output from previous platform stage
project_id = "umeshkumhar"
region     = "us-central1"

## this is required for terraform to connect to GKE master and deploy workloads
cluster_name   = "demo-cluster1"
cluster_location = "us-central1"
enable_autopilot = true    # If false, creates GKE standard cluster # Needed to install or not nvidia driver # If = true, functionality not created yet.
# If private cluster used will use connect gateway to connect GKE master
private_cluster = true
cluster_membership_id = "demo-cluster1-us-central1"  # Used for private cluster only

#######################################################
####    APPLICATIONS
#######################################################

## GKE environment variables
namespace       = "myray"
service_account = "myray-system-account1"
enable_tpu      = false

## Ray variables
create_ray       = true  

## JupyterHub variables
create_jupyterhub           = true    # Default = true, creates JupyterHub
create_jupyterhub_namespace = false   # Default = false, uses default ray namespace "myray". 
jupyterhub_namespace        = "myray" # If create_jupyterhub_namespace = false, then keep this same as namespace (from GKE variables)


## Triton variables
create_triton               = false     # Default = false, creates Triton
create_triton_namespace     = true     # Default = true, uses default triton namespace "triton". 
triton_namespace            = "triton" # If create_triton_namespace = false, then keep this same as namespace (from GKE variables)
