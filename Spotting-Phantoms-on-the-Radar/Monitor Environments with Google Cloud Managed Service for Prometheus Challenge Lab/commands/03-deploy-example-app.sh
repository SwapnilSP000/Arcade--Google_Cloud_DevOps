#!/usr/bin/env bash
# ==============================================================================
# Script: 03-deploy-example-app.sh
# Lab: GSP364 - Monitor Environments with Managed Service for Prometheus
# Environment: Google Cloud Shell
# Description: Deploy the instrumented example application emitting metrics.
# ==============================================================================

set -euo pipefail

echo "==> Deploying example application manifest from official prometheus-engine..."
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/main/examples/example-app.yaml

echo "==> Verifying application deployment, service, and pods..."
kubectl get deployment prom-example
kubectl get service prom-example
kubectl get pods -l app=prom-example

