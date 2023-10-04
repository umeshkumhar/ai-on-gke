#!/bin/bash
NAMESPACE=myray
PROJECT=juanie-newsandbox
USER_EMAIL=juani@juanie.joonix.net
gcloud container clusters get-credentials ml-cluster --region us-central1 --project $PROJECT

##########################################

echo -e "\nDelete ingress..."
kubectl delete ing  jupyter-ingress-iap -n $NAMESPACE

echo -e "\nDelete service... "
kubectl delete svc jupyter-svc-iap -n $NAMESPACE

echo -e "\nDelete secrets..."
kubectl delete secret  my-clientid-secret -n $NAMESPACE
kubectl delete secret  dummy-tls -n $NAMESPACE
kubectl delete secret  jupyter-tls -n $NAMESPACE

echo -e "\nRemove cert files..."
rm dummy-tls*
rm jupyter-tls*
##########################################





