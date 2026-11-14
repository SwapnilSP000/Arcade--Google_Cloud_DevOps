# GSP182: Distributed Load Testing Using Kubernetes – Command Reference

A complete, structured, copy-paste-friendly command reference for the **Distributed Load Testing Using Kubernetes** lab (`GSP182`).

---

## 1. Environment Variables & Project Configuration

Set foundational shell variables and configure default compute settings in Google Cloud Shell:

```bash
# Capture project identity and establish target variables
PROJECT=$(gcloud config get-value project)
REGION="us-central1"
ZONE="us-central1-a"
CLUSTER=gke-load-test
TARGET=${PROJECT}.appspot.com

# Configure persistent gcloud CLI compute defaults
gcloud config set compute/region "$REGION"
gcloud config set compute/zone "$ZONE"

# Verify active project and configured compute parameters
gcloud config list
```

---

## 2. Download Sample Code

Retrieve the official Google Cloud distributed load-testing bundle from Cloud Storage:

```bash
# Download and unpack the distributed load testing sample assets
gcloud storage cp -r gs://spls/gsp182/distributed-load-testing-using-kubernetes .

# Navigate into the project directory
cd distributed-load-testing-using-kubernetes
```

---

## 3. Python Runtime Update

Modernize the sample App Engine application manifest to use a current supported Python runtime:

```bash
# Navigate to the sample web application directory
cd sample-webapp/

# Update Python runtime from python37 to python312
sed -i "s/python37/python312/g" app.yaml

# Verify the updated runtime descriptor
cat app.yaml
```

---

## 4. Docker Image Build with Cloud Build

Return to the root of the sample project and trigger Google Cloud Build to compile and tag the Locust container image:

```bash
# IMPORTANT: Navigate back to the project root where docker-image/ exists
cd ..

# Verify the Dockerfile context is present
ls -la docker-image/

# Submit container build to Cloud Build and publish to Google Container Registry
gcloud builds submit --tag gcr.io/$PROJECT/locust-tasks:latest docker-image/.
```

> [!NOTE]
> The `gcloud builds submit` command must be run from `distributed-load-testing-using-kubernetes/` where the `docker-image/` subdirectory is located.

---

## 5. Deploy Sample Web Application to App Engine

Deploy the target Python application to Google App Engine standard environment:

```bash
# Deploy the web application
gcloud app deploy sample-webapp/app.yaml --quiet

# Verify the deployed App Engine serving URL
gcloud app browse --no-launch-browser
```

---

## 6. Provision GKE Cluster

Create a managed 5-node Google Kubernetes Engine cluster to host the Locust master and worker pods:

```bash
# Provision 5-node GKE cluster named gke-load-test
gcloud container clusters create $CLUSTER \
  --zone $ZONE \
  --num-nodes=5

# Authenticate kubectl with the newly created cluster
gcloud container clusters get-credentials $CLUSTER --zone $ZONE

# Verify cluster node status
kubectl get nodes
```

---

## 7. Configure Locust Master Manifests

Inject your project ID and target hostname into the Kubernetes controller manifests:

```bash
# Substitute target host into Locust master controller manifest
sed -i -e "s/\[TARGET_HOST\]/$TARGET/g" kubernetes-config/locust-master-controller.yaml

# Substitute project ID into Locust master controller manifest
sed -i -e "s/\[PROJECT_ID\]/$PROJECT/g" kubernetes-config/locust-master-controller.yaml

# Review substituted master manifest
cat kubernetes-config/locust-master-controller.yaml
```

---

## 8. Deploy Locust Master Controller

Apply the master Deployment manifest and verify the Pod enters the `Running` state:

```bash
# Deploy Locust Master Deployment
kubectl apply -f kubernetes-config/locust-master-controller.yaml

# Verify Locust master Pod status
kubectl get pods -l app=locust-master

# Inspect detailed master Pod description
kubectl describe pod -l app=locust-master
```

---

## 9. Deploy Locust Master Service

Apply the master Service manifest to provision a Google Cloud Network Load Balancer exposing port `8089`:

```bash
# Deploy Locust Master LoadBalancer Service
kubectl apply -f kubernetes-config/locust-master-service.yaml

# Verify the Service and monitor external IP allocation
kubectl get svc locust-master
```

---

## 10. Deploy Locust Worker Pool

Substitute the project ID into the worker controller manifest and launch the initial pool of 5 worker Pods:

```bash
# Substitute project ID into Locust worker controller manifest
sed -i -e "s/\[PROJECT_ID\]/$PROJECT/g" kubernetes-config/locust-worker-controller.yaml

# Deploy Locust Worker Deployment
kubectl apply -f kubernetes-config/locust-worker-controller.yaml

# Verify worker Pod creation
kubectl get pods -l app=locust-worker
```

---

## 11. Scale Locust Worker Deployment

Horizontally scale the worker deployment from 5 to 20 replicas to maximize distributed load-generation throughput:

```bash
# Scale worker Deployment to 20 replicas
kubectl scale deployment/locust-worker --replicas=20

# Monitor scaling progress and verify all 20 worker Pods are running
kubectl get pods -l app=locust-worker -o wide
```

---

## 12. Retrieve Locust Web Interface Address

Extract the external IP assigned by the Kubernetes `LoadBalancer` service and construct the dashboard URL:

```bash
# Extract LoadBalancer external ingress IP
EXTERNAL_IP=$(kubectl get svc locust-master -o yaml | grep ip: | awk -F": " '{print $NF}')

# Output the interactive Locust Web UI link
echo "http://${EXTERNAL_IP}:8089"
```

---

## 13. Comprehensive Kubernetes & Infrastructure Verification

Execute these verification commands to audit cluster health, deployment states, and pod distributions:

```bash
# Verify active project configuration
gcloud config get-value project

# List running container clusters in the project
gcloud container clusters list

# Enumerate all GKE cluster nodes
kubectl get nodes

# Enumerate all active Deployments in the default namespace
kubectl get deployments

# Inspect all running Pods with node assignments and IP addresses
kubectl get pods -o wide

# Enumerate all Services and exposed ports
kubectl get services

# Inspect the Locust master Service specifically
kubectl get svc locust-master

# Enumerate only Locust worker Pods
kubectl get pods -l app=locust-worker

# Inspect detailed state of the Locust worker Deployment
kubectl describe deployment locust-worker

# Inspect cluster lifecycle events ordered by creation timestamp
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

## 14. Optional Resource Cleanup (Clearly Labeled)

> [!CAUTION]
> **OPTIONAL CLEANUP STEPS**
> The following commands delete the infrastructure provisioned during this lab to prevent ongoing compute charges. **Do not run these commands if you still need the cluster or application running for evaluation or demonstration purposes.**

```bash
# ---------------------------------------------------------
# OPTIONAL: Delete GKE cluster and associated compute nodes
# ---------------------------------------------------------
# gcloud container clusters delete $CLUSTER --zone $ZONE --quiet

# ---------------------------------------------------------
# OPTIONAL: Delete Locust container image from registry
# ---------------------------------------------------------
# gcloud container images delete gcr.io/$PROJECT/locust-tasks:latest --force-delete-tags --quiet

# ---------------------------------------------------------
# OPTIONAL: Delete local sample repository directory
# ---------------------------------------------------------
# rm -rf ~/distributed-load-testing-using-kubernetes
```

