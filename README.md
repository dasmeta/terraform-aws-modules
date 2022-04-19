# Why
Somehow AWS does not have same tooling out of the box compared to GCP.
Automate creation of Terraform README documentation and format modules before commit to github repo.

## How
Modules to quickly spin up fully functional eks setup with right subnets and alb/logging/metrics and co.
Using terraform-docs and terraform fmt and pre-commit hooks
## Requirements for pre-commit hooks
for Run our pre-commit hooks you need to install
	- terraform
	- terraform-docs

## Config for GitHooks

```bash
git config core.hooksPath githooks
```

## What
- alb-ingress-controller with access logs and necessary permissions to handle k8s ingress resource
- eks-metrics-to-cloudwatch-metrics
- eks-logs-to-cloudwatch
- aws-rds-postgres
- terraform-docs
- terraform fmt
- pre-commit hooks

## Comming soon
- cert-manager to request certificates via AWS


