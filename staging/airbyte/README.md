# Airbyte – Staging

This directory contains the declarative configuration for deploying
**Airbyte** in the **staging** environment.

The deployment is based on the official Airbyte Helm chart and is
intended to be managed via **Argo CD**.

---

## Contents

- `Chart.yaml`  
  Wrapper chart that references the official Airbyte Helm chart.

- `values.yaml`  
  Environment-specific Helm values for the Airbyte deployment.

---

## Prerequisites

The following are assumed to exist in the cluster:

- An EKS cluster for the staging environment
- A namespace named `airbyte`
- Argo CD installed and managing this cluster

---

## Deployment model

This folder is intended to be synced by **Argo CD**.

Argo CD will:
- Render the Airbyte Helm chart using `values.yaml`
- Apply all generated Kubernetes manifests
- Continuously reconcile desired vs actual state

No manual Helm or kubectl commands are required once Argo CD is configured.

---

## Access

Airbyte services are exposed internally via ClusterIP services.

For access (e.g. UI), use:

```bash
kubectl port-forward svc/airbyte-webapp 8000:80 -n airbyte
