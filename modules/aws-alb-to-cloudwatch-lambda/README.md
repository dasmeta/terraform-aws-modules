# terraform-aws-lambda-builder

This Terraform module packages and deploys an AWS Lambda function. It optionally runs a build script *inside Lambda or CodeBuild* to build the Lambda package. This is great for building and deploying Go, Node.js, Python and other Lambda functions without needing any of their toolchains installed.

## Features

* Supports `source_dir` to automatically create Lambda packages.
    * Handles source code changes automatically and correctly.
    * No unexpected changes in Terraform plans.
* Supports `LAMBDA build_mode` to run a build scripts inside Lambda.
    * Runs inside Lambda using the same runtime environment as the target Lambda function.
    * Define your own build script with shell commands like `pip install`, `npm install`, etc.
    * No reliance on `pip`, `virtualenv`, `npm`, etc being on the machine running Terraform.
    * Smaller zip files to upload because `pip install`, etc. doesn't run locally.
* Supports `CODEBUILD build_mode` to run inside CodeBuild.
    * Define your own build steps in `buildspec.yml` with shell commands like `go build`, etc.
    * No reliance on `go`, etc being on the machine running Terraform.
    * Smaller zip files to upload because `go get`, `go build`, etc. doesn't run locally.
* Supports `S3/FILENAME build_mode` to just get the zip functionality.
    * For when there are no build steps but you still want the `source_dir` zip functionality.
* Helps you to avoid:
    * Extra setup requirements on the machine running Terraform.
    * Separate build steps to create packages before running Terraform.
    * Committing built package zip files to version control.

## Requirements

* Python

Python is used to create deterministic zip files. Terraform's `archive_file` data source is not used because it sometimes [produces different results](https://github.com/terraform-providers/terraform-provider-archive/issues/34) which lead to spurious resource changes when working in teams.

## Example

```terraform
module "lambda_function" {
  source = "github.com/raymondbutcher/terraform-aws-lambda-builder"

  # Standard aws_lambda_function attributes.
  function_name = "example"
  handler       = "lambda.handler"
  runtime       = "python3.6"
  s3_bucket     = aws_s3_bucket.packages.id
  timeout       = 30

  # Enable build functionality.
  build_mode = "LAMBDA"
  source_dir = "${path.module}/src"

  # Create and use a role with CloudWatch Logs permissions.
  role_cloudwatch_logs = true
}
```

See the [tests](tests) directory for more working examples.

## Build modes

The `build_mode` input variable can be set to one of:

* `CODEBUILD`
    * Zips `source_dir`, uploads it to `s3_bucket` and runs CodeBuild to build the final package.
* `LAMBDA`
    * Zips `source_dir`, uploads it to `s3_bucket` and runs `build.sh` inside Lambda to build the final package.
* `S3`
    * Zips `source_dir` and uploads to `s3_bucket` at `s3_key`.
* `FILENAME`
    * Zips `source_dir` and uploads it directly to the Lambda service.
* `DISABLED` (default)
    * Disables build functionality.

### CodeBuild build mode

If running in `CODEBUILD` build mode, then this module will use CodeBuild and your `buildspec.yml` file to create a new package for the Lambda function to use.

The `CODEBUILD` build mode works as follows.

