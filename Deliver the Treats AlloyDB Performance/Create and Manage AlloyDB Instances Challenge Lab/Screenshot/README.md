# Screenshot Evidence Directory (GSP395)

This directory contains forensic screenshot evidence captured during the execution of **Google Cloud Skills Boost Lab: GSP395 — Create and Manage AlloyDB Instances**.

---

## Evidence Inventory

| Screenshot Filename | Source Stage | What It Genuinely Proves |
|---|---|---|
| [`01-alloydb-client-vm-instance.png`](./01-alloydb-client-vm-instance.png) | **Tasks 1 & 5** | Google Cloud Console view of the `alloydb-client` Compute Engine VM instance in `us-west1-b` with Status: `Running` and boot disk image `ci-alloydb-client`. |
| [`02-startup-vm-observability-metrics.png`](./02-startup-vm-observability-metrics.png) | **Tasks 1 & 5** | Google Cloud Console Observability metrics dashboard showing operational network connectivity, disk throughput, and IOPS telemetry for VM infrastructure in the lab project. |
| [`03-read-pool-backup-and-resource-verification.png`](./03-read-pool-backup-and-resource-verification.png) | **Tasks 10, 11 & 12** | Cloud Shell terminal displaying successful CLI commands: creating read pool `lab-instance-rp1` (2 nodes, 2 vCPU), creating on-demand backup `lab-backup`, listing instances showing both `PRIMARY` and `READ_POOL` in `READY` status, and listing backups showing `lab-backup` in `READY` status. |

---

## Recommended Additional Screenshot Evidence (Optional for Future Runs)

If performing additional practice runs, the following complementary screenshots may be captured:

1. **AlloyDB Cluster & Primary Instance Overview**: Google Cloud Console UI showing `lab-cluster` and `lab-instance` in `READY` state.
2. **PostgreSQL SSL Connection**: Terminal output demonstrating `psql -h <IP> -U postgres -d postgres "sslmode=require"` displaying the `SSL connection (protocol: TLSv1.3, cipher: ...)` notification.
3. **Table & Record Verification**: Terminal view of the `psql` console running `\dt` and `SELECT ... COUNT(*)` returning the 19 inserted records.
4. **Skills Boost 100/100 Completion Score Banner**: Header assessment banner confirming the completed lab score.

