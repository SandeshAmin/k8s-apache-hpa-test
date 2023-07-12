#!/bin/bash

# Add Bitnami Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Check if the repository was added successfully
if [[ ! $(helm repo list | grep bitnami) ]]; then
  echo "Error: Failed to add Bitnami Helm repository."
  exit 1
fi

# Install metrics-server using Helm
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
helm install metrics-server bitnami/metrics-server

# Check if namespace apache-test exists, create if it doesn't
if [[ ! $(kubectl get namespace apache-test -o name) ]]; then
  kubectl create namespace apache-test
fi

sleep 5

# Apply manifests from the local manifests directory
kubectl apply -f manifests/php-apache.yaml;

