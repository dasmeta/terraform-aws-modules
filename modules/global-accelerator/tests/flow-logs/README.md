# Flow-log Global Accelerator fixture

This fixture plans a Standard Accelerator with one UDP listener, an existing
example EC2 endpoint, an explicit endpoint weight, and flow logs delivered to
an existing example S3 bucket and prefix. The fixture does not create either
the endpoint or the bucket.

Run it through the module's mocked native test suite:

```shell
terraform -chdir=../.. test -filter=tests/flow-logs.tftest.hcl
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_global_accelerator"></a> [global\_accelerator](#module\_global\_accelerator) | ../.. | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accelerator_arn"></a> [accelerator\_arn](#output\_accelerator\_arn) | ARN of the planned flow-log example accelerator. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the planned flow-log example accelerator. |
| <a name="output_dual_stack_dns_name"></a> [dual\_stack\_dns\_name](#output\_dual\_stack\_dns\_name) | Dual Stack DNS name, null for this IPv4 example. |
| <a name="output_endpoint_group_arns"></a> [endpoint\_group\_arns](#output\_endpoint\_group\_arns) | Endpoint-group ARNs keyed by listener and group names. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | Route 53 hosted zone ID of the planned flow-log example accelerator. |
| <a name="output_ip_sets"></a> [ip\_sets](#output\_ip\_sets) | IP sets assigned to the planned flow-log example accelerator. |
| <a name="output_listener_arns"></a> [listener\_arns](#output\_listener\_arns) | Listener ARNs keyed by logical listener name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
