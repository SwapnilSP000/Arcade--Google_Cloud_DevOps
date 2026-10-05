# Use an Internal Application Load Balancer

A comprehensive Google Cloud Networking & DevOps portfolio document detailing the architecture, configuration, deployment, and verification of an **Internal Layer 7 Application Load Balancer** on Google Cloud. This project demonstrates how to securely isolate backend microservices within a Virtual Private Cloud (VPC) without exposing public IP addresses, while routing traffic from a public-facing web frontend to a regional backend service.

---

## Lab Information

| Item | Details |
|---|---|
| **Arcade Game** | Arcade Simulator: DevOps Engineer |
| **Lab Name** | Use an Internal Application Load Balancer |
| **Lab ID** | GSP041 |
| **Platform** | Google Cloud Skills Boost / Qwiklabs |
| **Difficulty** | Introductory |
| **Focus** | Internal Application Load Balancing & Microservice Security |
| **Status** | Completed |

---

## Overview

In production enterprise cloud architecture, backend microservices, database clusters, and internal API services should never be directly exposed to the public internet. Instead, ingress traffic should be controlled through multi-tier network topologies where public-facing frontend web servers communicate with backend application tiers via an **Internal Load Balancer**.

Google Cloud **Internal Application Load Balancers** operate at OSI Layer 7 within a Virtual Private Cloud (VPC). They allocate a private Virtual IP (VIP) address from the internal subnet range and distribute internal HTTP/TCP connections across regional backend instance groups. Because backends are provisioned with no external IP addresses (`--no-address`), they are completely protected against external internet scanning, unauthorized ingress, and direct DDoS attacks.

In this lab implementation, a multi-tier microservices application was constructed in region `europe-west1`:
1. **Backend Tier**: A Python HTTP service calculating prime numbers was deployed on an Instance Template (`primecalc`) and managed via a Managed Instance Group (`backend`) of 3 Compute Engine VMs (`backend-nq0w`, `backend-t253`, `backend-w8xj`) provisioned with **no public IP addresses**.
2. **Internal Load Balancer Tier**: An HTTP Health Check (`ilb-health`), a Regional Backend Service (`prime-service`), and an Internal Forwarding Rule (`prime-lb`) were bound to private VIP `10.132.0.10`.
3. **Frontend Tier**: A public-facing web server (`frontend`) was provisioned to query `10.132.0.10` and dynamically generate an interactive 10x10 HTML prime-number matrix, rendering prime numbers in green and non-prime numbers in red.

---

## Network Architecture & Traffic Flow

```text
                                  Public Internet Client
                                             |
                                             v
                                  Public Frontend VM
                               (frontend: 35.240.65.78)
                                             |
                                             | Internal VPC Query (Port 80)
                                             v
                           Internal Load Balancer Virtual IP
                                prime-lb (10.132.0.10)
                                             |
                                             v
                                  Regional Backend Service
                                      (prime-service) <-----+
                                             |              |
              +------------------------------+              |
              |                                             |
              v                                             v
   Managed Instance Group (backend)               HTTP Health Check
       Zone: europe-west1-b                          (ilb-health)
              |                                   [Request Path /2]
     +--------+--------+                            Firewall: http
     |                 |                          (10.132.0.0/20 -> tcp:80)
     v                 v                 v
 backend-nq0w      backend-t253      backend-w8xj
 (10.132.0.3)      (10.132.0.2)      (10.132.0.4)
 External IP: None External IP: None External IP: None
```

![01 Conceptual Architecture Diagram](./Screenshot/01-conceptual-architecture-diagram.png)
*Figure 1: High-level architectural diagram illustrating internal load balancing topology, regional backend services, and multi-zone instance group distribution.*

---

## Technical Specifications

### 1. Compute Engine Instance Inventory

| Resource Name | Role / Scope | Machine Type | Zone / Region | Internal IP | External IP | Security Feature |
|---|---|---|---|---|---|---|
| `backend-nq0w` | Backend Prime Calculator VM | `e2-medium` | `europe-west1-b` | `10.132.0.3` | *None* | Zero Public IP (`--no-address`) |
| `backend-t253` | Backend Prime Calculator VM | `e2-medium` | `europe-west1-b` | `10.132.0.2` | *None* | Zero Public IP (`--no-address`) |
| `backend-w8xj` | Backend Prime Calculator VM | `e2-medium` | `europe-west1-b` | `10.132.0.4` | *None* | Zero Public IP (`--no-address`) |
| `frontend` | Public Web Server | `e2-medium` | `europe-west1-b` | `10.132.0.5` | `35.240.65.78` | Public Ingress Entry Point |

### 2. Ingress Firewall Policy Specifications

