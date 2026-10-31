#!/usr/bin/env bash
# ==============================================================================
# Script: 02-create-cluster.sh
# Lab: GSP395 - Create and Manage AlloyDB Instances
# Environment: Google Cloud Shell
# Description: Create the AlloyDB cluster attached to the peering-network VPC.
# Note: Prompt for password securely without hardcoding credentials.
# ==============================================================================

set -euo pipefail

export REGION="us-west1"
export CLUSTER_ID="lab-cluster"
export NETWORK_ID="peering-network"
export PROJECT_ID=$(gcloud config get-value project)

echo "==> Enter password for AlloyDB postgres user:"
read -s ALLOYDB_PASSWORD

echo "==> Creating AlloyDB cluster '${CLUSTER_ID}' in region '${REGION}'..."

gcloud alloydb clusters create "${CLUSTER_ID}" \
  --region="${REGION}" \
  --network="${NETWORK_ID}" \
  --password="${ALLOYDB_PASSWORD}" \
  --project="${PROJECT_ID}"

echo "==> Describing created cluster '${CLUSTER_ID}'..."
gcloud alloydb clusters describe "${CLUSTER_ID}" \
  --region="${REGION}" \
  --project="${PROJECT_ID}"

