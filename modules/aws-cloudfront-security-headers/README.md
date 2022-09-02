# Add HTTP security headers

**CloudFront Functions event type: viewer response**
Terraform module to create a Lambda@Edge function to add best practice security headers and support HSTS preload requirements.

- [Creating a Simple Lambda@Edge Function](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-how-it-works-tutorial.html)

## Dy default it will set the following headers:

```hcl
{ key = "Server", value = "CloudFront" }
{ key = "Strict-Transport-Security", value = "max-age=63072000; includeSubdomains; preload" }
{ key = "Content-Security-Policy", value = "default-src 'self' 'unsafe-inline' 'unsafe-eval' https: http: data: wss:" }
{ key = "X-Content-Type-Options", value = "nosniff" }
{ key = "X-Frame-Options", value = "DENY" }
{ key = "X-XSS-Protection", value = "1; mode=block" }
{ key = "Referrer-Policy", value = "same-origin" }
{ key = "Feature-Policy", value = "microphone 'none'; camera 'none'" }
{ key = "Permissions-Policy", value = "camera=(), microphone=()" }
```

## you can disable any default header or add you custom ones by using `override_custom_headers` variable

# Usage

**IMPORTANT:** Make sure that you’re in the US-East-1 (N. Virginia) Region (us-east-1). You must be in this Region to create Lambda@Edge functions.

# Sample 1

## Step 1: Create a Lambda@Edge using a module `aws-cloudfront-security-headers`

```hcl

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

module aws-cloudfront-security-headers {
    source                  = "dasmeta/modules/aws//modules/aws-cloudfront-security-headers"
    version                 = "0.19.8"
    name                    = "CloudFront-Add-HSTS-Header"

    providers = {
    aws = aws.east
  }

}

```

## Step 2: Add a CloudFront Trigger to Run the Function

Now that you have a Lambda function to update security headers, configure the CloudFront trigger to run your function to add the headers in any response that CloudFront receives from the origin for your distribution.

![Add a CloudFront Trigger to Run the Function](https://github.com/dasmeta/terraform-aws-modules/blob/main/modules/aws-cloudfront-security-headers/cloudfront.gif)

# Sample 2

## the following sample will create lambda@edge with config override:

- override default `Server` header with custom one
- disable default `x-frame-options` header
- have an additional `Cross-Origin-Embedder-Policy` header

```hcl

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

module aws-cloudfront-security-headers {
    source                  = "dasmeta/modules/aws//modules/aws-cloudfront-security-headers"
    version                 = "0.19.8"

    name                    = "CloudFront-Add-HSTS-Header"

    providers = {
    aws = aws.east
  }

  override_custom_headers = {
     server = { key = "Server", value = "CloudFront1" }
     x-frame-options = { key = "X-FRAME-OPTIONS", value = "" }
     cross-origin-embedder-policy = { key = "Cross-Origin-Embedder-Policy", value = "(unsafe-none|require-corp); report-to='default'" }
  }
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 3.43 |

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_archive"></a> [archive](#provider_archive) | n/a     |
| <a name="provider_aws"></a> [aws](#provider_aws)             | >= 3.43 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                    | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_policy.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                 | resource    |
| [aws_iam_role.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy_attachment.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)                                 | resource    |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                                            | data source |
| [aws_iam_policy_document.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                                       | data source |

## Inputs

| Name                                                                                                   | Description                                                                 | Type          | Default                                  | Required |
| ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- | ------------- | ---------------------------------------- | :------: |
| <a name="input_description"></a> [description](#input_description)                                     | Description to use for resource description created by this module          | `string`      | `"Adds security headers for Cloudfront"` |    no    |
| <a name="input_memory_size"></a> [memory_size](#input_memory_size)                                     | Memory to use for Lambda, defaults to 128mb                                 | `number`      | `128`                                    |    no    |
| <a name="input_name"></a> [name](#input_name)                                                          | Name to use for resource names created by this module                       | `string`      | `"CloudFront-Add-HSTS-Header"`           |    no    |
| <a name="input_override_custom_headers"></a> [override_custom_headers](#input_override_custom_headers) | Allows to override-default/disable-default/have-additional security headers | `any`         | `{}`                                     |    no    |
| <a name="input_runtime"></a> [runtime](#input_runtime)                                                 | Choose the language version to use to write your function.                  | `string`      | `"nodejs12.x"`                           |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                          | Tags to add to resouces created by this module                              | `map(string)` | `{}`                                     |    no    |
| <a name="input_timeout"></a> [timeout](#input_timeout)                                                 | Timeout to use for Lambda, defaults to 1ms                                  | `number`      | `1`                                      |    no    |

## Outputs

| Name                                                                          | Description |
| ----------------------------------------------------------------------------- | ----------- |
| <a name="output_custom_headers"></a> [custom_headers](#output_custom_headers) | n/a         |
| <a name="output_lambda_arn"></a> [lambda_arn](#output_lambda_arn)             | n/a         |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
