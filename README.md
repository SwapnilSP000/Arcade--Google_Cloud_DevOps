# Google Cloud DevOps & SRE Engineering Lab

> Hands-on engineering practice for building, deploying, troubleshooting, automating, and securing cloud-native systems with Google Cloud, Kubernetes, CI/CD, Infrastructure as Code, observability, security, and Site Reliability Engineering.

[![Google Cloud](https://img.shields.io/badge/Google%20Cloud-GCP-4285F4?logo=googlecloud&logoColor=white)](https://www.skills.google/public_profiles/e1158899-3f93-4f1a-be6a-398d495945a0)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Hands--On-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![DevOps](https://img.shields.io/badge/Focus-DevOps-2496ED)](https://github.com/SwapnilSP000/Arcade--Google_Cloud_DevOps)
[![SRE](https://img.shields.io/badge/Focus-SRE-5C2D91)](https://github.com/SwapnilSP000/Arcade--Google_Cloud_DevOps)
[![Google Skills Boost](https://img.shields.io/badge/Google%20Cloud-Skills%20Boost%20Profile-EA4335?logo=google&logoColor=white)](https://www.skills.google/public_profiles/e1158899-3f93-4f1a-be6a-398d495945a0)
[![Credly Badges](https://img.shields.io/badge/Credly-Verified%20Badges-FF6F00?logo=credly&logoColor=white)](https://www.credly.com/users/swapnil-patil.bbda7d25/badges/credly)

---

## 👤 Verified Profiles & Badges

- **Google Cloud Skills Boost Profile:** [skills.google/public_profiles/e1158899-3f93-4f1a-be6a-398d495945a0](https://www.skills.google/public_profiles/e1158899-3f93-4f1a-be6a-398d495945a0)
- **Credly Badges:** [credly.com/users/swapnil-patil.bbda7d25/badges/credly](https://www.credly.com/users/swapnil-patil.bbda7d25/badges/credly)
- **GitHub Repository:** [github.com/SwapnilSP000/Arcade--Google_Cloud_DevOps](https://github.com/SwapnilSP000/Arcade--Google_Cloud_DevOps)

---

## 🎯 Engineering Mindset

This repository documents hands-on cloud engineering implementations, moving beyond basic tutorials toward production-ready architectures and troubleshooting practices:

```text
Learn  ──▶  Practice  ──▶  Reproduce  ──▶  Break  ──▶  Troubleshoot  ──▶  Fix  ──▶  Automate  ──▶  Measure  ──▶  Improve
```

---

## 📂 Repository Architecture & Modules

### 1. 🚦 [Production Traffic & Load Balancing](./Production%20Traffic%20%26%20Load%20Balancing)
Implementation of enterprise-grade traffic engineering, load balancing topologies, and high-availability patterns across Compute Engine and Managed Instance Groups (MIG).
* **Set Up Network Load Balancers (`GSP007`)**: Layer 4 regional passthrough load balancing with target pools and health checks.
* **Set Up Application Load Balancers (`GSP155`)**: Layer 7 global HTTP(S) load balancing, URL maps, backend services, and target HTTP proxies.
* **Use an Internal Application Load Balancer (`GSP041`)**: Private regional L7 proxy for zero-public-IP microservices tiers.
* **Challenge Lab (`GSP313`)**: End-to-end multi-tier load balancing implementation under timed challenge conditions.

### 2. 🛡️ [Secure Multi-VPC Architecture](./Secure-Multi-VPC-Architecture)
Enterprise network design focusing on zero-trust isolation, private connectivity, and granular traffic controls.
* **Multiple VPC Networks**: Dual-homed bastion hosts, non-default subnet topologies, and cross-network routing.
* **VPC Networks - Controlling Access**: Tag-based firewall rules, service accounts, and least-privilege network security.
* **Enhance Application Reliability & Scalability with Internal LB**: High-availability internal backend scaling.
* **Challenge Lab**: Building secure, resilient Google Cloud networks from scratch.

### 3. ☸️ [Deploy Kubernetes Applications on Google Cloud](./Deploy-Kubernetes-Applications-on-Google-Cloud)
Containerization, cluster provisioning, and microservice orchestration using Google Kubernetes Engine (GKE).
* **Introduction to Docker**: Image building, layer caching, Dockerfile optimization, and container lifecycles.
* **GKE Qwik Start**: Multi-zone cluster orchestration and automated pod scheduling.
* **Orchestrating the Cloud with Kubernetes**: Pods, Deployments, Services, ConfigMaps, Secrets, and rolling updates.
* **Challenge Lab**: GKE deployment automation and production-grade workload configuration.

### 4. 🔍 [Secure Analytics & Observability](./Secure-Analytics)
Cloud monitoring, troubleshooting, and resilient runtime operations.
* **Debug Apps on Google Kubernetes Engine**: Identifying crash loops, broken deployments, resource bottlenecks, and log investigation.

---

## 🛠️ Key Technologies & Skills

* **Cloud Platform:** Google Cloud Platform (Compute Engine, GKE, Cloud VPC, Cloud Load Balancing, Cloud NAT, Cloud Armor)
* **Containers & Orchestration:** Docker, Kubernetes, Google Kubernetes Engine (GKE), Helm
* **Networking & Security:** Custom VPCs, VPC Peering, Cloud Firewall Rules, Internal & External L4/L7 Load Balancers
* **DevOps & SRE:** Managed Instance Groups (MIG), Rolling Updates, Health Checking, Observability, Fault Isolation

---

## 🚀 Quick Git Workflow

```bash
# Check status
git status

# Stage all files
git add .

# Commit changes
git commit -m "feat: add production traffic, multi-vpc architecture labs and profile badges"

# Push to GitHub main branch
git push origin main
```
