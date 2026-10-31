#!/usr/bin/env bash
# ==============================================================================
# Script: 07-verify-resources.sh
# Lab: GSP395 - Create and Manage AlloyDB Instances
# Environment: Google Cloud Shell
# Description: List and verify AlloyDB clusters, instances, and backups.
# ==============================================================================

set -euo pipefail

export REGION="us-west1"
export CLUSTER_ID="lab-cluster"
export PROJECT_ID=$(gcloud config get-value project)

echo "=============================================================================="
echo "==> Listing AlloyDB Clusters in ${REGION}:"
echo "=============================================================================="
gcloud alloydb clusters list \
  --region="${REGION}" \
  --project="${PROJECT_ID}"

echo ""
echo "=============================================================================="
echo "==> Listing AlloyDB Instances for Cluster '${CLUSTER_ID}':"
echo "=============================================================================="
gcloud alloydb instances list \
  --cluster="${CLUSTER_ID}" \
  --region="${REGION}" \
  --project="${PROJECT_ID}"

echo ""
echo "=============================================================================="
echo "==> Listing AlloyDB Backups in ${REGION}:"
echo "=============================================================================="
gcloud alloydb backups list \
  --region="${REGION}" \
  --project="${PROJECT_ID}"

