#!/usr/bin/env bash
# ==============================================================================
# Script: 06-upload-configuration.sh
# Lab: GSP364 - Monitor Environments with Managed Service for Prometheus
# Environment: Google Cloud Shell
# Description: Create Cloud Storage bucket, upload op-config.yaml, and verify.
# ==============================================================================

set -euo pipefail

export PROJECT=$(gcloud config get-value project)

echo "==> Creating Cloud Storage bucket gs://${PROJECT}..."
gcloud storage buckets create --project="${PROJECT}" gs://"${PROJECT}"

echo "==> Uploading op-config.yaml to gs://${PROJECT}..."
gcloud storage cp op-config.yaml gs://"${PROJECT}"

echo "==> Granting public read access for lab assessment verification..."
# Note: allUsers objectViewer binding is a specific lab assessment requirement.
# Production systems should adhere to least privilege IAM roles.
gcloud storage buckets add-iam-policy-binding gs://"${PROJECT}" \
  --member=allUsers \
  --role=roles/storage.objectViewer

echo "==> Verifying uploaded configuration object in Cloud Storage:"
gcloud storage ls gs://"${PROJECT}"/op-config.yaml

