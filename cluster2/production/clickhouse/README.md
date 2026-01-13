# ClickHouse

This directory contains the declarative configuration for the ClickHouse
deployment.

The deployment is based on the **Altinity ClickHouse Operator** and is fully
managed via **Argo CD** using a **Kustomize-based setup**. No manual Helm
commands are required.

---

## Overview

The ClickHouse deployment is split into two logical parts, both managed
declaratively:

- The **Altinity ClickHouse Operator**, rendered from the upstream Helm chart
- A **ClickHouseInstallation** custom resource, which defines the actual
  ClickHouse cluster (replicas, storage, users, etc.)

Argo CD, together with Kustomize, is responsible for rendering and applying
both.

---

## Contents

- `kustomization.yaml`  
  Entry point for Argo CD.  
  Combines:
  - Helm-based rendering of the Altinity ClickHouse Operator
  - Application of the `ClickHouseInstallation` custom resource

- `values.yaml`  
  Helm values used to configure the Altinity ClickHouse Operator.

- `clickhouse-installation.yaml`  
  A `ClickHouseInstallation` custom resource defining the actual ClickHouse
  cluster (replicas, storage, users, credentials, etc.).

---

## Prerequisites

The following are assumed to exist in the target cluster:

- An EKS cluster
- A dedicated namespace for ClickHouse (e.g. `clickhouse`)
- **EBS CSI driver** installed and functional  
  (verify with: `kubectl get pods -n kube-system | grep ebs`)
- A suitable **StorageClass** for stateful workloads  
  (e.g. `gp2-csi`)
