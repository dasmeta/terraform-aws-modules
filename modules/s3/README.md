# aws S3 bucket and iam user with access to it

Creates AWS S3 bucket and if there is need IAM user with appropriated accesses to list/get/put/delete objects in it.

# Use Cases

## Case 1: simple use case with minimal params

```terraform

module "my_bucket" {
  source = "dasmeta/modules/aws//modules/s3"
  version = "0.26.0"

  name = "my-files-bucket"
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.my_bucket.iam_access_key_id
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.my_bucket.iam_user_arn
}
```

## Case 2: with some additional params, by disabling iam user creation

```terraform
module "my_bucket" {
  source = "dasmeta/modules/aws//modules/s3"
  version = "0.26.0"

  name = "my-files-bucket"

  create_iam_user = false

  acl    = "public-read"

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
}
```

## Case 3: website with initial index.html and "/images/\*\*" content

```terraform
module "my_bucket" {
  source = "dasmeta/modules/aws//modules/s3"
  version = "0.36.2"

  name = "my-website"

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  create_index_html = true
  bucket_files = "{module.path}/images"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.43 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket"></a> [bucket](#module\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.1.0 |
| <a name="module_bucket_files"></a> [bucket\_files](#module\_bucket\_files) | ./objects | n/a |
| <a name="module_iam_user"></a> [iam\_user](#module\_iam\_user) | dasmeta/modules/aws//modules/aws-iam-user | 0.36.1 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_object.index](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | The acl config for bucket, NOTE: 'acl' conflicts with 'grant' and 'owner'. | `string` | `"private"` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `false` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `false` | no |
| <a name="input_bucket_files"></a> [bucket\_files](#input\_bucket\_files) | Initial content for bucket, use acl and pattern params if you need more control. | <pre>object({<br>    path = string<br>  })</pre> | <pre>{<br>  "path": ""<br>}</pre> | no |
| <a name="input_create_iam_user"></a> [create\_iam\_user](#input\_create\_iam\_user) | Whether to create specific api access user to this created bucket. | `bool` | `true` | no |
| <a name="input_create_index_html"></a> [create\_index\_html](#input\_create\_index\_html) | Whether to create and initial index.html file with default data. | `bool` | `false` | no |
| <a name="input_grant"></a> [grant](#input\_grant) | The ACL policy grant. NOTE: conflicts with 'acl'. | `any` | `[]` | no |
| <a name="input_iam_user_actions"></a> [iam\_user\_actions](#input\_iam\_user\_actions) | The allowed actions that created user can perform on this created bucket. | `list(string)` | <pre>[<br>  "s3:PutObject",<br>  "s3:ListBucket",<br>  "s3:GetObject",<br>  "s3:GetObjectVersion",<br>  "s3:GetBucketAcl",<br>  "s3:DeleteObject",<br>  "s3:DeleteObjectVersion",<br>  "s3:PutLifecycleConfiguration",<br>  "s3:PutObjectAcl"<br>]</pre> | no |
| <a name="input_iam_user_name"></a> [iam\_user\_name](#input\_iam\_user\_name) | The name of user, NOTE: this is optional and if it is not passed in use place the name will be generated based on bucket name. | `string` | `""` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Bucket name. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | The Bucket owner's display name and ID. NOTE: Conflicts with 'acl'. | `map(string)` | `{}` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `false` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | The versioning configuration for the created bucket. | `map(string)` | `{}` | no |
| <a name="input_website"></a> [website](#input\_website) | The website configuration for the created bucket. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_access_key_id"></a> [iam\_access\_key\_id](#output\_iam\_access\_key\_id) | The access key ID |
| <a name="output_iam_access_key_secret"></a> [iam\_access\_key\_secret](#output\_iam\_access\_key\_secret) | The access key secret |
| <a name="output_iam_user_arn"></a> [iam\_user\_arn](#output\_iam\_user\_arn) | The ARN assigned by AWS for this user |
| <a name="output_iam_user_name"></a> [iam\_user\_name](#output\_iam\_user\_name) | The user's name |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The bucket name |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | The website endpoint associated to created s3 bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
