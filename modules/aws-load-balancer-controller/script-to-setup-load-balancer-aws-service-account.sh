eksctl utils associate-iam-oidc-provider \
    --region eu-central-1 \
    --cluster stage-6 \
    --profile pushmetrics \
    --approve

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json \
    --profile pushmetrics

eksctl create iamserviceaccount \
  --cluster=stage-6 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::133737826969:policy/AWSLoadBalancerControllerIAMPolicy \
  --profile=pushmetrics \
  --override-existing-serviceaccounts \
  --approve

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"