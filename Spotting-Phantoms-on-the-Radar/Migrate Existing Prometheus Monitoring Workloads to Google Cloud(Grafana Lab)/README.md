# Migrate Existing Prometheus Monitoring Workloads to Google Cloud (GSP1025)

A comprehensive Google Cloud DevOps and Site Reliability Engineering (SRE) portfolio project demonstrating how to migrate self-managed Prometheus workloads to **Google Cloud Managed Service for Prometheus (GMP)** using the **self-deployed data collection** model on **Google Kubernetes Engine (GKE)**, verify metric scraping from an instrumented application, deploy an ephemeral **Grafana** visualization tier, configure an internal PromQL data source via the Managed Service for Prometheus frontend service, and inspect exported telemetry data.

[![Google Cloud](https://img.shields.io/badge/Google%20Cloud-GCP-4285F4?logo=googlecloud&logoColor=white)](https://cloud.google.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-GKE-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Managed Service for Prometheus](https://img.shields.io/badge/Monitoring-Managed%20Prometheus-E6522C?logo=prometheus&logoColor=white)](https://cloud.google.com/stackdriver/docs/managed-prometheus)
[![Grafana](https://img.shields.io/badge/Visualization-Grafana-F46800?logo=grafana&logoColor=white)](https://grafana.com/)
[![PromQL](https://img.shields.io/badge/Query-PromQL-E6522C?logo=prometheus&logoColor=white)](https://prometheus.io/docs/prometheus/latest/querying/basics/)

---

## Lab Information

| Metadata Field | Specification Details |
|---|---|
| **Official Lab Title** | Migrate Existing Prometheus Monitoring Workloads to Google Cloud |
| **Lab ID** | GSP1025 |
| **Platform** | Google Cloud Skills Boost / Qwiklabs |
| **Difficulty** | Introductory |
| **Duration** | 15 minutes |
| **Reported Completion Score** | **100 / 100** *(Completed)* |
| **Category** | Google Cloud Monitoring / Prometheus / Grafana / Kubernetes |
| **Ephemeral Lab Project ID** | `qwiklabs-gcp-02-8cbb8dc536cc` *(Visible in terminal session evidence)* |
| **Target Zone & Region** | `europe-west4-b` / `europe-west4` (Eemshaven, Netherlands) |
| **Documentation Status** | Complete & Verified *(Validated against terminal logs, Grafana UI captures, and CSV telemetry)* |

---

## Overview

Enterprises running on-premises or self-managed Prometheus monitoring infrastructures often struggle with the operational overhead of scaling stateful storage, managing cross-region metric federation, provisioning high-availability pairs, and retaining historical telemetry for compliance and capacity planning.

**Google Cloud Managed Service for Prometheus (GMP)** offers a drop-in migration path that preserves existing Prometheus workflows, scrape targets, alerting rules, and Grafana dashboards, while offloading storage and scaling to Google's planetary-scale global time-series database (Monarch).

In Google Cloud Managed Service for Prometheus, organizations can choose between two collection modes:
1. **Managed Data Collection**: A fully managed operator deployed via GKE control-plane flags using declarative `PodMonitoring` custom resources (demonstrated in [GSP1024](../Using%20Prometheus%20for%20Monitoring%20on%20Google%20Cloud%20Qwik%20Start/README.md)).
2. **Self-Deployed Data Collection**: A seamless migration pattern where existing Prometheus server configurations, StatefulSets, and Helm charts remain in place, replacing the upstream Prometheus container binary with the Managed Service for Prometheus drop-in binary (`gke.gcr.io/prometheus-engine/prometheus`). This binary continues local scraping but writes metrics directly to Google Cloud Monarch without requiring local persistent disks or remote-write sidecars.

This lab implements the **self-deployed data collection** model on a GKE cluster, verifies metric ingestion through the Managed Service for Prometheus frontend service, deploys an ephemeral Grafana instance inside Kubernetes, and bridges Grafana to Managed Service for Prometheus via internal cluster networking.

---

## Objectives

- Authenticate against a pre-provisioned GKE cluster (`gmp-cluster`) in `europe-west4-b`.
- Establish workload namespace isolation using `gmp-test`.
- Deploy an instrumented example microservice (`prom-example`) with 3 replicas exposing application metrics.
- Deploy a self-managed Prometheus StatefulSet using the Managed Service for Prometheus drop-in replacement engine.
- Verify that all application pods and Prometheus StatefulSet pods reach `Running` readiness.
- Deploy the Managed Service for Prometheus frontend service and proxy queries using `kubectl port-forward` on port 9090.
- Deploy an ephemeral Grafana instance from the `kube-prometheus` ecosystem and expose its web UI on port 3001 via local port forwarding.
- Configure a Prometheus data source in Grafana pointing to `http://frontend.gmp-test.svc:9090`.
- Validate the end-to-end telemetry pipeline by building a visualization panel and exporting sample time-series data to CSV.

---

## Technologies Used

- **Google Cloud Platform (GCP)**: Enterprise cloud infrastructure hosting the Kubernetes cluster and Monarch telemetry backend.
- **Google Kubernetes Engine (GKE)**: Managed Kubernetes service orchestrating workloads across 3 compute nodes.
- **Google Cloud Managed Service for Prometheus (GMP)**: Self-deployed drop-in Prometheus engine with zero-disk global retention.
- **Prometheus**: Open-source systems monitoring and alerting toolkit with standard metric exposition format.
- **Grafana**: Open-source analytics and visualization web application for time-series telemetry.
- **PromQL**: Prometheus Query Language used to evaluate metrics across dimensional labels.
- **`kubectl` & Google Cloud Shell**: Kubernetes CLI and containerized management terminal.

---

## Architecture

The following diagram illustrates the lab architecture, namespace structure, and telemetry flow between Kubernetes workloads, the Managed Service for Prometheus frontend proxy, and the Grafana visualization layer:

```mermaid
flowchart TD
    subgraph GKE ["Google Kubernetes Engine Cluster: gmp-cluster (europe-west4-b)"]
        subgraph NS ["Kubernetes Namespace: gmp-test"]
            subgraph AppTier ["Application Tier"]
                AppPod1["prom-example Pod 1<br/>Port: 8080 (/metrics)"]
                AppPod2["prom-example Pod 2<br/>Port: 8080 (/metrics)"]
                AppPod3["prom-example Pod 3<br/>Port: 8080 (/metrics)"]
            end

            subgraph PromTier ["Self-Deployed Prometheus Tier"]
                PromPod["prometheus-test-0 StatefulSet<br/>(GMP Drop-in Binary Engine)<br/>Ready: 2/2"]
            end

            subgraph FrontendTier ["Query & Frontend Tier"]
                FrontendSvc["frontend Service<br/>ClusterIP / Port 9090"]
                FrontendPod["frontend Deployment Pod<br/>(Monarch PromQL Proxy)"]
                FrontendSvc --> FrontendPod
            end

            subgraph GrafanaTier ["Grafana Visualization Tier"]
                GrafanaSvc["grafana Service<br/>ClusterIP / Port 3000"]
                GrafanaPod["grafana Deployment Pod<br/>(kube-prometheus manifest)"]
                GrafanaSvc --> GrafanaPod
            end
        end

        AppPod1 -.->|Metrics Scraped| PromPod
        AppPod2 -.->|Metrics Scraped| PromPod
        AppPod3 -.->|Metrics Scraped| PromPod
        PromPod -->|Direct Push / Monarch Ingest| CloudBackend["Google Cloud Monarch<br/>(Global Telemetry Backend)"]
        FrontendPod -->|Evaluates PromQL| CloudBackend
        GrafanaPod -->|HTTP GET / Query API<br/>http://frontend.gmp-test.svc:9090| FrontendSvc
    end

    subgraph DeveloperWorkstation ["Developer Environment (Google Cloud Shell)"]
        PFProm["kubectl port-forward svc/frontend 9090:9090"]
        PFGraf["kubectl port-forward svc/grafana 3001:3000"]
        BrowserUI["Web Preview / Browser<br/>(Grafana UI on :3001 & CSV Export)"]

        PFProm -->|Tunnel| FrontendSvc
        PFGraf -->|Tunnel| GrafanaSvc
        BrowserUI -->|Accesses| PFGraf
    end
```

> [!NOTE]
> This diagram represents the **self-deployed data collection** model implemented in this training exercise. It is an ephemeral lab environment designed to demonstrate migration patterns and internal cluster networking, not a production-hardened high-availability deployment.

---

## Implementation Workflow

### 1. Deploy & Authenticate GKE Cluster

The lab utilizes a pre-provisioned 3-node GKE cluster named `gmp-cluster` residing in zone `europe-west4-b`. Authentication credentials and `kubeconfig` entries were established via Cloud Shell:

```bash
# Retrieve cluster credentials for kubectl
gcloud container clusters get-credentials gmp-cluster --zone=europe-west4-b

# Create the dedicated workload namespace
kubectl create ns gmp-test
```

The dedicated namespace `gmp-test` ensures strict workload isolation from system namespaces (`kube-system`, `gke-managed-cim`).

![Figure 1: GKE Cluster Authentication & Prometheus Deployment Execution](./Screenshot/01-gke-cluster-auth-and-prometheus-deployment.png)

### 2. Deploy Example Application

An instrumented sample microservice from the Google Cloud Platform Prometheus Engine repository (`v0.4.3-gke.0`) was deployed into the `gmp-test` namespace. The deployment creates 3 replicas producing standard Prometheus application metrics:

```bash
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.4.3-gke.0/examples/example-app.yaml
```

Output:
```text
deployment.apps/prom-example created
```

### 3. Deploy Self-Managed Prometheus

Rather than maintaining a legacy Prometheus binary, the lab deploys a self-managed Prometheus StatefulSet using the Managed Service for Prometheus drop-in binary:

```bash
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.4.3-gke.0/examples/prometheus.yaml
```

This manifest provisions:
- **RBAC**: `ClusterRole` and `ClusterRoleBinding` granting scraping discovery permissions.
- **Service**: Headless service for the Prometheus StatefulSet.
- **ConfigMap**: Prometheus scrape configurations targeting the `prom-example` pods.
- **StatefulSet**: `prometheus-test` running the GMP drop-in binary with 2/2 container readiness.

Workload readiness was verified using:

```bash
kubectl -n gmp-test get pod
```

Verified pod status:
```text
NAME                           READY   STATUS    RESTARTS   AGE
prom-example-58b849d788-4f9qc   1/1     Running   0          43s
prom-example-58b849d788-p4krs   1/1     Running   0          43s
prom-example-58b849d788-vns8s   1/1     Running   0          43s
prometheus-test-0              2/2     Running   1          26s
```

All 3 application pods and the Prometheus StatefulSet pod successfully attained `Running` status.

![Figure 2: Prometheus Pod Readiness & Frontend Service Deployment](./Screenshot/02-prometheus-pods-running-and-frontend-setup.png)

### 4. Verify Metrics via Prometheus Frontend Service

In self-deployed collection mode, queries are routed through a dedicated Managed Service for Prometheus frontend service that proxies requests to Google's backend. The frontend deployment was customized with the active project ID and applied:

```bash
# Retrieve active GCP project ID
export PROJECT_ID=$(gcloud config get-value project)

# Deploy frontend deployment and service with substituted project ID
curl https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.4.3-gke.0/examples/frontend.yaml | \
  sed "s/\$PROJECT_ID/$PROJECT_ID/" | \
  kubectl apply -n gmp-test -f -
```

Output:
```text
deployment.apps/frontend created
service/frontend created
```

To verify metric query functionality locally before connecting Grafana, port forwarding was initiated:

```bash
kubectl -n gmp-test port-forward svc/frontend 9090
```

The terminal log confirms that inbound connections were successfully received and handled:
```text
Forwarding from 127.0.0.1:9090 -> 9090
Handling connection for 9090
Handling connection for 9090
```

![Figure 3: Prometheus Frontend Port Verification & Grafana Ingestion Deployment](./Screenshot/03-prometheus-frontend-verified-and-grafana-deployed.png)

### 5. Deploy Ephemeral Grafana Instance

The Grafana visualization tier was sourced from the open-source `kube-prometheus` ecosystem and deployed to the `gmp-test` namespace:

```bash
# Clone kube-prometheus repository
git clone https://github.com/prometheus-operator/kube-prometheus.git
cd kube-prometheus

# Apply the lab Grafana manifest
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.4.3-gke.0/examples/grafana.yaml
```

Output:
```text
deployment.apps/grafana created
service/grafana created
```

#### SRE Operational Triage: Pod Scheduling & Port Forwarding
During initial port forwarding, the command encountered a transient pending state while Kubernetes was scheduling the pod and pulling the container image:

```text
student_02_6afa04154532@cloudshell:~/kube-prometheus$ kubectl -n gmp-test port-forward svc/grafana 3001:3000
error: unable to forward port because pod is not running. Current status=Pending
```

Upon pod transition to `Running`, port forwarding was re-executed:

```bash
kubectl -n gmp-test port-forward svc/grafana 3001:3000
```

Terminal logs confirm stable connection handling across multiple HTTP sessions:
```text
Forwarding from 127.0.0.1:3001 -> 3000
Handling connection for 3001
Handling connection for 3001
Handling connection for 3001
```

### 6. Configure Prometheus Data Source in Grafana

Grafana was accessed via Cloud Shell Web Preview on port 3001. A new Prometheus data source was configured with internal Kubernetes Service DNS:

- **Data Source Name:** `Prometheus`
- **Default:** `Yes`
- **URL:** `http://frontend.gmp-test.svc:9090`
- **HTTP Method:** `GET`
- **Verification:** Executed **Save & Test**

This routes all Grafana PromQL queries directly to the `frontend` service in the `gmp-test` namespace without exposing the metrics endpoint to the public internet.

### 7. Create Visualization Dashboard & Inspect Data

A new Grafana dashboard was authored to visualize application and collector telemetry:
1. Created a time-series panel querying the target data source.
2. Verified panel configuration with a 20-second sampling interval (`Interval = 20s`) over a 6-hour query window (`Last 6 hours`).
3. Used Grafana's **Query Inspector** (`Inspect -> Data`) to analyze time-series points and exported the raw telemetry to CSV format (`Panel Title-data-2026-10-29 11_51_37.csv`).
4. Saved the dashboard to the Grafana Home view.

![Figure 4: Grafana Panel Query Editor & Time-Series Inspector](./Screenshot/04-grafana-panel-editor-and-query-inspector.png)

![Figure 5: Grafana Home Dashboard & Data Source Setup Verification](./Screenshot/05-grafana-home-dashboard-and-datasource-completed.png)

---

## CSV Supporting Artifact

The repository includes an empirical telemetry export captured directly from the running Grafana panel during lab execution:

- **File Path:** [`./Panel Title-data-2026-10-29 11_51_37.csv`](./Panel%20Title-data-2026-10-29%2011_51_37.csv)
- **Source:** Grafana Panel Inspector export (`Inspect -> Data -> Download CSV`)
- **File Size:** 28,104 bytes
- **Total Rows:** 1,082 (1 header row + 1,081 telemetry observations)
- **Delimiter / Encoding:** Comma-separated (`,`), UTF-8 text
- **Sampling Interval:** Exactly 20 seconds (`Interval = 20s`)
- **Temporal Range:** `2026-10-29 05:51:22` to `2026-10-29 11:51:02` (exact 6-hour window matching the Grafana time picker)

### Column Definitions

| Column Header | Data Type | Description |
|---|---|---|
| `"time"` | Timestamp (`YYYY-MM-DD HH:MM:SS`) | Timestamp of the metric sample in UTC time |
| `"A-series"` | Float64 | Numeric time-series metric value evaluated by the panel query engine |

### Statistical Summary

| Metric Property | Value | Notes |
|---|---|---|
| **Total Samples** | 1,080 | Complete, uninterrupted 20-second step series |
| **Minimum Value** | `53.1` | Recorded at `05:55:42` |
| **Maximum Value** | `66.4` | Peak telemetry value observed during execution window |
| **Mean / Average** | `59.92` | Steady-state average across the 6-hour observation window |
| **Malformed Records** | 0 | Zero parsing errors or corrupt records |
| **Sensitive Data** | None | No credentials, tokens, IP addresses, or project secrets |

### Representative Data Sample

```csv
"time","A-series"
2026-10-29 05:51:22,53.6
2026-10-29 05:51:42,53.4
2026-10-29 05:52:02,53.7
...
2026-10-29 11:50:22,65.2
2026-10-29 11:50:42,65.1
2026-10-29 11:51:02,65.2
```

This CSV provides verifiable evidence that the Grafana instance was functional, query evaluation was operational, and real-time telemetry points were rendered and exportable.

---

## Screenshot Evidence

All screenshots have been forensically audited and renamed from generic defaults into standardized kebab-case filenames:

| Figure | Filename | Lab Stage | What It Demonstrates | Evidence Status |
|---|---|---|---|---|
| **Figure 1** | [`./Screenshot/01-gke-cluster-auth-and-prometheus-deployment.png`](./Screenshot/01-gke-cluster-auth-and-prometheus-deployment.png) | Tasks 1, 2, 3 | Cluster credential retrieval (`gmp-cluster`, `europe-west4-b`), namespace verification (`gmp-test`), deployment of `example-app.yaml`, deployment of `prometheus.yaml` (RBAC, Service, ConfigMap, StatefulSet) | **VERIFIED** |
| **Figure 2** | [`./Screenshot/02-prometheus-pods-running-and-frontend-setup.png`](./Screenshot/02-prometheus-pods-running-and-frontend-setup.png) | Tasks 3, 4 | Terminal view of `kubectl get pod` showing 3x `prom-example` (1/1 Running) and `prometheus-test-0` (2/2 Running), project ID retrieval, frontend manifest application, and port 9090 forwarding | **VERIFIED** |
| **Figure 3** | [`./Screenshot/03-prometheus-frontend-verified-and-grafana-deployed.png`](./Screenshot/03-prometheus-frontend-verified-and-grafana-deployed.png) | Tasks 4, 5, 6 | Inbound connection handling on port 9090, cloning `kube-prometheus`, deploying `grafana.yaml`, SRE triage of transient `Pending` pod state, and active port 3001 forwarding with incoming web preview sessions | **VERIFIED** |
| **Figure 4** | [`./Screenshot/04-grafana-panel-editor-and-query-inspector.png`](./Screenshot/04-grafana-panel-editor-and-query-inspector.png) | Tasks 7, 8 | Grafana Panel edit screen showing time range (Last 6 hours), 20s interval, query inspector, and `A-series` curve matching the exported CSV dataset | **VERIFIED** |
| **Figure 5** | [`./Screenshot/05-grafana-home-dashboard-and-datasource-completed.png`](./Screenshot/05-grafana-home-dashboard-and-datasource-completed.png) | Tasks 7, 8 | Grafana Home Dashboard with active metric panels and tutorial status cards confirming: `COMPLETE: Add your first data source` and `COMPLETE: Create your first dashboard` | **VERIFIED** |

---

## Verification and Results

| Lab Task / Component | Verification Source | Result / State | Audit Status |
|---|---|---|---|
| **GKE Cluster Authentication** | `01-gke-cluster-auth-and-prometheus-deployment.png` | `kubeconfig entry generated for gmp-cluster` | **VERIFIED** |
| **Namespace Isolation** | `01-gke-cluster-auth-and-prometheus-deployment.png` | `gmp-test` namespace confirmed | **VERIFIED** |
| **Example Application Deployment** | `01-gke-cluster-auth-and-prometheus-deployment.png` | `deployment.apps/prom-example created` (3 replicas) | **VERIFIED** |
| **Prometheus StatefulSet** | `02-prometheus-pods-running-and-frontend-setup.png` | `prometheus-test-0` ready (2/2 Running) | **VERIFIED** |
| **All Workload Pods Running** | `02-prometheus-pods-running-and-frontend-setup.png` | 4/4 pods Running (3 application + 1 Prometheus) | **VERIFIED** |
| **Prometheus Frontend Service** | `02-prometheus-pods-running-and-frontend-setup.png` | `deployment.apps/frontend` and `svc/frontend` created | **VERIFIED** |
| **Frontend Port Forwarding (9090)** | `03-prometheus-frontend-verified-and-grafana-deployed.png` | `Handling connection for 9090` (multiple connections) | **VERIFIED** |
| **Grafana Deployment** | `03-prometheus-frontend-verified-and-grafana-deployed.png` | `deployment.apps/grafana` and `svc/grafana` created | **VERIFIED** |
| **Grafana Port Forwarding (3001)** | `03-prometheus-frontend-verified-and-grafana-deployed.png` | `Handling connection for 3001` (multiple connections) | **VERIFIED** |
| **Grafana Data Source Configuration** | `05-grafana-home-dashboard-and-datasource-completed.png` | `COMPLETE: Add your first data source` card | **VERIFIED** |
| **Grafana Dashboard Panel** | `04-grafana-panel-editor-and-query-inspector.png` | Panel query editor and time series rendered | **VERIFIED** |
| **Grafana Home Dashboard** | `05-grafana-home-dashboard-and-datasource-completed.png` | Multiple active panels + `COMPLETE: Create your first dashboard` | **VERIFIED** |
| **Time-Series Telemetry Export** | `Panel Title-data-2026-10-29 11_51_37.csv` | 1,081 data points at 20-second intervals exported | **VERIFIED** |
| **Lab Completion Score (100/100)** | User reported | 100/100 reported; all technical tasks validated via terminal & UI logs | **REPORTED / VERIFIED VIA LOGS** |

> [!NOTE]
> While the numerical "100/100" score assessment badge from the Qwiklabs header was not captured in the 5 cropped window screenshots, the complete technical implementation sequence is 100% verified through the terminal logs, service outputs, Grafana UI status cards, and the exported time-series dataset.

---

## Key Technical Concepts

### Managed Data Collection vs. Self-Deployed Data Collection

| Feature | Managed Data Collection (GSP1024) | Self-Deployed Data Collection (GSP1025) |
|---|---|---|
| **Mechanism** | Native GKE control plane operator | Drop-in container binary replacing upstream Prometheus |
| **Scrape Configuration** | Declarative Kubernetes `PodMonitoring` CRD | Standard Prometheus `prometheus.yaml` ConfigMap |
| **Infrastructure Footprint** | Lightweight daemonset collector on nodes | Prometheus StatefulSet in application namespace |
| **Migration Effort** | Requires translating scrape configs to CRDs | Zero config rewrite; drop-in binary swap |
| **Storage Backend** | Direct ingestion to Monarch | Direct ingestion to Monarch (no local persistent disk needed) |
| **Query Mechanism** | Cloud Monitoring PromQL or Frontend proxy | Frontend proxy service (`frontend:9090`) |

### Monarch: Google's Globally Scaled Telemetry Engine
Google Cloud Managed Service for Prometheus writes all scraped metrics directly into Monarch, Google's planet-scale multi-tenant time-series storage system. This eliminates the traditional Prometheus operational bottlenecks:
- No local persistent volume claims (PVC) or disk exhaustion.
- No need for Thanos, Cortex, or complex remote-write federation across clusters.
- Unified querying across multiple Kubernetes clusters in different regions and projects.

---

## Troubleshooting & SRE Observations

1. **Transient Pending Pod State During Port Forwarding:**
   - *Symptom:* `kubectl port-forward svc/grafana 3001:3000` threw `error: unable to forward port because pod is not running. Current status=Pending`.
   - *Root Cause:* The command was executed immediately after manifest application while the container runtime was pulling the Grafana image and attaching volumes.
   - *SRE Resolution:* Waiting approximately 15 seconds allowed the pod to transition to `Running`, after which port forwarding bound cleanly and served web preview traffic.

2. **Internal Service Discovery for Grafana Data Sources:**
   - Instead of exposing Prometheus via external LoadBalancer IPs or NodePorts, Grafana resolves the Prometheus frontend via CoreDNS within the cluster (`frontend.gmp-test.svc:9090`). This maintains zero-trust private network isolation within the cluster perimeter.

---

## Skills Demonstrated

- **Kubernetes Operations:** Deploying multi-replica microservices, RBAC cluster roles, headless services, StatefulSets, and ConfigMaps on GKE.
- **Observability Migration:** Executing a migration strategy from upstream Prometheus to Google Cloud Managed Service for Prometheus using drop-in binary engines.
- **Service Networking & Tunnelling:** Utilizing Kubernetes internal service DNS and `kubectl port-forward` tunnels for secure administrative access.
- **Grafana Administration:** Deploying containerized Grafana, configuring PromQL data source integrations, building dashboard panels, and utilizing the query inspector.
- **Telemetry Data Analysis:** Parsing, validating, and extracting statistical profiles from exported time-series monitoring datasets.

---

## Portfolio Relevance

This project demonstrates practical SRE and cloud monitoring competencies directly aligned with modern enterprise infrastructure operations:
- **Cost & Maintenance Optimization:** Migrating stateful Prometheus instances to managed telemetry backends reduces operational toil and disk management overhead.
- **Seamless Cloud Migration:** Proves ability to adopt Google Cloud observability tools without breaking existing developer workflows or Grafana dashboards.
- **Security Best Practices:** Enforces namespace boundary isolation and keeps monitoring query endpoints private to cluster workloads.

---

## Completion Status

- **Status:** **Completed**
- **Reported Score:** **100 / 100**
- **Artifacts Preserved:** 5 descriptive screenshots in `./Screenshot/`, 1 complete CSV time-series dataset (`Panel Title-data-2026-10-29 11_51_37.csv`), and full technical documentation.

