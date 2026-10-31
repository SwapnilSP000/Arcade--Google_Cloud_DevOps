# Monitoring Architecture Overview (GSP364)

This document details the telemetry collection pipeline, component interactions, and metric filtering flow implemented with **Google Cloud Managed Service for Prometheus** in **GSP364: Monitor Environments with Google Cloud Managed Service for Prometheus: Challenge Lab**.

---

## Architecture Diagram

```mermaid
flowchart TD
    subgraph GCP ["Google Cloud Platform (europe-west1-c)"]
        subgraph GKE ["Google Kubernetes Engine (gmp-cluster)"]
            direction TB
            subgraph AppTier ["Workload Tier (Namespace: default)"]
                App["Example Application: prom-example<br/>(3 Pod Replicas)<br/>Image: example-app:v0.4.3-gke.0<br/>Port: 8080"]
                AppSvc["Kubernetes Service: prom-example<br/>ClusterIP: 34.118.237.173:8080"]
                PodMon["PodMonitoring Custom Resource<br/>Target: app=prom-example<br/>Interval: 30s<br/>Port: metrics"]
                AppSvc --- App
            end

            subgraph SystemTier ["Managed Prometheus Infrastructure (Namespace: gmp-system)"]
                Operator["gmp-operator Pod<br/>(Manages Collector Lifecycle & CRDs)"]
                Collector["collector-64nbw DaemonSet Pod<br/>(Scrapes Pods via node-local loop)"]
            end

            subgraph PublicTier ["Operator Configuration (Namespace: gmp-public)"]
                OpConfig["OperatorConfig Resource: config<br/>Filter Rule: matchOneOf<br/>- {job='prom-example'}<br/>- {__name__=~'job:.+'}"]
            end

            PodMon -.->|1. Instructs Scrape Target| Collector
            App -->|2. Emits Telemetry /metrics| Collector
            Operator -.->|3. Synchronizes Filter Rules| Collector
            OpConfig -.->|4. Defines Ingestion Filter| Operator
        end

        subgraph CloudObservability ["Cloud Observability & Verification Tier"]
            Collector -->|5. Pushes Filtered Metrics Only| Monarch["Google Cloud Monarch<br/>(Managed Prometheus Storage Backend)"]
            Monarch -->|6. Query & Dashboard| CloudMonitoring["Cloud Monitoring & Metrics Explorer<br/>(PromQL / MQL Evaluation)"]
            GCS["Cloud Storage Bucket: gs://PROJECT_ID<br/>- op-config.yaml"]
        end

        OpConfig -.->|Archived Configuration Manifest| GCS
    end
```

---

## Component Deep Dive

### 1. Google Kubernetes Engine (`gmp-cluster`)
The cluster is provisioned with `--enable-managed-prometheus`, which instructs the GKE control plane to automatically deploy and maintain the Managed Service for Prometheus operator and node-level collection components without requiring manual Helm chart management or local persistent disk volumes.

### 2. Managed Collection Engine (`gmp-system`)
- **`gmp-operator`**: Automates the lifecycle of collection agents, validates `PodMonitoring` custom resources, and translates `OperatorConfig` rules into local Prometheus collector configurations.
- **`collector` DaemonSet**: Runs on each Kubernetes node, discovering pods matched by `PodMonitoring` resources and scraping endpoints via the node network.

### 3. Application Telemetry (`default` namespace)
The `prom-example` microservice deploys with 3 replicas. Each replica exposes standard Prometheus application metrics on container port `8080` at the `/metrics` endpoint. The `PodMonitoring` custom resource specifies target selectors and a 30-second polling interval.

### 4. Telemetry Egress Filtering (`OperatorConfig`)
By default, Prometheus collectors forward every scraped metric series to the backend. The `OperatorConfig` resource deployed in the `gmp-public` namespace acts as a gateway filter, enforcing `matchOneOf` whitelisting to eliminate unneeded runtime debug metrics and prevent unnecessary storage ingestion costs in Monarch.

### 5. Google Cloud Storage Compliance Archival
The verified `op-config.yaml` is uploaded to an authenticated Google Cloud Storage bucket (`gs://$PROJECT/op-config.yaml`), ensuring infrastructure-as-code versioning and fulfilling assessment verification checks.

