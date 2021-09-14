# aws iam?
eksctl utils associate-iam-oidc-provider \
    --region eu-central-1 \
    --cluster stage-6 \
    --profile aws-profile-name \
    --approve

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

# aws iam policy
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json \
    --profile aws-profile-name

# kubernetes service account
eksctl create iamserviceaccount \
  --cluster=stage-6 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::338758973598:policy/AWSLoadBalancerControllerIAMPolicy \
  --profile=aws-profile-name \
  --override-existing-serviceaccounts \
  --approve

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
