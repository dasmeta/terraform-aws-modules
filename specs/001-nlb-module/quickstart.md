# Quickstart: Generic AWS NLB Module

## Validate The Module

```bash
terraform -chdir=modules/nlb init -backend=false
terraform -chdir=modules/nlb validate
```

## Validate The Basic Example

```bash
terraform -chdir=modules/nlb/tests/basic init -backend=false
terraform -chdir=modules/nlb/tests/basic validate
```

## Format Check

```bash
terraform fmt -check modules/nlb specs/001-nlb-module
```
