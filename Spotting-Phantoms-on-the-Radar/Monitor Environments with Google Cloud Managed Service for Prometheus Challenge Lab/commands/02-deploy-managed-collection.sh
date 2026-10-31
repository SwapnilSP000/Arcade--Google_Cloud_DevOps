#!/usr/bin/env bash
# ==============================================================================
# Script: 02-deploy-managed-collection.sh
# Lab: GSP364 - Monitor Environments with Managed Service for Prometheus
# Environment: Google Cloud Shell
# Description: Set up directory, clone prometheus-engine, and verify operator.
# ==============================================================================

set -euo pipefail

echo "==> Setting up workspace directory and cloning prometheus-engine repository..."
mkdir -p ~/gsp364 && cd ~/gsp364

if [ ! -d "prometheus-engine" ]; then
  git clone https://github.com/GoogleCloudPlatform/prometheus-engine.git
fi

cd ~/gsp364/prometheus-engine

echo "==> Verifying Prometheus Operator and collector daemonset pods in gmp-system..."
kubectl get pods -n gmp-system

echo "==> Verifying OperatorConfig resource in gmp-public namespace..."
kubectl get operatorconfig -A

