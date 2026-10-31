#!/usr/bin/env bash
# ==============================================================================
# Script: 01-environment-setup.sh
# Lab: GSP395 - Create and Manage AlloyDB Instances
# Environment: Google Cloud Shell
# Description: Set environment variables and verify project configuration.
# ==============================================================================

set -euo pipefail

echo "==> Configuring Google Cloud environment variables..."

export REGION="us-west1"
export ZONE="us-west1-b"
export CLUSTER_ID="lab-cluster"
export PRIMARY_ID="lab-instance"
export READ_POOL_ID="lab-instance-rp1"
export BACKUP_ID="lab-backup"
export NETWORK_ID="peering-network"
export CLIENT_VM="alloydb-client"

export PROJECT_ID=$(gcloud config get-value project)

echo "PROJECT_ID:   ${PROJECT_ID}"
echo "REGION:       ${REGION}"
echo "ZONE:         ${ZONE}"
echo "CLUSTER_ID:   ${CLUSTER_ID}"
echo "PRIMARY_ID:   ${PRIMARY_ID}"
echo "READ_POOL_ID: ${READ_POOL_ID}"
echo "BACKUP_ID:    ${BACKUP_ID}"
echo "NETWORK_ID:   ${NETWORK_ID}"

# Verify active project and region
gcloud config set compute/region "${REGION}"
gcloud config set compute/zone "${ZONE}"

echo "==> Environment configuration complete."

