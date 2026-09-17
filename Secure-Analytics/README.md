# Secure Analytics - Google Cloud Arcade & DevOps Track

Welcome to the **Secure Analytics** module repository within the **Arcade--Google_Cloud_DevOps** collection. This repository is dedicated to advanced Site Reliability Engineering (SRE), Kubernetes security, microservices telemetry, and Cloud observability practices on Google Cloud Platform (GCP).

---

## Module Index & Labs

| Lab / Project Directory | Lab ID | Domain | Key Learnings & Practices | Status |
|---|---|---|---|---|
| [`Debug-Apps-on-Google-Kubernetes-Engine/`](Debug-Apps-on-Google-Kubernetes-Engine/README.md) | GSP736 | GKE & Observability | GKE Diagnostics, Cloud Logging Filters, Logs-Based Metrics (`Error_Rate_SLI`), Cloud Monitoring Alerting, Pod CrashLoop Triage, YAML Configuration Fixes | Completed |

---

## Advanced Hands-On Practice Roadmap

To maximize learning and turn lab foundations into production-grade DevOps/SRE skills, this track follows an advanced 4-stage practice framework:

```text
[Stage 1: Foundational Lab Execution]
    ├── Deploy multi-container GKE microservices
    ├── Configure Cloud Logging filters & logs-based metrics
    └── Set up threshold-based Cloud Monitoring alerts
            ↓
[Stage 2: Advanced Observability & Telemetry]
    ├── Instrument custom Prometheus metrics & Grafana dashboards
    ├── Define Availability & Latency SLOs with Error Budgets
    └── Correlate Cloud Trace spans across gRPC microservices
            ↓
[Stage 3: GitOps & Declarative Operations]
    ├── Store Kubernetes manifests in Git repository
    ├── Implement ArgoCD / FluxCD for automated deployment sync
    └── Enforce Kyverno / OPA Gatekeeper security policies
            ↓
[Stage 4: Chaos Engineering & Resilience Testing]
    ├── Inject synthetic latency using LitmusChaos / Chaos Mesh
    ├── Simulate node pool degradation and pod eviction
    └── Validate automated self-healing & PagerDuty incident alerts
```

---

## SRE Incident Response Playbook Quick Reference

When managing production microservice incidents on GKE, follow this standardized 6-phase SRE playbook:

1. **Detect**: Telemetry systems (Cloud Monitoring / Prometheus) catch metric anomaly or SLI threshold breach.
2. **Acknowledge**: On-call SRE acknowledges alert, opens incident ticket, and establishes communication bridge.
3. **Contain**: Mitigate user impact (e.g., enable caching, scale replicas, reroute traffic via Service Mesh).
4. **Isolate**: Inspect logs (`kubectl logs`, Cloud Logging), pod states (`kubectl get pods`), and container events to pinpoint failing component.
5. **Remediate**: Apply fix via declarative manifest update (`kubectl apply` / GitOps PR) and monitor rolling rollout.
6. **Post-Mortem**: Document root cause, timeline, impact, and preventive action items (blameless post-mortem).

---

## Core Technical Focus Areas

### 1. Kubernetes Container Observability & Telemetry
- Deploying multi-container microservice applications (Online Boutique) on Google Kubernetes Engine (GKE).
- Creating custom user-defined logs-based metrics in Cloud Logging to capture application-level Service Level Indicators (SLIs).
- Configuring automated Cloud Monitoring alerting policies based on error thresholds.

### 2. SRE Incident Triage & Root Cause Remediation
- Diagnosing cascading microservices failures under active synthetic load (Locust).
- Isolating pod crash loops (`CrashLoopBackOff`) and memory exhaustion issues using `kubectl get pods` and container stdout logs.
- Performing configuration-based remediation by stripping bad environment variables (`ENABLE_RELOAD`) from Kubernetes manifests and initiating rolling updates.

---

## Technology Stack

| Category | Technologies / Services |
|---|---|
| **Cloud Provider** | Google Cloud Platform (GCP) |
| **Container Orchestration** | Google Kubernetes Engine (GKE), Docker |
| **Telemetry & Observability** | Cloud Logging, Cloud Monitoring, Logs-Based Metrics (`Error_Rate_SLI`) |
| **Infrastructure & CLI** | `kubectl`, Google Cloud Shell, Kubernetes YAML Manifests |
| **Load Testing** | Locust Load Generator |

---

## Lab Documentation Highlights

- 📄 **[Debug Apps on Google Kubernetes Engine (GSP736)](Debug-Apps-on-Google-Kubernetes-Engine/README.md)**: Full end-to-end incident response guide complete with 8 screenshot evidence proofs, SRE troubleshooting workflow, SLI/SLO math equations, advanced debugging cheatsheet, and lessons learned.

---

## Portfolio Relevance & Evidence Integrity

- **Target Roles**: Cloud Engineer, DevOps Engineer, Site Reliability Engineer (SRE), Platform Engineer.
- **Evidence Integrity**: All documented lab work is verified using empirical screenshots stored within subfolder `Screenshot/` directories.
- **Security**: No production credentials, active project IDs, or confidential secrets are included. All labs were completed within sandboxed Google Cloud Qwiklabs environments.
