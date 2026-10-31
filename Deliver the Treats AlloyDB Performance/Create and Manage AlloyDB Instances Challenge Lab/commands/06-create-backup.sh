#!/usr/bin/env bash
# ==============================================================================
# Script: 06-create-backup.sh
# Lab: GSP395 - Create and Manage AlloyDB Instances
# Environment: Google Cloud Shell
# Description: Create an on-demand backup of the AlloyDB cluster.
# ==============================================================================

set -euo pipefail

export REGION="us-west1"
export CLUSTER_ID="lab-cluster"
export BACKUP_ID="lab-backup"
export PROJECT_ID=$(gcloud config get-value project)

echo "==> Creating on-demand backup '${BACKUP_ID}' for cluster '${CLUSTER_ID}'..."

gcloud alloydb backups create "${BACKUP_ID}" \
  --cluster="${CLUSTER_ID}" \
  --region="${REGION}" \
  --project="${PROJECT_ID}"

echo "==> Describing backup '${BACKUP_ID}'..."
gcloud alloydb backups describe "${BACKUP_ID}" \
  --region="${REGION}" \
  --project="${PROJECT_ID}"

