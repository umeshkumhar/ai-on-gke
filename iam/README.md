


## IAM Readme

The following are the steps required to set the IAM policies for the service Account "aiongke" to deploy
```bash
export PROJECT_ID=$(gcloud config get-value project)
gcloud iam service-accounts create aiongke --display-name="AI ON GKE Service Account"
gcloud projects get-iam-policy $PROJECT_ID  --format yaml > ./iam/project.yaml
cat ./iam/iam-policy-required.yaml | sed "s/PROJECTNAME/$PROJECT_ID/g" >> ./iam/new_project_policy.yaml
cat ./iam/project.yaml >> ./iam/new_project_policy.yaml
gcloud projects set-iam-policy $PROJECT_ID ./iam/new_project_policy.yaml
```