# Spotting Phantoms on the Radar — Cloud Observability & Monitoring

A dedicated module repository within the **Arcade--Google_Cloud_DevOps** collection focusing on advanced cloud-native observability, application telemetry instrumentation, Prometheus monitoring, and Site Reliability Engineering (SRE) practices on Google Cloud Platform.

---

## Portfolio Labs Directory

| Lab Title | Lab ID | Domain | Key Infrastructure & Technologies | Documentation | Status |
|---|---|---|---|---|---|
| **Using Prometheus for Monitoring on Google Cloud: Qwik Start** | **GSP1024** | Observability & Kubernetes | Google Kubernetes Engine (GKE), Google Cloud Managed Service for Prometheus, Artifact Registry, Python Flask, PodMonitoring CRD, Cloud Monitoring Dashboards | [README.md](./Using%20Prometheus%20for%20Monitoring%20on%20Google%20Cloud%20Qwik%20Start/README.md) | **Completed** |

---

## Architectural Focus Areas

```text
                                  Spotting Phantoms on the Radar
                                                |
        +---------------------------------------+---------------------------------------+
        |                                                                               |
Managed Service for Prometheus (GMP)                                   Cloud Monitoring Dashboards
             (GSP1024)                                                              (GSP1024)
----------------------------------------                               ------------------------------------------
- Native GKE Control Plane Integration                                 - Global Multi-Cluster Metric Aggregation
- Automated Scrape via PodMonitoring CRD                               - PromQL Rate Transformations (ALIGN_MEAN)
- Zero-maintenance Monarch Storage Backend                             - Grouping by HTTP Status Codes (200, 404)
- Native Prometheus Exposition Formats                                 - Single-pane SRE Operational Telemetry
```

---

## Practical Skills Demonstrated

1. **Serverless Prometheus Engine**: Eliminating the operational burden of managing Prometheus stateful storage sets and cross-region federation by using Google Cloud Managed Service for Prometheus.
2. **Declarative Kubernetes Scraping**: Employing `PodMonitoring` Custom Resource Definitions to configure target discovery, scrape intervals (30s), and metrics endpoints without modifying Prometheus server configuration files.
3. **Application Telemetry Instrumentation**: Deploying Python Flask microservices instrumented with `prometheus_flask_exporter` to export request counters, latency histograms, and exporter metadata.
4. **Cloud Monitoring Visualizations**: Creating custom monitoring dashboards querying Prometheus metrics with rate alignment and multi-dimensional status-code breakdowns.
