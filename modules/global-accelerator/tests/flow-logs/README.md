# Flow-log Global Accelerator fixture

This fixture plans a Standard Accelerator with one UDP listener, an existing
example EC2 endpoint, an explicit endpoint weight, and flow logs delivered to
an existing example S3 bucket and prefix. The fixture does not create either
the endpoint or the bucket.

Run it through the module's mocked native test suite:

```shell
terraform -chdir=../.. test -filter=tests/flow-logs.tftest.hcl
```
