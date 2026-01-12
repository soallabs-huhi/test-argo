#!/bin/bash

export AWS_PROFILE=soal
export AWS_REGION=eu-central-1

eksctl create cluster -f cluster.yaml
kubectl create namespace airbyte
kubectl create namespace clickhouse

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
# helm repo update

# helm upgrade --install secrets-store-csi-driver \
#   secrets-store-csi-driver/secrets-store-csi-driver \
#   --namespace kube-system \
#   --set syncSecret.enabled=true

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm repo update
helm install -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver
helm upgrade --install csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --namespace kube-system \
  --set syncSecret.enabled=true

helm upgrade csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --namespace kube-system \
  --set syncSecret.enabled=true

cccccccccc


kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml

aws --region secretsmanager create-secret \
  --name poc/clickhouse \
  --secret-string '{
    "username": "default",
    "password": "clickhouse"
  }'

aws secretsmanager create-secret \
  --name poc/postgres \
  --secret-string '{
    "host": "poc-mh.cmiggofcpjgy.eu-central-1.rds.amazonaws.com",
    "port": "5432",
    "database": "postgres",
    "username": "postgres",
    "password": "Pk8#aOL#yd~:2:z77)pj*Y$NFQDy"
  }'

kubectl apply -f clickhouse-spc.yaml

kubectl apply -f airbyte-spc.yaml

helm upgrade --install clickhouse bitnami/clickhouse \
  -n clickhouse \
  -f clickhouse-values.yaml



kubectl get secret clickhouse-auth -n clickhouse -o yaml

eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster poc-eks \
  --region eu-central-1

eksctl utils associate-iam-oidc-provider \
--cluster poc-eks \
--region eu-central-1 \
--approve

aws eks describe-cluster \
  --name poc-eks \
  --region eu-central-1 \
  --query "cluster.identity.oidc.issuer" \
  --output text


eksctl delete addon \
  --name aws-ebs-csi-driver \
  --cluster poc-eks \
  --region eu-central-1

kubectl get pods -n kube-system | grep ebs


eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster poc-eks \
  --region eu-central-1 \
  --force


kubectl apply -f gp2-csi.yaml

kubectl get storageclass

helm uninstall clickhouse -n clickhouse

kubectl delete pvc -n clickhouse --all

helm upgrade --install clickhouse bitnami/clickhouse -n clickhouse -f clickhouse-values.yaml





eksctl scale nodegroup \
  --cluster poc-eks \
  --name ng-main \
  --nodes 0


  aws eks describe-nodegroup \
  --cluster-name poc-eks \
  --nodegroup-name ng-main \
  --region eu-central-1 \
  --query "nodegroup.resources.autoScalingGroups"


aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name eks-ng-main-accdc76a-31b8-12ea-e626-075c0a46e243 \
  --min-size 0 \
  --max-size 0 \
  --desired-capacity 0


eksctl create nodegroup \
  --cluster poc-eks \
  --name ng-main \
  --region eu-central-1 \
  --instance-types t3.large \
  --nodes 2 \
  --nodes-min 2 \
  --nodes-max 3 \
  --node-volume-size 50


eksctl delete nodegroup   --cluster poc-eks   --name ng-main   --region eu-central-1




kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/main/deploy/rbac-secretproviderclass.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/main/deploy/csidriver.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/main/deploy/secrets-store-csi-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml

kubectl get sa clickhouse -n clickhouse

aws iam create-policy \
  --policy-name ClickHouseSecretsRead \
  --policy-document file://secretsmanager-read.json


eksctl create iamserviceaccount \
  --cluster poc-eks \
  --region eu-central-1 \
  --namespace clickhouse \
  --name clickhouse \
  --attach-policy-arn arn:aws:iam::250847611043:policy/ClickHouseSecretsRead \
  --override-existing-serviceaccounts \
  --approve


cccccccccc








dd



helm repo add altinity https://helm.altinity.com
helm install clickhouse altinity/clickhouse --namespace clickhouse2 --create-namespace

helm get values clickhouse -n clickhouse -a > values.current.yaml



helm template clickhouse altinity/clickhouse \
  -n clickhouse \
  -f values.yaml \
  | kubectl apply -n clickhouse -f -



helm template clickhouse altinity/clickhouse \
  -n clickhouse \
  -f values.yaml \
  | kubectl diff -n clickhouse -f -

helm template clickhouse altinity/clickhouse   -n clickhouse   -f values.yaml   | kubectl apply -n clickhouse -f -
kubectl apply -f clickhouse-installation.yaml



helm install clickhouse-operator altinity-docs/altinity-clickhouse-operator --namespace clickhouse2

helm install altinity/altinity-operator --namespace clickhouse2 --generate-name





##########

helm repo add altinity https://helm.altinity.com
helm repo update
helm install clickhouse altinity/clickhouse \
  --namespace clickhouse \
  --create-namespace

helm template clickhouse altinity/clickhouse   -n clickhouse   -f values.yaml   | kubectl apply -n clickhouse -f -
kubectl apply -f clickhouse-installation.yaml

##################




eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster <cluster-name> \
  --region <region>



kubectl get csidriver
kubectl get storageclass
kubectl get pods -n kube-system | egrep "ebs|secrets"
kubectl get secretproviderclass -n clickhouse







helm repo add airbyte https://airbytehq.github.io/helm-charts

helm repo update

kubectl create namespace airbyte

helm install airbyte airbyte/airbyte \
  --namespace airbyte \
  --values ./values.yaml

kubectl -n airbyte port-forward deployment/airbyte-server 8080:8001




helm template airbyte . \
  -n airbyte-test \
  | kubectl apply -n airbyte-test -f -



kubectl exec -it chi-clickhouse-clickhouse-0-0-0 --namespace clickhouse -- clickhouse-client


kubectl -n airbyte port-forward deployment/airbyte-server 8080:8001

kubectl get svc -n clickhouse

clickhouse-clickhouse.clickhouse