| Firewall Rule Name | Network | Direction | Action | Target Tags | Source Range | Allowed Protocols & Ports |
|---|---|---|---|---|---|---|
| `http` | `default` | Ingress | Allow | `backend` | `10.132.0.0/20` | `tcp:80` |

### 3. Load Balancer Component Specifications

| Component | Resource Name | Scope / Scheme | Configuration Details |
|---|---|---|---|
| **Internal VIP** | `prime-lb` | `europe-west1` / `INTERNAL` | Private IPv4 Address (`10.132.0.10`), Network: `default` |
| **Health Check** | `ilb-health` | Global / HTTP | Port: `80`, Request Path: `/2` |
| **Backend Service** | `prime-service` | `europe-west1` / `INTERNAL` | Protocol: `TCP`, Health Check: `ilb-health`, Attached MIG: `backend` |
| **Forwarding Rule** | `prime-lb` | `europe-west1` / `INTERNAL` | IP: `10.132.0.10`, Port: `80`, Target Backend Service: `prime-service` |

---

## Step-by-Step Implementation & Verification

### Task 1 — Create Virtual Environment & Set Region/Zone

The default compute region and zone were set to `europe-west1` and `europe-west1-b`. A Python virtual environment was initialized to run custom microservice scripts.

```bash
# 1. Set default compute region and zone
gcloud config set compute/region europe-west1
gcloud config set compute/zone europe-west1-b

# 2. Install virtualenv package
sudo apt-get install -y virtualenv

# 3. Create and activate Python virtual environment
python3 -m venv venv
source venv/bin/activate
```

![02 Virtual Environment Setup](./Screenshot/02-virtual-environment-setup.png)
*Figure 2: Configuring default region/zone (`europe-west1-b`) and installing `virtualenv` package inside Cloud Shell.*

---

### Task 2 — Create Backend Managed Instance Group & Python Prime Service

The backend tier executes a lightweight Python HTTP server (`serveprimes.py`) that evaluates whether incoming request integer paths are prime numbers (returning `True` or `False`).

#### 1. Backend Startup Script (`backend.sh`)

```bash
sudo chmod -R 777 /usr/local/sbin/
sudo cat << EOF > /usr/local/sbin/serveprimes.py
import http.server

def is_prime(a): return a!=1 and all(a % i for i in range(2,int(a**0.5)+1))

class myHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(s):
        s.send_response(200)
        s.send_header("Content-type", "text/plain")
        s.end_headers()
        s.wfile.write(bytes(str(is_prime(int(s.path[1:]))).encode('utf-8')))

http.server.HTTPServer(("",80),myHandler).serve_forever()
EOF
nohup python3 /usr/local/sbin/serveprimes.py >/dev/null 2>&1 &
```

![03 Backend Prime Service Script](./Screenshot/03-backend-prime-service-script.png)
*Figure 3: Cloud Shell Editor displaying `backend.sh` script containing the Python `is_prime(a)` HTTP service algorithm.*

#### 2. Create Instance Template & Managed Instance Group with `--no-address`

To ensure backend security, the instance template was provisioned with `--no-address` to omit public IP creation.

```bash
# 1. Create Instance Template
gcloud compute instance-templates create primecalc \
  --metadata-from-file startup-script=backend.sh \
  --no-address \
  --tags backend

# 2. Create Ingress Firewall Rule allowing internal VPC traffic
gcloud compute firewall-rules create http \
  --network default \
  --allow=tcp:80 \
  --source-ranges 10.132.0.0/20 \
  --target-tags backend

# 3. Create Managed Instance Group of size 3
gcloud compute instance-groups managed create backend \
  --size 3 \
  --template primecalc \
  --zone europe-west1-b
```

![04 Firewall Rule, MIG, & Health Check Setup](./Screenshot/04-firewall-mig-health-check-and-backend-service.png)
*Figure 4: Output confirming creation of firewall rule `http`, Managed Instance Group `backend` (size 3), health check `ilb-health`, and backend service `prime-service`.*

#### 3. Verify Zero Public IP Assignment

Inspecting the Compute Engine VM instances dashboard confirms that `backend-nq0w`, `backend-t253`, and `backend-w8xj` have internal IPs (`10.132.0.2`–`10.132.0.4`) but **no external IP addresses**:

![05 Backend VMs No External IP](./Screenshot/05-backend-vms-no-external-ip.png)
*Figure 5: Compute Engine console displaying `backend` MIG instances running in `europe-west1-b` with external IP fields set to empty (`None`), proving private network isolation.*

---

### Task 3 — Set Up Internal Application Load Balancer

An Internal Application Load Balancer was constructed to expose a private VIP (`10.132.0.10`) targeting the backend MIG.

