# Basic Global Accelerator fixture

This fixture plans an IPv4 Standard Accelerator with one TCP listener and one
regional endpoint group that references an existing example Application Load
Balancer ARN. It creates no endpoint resources and leaves flow logs disabled.

Run it through the module's mocked native test suite:

```shell
terraform -chdir=../.. test -filter=tests/basic.tftest.hcl
```