* Terraform runs [zip.py](https://github.com/raymondbutcher/terraform-archive-stable) which:
    * Creates a zip file from the source directory.
    * Timestamps and permissions are normalised so the resulting file hash is consistent and only affected by meaningful changes.
* Terraform uploads the zip file to the S3 bucket.
* Terraform creates a CloudFormation stack which:
    * Creates a CodeBuild project which:
        * Uses the S3 bucket zip file as the source.
        * Uses the `buildspec.yml` file from the zipped source directory.
        * Should build and output artifacts to include in the new zip file.
    * Creates a custom resource Lambda function which:
        * Starts the CodeBuild project.
        * Gets invoked again when CodeBuild finishes.
        * Verifies that CodeBuild has uploaded the new zip file.
    * Outputs the location of the new zip file for Terraform to use.
* Terraform creates a Lambda function using the new zip file.

### Lambda build mode

If running in `LAMBDA` build mode, then this module will run `build.sh` from `source_dir` inside the target Lambda runtime environment, and then create a new package for the final Lambda function to use.

The `LAMBDA` build mode works as follows.

* Terraform runs [zip.py](https://github.com/raymondbutcher/terraform-archive-stable) which:
    * Creates a zip file from the source directory.
    * Timestamps and permissions are normalised so the resulting file hash is consistent and only affected by meaningful changes.
* Terraform uploads the zip file to the S3 bucket.
* Terraform creates a CloudFormation stack which:
    * Creates a custom resource Lambda function which:
        * Downloads the zip file from the S3 bucket.
        * Extracts the zip file.
        * Runs the build script.
        * Creates a new zip file.
        * Uploads it to the S3 bucket in another location.
    * Outputs the location of the new zip file for Terraform to use.
* Terraform creates a Lambda function using the new zip file.

 Different runtimes have different tools installed. Here are some notes about what is available to use in `build.sh`.

| Runtime    | Notes               |
|------------|---------------------|
| nodejs10.x | `npm install` works |
| nodejs12.x | `npm install` works |
| nodejs14.x  | waiting on [this](https://github.com/aws-cloudformation/aws-cloudformation-coverage-roadmap/issues/80), try CodeBuild instead |
| python2.7  | `pip` not included  |
| python3.6  | `pip install` works |
| python3.7  | `pip install` works |
| python3.8  | `pip install` works |

Runtimes not listed above have not been tested.

### S3 build mode

The `S3` build mode zips `source_dir` and uploads it to S3 using `s3_bucket` and `s3_key`. It automatically sets `source_code_hash` to ensure changes to the source code get deployed.

### Filename build mode

The `FILENAME` build mode zips `source_dir` and writes it to `filename`. The package is uploaded directly to the Lambda service. It automatically sets `source_code_hash` to ensure changes to the source code get deployed.

### Disabled build mode

The `DISABLED` build mode disables build functionality, making this module do nothing except create a Lambda function resource and optionally its IAM role.

## Automatic role creation

If a `role` is not provided then one will be created automatically. There are various input variables which add policies to this role. If `dead_letter_config` or `vpc_config` are set, then the required policies are automatically attached to this role.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.41 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.41 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_role"></a> [role](#module\_role) | git::https://gitlab.com/claranet-pcp/terraform/aws/terraform-aws-lambda-role.git | v0.1.0 |
| <a name="module_source_zip_file"></a> [source\_zip\_file](#module\_source\_zip\_file) | github.com/raymondbutcher/terraform-archive-stable | v0.0.4 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.builder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_lambda_function.built](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_bucket_object.source_zip_file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [random_string.build_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [external_external.validate](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_build_mode"></a> [build\_mode](#input\_build\_mode) | The build mode to use, one of `CODEBUILD`, `DISABLED`, `FILENAME`, `LAMBDA`, `S3`. | `string` | `"DISABLED"` | no |
| <a name="input_codebuild_environment_compute_type"></a> [codebuild\_environment\_compute\_type](#input\_codebuild\_environment\_compute\_type) | Compute type for CodeBuild. See https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_codebuild_environment_image"></a> [codebuild\_environment\_image](#input\_codebuild\_environment\_image) | Image for CodeBuild. See https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:3.0"` | no |
| <a name="input_codebuild_environment_type"></a> [codebuild\_environment\_type](#input\_codebuild\_environment\_type) | The type of CodeBuild build environment to use. See https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_codebuild_queued_timeout_in_minutes"></a> [codebuild\_queued\_timeout\_in\_minutes](#input\_codebuild\_queued\_timeout\_in\_minutes) | The number of minutes CodeBuild is allowed to be queued before it times out. | `number` | `15` | no |
| <a name="input_codebuild_timeout_in_minutes"></a> [codebuild\_timeout\_in\_minutes](#input\_codebuild\_timeout\_in\_minutes) | The number of minutes CodeBuild is allowed to run before it times out. | `number` | `60` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Create an IAM role for the function. Only required when `role` is a computed/unknown value. | `bool` | `null` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | Nested block to configure the function's dead letter queue. See details below. | <pre>object({<br>    target_arn = string<br>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what your Lambda Function does. | `string` | `null` | no |
| <a name="input_empty_dirs"></a> [empty\_dirs](#input\_empty\_dirs) | Include empty directories in the Lambda package. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Create resources. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Lambda environment's configuration settings. | <pre>object({<br>    variables = map(string)<br>  })</pre> | `null` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | The path to the function's deployment package within the local filesystem. If defined, The s3\_-prefixed options cannot be used. | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | A unique name for your Lambda Function. | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint in your code. | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt environment variables. | `string` | `null` | no |
| <a name="input_lambda_builder_memory_size"></a> [lambda\_builder\_memory\_size](#input\_lambda\_builder\_memory\_size) | Memory size for the builder Lambda function. | `number` | `512` | no |
| <a name="input_lambda_builder_timeout"></a> [lambda\_builder\_timeout](#input\_lambda\_builder\_timeout) | Timeout for the builder Lambda function. | `number` | `900` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. | `list(string)` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. | `number` | `null` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version. | `bool` | `null` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. | `number` | `null` | no |
| <a name="input_role"></a> [role](#input\_role) | IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. | `string` | `null` | no |
| <a name="input_role_cloudwatch_logs"></a> [role\_cloudwatch\_logs](#input\_role\_cloudwatch\_logs) | If `role` is not provided, one will be created with a policy that enables CloudWatch Logs. | `bool` | `false` | no |
| <a name="input_role_custom_policies"></a> [role\_custom\_policies](#input\_role\_custom\_policies) | If `role` is not provided, one will be created with these JSON policies attached. | `list(string)` | `[]` | no |
| <a name="input_role_custom_policies_count"></a> [role\_custom\_policies\_count](#input\_role\_custom\_policies\_count) | The number of `role_custom_policies` to attach. Only required when `role_custom_policies` is a computed/unknown value. | `number` | `null` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | If `role` is not provided, one will be created with these policy ARNs attached. | `list(string)` | `[]` | no |
| <a name="input_role_policy_arns_count"></a> [role\_policy\_arns\_count](#input\_role\_policy\_arns\_count) | The number of `role_policy_arns` to attach. Only required when `role_policy_arns` is a computed/unknown value. | `number` | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The identifier of the function's runtime. | `string` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | The S3 bucket location containing the function's deployment package. Conflicts with filename. This bucket must reside in the same AWS region where you are creating the Lambda function. | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | The S3 key of an object containing the function's deployment package. Conflicts with filename. | `string` | `null` | no |
| <a name="input_s3_object_version"></a> [s3\_object\_version](#input\_s3\_object\_version) | The object version containing the function's deployment package. Conflicts with filename. | `string` | `null` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3\_key. | `string` | `null` | no |
| <a name="input_source_dir"></a> [source\_dir](#input\_source\_dir) | Local source directory for the Lambda package. This will be zipped and uploaded to the S3 bucket. Requires `s3_bucket`. Conflicts with `s3_key`, `s3_object_version` and `filename`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the object. | `map(string)` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. | `number` | `null` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | Provide this to configure tracing. | <pre>object({<br>    mode = string<br>  })</pre> | `null` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Provide this to allow your function to access your VPC. | <pre>object({<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) identifying your Lambda Function. |
| <a name="output_dead_letter_config"></a> [dead\_letter\_config](#output\_dead\_letter\_config) | The function's dead letter queue configuration. |
| <a name="output_description"></a> [description](#output\_description) | Description of what your Lambda Function does. |
| <a name="output_environment"></a> [environment](#output\_environment) | The Lambda environment's configuration settings. |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The unique name for your Lambda Function. |
| <a name="output_handler"></a> [handler](#output\_handler) | The function entrypoint in your code. |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | The ARN to be used for invoking Lambda Function from API Gateway. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN for the KMS encryption key. |
| <a name="output_last_modified"></a> [last\_modified](#output\_last\_modified) | The date this resource was last modified. |
| <a name="output_layers"></a> [layers](#output\_layers) | List of Lambda Layer Version ARNs attached to your Lambda Function. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The log group name for your Lambda Function. |
| <a name="output_log_group_name_edge"></a> [log\_group\_name\_edge](#output\_log\_group\_name\_edge) | The log group name for your Lambda@Edge Function. |
| <a name="output_memory_size"></a> [memory\_size](#output\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. |
| <a name="output_publish"></a> [publish](#output\_publish) | Whether creation/changes will publish a new Lambda Function Version. |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | The Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true). |
| <a name="output_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#output\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this lambda function. |
| <a name="output_role"></a> [role](#output\_role) | IAM role attached to the Lambda Function. |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role attached to the Lambda Function. |
| <a name="output_runtime"></a> [runtime](#output\_runtime) | The identifier of the function's runtime. |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | The S3 bucket location containing the function's deployment package. |
| <a name="output_s3_key"></a> [s3\_key](#output\_s3\_key) | The S3 key of an object containing the function's deployment package. |
| <a name="output_s3_object_version"></a> [s3\_object\_version](#output\_s3\_object\_version) | The object version containing the function's deployment package. |
| <a name="output_source_code_hash"></a> [source\_code\_hash](#output\_source\_code\_hash) | Base64-encoded representation of raw SHA-256 sum of the zip file. |
| <a name="output_source_code_size"></a> [source\_code\_size](#output\_source\_code\_size) | The size in bytes of the function .zip file. |
| <a name="output_tags"></a> [tags](#output\_tags) | A mapping of tags assigned to the object. |
| <a name="output_timeout"></a> [timeout](#output\_timeout) | The amount of time your Lambda Function has to run in seconds. |
| <a name="output_tracing_config"></a> [tracing\_config](#output\_tracing\_config) | The tracing configuration. |
| <a name="output_version"></a> [version](#output\_version) | Latest published version of your Lambda Function. |
| <a name="output_vpc_config"></a> [vpc\_config](#output\_vpc\_config) | The VPC configuration. |
<!-- END_TF_DOCS -->