```bash
# 1. Create HTTP Health Check probing path /2
gcloud compute health-checks create http ilb-health \
  --request-path /2

# 2. Create Regional Internal Backend Service
gcloud compute backend-services create prime-service \
  --load-balancing-scheme internal \
  --region=europe-west1 \
  --protocol tcp \
  --health-checks ilb-health

# 3. Attach MIG to Backend Service
gcloud compute backend-services add-backend prime-service \
  --instance-group backend \
  --instance-group-zone=europe-west1-b \
  --region=europe-west1

# 4. Create Internal Forwarding Rule bound to VIP 10.132.0.10
gcloud compute forwarding-rules create prime-lb \
  --load-balancing-scheme internal \
  --ports 80 \
  --network default \
  --region=europe-west1 \
  --address 10.132.0.10 \
  --backend-service prime-service
```

---

### Task 4 — Test Internal Load Balancer from Test Instance

A temporary test VM (`testinstance`) was deployed into `europe-west1-b` to query private VIP `10.132.0.10`:

```bash
# Create temporary test instance
gcloud compute instances create testinstance --zone europe-west1-b

# SSH into testinstance and verify responses
curl 10.132.0.10/2   # Returns: True
curl 10.132.0.10/4   # Returns: False
curl 10.132.0.10/5   # Returns: True
```

---

### Task 5 — Deploy Public Frontend Web Server & Verify Prime Matrix

A public-facing web server (`frontend`) was provisioned. Its startup script (`frontend.sh`) executes a Python multithreaded HTTP server that queries `http://10.132.0.10/<number>` for numbers 1 to 100 and generates an HTML grid.

#### 1. Frontend Startup Script (`frontend.sh`)

```bash
cat << EOF > frontend.sh
#!/bin/bash
sudo apt-get update
sudo apt-get install -y python3

cat << 'PYEOF' > /usr/local/sbin/getprimes.py
import http.server
import urllib.request
from multiprocessing.dummy import Pool as ThreadPool

def get_url(url):
    try:
        return urllib.request.urlopen('http://10.132.0.10/' + str(url)).read().decode('utf-8')
    except:
        return "Error"

class myHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(s):
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()
        i = int(s.path[1:]) if (len(s.path)>1) else 1
        s.wfile.write("<html><body><table>".encode('utf-8'))
        pool = ThreadPool(10)
        results = pool.map(get_url, range(i, i+100))
        for x in range(0, 100):
            if not (x % 10): s.wfile.write("<tr>".encode('utf-8'))
            if results[x] == "True":
                s.wfile.write("<td bgcolor='#00ff00'>".encode('utf-8'))
            else:
                s.wfile.write("<td bgcolor='#ff0000'>".encode('utf-8'))
            s.wfile.write((str(x+i) + "</td>").encode('utf-8'))
            if not ((x+1) % 10): s.wfile.write("</tr>".encode('utf-8'))
        s.wfile.write("</table></body></html>".encode('utf-8'))

http.server.HTTPServer(("", 80), myHandler).serve_forever()
PYEOF

nohup python3 /usr/local/sbin/getprimes.py >/dev/null 2>&1 &
EOF

# Deploy Frontend VM
gcloud compute instances create frontend \
  --zone europe-west1-b \
  --metadata-from-file startup-script=frontend.sh

# Create Firewall Rule for Frontend HTTP Access
gcloud compute firewall-rules create webserver \
  --network default \
  --allow=tcp:80 \
  --target-tags http-server
```

![06 Frontend Service Script](./Screenshot/06-frontend-service-script.png)
*Figure 6: Cloud Shell Editor displaying `frontend.sh` Python handler querying internal VIP `10.132.0.10` and constructing prime-number HTML table.*

#### 2. Browser Verification Test

Accessing the public IP of the frontend VM (`http://35.240.65.78`) in a web browser renders the complete 10x10 prime matrix:

![07 Prime Number Matrix Browser Test](./Screenshot/07-prime-number-matrix-browser-test.png)
*Figure 7: Web browser requesting `http://35.240.65.78` rendering a 10x10 grid (numbers 1 to 100). Prime numbers (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97) render in green (`#00ff00`) and composite numbers render in red (`#ff0000`), confirming successful end-to-end internal load balancing.*

---

## Environment Triage & Common Pitfalls

> [!IMPORTANT]
> **1. Private Backend Connectivity Isolation (`--no-address`)**
> 
> Provisioning backend instances with `--no-address` prevents external IP assignment. 
> 
> **Root Cause**: While `--no-address` provides strong security against direct external ingress, backend instances cannot fetch OS packages from public apt repositories unless Cloud NAT or a Private Google Access gateway is enabled.
> 
> **Resolution**: Ensure base VM images or startup scripts contain pre-packaged dependencies or route outbound package traffic through Cloud NAT.

