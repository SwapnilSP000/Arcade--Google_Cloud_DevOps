# Production Traffic & Load Balancing

A comprehensive collection of Google Cloud Networking, Traffic Engineering, and Load Balancing portfolio projects detailing Layer 4 Passthrough Network Load Balancing, External Layer 7 Application Load Balancing, and Internal Layer 7 Application Load Balancing across Compute Engine backend VM tiers, Instance Templates, and Managed Instance Groups (MIG).

---

## Portfolio Labs Directory

| Lab Name | Lab ID | OSI Layer | Load Balancer Type | Scope & Security | Key Infrastructure Components | Documentation |
|---|---|---|---|---|---|---|
| **Use an Internal Application Load Balancer** | **GSP041** | Layer 7 (Application) | Regional Internal Application Load Balancer | Private VPC VIP (`10.132.0.10`); Zero Public IP Backends (`--no-address`) | Managed Instance Group, Internal Backend Service, Internal Forwarding Rule, Python Microservice | [README.md](./Use-an-Internal-Application-Load-Balancer/README.md) |
| **Set Up Application Load Balancers** | **GSP155** | Layer 7 (Application) | External HTTP(S) Application Load Balancer | Global Anycast Public IP (`136.82.45.239`); Edge Ingress Proxy | Managed Instance Group, Instance Template, URL Map, Target HTTP Proxy, Health Check Firewalls | [README.md](./Set-Up-Application-Load-Balancers/README.md) |
| **Set Up Network Load Balancers** | **GSP007** | Layer 4 (Transport) | External Passthrough Network Load Balancer | Regional External IP (`136.116.22.246`); Line-rate TCP passthrough | Compute Engine VMs, Regional Target Pool, Regional Forwarding Rule, HTTP Health Checks | [README.md](./Set-Up-Network-Load-Balancers/README.md) |
| **Implement Load Balancing on Compute Engine** | **GSP313** | Layer 4 & Layer 7 | External Network LB & Global HTTP LB | Challenge Lab; External Regional & Global IPs | Web Server VMs (`web1`-`web3`), Target Pool, MIG, Instance Template, Health Checks, URL Map, HTTP Proxy | [README.md](./Implement-Load-Balancing-on-Compute-Engine-Challenge-Lab/README.md) |

---

## Load Balancing Architectural Comparison Matrix

```text
                                              Production Traffic & Load Balancing
                                                               |
            +--------------------------------------------------+--------------------------------------------------+
            |                                                  |                                                  |
Layer 4 External Network Load Balancer             Layer 7 External Application Load Balancer        Layer 7 Internal Application Load Balancer
         (GSP007)                                           (GSP155)                                           (GSP041)
----------------------------------------           ------------------------------------------        ------------------------------------------
- Transport Layer (TCP/UDP) Passthrough            - Application Layer (HTTP/HTTPS) Proxy            - Private VPC Internal Proxy
- Regional Scope (Forwarding Rule + Target Pool)   - Global Scope (Anycast IP + URL Map + MIG)       - Regional Scope (Private VIP 10.132.0.10)
- Preserves raw Client Source IPv4                 - Terminates TLS/TCP; appends X-Forwarded-For     - Backend VMs have NO public IP (--no-address)
- Ultra-low latency line-rate packet routing       - Host & Path-based HTTP routing                   - Microservices frontend/backend isolation
```
