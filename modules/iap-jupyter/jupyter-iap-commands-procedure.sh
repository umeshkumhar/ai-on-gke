#!/bin/bash
NAMESPACE=myray
PROJECT=juanie-newsandbox
USER_EMAIL=juani@juanie.joonix.net

gcloud container clusters get-credentials ml-cluster --region us-central1 --project $PROJECT

##########################################

# Create IAP Client ID secret
## TODO: Fetch Client ID USERID and SECRERT DYANMICALLY

echo "Setting OAuth Client ID Secret.... "

kubectl config set-context --current --namespace=$NAMESPACE

kubectl create secret generic my-clientid-secret	\
--from-literal=client_id=455460072909-itvsipctb5jve6qb0olvs9847b2s30ab.apps.googleusercontent.com	\
	--from-literal=client_secret=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 \
	--namespace=$NAMESPACE

##########################################

## NAMESPACE "myray" HARDCODED IN YAML files

# 1. Create Backend Config
echo -e "\nCreating Backend Config... "
kubectl apply -f jupyter-backend-config-iap.yaml

# 2. Create JupyterHub Service with backend-config
echo -e "\nCreating JupyterHub Service With IAP... "
kubectl apply -f jupyter-svc-iap.yaml


# 3. Create dummy TLS Certificate with dummy IP
echo -e "\nCreating Dummy TLS Cert... "
openssl genrsa -out dummy-tls.key 2048
SUBJ="/CN=8.8.8.8.sslip.io"

openssl req -new -key dummy-tls.key -out dummy-tls.csr \
    -subj  $SUBJ
openssl x509 -req -days 365 -in dummy-tls.csr -signkey dummy-tls.key \
    -out dummy-tls.crt

kubectl create secret tls dummy-tls \
    --cert dummy-tls.crt --key dummy-tls.key  \
    --namespace=myray

# 4. Create Ingress with dummy TLS certificate
echo -e "\nCreating Ingress with Dummy TLS Cert... "
kubectl apply -f jupyter-ingress-iap-dummy-tls.yaml

echo -e "\nPlease wait some 5 mins until LB gets set up... " # Sleep till IP is published
sleep 300

# 5. Capture LB IP.
IP=$(kubectl get ing jupyter-ingress-iap -o jsonpath='{.status.loadBalancer.ingress[0].ip}') 
echo $IP

# 6. Create TLS Certificate with SSLIP with LB's IP
echo -e "\nCreating TLS Cert with LB's IP... "
openssl genrsa -out jupyter-tls.key 2048
SUBJ="/CN=$IP.sslip.io"
openssl req -new -key jupyter-tls.key -out jupyter-tls.csr \
    -subj  $SUBJ
openssl x509 -req -days 365 -in jupyter-tls.csr -signkey jupyter-tls.key \
    -out jupyter-tls.crt
kubectl create secret tls jupyter-tls \
    --cert jupyter-tls.crt --key jupyter-tls.key  \
    --namespace=myray

# 6. Reconfigure Ingress/Load-Balancer to use TLS with certificate created.
echo -e "\nReconfigure Ingress with new TLS Cert... "
kubectl apply -f jupyter-ingress-iap.yaml

# 7. Authorize my user to access the IAP protected site
echo -e "\nAuthorize IAP user to Backend Services.. "
BACKEND=$(gcloud compute backend-services list --filter="name~'32002'" --format="value(name)")

gcloud iap web add-iam-policy-binding \
    --resource-type=backend-services \
    --service $BACKEND \
    --member=user:$USER_EMAIL \
    --role='roles/iap.httpsResourceAccessor'


echo -e "\n Visit https://$IP.sslip.io"