> [!TIP]
> **2. Internal Health Check Request Path (`/2`)**
> 
> The health check `ilb-health` was created with `--request-path /2`.
> 
> **Root Cause**: Standard HTTP health checks target path `/`. However, querying `/` on `serveprimes.py` passes `int("")`, raising a Python `ValueError`. Path `/2` passes `int("2")`, returning `True` with HTTP 200 OK and marking instances `HEALTHY`.

---

## Technical Deep-Dive: Internal vs. External Load Balancing

| Architectural Property | Internal Application Load Balancer (GSP041) | External Application Load Balancer (GSP155) |
|---|---|---|
| **OSI Operating Layer** | Layer 7 (Application Layer) | Layer 7 (Application Layer) |
| **Virtual IP Scope** | Private Internal IPv4 (`10.132.0.10`) | Global Anycast Public IPv4 (`136.82.45.239`) |
| **Backend IP Requirement** | Zero Public IP (`--no-address` supported) | Private internal IPs within VPC |
| **Ingress Access** | Internal VPC clients / Peered VPCs / Cloud VPN | Public Internet clients globally |
| **Backend Resource** | Regional Backend Service (`--load-balancing-scheme internal`) | Global Backend Service |
| **Security Boundary** | High (Restricted to internal VPC CIDR `10.132.0.0/20`) | Public Edge Ingress with Cloud Armor protection |

---

## Evidence & Verification Summary

### Evidence Audit Matrix

| Figure | Screenshot File Path | Workflow Stage | Key Technical Evidence Visible | Verification Status |
|---|---|---|---|---|
| **Figure 1** | `./Screenshot/01-conceptual-architecture-diagram.png` | Architecture Overview | Conceptual diagram illustrating internal load balancing topology and backend MIGs | **VERIFIED** |
| **Figure 2** | `./Screenshot/02-virtual-environment-setup.png` | Task 1: Setup | Setting region `europe-west1`, zone `europe-west1-b`, and installing `virtualenv` | **VERIFIED** |
| **Figure 3** | `./Screenshot/03-backend-prime-service-script.png` | Task 2: Backend Setup | `backend.sh` script containing Python `is_prime(a)` HTTP service handler | **VERIFIED** |
| **Figure 4** | `./Screenshot/04-firewall-mig-health-check-and-backend-service.png` | Task 2 & 3: ILB Core Setup | Firewall `http`, MIG `backend` (size 3), Health Check `ilb-health`, Backend Service `prime-service` | **VERIFIED** |
| **Figure 5** | `./Screenshot/05-backend-vms-no-external-ip.png` | Task 2: Security Audit | Compute Engine console displaying `backend` VMs (`10.132.0.2`–`10.132.0.4`) with **External IP: None** | **VERIFIED** |
| **Figure 6** | `./Screenshot/06-frontend-service-script.png` | Task 5: Frontend Setup | `frontend.sh` script executing multithreaded Python server querying VIP `10.132.0.10` | **VERIFIED** |
| **Figure 7** | `./Screenshot/07-prime-number-matrix-browser-test.png` | Task 5: Verification Test | Browser requesting `http://35.240.65.78` rendering 10x10 prime matrix (Green = Prime, Red = Non-Prime) | **VERIFIED** |

---

## Security & Privacy Audit

- **Secrets & Credentials**: Checked. No API keys, passwords, service account JSON keys, or private SSH keys are exposed.
- **Project Identifiers**: Ephemeral Qwiklabs project ID (`qwiklabs-gcp-01-a88107480883`) is visible in terminal prompt screenshots. These temporary resources automatically expire upon lab teardown.
- **PII / Account Information**: No personal email addresses, phone numbers, or private credentials are included in documentation.

---

## Skills Demonstrated & Portfolio Relevance

### Practical Cloud & DevOps Skills Demonstrated

- **Private Microservice Architecture**: Designing zero-public-IP backend tiers using Compute Engine `--no-address` flags.
- **Internal Traffic Engineering**: Provisioning Regional Internal Application Load Balancers, internal forwarding rules, and private VIPs (`10.132.0.10`).
- **Backend Managed Instance Groups**: Configuring Instance Templates and Managed Instance Groups (`backend`) for scalable internal workloads.
- **Microservice Integration**: Interfacing a public web frontend (`frontend`) with an internal load-balanced microservice via REST/HTTP calls.
- **VPC Security & Firewall Isolation**: Crafting internal VPC firewall policies restricting HTTP access strictly to internal CIDR ranges (`10.132.0.0/20`).

---

## Completion Status

- **Lab ID**: GSP041
- **Lab Name**: Use an Internal Application Load Balancer
- **Execution Score**: 20 / 20 (User-supplied completion info; verified via browser matrix test)
- **Documentation Status**: Complete & Portfolio-Ready

```text
       [GSP041 Completion Status: VERIFIED & AUDITED]
```
