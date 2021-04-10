# Why
Somehow AWS does not have same tooling out of the box compared to GCP.

## How
Modules to quickly spin up fully functional eks setup with right subnets and alb/logging/metrics and co.

## What
- alb-ingress-controller with access logs and necessary permissions to handle k8s ingress resource
- eks-metrics-to-cloudwatch-metrics
- eks-logs-to-cloudwatch

## Comming soon
- cert-manager to request certificates via AWS
