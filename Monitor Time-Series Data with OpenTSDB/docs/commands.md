# Command Reference Sheet — OpenTSDB on Cloud Bigtable & GKE

This document provides a copy-paste reference sheet of all Google Cloud CLI (`gcloud`) and Kubernetes (`kubectl`) commands used to deploy, operate, troubleshoot, and tear down the OpenTSDB time-series monitoring system.

---

## 1. Environment Setup & Configuration

```bash
# 1. Set Google Cloud project identifier
export PROJECT_ID="$(gcloud config get-value project)"

# 2. Configure target deployment region and zone
export REGION="europe-west1"
export ZONE="europe-west1-c"

# 3. Define resource identifiers
export BIGTABLE_INSTANCE_ID="bt-opentsdb"
export AR_REPO="opentsdb-bt-repo"
export CLUSTER_NAME="opentsdb-cluster"

# 4. Set gcloud defaults
gcloud config set project "${PROJECT_ID}"
gcloud config set compute/region "${REGION}"
gcloud config set compute/zone "${ZONE}"

# 5. Display active environment configuration
echo "Project:           ${PROJECT_ID}"
echo "Region:            ${REGION}"
echo "Zone:              ${ZONE}"
echo "Bigtable Instance: ${BIGTABLE_INSTANCE_ID}"
echo "Artifact Registry: ${AR_REPO}"
```

---

## 2. Source Repository Setup

```bash
# 1. Clone the repository into home directory
cd ~
git clone https://github.com/GoogleCloudPlatform/opentsdb-bigtable.git
cd ~/opentsdb-bigtable
```

---

## 3. Provision Cloud Bigtable

```bash
# 1. Create Cloud Bigtable single-node SSD instance
gcloud bigtable instances create "${BIGTABLE_INSTANCE_ID}" \
  --cluster-config=id="${BIGTABLE_INSTANCE_ID}-${ZONE}",zone="${ZONE}",nodes=1 \
  --display-name="OpenTSDB"

# 2. Verify Bigtable instance status
gcloud bigtable instances list
gcloud bigtable instances describe "${BIGTABLE_INSTANCE_ID}"
```

---

## 4. Provision Google Kubernetes Engine (GKE) Cluster

```bash
# 1. Create a 3-node GKE cluster with e2-standard-4 instances and Bigtable scopes
gcloud container clusters create "${CLUSTER_NAME}" \
  --zone="${ZONE}" \
  --num-nodes=3 \
  --machine-type="e2-standard-4" \
  --scopes="https://www.googleapis.com/auth/cloud-platform"

# 2. Obtain cluster authentication credentials for kubectl
gcloud container clusters get-credentials "${CLUSTER_NAME}" --zone="${ZONE}"

# 3. Verify cluster nodes are Ready
kubectl get nodes -o wide
```

---

## 5. Artifact Registry Setup & Container Builds

```bash
# 1. Create Docker format Artifact Registry repository
gcloud artifacts repositories create "${AR_REPO}" \
  --repository-format=docker \
  --location="${REGION}" \
  --description="OpenTSDB on bigtable container images"

# 2. Verify repository creation
gcloud artifacts repositories list --location="${REGION}"

# 3. Build the synthetic time-series generator container image
cd ~/opentsdb-bigtable/generator
gcloud builds submit \
  --tag "${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/opentsdb-timeseries-generator:0.1" .

# 4. (Optional / Triage) Update OpenTSDB Dockerfile base image to debian:bookworm-slim
cd ~/opentsdb-bigtable/opentsdb
sed -i 's/FROM debian:11.2/FROM debian:bookworm-slim/g' Dockerfile

# 5. Build and submit OpenTSDB server container image
gcloud builds submit \
  --tag "${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/opentsdb-server-bigtable:2.4.1" .
```

---

## 6. Kubernetes Manifest Preparation & Deployment

```bash
cd ~/opentsdb-bigtable

# 1. Substitute environment variables in ConfigMap and Deployment YAMLs
sed -i "s/<BIGTABLE_INSTANCE_ID>/${BIGTABLE_INSTANCE_ID}/g" configmaps/opentsdb-config.yaml
sed -i "s/<PROJECT_ID>/${PROJECT_ID}/g" configmaps/opentsdb-config.yaml
sed -i "s|<SERVER_IMAGE>|${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/opentsdb-server-bigtable:2.4.1|g" \
  jobs/opentsdb-init.yaml deployments/opentsdb-write.yaml deployments/opentsdb-read.yaml
sed -i "s|<GENERATOR_IMAGE>|${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/opentsdb-timeseries-generator:0.1|g" \
  deployments/opentsdb-timeseries-generator.yaml

# 2. Create the OpenTSDB ConfigMap
kubectl create -f configmaps/opentsdb-config.yaml

# 3. Run the Bigtable schema initialization Job
kubectl create -f jobs/opentsdb-init.yaml

# 4. Monitor the schema init Job until completion
kubectl describe job opentsdb-init
kubectl logs -f job/opentsdb-init

# 5. Deploy OpenTSDB write and read deployments
kubectl create -f deployments/opentsdb-write.yaml
kubectl create -f deployments/opentsdb-read.yaml

# 6. Expose OpenTSDB ClusterIP services
kubectl create -f services/opentsdb-write.yaml
kubectl create -f services/opentsdb-read.yaml

# 7. Deploy the synthetic telemetry generator
kubectl create -f deployments/opentsdb-timeseries-generator.yaml

# 8. Deploy Grafana visualization service
kubectl create -f configmaps/grafana-config.yaml
kubectl create -f deployments/grafana.yaml
kubectl create -f services/grafana.yaml
```

---

## 7. Cluster Verification & Diagnostics

```bash
# 1. Watch all pods and services
kubectl get pods -o wide -w
kubectl get services

# 2. Inspect events on troubled pods
kubectl describe pod -l app=opentsdb-write
kubectl describe pod -l app=opentsdb-read

# 3. Stream container logs
kubectl logs -l app=opentsdb-timeseries-generator --tail=50 -f
kubectl logs -l app=opentsdb-read --tail=50 -f

# 4. Port-forward Grafana to localhost for local browser access
kubectl port-forward service/grafana 3000:3000
```

---

## 8. Ephemeral Lab Teardown & Resource Cleanup

To avoid recurring billing and remove all ephemeral lab resources:

```bash
# 1. Delete GKE cluster
gcloud container clusters delete "${CLUSTER_NAME}" --zone="${ZONE}" --quiet

# 2. Delete Cloud Bigtable instance
gcloud bigtable instances delete "${BIGTABLE_INSTANCE_ID}" --quiet

# 3. Delete Artifact Registry repository and stored images
gcloud artifacts repositories delete "${AR_REPO}" --location="${REGION}" --quiet
```
