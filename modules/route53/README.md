# HOW TO

You can use module use when you create zones and add records.
Module output zone id and zone arn.

## Example 1. create only zone

```terraform
module "route53" {
    source = "dasmeta/modules/aws//modules/route53"
    version = "0.21.17"

    zone = "example.com"
}
```

## Example 2. Create zone and add one record

```terraform
module "route53" {
    source  = "dasmeta/modules/aws//modules/route53"
    version = "0.21.17"

    zone    = "test.example.com"
    records = [
        {
            name  = "test.example.com"
            type  = "A"
            value = ["192.168.0.2"]
        }
    ]
    ttl = "30"
}
```

## Example 3. Create zone and more that one records

Note. Your record names must be unique

```terraform
module "route53" {
    source = "dasmeta/modules/aws//modules/route53"
    version = "0.21.17"

    zone = "example.com"
    records = [
        {
            name  = "test1.example.com"
            type  = "A"
            value = ["192.168.0.2"]
        },
        {
            name  = "test2.example.com"
            type  = "MX"
            value = ["1 mail1","2 mail2"]
        }
    ]
    ttl = "30"
}
```

## Example 4. Create only records

```terraform
module "route53" {
    source = "dasmeta/modules/aws//modules/route53"
    version = "0.21.17"

    zone = "example.com"
    create_zone = false
    records = [
        {
            name  = "test1.example.com"
            type  = "A"
            value = ["192.168.0.2"]
        },
        {
            name  = "test2.example.com"
            type  = "MX"
            value = ["1 mail1","2 mail2"]
        }
    ]
    ttl = "30"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_zone"></a> [zone](#module\_zone) | ./zone | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.add_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_zone"></a> [create\_zone](#input\_create\_zone) | controlls whether create Route53 zone or use already created zone for just generating new records | `bool` | `true` | no |
| <a name="input_records"></a> [records](#input\_records) | dns records name, type and value list | <pre>list(object({<br>    name  = string,<br>    type  = string,<br>    value = set(string)<br>  }))</pre> | `[]` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL Time | `string` | `"30"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Route53 zone name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Returns zone arn. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Returns zone id. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
