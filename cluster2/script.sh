export AWS_PROFILE=soal
export AWS_REGION=eu-central-1

eksctl create cluster -f cluster.yaml

kubectl create namespace airbyte
kubectl create namespace clickhouse

kubectl apply -f gp2-csi.yaml


eksctl --profile soal  utils associate-iam-oidc-provider --region=eu-central-1 --cluster=poc-eks2 --approve

eksctl --profile soal create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster poc-eks2 \
  --region eu-central-1 \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve --override-existing-serviceaccounts

aws --profile soal eks describe-cluster \
  --name poc-eks2 \
  --region eu-central-1 \
  --query "cluster.identity.oidc.issuer" \
  --output text

eksctl --profile soal create addon \
  --name aws-ebs-csi-driver \
  --cluster poc-eks2 \
  --region eu-central-1 --force


