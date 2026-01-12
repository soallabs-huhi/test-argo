export AWS_PROFILE=soal
export AWS_REGION=eu-central-1

eksctl create cluster -f cluster.yaml

kubectl create namespace airbyte
kubectl create namespace clickhouse

