#!/usr/bin/env bash
# ==============================================================================
# Script: 04-verify-prometheus.sh
# Lab: GSP364 - Monitor Environments with Managed Service for Prometheus
# Environment: Google Cloud Shell
# Description: Verify all running pods, services, and PodMonitoring resources.
# ==============================================================================

set -euo pipefail

echo "=============================================================================="
echo "==> Cluster Workloads Status across all namespaces:"
echo "=============================================================================="
kubectl get pods -A

echo ""
echo "=============================================================================="
echo "==> Kubernetes Services across all namespaces:"
echo "=============================================================================="
kubectl get services -A

echo ""
echo "=============================================================================="
echo "==> PodMonitoring Custom Resources across all namespaces:"
echo "=============================================================================="
kubectl get podmonitoring -A

