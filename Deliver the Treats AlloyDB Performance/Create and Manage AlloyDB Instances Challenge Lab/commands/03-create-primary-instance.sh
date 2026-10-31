#!/usr/bin/env bash
# ==============================================================================
# Script: 03-create-primary-instance.sh
# Lab: GSP395 - Create and Manage AlloyDB Instances
# Environment: Google Cloud Shell
# Description: Create the primary AlloyDB read/write instance with 2 vCPUs.
# ==============================================================================

set -euo pipefail

export REGION="us-west1"
export CLUSTER_ID="lab-cluster"
export PRIMARY_ID="lab-instance"
export PROJECT_ID=$(gcloud config get-value project)

echo "==> Creating primary AlloyDB instance '${PRIMARY_ID}'..."

gcloud alloydb instances create "${PRIMARY_ID}" \
  --instance-type=PRIMARY \
  --cpu-count=2 \
  --region="${REGION}" \
  --cluster="${CLUSTER_ID}" \
  --project="${PROJECT_ID}"

echo "==> Retrieving primary instance details and IP address..."
gcloud alloydb instances describe "${PRIMARY_ID}" \
  --cluster="${CLUSTER_ID}" \
  --region="${REGION}" \
  --project="${PROJECT_ID}"

