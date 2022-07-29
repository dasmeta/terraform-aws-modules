# allows to create S3 bucket content by syncing all the files in local folder to s3 as separate state having item
# TODO: have this as submodule int our future s3 separate module

## example how it can be used
```hcl
module "bucket_files" {
  source = "{path-to-this-module-root}/objects"

  bucket  = "my-bucket"
  path    = "./my-files/"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_object.bucket_files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | ACL for files be created in S3 bucket. | `string` | `"public-read"` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Bucket name. | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | Path to folder which will be pushed into bucket. | `string` | n/a | yes |
| <a name="input_pattern"></a> [pattern](#input\_pattern) | Pattern to look for files to push to bucket. | `string` | `"**"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->