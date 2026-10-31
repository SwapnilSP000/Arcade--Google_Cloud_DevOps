# Deliver the Treats — AlloyDB Performance & Database Operations

A specialized module repository within the **Arcade--Google_Cloud_DevOps** collection focusing on high-performance database architectures, Google Cloud AlloyDB for PostgreSQL, Private Service Access (PSA) network topologies, read pool scalability, and enterprise Site Reliability Engineering (SRE) database administration practices on Google Cloud Platform.

---

## Portfolio Labs Directory

| Lab Title | Lab ID | Domain | Key Infrastructure & Technologies | Documentation | Status |
|---|---|---|---|---|---|
| **Create and Manage AlloyDB Instances** | **GSP395** | Database Engineering & Cloud Architecture | Google Cloud AlloyDB for PostgreSQL, Compute Engine, Private Service Access (PSA), psql, Read Pools, SSL/TLS, Backups | [README.md](./Create%20and%20Manage%20AlloyDB%20Instances%20Challenge%20Lab/README.md) | **Completed (100/100)** |
| **Accelerating Analytical Queries using the AlloyDB Columnar Engine** | **GSP1087** | Analytical Query Acceleration | AlloyDB Columnar Engine, In-Memory Columnar Store, Hybrid Transactional/Analytical Processing (HTAP) | [Folder](./Accelerating%20Analytical%20Queries%20using%20the%20AlloyDB%20Columnar%20Engine) | *Planned / Staged* |
| **AlloyDB - Database Fundamentals** | **GSP1083** | Cloud Database Fundamentals | AlloyDB Clusters, Primary Instances, psql, Basic DDL/DML, Storage Scaling | [Folder](./AlloyDB%20-%20Database%20Fundamentals) | *Planned / Staged* |
| **Migrate to AlloyDB from PostgreSQL Using Database Migration Service** | **GSP1085** | Database Migration & Homogeneous Transfer | Database Migration Service (DMS), Continuous Replication, PostgreSQL Source to AlloyDB Destination | [Folder](./Migrate%20to%20AlloyDB%20from%20PostgreSQL%20Using%20Database%20Migration%20Service) | *Planned / Staged* |

---

## Architectural Focus Areas

```text
                             Deliver the Treats — AlloyDB Performance
                                                |
        +---------------------------------------+---------------------------------------+
        |                                                                               |
AlloyDB Disaggregated Architecture                                     Enterprise Security & Operations
            (GSP395)                                                                (GSP395)
----------------------------------------                               ------------------------------------------
- Compute & Storage Disaggregation                                     - Private Service Access (PSA) Peering
- Primary Read/Write Instance (2 vCPU)                                 - Mandatory SSL/TLS Transport Encryption
- Multi-Node Analytical Read Pool (2 Nodes)                            - Client Isolation via Dedicated VM
- Multi-Zone Synchronous Storage Engine                                - Non-Disruptive On-Demand Backups
```

---

## Practical Skills Demonstrated

1. **Enterprise Relational Architecture**: Provisioning Google Cloud AlloyDB for PostgreSQL clusters and instances with decoupled compute and multi-zone storage.
2. **Private Network Security**: Configuring Private Service Access (PSA) peering to keep database endpoints private, enforcing zero public IP exposure.
3. **Database Client Administration**: Establishing encrypted database sessions via `psql` using `sslmode=require` from Compute Engine Linux VMs.
4. **Relational Data Engineering**: Designing normalized DDL tables (`regions`, `countries`, `departments`), inserting relational datasets, and performing verification analytics.
5. **Horizontal Read Scaling**: Deploying load-balanced multi-node AlloyDB read pools to offload analytical query traffic from transactional primary instances.
6. **Disaster Recovery & Backup Automation**: Generating on-demand cluster storage snapshots with zero impact on active transactional performance.

