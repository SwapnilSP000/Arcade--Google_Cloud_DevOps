# Secure Multi-VPC Architecture - Google Cloud Arcade & DevOps Track

Welcome to the **Secure Multi-VPC Architecture** module repository within the **Arcade--Google_Cloud_DevOps** collection. This repository is dedicated to cloud networking engineering, Virtual Private Cloud (VPC) topology design, firewall security policies, multi-network interface (Multi-NIC) virtual appliances, and inter-VPC traffic control on Google Cloud Platform (GCP).

---

## Module Index & Labs

| Lab / Project Directory | Lab ID | Domain | Key Learnings & Practices | Status |
|---|---|---|---|---|
| [`Multiple-VPC-Networks/`](Multiple-VPC-Networks/README.md) | GSP211 | Cloud Networking & Architecture | Custom-Mode VPCs, Subnet CIDRs (`10.130.0.0/20`, `172.16.0.0/24`, `172.20.0.0/20`), Ingress Firewall Policies, Multi-NIC VMs (`vm-appliance`), Linux Networking (`ifconfig`, `ip route`), VPC Network Isolation | Completed (100/100) |
| [`VPC-Networks-Controlling-Access/`](VPC-Networks-Controlling-Access/README.md) | GSP213 | Security & Access Control | Custom Web Servers (`blue`/`green`), Network Tags (`web-server`), Ingress Firewall Filtering, IAM Network & Security Admin Roles | In Progress / Documentation Updated |

---

## Cloud Networking Engineering Practice Roadmap

To turn foundational VPC concepts into production-grade Cloud Networking & Security skills, this track follows a 4-stage engineering framework:

```text
[Stage 1: Custom VPC & Subnet Design]
    ├── Provision custom-mode VPC networks & non-overlapping CIDR subnets
    ├── Configure fine-grained firewall policies (ICMP, SSH, RDP)
    └── Enforce default Layer 3 cross-VPC isolation
            ↓
[Stage 2: Multi-NIC & Virtual Appliance Deployment]
    ├── Provision multi-homed VM instances across separate VPC networks
    ├── Audit Linux kernel interfaces (eth0, eth1, eth2) & default routes
    └── Implement policy routing for asymmetric multi-interface traffic
            ↓
[Stage 3: Advanced Inter-VPC Connectivity & Security]
    ├── Establish VPC Network Peering & Cloud VPN IPsec tunnels
    ├── Deploy Private Google Access & Cloud NAT for egress security
    └── Enforce Hierarchical Firewall Policies & Cloud Armor WAF
            ↓
[Stage 4: Automated Network Reliability & Observability]
    ├── Monitor VPC Flow Logs & Packet Mirroring using Cloud Logging
    ├── Execute Network Intelligence Center Connectivity Tests
    └── Automate multi-VPC deployment via Terraform / Cloud Deployment Manager
```

---

## Network Architecture & Topology Quick Reference

### Key VPC Networking Principles:
1. **Custom-Mode Isolation**: Unlike `auto-mode` VPCs which auto-create subnets in every GCP region, `custom-mode` VPCs allow strict administrative control over IP ranges and regional subnet placement.
2. **Layer 3 VPC Isolation**: Instances residing in different VPC networks cannot communicate via internal IP addressing unless explicit transit mechanisms (VPC Network Peering, Cloud VPN, or multi-homed appliances) are configured.
3. **Multi-NIC Appliance Behavior**: A multi-NIC VM receives a primary default route via `eth0`. Secondary interfaces route traffic for directly connected subnets natively, while external egress traffic requires explicit routing configurations.

---

## Technology Stack

| Category | Technologies / Services |
|---|---|
| **Cloud Provider** | Google Cloud Platform (GCP) |
| **Networking Infrastructure** | Virtual Private Cloud (VPC), Subnets, Firewall Rules, Multi-NIC Virtual Appliances |
| **Compute Infrastructure** | Compute Engine VM Instances |
| **CLI & Tools** | `gcloud` SDK, Google Cloud Shell, Linux Network Utilities (`ifconfig`, `ip route`, `ping`) |

---

## Lab Documentation Highlights

- 📄 **[Multiple VPC Networks (GSP211)](Multiple-VPC-Networks/README.md)**: Full end-to-end cloud networking document complete with 9 empirical screenshot evidence proofs, subnetting mathematics, network topology tables, multi-NIC kernel routing analysis, and firewall configurations.

---

## Portfolio Relevance & Evidence Integrity

- **Target Roles**: Cloud Engineer, DevOps Engineer, Network Security Engineer, Platform Engineer.
- **Evidence Integrity**: All documented lab work is verified using empirical screenshots stored within subfolder `Screenshot/` directories.
- **Security**: No production credentials, active project IDs, or confidential secrets are included. All labs were completed within sandboxed Google Cloud Qwiklabs environments.
