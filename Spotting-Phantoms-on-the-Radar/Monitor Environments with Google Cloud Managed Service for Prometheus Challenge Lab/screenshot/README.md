# Screenshot Evidence Directory (GSP364)

This directory contains forensic screenshot evidence captured during the execution of **Google Cloud Skills Boost Challenge Lab: GSP364 — Monitor Environments with Google Cloud Managed Service for Prometheus: Challenge Lab**.

---

## Evidence Inventory

| Screenshot Filename | Related Lab Task | Verified Visible Content & Evidence Proved |
|---|---|---|
| [`01-gke-cluster-created-with-managed-prometheus.png`](./01-gke-cluster-created-with-managed-prometheus.png) | **Task 1** | Cloud Shell terminal executing `gcloud container clusters create gmp-cluster --zone=europe-west1-c --num-nodes=1 --enable-managed-prometheus`, generating kubeconfig, displaying cluster status `RUNNING`, running `kubectl get nodes` (node `Ready`), and cloning `prometheus-engine`. |
| [`02-managed-collection-and-operator-verified.png`](./02-managed-collection-and-operator-verified.png) | **Task 2** | Cloud Shell terminal listing Prometheus namespaces and resources: `collector-64nbw` (2/2 Running), `gmp-operator` (1/1 Running) in `gmp-system`, `operatorconfig` resource `config` in `gmp-public`, and preparing to apply `example-app.yaml`. |
| [`03-example-app-running-and-services-listed.png`](./03-example-app-running-and-services-listed.png) | **Task 3 & 4** | Cloud Shell terminal confirming `deployment.apps/prom-example created`, running `kubectl get pods -A` showing 3x `prom-example` pods (1/1 Running) in `default` namespace, and `kubectl get services -A` listing cluster IP services. |
| [`04-gke-cluster-observability-dashboard.png`](./04-gke-cluster-observability-dashboard.png) | **Task 4 & 5** | Google Cloud Console GKE Observability dashboard for `gmp-cluster` displaying real-time Kubernetes events, container error logs, and cluster telemetry. |
| [`05-cloud-shell-editor-op-config-yaml.png`](./05-cloud-shell-editor-op-config-yaml.png) | **Task 5 & 6** | Google Cloud Shell Editor showing the `gsp364/prometheus-engine` workspace with `op-config.yaml` authored and staged for Cloud Storage upload. |

---

## Recommended Additional Screenshot Evidence (Optional for Future Runs)

If performing additional practice runs, the following complementary screenshots may be captured:

1. **Cloud Storage Bucket & Object**: Google Cloud Console Cloud Storage browser showing `op-config.yaml` in bucket `gs://$PROJECT`.
2. **Metrics Explorer Query**: Cloud Monitoring Metrics Explorer interface graphing `up` or filtered `prom-example` metrics.
3. **Challenge Lab 100/100 Completion Score Banner**: Skills Boost lab banner confirming 100/100 assessment score.

