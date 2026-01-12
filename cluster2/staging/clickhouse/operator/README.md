# ClickHouse – Staging

This directory contains the declarative configuration for the ClickHouse
deployment in the **staging** environment.

The deployment is based on the **Altinity ClickHouse Operator** and is designed
to be managed via **Argo CD**.

---

## Contents

- `values.yaml`  
  Helm values used to configure the Altinity ClickHouse Operator and its defaults.

- `clickhouse-installation.yaml`  
  A `ClickHouseInstallation` custom resource defining the actual ClickHouse
  cluster (replicas, storage, users, etc.).

---

## Prerequisites

The following are assumed to exist in the cluster:

- An EKS cluster for the staging environment
- A namespace for ClickHouse (ex `clickhouse`)
- EBS CSI driver installed and functional ( check by running `kubectl get pods -n kube-system | grep ebs` )
- A suitable StorageClass for stateful workloads (e.g. `gp2-csi`, check: `kubectl get csidriver | grep ebs
`) 
- Secrets Store CSI Driver + AWS provider installed (check: `kubectl get pods -n kube-system | grep secrets-store
`)
- ClickHouse credentials stored in AWS Secrets Manager
- A `SecretProviderClass` exposing those credentials in Kubernetes
- Argo CD installed and managing this cluster

---

## Operator initialization (one-time)

The Altinity ClickHouse Operator **must be installed in the cluster** before
applying the `ClickHouseInstallation` resource.

In environments where the operator is not already present, it can be installed
once using Helm (typically via Argo CD or an infra-level workflow):

```bash
helm repo add altinity https://helm.altinity.com
helm repo update

helm install clickhouse altinity/clickhouse \
  --namespace clickhouse \
  --create-namespace
```
