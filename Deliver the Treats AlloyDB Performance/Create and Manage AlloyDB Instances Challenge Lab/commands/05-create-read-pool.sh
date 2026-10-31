#!/usr/bin/env bash
# ==============================================================================
# Script: 05-create-read-pool.sh
# Lab: GSP395 - Create and Manage AlloyDB Instances
# Environment: Google Cloud Shell
# Description: Create a 2-node AlloyDB read pool instance with 2 vCPUs per node.
# ==============================================================================

set -euo pipefail

export REGION="us-west1"
export CLUSTER_ID="lab-cluster"
export READ_POOL_ID="lab-instance-rp1"
export PROJECT_ID=$(gcloud config get-value project)

echo "==> Creating AlloyDB read pool '${READ_POOL_ID}' with 2 nodes..."

gcloud alloydb instances create "${READ_POOL_ID}" \
  --instance-type=READ_POOL \
  --cpu-count=2 \
  --read-pool-node-count=2 \
  --region="${REGION}" \
  --cluster="${CLUSTER_ID}" \
  --project="${PROJECT_ID}"

echo "==> Read pool instance '${READ_POOL_ID}' created successfully."

