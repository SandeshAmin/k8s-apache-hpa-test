#!/bin/bash

# Check if the repository was added successfully
if [[ ! $(helm repo list | grep bitnami) ]]; then
  helm repo add bitnami https://charts.bitnami.com/bitnami
  exit 1
fi

NAMESPACE="apache-test"

# Check if namespace apache-test exists, create if it doesn't
if [[ ! $(kubectl get namespace $NAMESPACE -o name) ]]; then
  kubectl create namespace $NAMESPACE
  echo "Namespace $NAMESPACE created successfully."
else
  echo "Namespace $NAMESPACE already exists."
fi

# Enable metrics.k8s.io/v1beta1 API using Helm chart configuration
helm upgrade --install --namespace kube-system metrics-server bitnami/metrics-server --set apiService.create=true

sleep 5

# Apply manifests from the local manifests directory
kubectl apply -f manifests/php-apache.yaml;
