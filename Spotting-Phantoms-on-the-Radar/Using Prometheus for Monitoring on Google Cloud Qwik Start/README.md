# Using Prometheus for Monitoring on Google Cloud: Qwik Start (GSP1024)

A comprehensive Google Cloud DevOps & Observability portfolio project demonstrating how to deploy **Google Cloud Managed Service for Prometheus** on **Google Kubernetes Engine (GKE)**, containerize and publish an instrumented **Python Flask** application with **Artifact Registry**, scrape metrics using the Kubernetes **PodMonitoring** Custom Resource Definition (CRD), and visualize live telemetry with **Cloud Monitoring** dashboards.

[![Google Cloud](https://img.shields.io/badge/Google%20Cloud-GCP-4285F4?logo=googlecloud&logoColor=white)](https://cloud.google.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-GKE-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Managed Service for Prometheus](https://img.shields.io/badge/Monitoring-Managed%20Prometheus-E6522C?logo=prometheus&logoColor=white)](https://cloud.google.com/stackdriver/docs/managed-prometheus)
[![Artifact Registry](https://img.shields.io/badge/Registry-Artifact%20Registry-4285F4?logo=googlecloud&logoColor=white)](https://cloud.google.com/artifact-registry)
[![Python Flask](https://img.shields.io/badge/Application-Python%20Flask-000000?logo=flask&logoColor=white)](https://flask.palletsprojects.com/)
[![Cloud Monitoring](https://img.shields.io/badge/Observability-Cloud%20Monitoring-4285F4?logo=googlecloud&logoColor=white)](https://cloud.google.com/monitoring)

---

## Lab Information

| Metadata Field | Specification Details |
|---|---|
| **Official Lab Title** | Using Prometheus for Monitoring on Google Cloud: Qwik Start |
| **Lab ID** | GSP1024 |
| **Platform** | Google Cloud Skills Boost / Qwiklabs |
| **Difficulty** | Introductory |
| **Duration** | 25 minutes |
| **Cost** | No cost |
| **Category** | Google Cloud, Kubernetes, DevOps, Monitoring, Observability |
| **Lab Project ID** | `qwiklabs-gcp-02-d727e6223035` *(Ephemeral lab environment)* |
| **Lab Region & Zone** | `europe-west1` / `europe-west1-d` |
| **Documentation Status** | Complete & Verified *(Empirical evidence backed)* |

---

## Overview

In microservices architectures, monitoring application health, request throughput, latency histograms, and error rates is essential for Site Reliability Engineering (SRE). **Prometheus** has emerged as the cloud-native industry standard for metric instrumentation, collection, and alerting. However, hosting and maintaining self-managed Prometheus servers at scale introduces operational overhead, including managing persistent storage, high availability, cross-cluster metric federation, and long-term retention.

**Google Cloud Managed Service for Prometheus (GMP)** provides a fully managed, multi-cloud-compatible Prometheus service built on Google's global planetary-scale monitoring infrastructure (Monarch). It eliminates manual capacity planning, storage management, and Prometheus server maintenance while retaining native PromQL compatibility and standard metric exposition formats.

This hands-on engineering lab demonstrates how to:
1. Provision a Google Cloud **Artifact Registry** Docker repository (`docker-repo`) and stage an instrumented Python Flask container image (`flask-telemetry:v1`).
2. Deploy a **Google Kubernetes Engine (GKE)** cluster (`gmp-cluster`) with native **Managed Service for Prometheus** enabled via a single control-plane flag.
3. Configure workload isolation using the dedicated Kubernetes namespace `gmp-test`.
4. Deploy the instrumented Python Flask web application and expose it to internet traffic via a Layer 4 Kubernetes `LoadBalancer` service.
5. Deploy a declarative Kubernetes **PodMonitoring** Custom Resource to automatically discover, scrape, and forward `/metrics` to Google Cloud Managed Service for Prometheus.
6. Generate synthetic user traffic across valid (`200 OK`) and invalid (`404 Not Found`) endpoints.
7. Build an executive **Cloud Monitoring** dashboard (**Prometheus Dashboard Example**) querying ingested Prometheus counters (`prometheus/flask_http_request_total/counter`) using `ALIGN_MEAN` rate aggregation.

---

## Lab Objectives

- Deploy Google Cloud Managed Service for Prometheus to a GKE cluster with automated collection.
- Load, tag, and publish an instrumented Python Flask container image to Artifact Registry.
- Deploy the Flask microservice in the `gmp-test` namespace and expose it via an external LoadBalancer service.
- Verify real-time application metric exposition at the `/metrics` endpoint.
- Configure declarative scraping using the `PodMonitoring` custom resource.
- Generate concurrent synthetic HTTP traffic to trigger metric counter increments.
- Build a custom Cloud Monitoring dashboard to visualize Prometheus telemetry grouped by HTTP response codes.

---

## Technologies Used

- **Google Cloud Platform (GCP)**: Cloud infrastructure provider.
- **Google Kubernetes Engine (GKE)**: Managed Kubernetes cluster runtime for container orchestration.
- **Google Cloud Managed Service for Prometheus**: Serverless, planet-scale Prometheus metric ingestion, storage, and PromQL evaluation engine.
- **Artifact Registry**: Next-generation OCI-compliant container registry for storing and securing Docker images.
- **Docker**: Container runtime and image packaging tool.
- **Kubernetes & `kubectl`**: Declarative workload orchestration, namespace management, and custom resource configuration.
- **Python Flask & `prometheus_flask_exporter`**: Microservice web framework exposing runtime metrics (`flask_http_request_total`, `flask_http_request_duration_seconds`).
- **Cloud Monitoring**: Unified metrics explorer and dashboarding service querying Prometheus metrics via Monarch.
- **PromQL & Prometheus Metrics**: Time-series query language and standard exposition format (`counter`, `gauge`, `histogram`).
- **Cloud Shell & `gcloud` CLI**: Programmatic cloud command-line management.

---

## Architecture

The diagram below illustrates the documented workflow from local artifact loading to real-time Cloud Monitoring dashboard visualization:

```mermaid
flowchart TD
    subgraph DeveloperWorkspace ["1. Developer Workspace & Image Management"]
        Shell["Google Cloud Shell<br/>(Developer Environment)"]
        PrebuiltArchive["Prebuilt Image Archive<br/>(flask_telemetry.zip / tar)"]
        AR["Artifact Registry<br/>(docker-repo in europe-west1)<br/>Image: flask-telemetry:v1"]

        Shell -->|Downloads & Unzips| PrebuiltArchive
        PrebuiltArchive -->|docker load & docker tag| Shell
        Shell -->|docker push| AR
    end

    subgraph GKECluster ["2. GKE Cluster (gmp-cluster) with Managed Prometheus"]
        GMPCollector["GMP Managed Collector DaemonSet<br/>(Auto-configured on node)"]
        
        subgraph NamespaceTest ["Kubernetes Namespace: gmp-test"]
            FlaskPod["Flask Application Pod<br/>(Python Web App)<br/>Port: 5000 / Endpoint: /metrics"]
            FlaskSvc["Kubernetes Service: flask-service<br/>(Type: LoadBalancer / External IP: 34.22.113.80)"]
            PodMonCRD["PodMonitoring CRD<br/>(Target: app=flask-telemetry<br/>Path: /metrics / Interval: 30s)"]
            
            FlaskSvc -->|Routes Port 80 to 5000| FlaskPod
            PodMonCRD -.->|Instructs Scrape| GMPCollector
            GMPCollector -->|Scrapes HTTP GET /metrics| FlaskPod
        end
    end

    subgraph MonitoringBackend ["3. Google Cloud Observability Backend"]
        Monarch["Managed Service for Prometheus<br/>(Global Monarch Storage Engine)"]
        Dashboard["Cloud Monitoring Dashboard<br/>('Prometheus Dashboard Example')<br/>Query: flask_http_request_total/counter"]

        GMPCollector -->|Secure gRPC Ingestion| Monarch
        Monarch -->|Evaluates ALIGN_MEAN & Groups by Status| Dashboard
    end

    AR -.->|Pulls flask-telemetry:v1| FlaskPod

    classDef dev fill:#1e293b,stroke:#3b82f6,stroke-width:2px,color:#e2e8f0;
    classDef k8s fill:#1e3a1e,stroke:#4caf50,stroke-width:2px,color:#ffffff;
    classDef obs fill:#451a03,stroke:#d97706,stroke-width:2px,color:#fef3c7;

    class Shell,PrebuiltArchive,AR dev;
    class GMPCollector,FlaskPod,FlaskSvc,PodMonCRD k8s;
    class Monarch,Dashboard obs;
```

---

## Important Configuration Reference

| Resource | Value / Name | Purpose |
|---|---|---|
| **Lab ID** | `GSP1024` | Google Cloud Skills Boost Official Identifier |
| **Artifact Registry Repository** | `docker-repo` | Standard Docker format repository in `europe-west1` |
| **Container Image Tag** | `flask-telemetry:v1` | Application image reference published to Artifact Registry |
| **GKE Cluster** | `gmp-cluster` | Single-node GKE cluster (`e2-medium`) with Managed Prometheus enabled |
| **GKE Zone** | `europe-west1-d` | Target deployment zone |
| **Kubernetes Namespace** | `gmp-test` | Isolated namespace for application workloads and monitoring CRDs |
| **Kubernetes Service** | `flask-service` | L4 LoadBalancer exposing port 80 externally to target port 5000 |
| **PodMonitoring Resource** | `prom-example` | Declarative CRD specifying scrape targets, interval (30s), and port |
| **Cloud Monitoring Dashboard** | `Prometheus Dashboard Example` | Custom dashboard displaying rate of `flask_http_request_total/counter` |

---

## Step-by-Step Implementation & Empirical Evidence

### Task 1 — Create Artifact Registry Repository & Stage Container Image

Artifact Registry was selected to store the containerized application image. Rather than compiling from source, the lab utilizes a prebuilt container archive `flask_telemetry.zip`:

```bash
# 1. Set environment variables
export PROJECT_ID=$(gcloud config get-value project)
export REGION="europe-west1"
export ZONE="europe-west1-d"

# 2. Create Artifact Registry Docker repository
gcloud artifacts repositories create docker-repo \
  --repository-format=docker \
  --location="${REGION}" \
  --description="Docker repository for Prometheus telemetry lab"

# 3. Download and extract prebuilt Flask telemetry container archive
wget https://storage.googleapis.com/spls/gsp1024/flask_telemetry.zip
unzip flask_telemetry.zip

# 4. Load Docker image archive into local daemon
docker load -i flask_telemetry.tar

# 5. Tag image for Artifact Registry
docker tag gcr.io/ops-demo-330920/flask_telemetry:61a2a7aabc7077ef474eb24f4b69faeab47deed9 \
  ${REGION}-docker.pkg.dev/${PROJECT_ID}/docker-repo/flask-telemetry:v1

# 6. Configure Docker authentication and push image
gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/docker-repo/flask-telemetry:v1
```

![Figure 1: Artifact Registry Repository Verified in Console](./Screenshot/Screenshot%202026-10-28%20115547.png)
*Figure 1: Google Cloud Console UI verifying the creation of repository `docker-repo` (Standard Docker format, active vulnerability scanning, Google-managed encryption) located in `europe-west1` (Belgium).*

![Figure 2: Loading, Tagging, and Pushing Flask Container Image](./Screenshot/image.png)
*Figure 2: Cloud Shell terminal showing download of `flask_telemetry.zip` (345.54 MB), archive extraction, `docker load` importing image digest `61a2a7aabc7077...`, tagging as `flask-telemetry:v1`, and pushing image layers to `europe-west1-docker.pkg.dev/qwiklabs-gcp-02-d727e6223035/docker-repo/flask-telemetry:v1`.*

---

### Task 2 — Provision GKE Cluster with Managed Prometheus

A GKE cluster was created with the `--enable-managed-prometheus` flag. This automated flag instructs Google Cloud to provision and manage the lightweight Prometheus collector daemon and custom resource definitions without requiring Helm charts or manual operator installations:

```bash
# Provision GKE cluster with Managed Prometheus enabled
gcloud beta container clusters create gmp-cluster \
  --num-nodes=1 \
  --zone="${ZONE}" \
  --machine-type="e2-medium" \
  --enable-managed-prometheus

# Retrieve cluster authentication credentials for kubectl
gcloud container clusters get-credentials gmp-cluster --zone="${ZONE}"
```

![Figure 3: GKE Cluster Provisioning with Managed Prometheus](./Screenshot/image%20copy.png)
*Figure 3: Cloud Shell terminal showing execution of `gcloud beta container clusters create gmp-cluster --num-nodes=1 --zone europe-west1-d --enable-managed-prometheus`. Output confirms healthy control plane creation, GKE version `1.36.4-gke.2046003`, Master IP `34.79.167.223`, machine type `e2-medium`, `RUNNING` status, and successful generation of the local `kubeconfig` entry.*

---

### Task 3 — Set Up Monitoring Namespace

To isolate lab workloads from default cluster system pods, the dedicated namespace `gmp-test` was created:

```bash
kubectl create ns gmp-test
```

---

### Task 4 — Deploy the Flask Application & PodMonitoring Resource

1. The sample manifests were downloaded and unpacked:
   ```bash
   wget https://storage.googleapis.com/spls/gsp1024/gmp_prom_setup.zip
   unzip gmp_prom_setup.zip
   cd gmp_prom_setup
   ```
2. The deployment manifest `flask_deployment.yaml` was updated to reference the newly pushed container image:
   `europe-west1-docker.pkg.dev/<PROJECT_ID>/docker-repo/flask-telemetry:v1`
3. The deployment and LoadBalancer service were applied:
   ```bash
   kubectl -n gmp-test apply -f flask_deployment.yaml
   kubectl -n gmp-test apply -f flask_service.yaml
   ```
4. Once the service allocated an external IP (`34.22.113.80`), metric exposition was verified via web browser and curl:

![Figure 4: Flask Application Exposing Raw Prometheus Metrics](./Screenshot/image%20copy%202.png)
*Figure 4: Web browser verification at `http://34.22.113.80/metrics` demonstrating live Prometheus metrics served by `prometheus_flask_exporter`. Visible metrics include histograms (`flask_http_request_duration_seconds`), metadata gauges (`flask_exporter_info{version="0.18.5"}`), and request counters (`flask_http_request_total{method="GET",status="200"} 5.0`).*

5. Metric scraping was enabled by applying the declarative `PodMonitoring` custom resource:
   ```yaml
   apiVersion: monitoring.googleapis.com/v1
   kind: PodMonitoring
   metadata:
     name: prom-example
     namespace: gmp-test
   spec:
     selector:
       matchLabels:
         app: flask-telemetry
     endpoints:
     - port: web
       interval: 30s
       path: /metrics
   ```
   ```bash
   kubectl -n gmp-test apply -f prom_deploy.yaml
   ```

6. Application traffic was generated by invoking endpoints in a bash loop to generate telemetry:
   ```bash
   export SERVICE_IP=$(kubectl get service -n gmp-test flask-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   
   # Generate successful requests (HTTP 200)
   for i in {1..50}; do curl -s "http://${SERVICE_IP}/" > /dev/null; sleep 0.2; done
   
   # Generate not-found requests (HTTP 404)
   for i in {1..20}; do curl -s "http://${SERVICE_IP}/non-existent-path" > /dev/null; sleep 0.2; done
   ```

---

### Task 5 — Build Cloud Monitoring Dashboard

A custom Cloud Monitoring dashboard was constructed to visualize the scraped Prometheus metrics. The dashboard queries the monarch metric descriptor `prometheus.googleapis.com/flask_http_request_total/counter`:
- **Metric**: `prometheus/flask_http_request_total/counter`
- **Transformation / Aggregation**: `ALIGN_MEAN` calculates the per-second rate of incoming HTTP requests.
- **Grouping**: Grouped by HTTP status code (`status="200"` and `status="404"`).

![Figure 5: Cloud Monitoring Prometheus Dashboard Visualizing Real Traffic](./Screenshot/image%20copy%203.png)
*Figure 5: Cloud Monitoring dashboard titled "Prometheus Dashboard Example". The line chart plots `prometheus/flask_http_request_total/counter [MEAN]` over a 15-minute window, clearly capturing the traffic surge peaking at ~0.24 requests/sec before tapering off. The legend distinguishes between HTTP 200 (blue) and HTTP 404 (green) response codes.*

---

## Commands Reference for Resource Inspection

Below is a reference of diagnostic commands used to verify the deployed infrastructure:

```bash
# 1. Inspect active project configuration
gcloud config list project

# 2. Re-authenticate kubectl credentials for the cluster
gcloud container clusters get-credentials gmp-cluster --zone europe-west1-d

# 3. Verify GKE cluster nodes
kubectl get nodes -o wide

# 4. Check application pod status in the monitoring namespace
kubectl get pods -n gmp-test -o wide

# 5. Check LoadBalancer service and obtain external IP
kubectl get services -n gmp-test

# 6. Discover monitoring API resources (confirms GMP CRDs are installed)
kubectl api-resources | grep -i monitoring

# 7. Inspect PodMonitoring custom resource status
kubectl get podmonitoring -n gmp-test
kubectl describe podmonitoring prom-example -n gmp-test

# 8. Test the live metrics endpoint directly
curl -s http://<EXTERNAL_IP>/metrics | grep flask_http_request_total
```

---

## Evidence & Verification Audit

| Figure | Screenshot Path | Workflow Stage | Empirical Evidence Visible | Audit Status |
|---|---|---|---|---|
| **Figure 1** | [`./Screenshot/Screenshot 2026-10-28 115547.png`](./Screenshot/Screenshot%202026-10-28%20115547.png) | Artifact Registry Setup | Console UI confirming repository `docker-repo` (Docker, Standard, `europe-west1`) | **VERIFIED** |
| **Figure 2** | [`./Screenshot/image.png`](./Screenshot/image.png) | Container Build & Push | Cloud Shell showing `unzip flask_telemetry.zip`, `docker load`, tagging `v1`, and successful push to Artifact Registry | **VERIFIED** |
| **Figure 3** | [`./Screenshot/image copy.png`](./Screenshot/image%20copy.png) | GKE Cluster Creation | `gcloud beta container clusters create` output confirming `gmp-cluster` (`1.36.4-gke`, `RUNNING`) with Managed Prometheus enabled | **VERIFIED** |
| **Figure 4** | [`./Screenshot/image copy 2.png`](./Screenshot/image%20copy%202.png) | Metric Exposition | Browser accessing `http://34.22.113.80/metrics` displaying raw Prometheus metrics and counter values | **VERIFIED** |
| **Figure 5** | [`./Screenshot/image copy 3.png`](./Screenshot/image%20copy%203.png) | Dashboard Telemetry | Cloud Monitoring dashboard `Prometheus Dashboard Example` showing live request rates grouped by status 200/404 | **VERIFIED** |

### Disclosure of Non-Captured / Missing Evidence
In accordance with strict portfolio integrity rules:
- ❌ **Lab Instructions / Scorecard Screenshot**: The final 100% checkpoint scorecard was not recorded in the screenshot folder; all 5 technical tasks were validated empirically via live terminal outputs, raw endpoint responses, and dashboard telemetry.
- ❌ **`prom_deploy.yaml` Terminal Execution**: Terminal output of `kubectl apply -f prom_deploy.yaml` is not explicitly screenshotted, but its successful operation is proven by Figure 5 confirming metrics were scraped and ingested into Cloud Monitoring.

---

## Troubleshooting Guide

### 1. Image Pull Failures (`ErrImagePull` / `ImagePullBackOff`)
- **Symptom**: Application pod remains in `ImagePullBackOff`.
- **Cause**: Typo in the Artifact Registry image path inside `flask_deployment.yaml`, or missing IAM permissions on the GKE default node service account.
- **Resolution**:
  - Run `kubectl describe pod -n gmp-test <pod-name>` to check the exact failed image URL.
  - Verify that the image exists using `gcloud artifacts docker images list europe-west1-docker.pkg.dev/<PROJECT_ID>/docker-repo`.
  - Ensure the image path follows the format `${REGION}-docker.pkg.dev/${PROJECT_ID}/docker-repo/flask-telemetry:v1`.

### 2. Service External IP Remains `<pending>`
- **Symptom**: `kubectl get svc -n gmp-test` displays `<pending>` for `EXTERNAL-IP`.
- **Cause**: Google Cloud Network Load Balancer provisioning takes 30–60 seconds to bind a public IPv4 address and configure firewall health checks.
- **Resolution**: Allow up to 1 minute for the cloud provider controller to allocate the external IP. If persistent, check cluster quotas in the selected region.

### 3. Empty Metrics Dashboard in Cloud Monitoring
- **Symptom**: The chart displays "No data available" for `prometheus/flask_http_request_total/counter`.
- **Cause**:
  1. Synthetic traffic has not been generated yet.
  2. The `PodMonitoring` selector does not match the deployment labels (`app: flask-telemetry`).
  3. The time window is misconfigured.
- **Resolution**:
  - Verify the label selector: `kubectl get pods -n gmp-test --show-labels` and compare with `prom_deploy.yaml`.
  - Send test curl requests to `http://<EXTERNAL_IP>/` to increment the counter.
  - Set the Cloud Monitoring time range to **Last 15 minutes** or **Last 1 hour** and select auto-refresh.

---

## Results and Learning Outcomes

- **Container Lifecycle with Artifact Registry**: Extracted, tagged, and published production container images to Google Cloud Artifact Registry using secure regional endpoints.
- **Managed Prometheus on GKE**: Provisioned a GKE cluster with zero-overhead Prometheus collection enabled natively at the platform level.
- **Declarative Metric Ingestion**: Implemented the `PodMonitoring` custom resource to scrape `/metrics` endpoints using Kubernetes-native label selectors.
- **Enterprise Observability**: Correlated application HTTP traffic with Prometheus counters and built custom rate visualizations in Cloud Monitoring.
- **Site Reliability Engineering Practices**: Gained hands-on experience debugging cloud load balancers, container pull errors, and PromQL metric alignment (`ALIGN_MEAN`).

---

## References

- **Google Cloud Managed Service for Prometheus Documentation:** [Managed Service for Prometheus Overview](https://cloud.google.com/stackdriver/docs/managed-prometheus)
- **Google Kubernetes Engine Documentation:** [GKE Cluster Creation Guide](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-zonal-cluster)
- **Artifact Registry Documentation:** [Managing Docker Container Repositories](https://cloud.google.com/artifact-registry/docs/docker)
- **Cloud Monitoring Dashboards:** [Building and Managing Custom Dashboards](https://cloud.google.com/monitoring/charts/dashboards)
- **Google Cloud Skills Boost Official Lab:** [Using Prometheus for Monitoring on Google Cloud: Qwik Start (GSP1024)](https://www.cloudskillsboost.google/focuses/43734?parent=catalog)
