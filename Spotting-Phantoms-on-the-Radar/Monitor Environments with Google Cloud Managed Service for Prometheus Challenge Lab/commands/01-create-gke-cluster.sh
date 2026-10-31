#!/usr/bin/env bash
# ==============================================================================
# Script: 01-create-gke-cluster.sh
# Lab: GSP364 - Monitor Environments with Managed Service for Prometheus
# Environment: Google Cloud Shell
# Description: Deploy a GKE cluster with Managed Service for Prometheus enabled.
# ==============================================================================

set -euo pipefail

export CLUSTER_NAME="gmp-cluster"
export ZONE="europe-west1-c"
export NUM_NODES=1
export PROJECT_ID=$(gcloud config get-value project)

echo "==> Deploying GKE cluster '${CLUSTER_NAME}' in zone '${ZONE}' with Managed Prometheus..."

gcloud container clusters create "${CLUSTER_NAME}" \
  --zone="${ZONE}" \
  --num-nodes="${NUM_NODES}" \
  --enable-managed-prometheus \
  --project="${PROJECT_ID}"

echo "==> Obtaining cluster credentials for kubectl..."
gcloud container clusters get-credentials "${CLUSTER_NAME}" --zone="${ZONE}"

echo "==> Verifying cluster nodes status..."
kubectl get nodes

