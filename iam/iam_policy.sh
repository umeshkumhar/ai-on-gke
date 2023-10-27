export PROJECT_ID=$(gcloud config get-value project)

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/container.admin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/compute.networkAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/resourcemanager.projectIamAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/gkehub.admin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/compute.storageAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/storage.objectAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/gkehub.gatewayAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:aiongke@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/logging.logWriter
