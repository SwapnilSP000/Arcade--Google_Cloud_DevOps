#!/usr/bin/env bash
# ==============================================================================
# Script: 05-configure-metric-filter.sh
# Lab: GSP364 - Monitor Environments with Managed Service for Prometheus
# Environment: Google Cloud Shell
# Description: Apply OperatorConfig filter to govern exported Prometheus metrics.
# ==============================================================================

set -euo pipefail

echo "==> Authoring op-config.yaml with metric filtering rules..."
cat > op-config.yaml <<'EOF'
apiVersion: monitoring.googleapis.com/v1
kind: OperatorConfig
metadata:
  namespace: gmp-public
  name: config
collection:
  filter:
    matchOneOf:
    - '{job="prom-example"}'
    - '{__name__=~"job:.+"}'
EOF

echo "==> Applying op-config.yaml to cluster in gmp-public namespace..."
kubectl apply -f op-config.yaml

echo "==> Verifying OperatorConfig status..."
kubectl get operatorconfig -n gmp-public config -o yaml

