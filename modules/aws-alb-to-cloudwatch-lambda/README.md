# terraform-aws-lambda-builder

This Terraform module packages and deploys an AWS Lambda function. It optionally runs a build script _inside Lambda or CodeBuild_ to build the Lambda package. This is great for building and deploying Go, Node.js, Python and other Lambda functions without needing any of their toolchains installed.

## Features

- Supports `source_dir` to automatically create Lambda packages.
  - Handles source code changes automatically and correctly.
  - No unexpected changes in Terraform plans.
- Supports `LAMBDA build_mode` to run a build scripts inside Lambda.
  - Runs inside Lambda using the same runtime environment as the target Lambda function.
  - Define your own build script with shell commands like `pip install`, `npm install`, etc.
  - No reliance on `pip`, `virtualenv`, `npm`, etc being on the machine running Terraform.
  - Smaller zip files to upload because `pip install`, etc. doesn't run locally.
- Supports `CODEBUILD build_mode` to run inside CodeBuild.
  - Define your own build steps in `buildspec.yml` with shell commands like `go build`, etc.
  - No reliance on `go`, etc being on the machine running Terraform.
  - Smaller zip files to upload because `go get`, `go build`, etc. doesn't run locally.
- Supports `S3/FILENAME build_mode` to just get the zip functionality.
  - For when there are no build steps but you still want the `source_dir` zip functionality.
- Helps you to avoid:
  - Extra setup requirements on the machine running Terraform.
  - Separate build steps to create packages before running Terraform.
  - Committing built package zip files to version control.

## Requirements

- Python

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

- `CODEBUILD`
  - Zips `source_dir`, uploads it to `s3_bucket` and runs CodeBuild to build the final package.
- `LAMBDA`
  - Zips `source_dir`, uploads it to `s3_bucket` and runs `build.sh` inside Lambda to build the final package.
- `S3`
  - Zips `source_dir` and uploads to `s3_bucket` at `s3_key`.
- `FILENAME`
  - Zips `source_dir` and uploads it directly to the Lambda service.
- `DISABLED` (default)
  - Disables build functionality.

### CodeBuild build mode

If running in `CODEBUILD` build mode, then this module will use CodeBuild and your `buildspec.yml` file to create a new package for the Lambda function to use.

The `CODEBUILD` build mode works as follows.

- Terraform runs [zip.py](https://github.com/raymondbutcher/terraform-archive-stable) which:
  - Creates a zip file from the source directory.
  - Timestamps and permissions are normalised so the resulting file hash is consistent and only affected by meaningful changes.
- Terraform uploads the zip file to the S3 bucket.
- Terraform creates a CloudFormation stack which:
  - Creates a CodeBuild project which:
    - Uses the S3 bucket zip file as the source.
    - Uses the `buildspec.yml` file from the zipped source directory.
    - Should build and output artifacts to include in the new zip file.
  - Creates a custom resource Lambda function which:
    - Starts the CodeBuild project.
    - Gets invoked again when CodeBuild finishes.
    - Verifies that CodeBuild has uploaded the new zip file.
  - Outputs the location of the new zip file for Terraform to use.
- Terraform creates a Lambda function using the new zip file.

### Lambda build mode

If running in `LAMBDA` build mode, then this module will run `build.sh` from `source_dir` inside the target Lambda runtime environment, and then create a new package for the final Lambda function to use.

The `LAMBDA` build mode works as follows.

- Terraform runs [zip.py](https://github.com/raymondbutcher/terraform-archive-stable) which:
  - Creates a zip file from the source directory.
  - Timestamps and permissions are normalised so the resulting file hash is consistent and only affected by meaningful changes.
- Terraform uploads the zip file to the S3 bucket.
- Terraform creates a CloudFormation stack which:
  - Creates a custom resource Lambda function which:
    - Downloads the zip file from the S3 bucket.
    - Extracts the zip file.
    - Runs the build script.
    - Creates a new zip file.
    - Uploads it to the S3 bucket in another location.
  - Outputs the location of the new zip file for Terraform to use.
- Terraform creates a Lambda function using the new zip file.

Different runtimes have different tools installed. Here are some notes about what is available to use in `build.sh`.

| Runtime    | Notes                                                                                                                         |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------- |
| nodejs10.x | `npm install` works                                                                                                           |
| nodejs12.x | `npm install` works                                                                                                           |
| nodejs14.x | waiting on [this](https://github.com/aws-cloudformation/aws-cloudformation-coverage-roadmap/issues/80), try CodeBuild instead |
| python2.7  | `pip` not included                                                                                                            |
| python3.6  | `pip install` works                                                                                                           |
| python3.7  | `pip install` works                                                                                                           |
| python3.8  | `pip install` works                                                                                                           |

Runtimes not listed above have not been tested.

### S3 build mode

The `S3` build mode zips `source_dir` and uploads it to S3 using `s3_bucket` and `s3_key`. It automatically sets `source_code_hash` to ensure changes to the source code get deployed.

### Filename build mode

The `FILENAME` build mode zips `source_dir` and writes it to `filename`. The package is uploaded directly to the Lambda service. It automatically sets `source_code_hash` to ensure changes to the source code get deployed.

### Disabled build mode

The `DISABLED` build mode disables build functionality, making this module do nothing except create a Lambda function resource and optionally its IAM role.

## Automatic role creation

If a `role` is not provided then one will be created automatically. There are various input variables which add policies to this role. If `dead_letter_config` or `vpc_config` are set, then the required policies are automatically attached to this role.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.41   |

## Providers

| Name                                                            | Version |
| --------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                | >= 3.41 |
| <a name="provider_external"></a> [external](#provider_external) | n/a     |
| <a name="provider_random"></a> [random](#provider_random)       | n/a     |

## Modules

| Name                                                                             | Source                                                                           | Version |
| -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | ------- |
| <a name="module_role"></a> [role](#module_role)                                  | git::https://gitlab.com/claranet-pcp/terraform/aws/terraform-aws-lambda-role.git | v0.1.0  |
| <a name="module_source_zip_file"></a> [source_zip_file](#module_source_zip_file) | github.com/raymondbutcher/terraform-archive-stable                               | v0.0.4  |

## Resources

| Name                                                                                                                                 | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_cloudformation_stack.builder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource    |
| [aws_lambda_function.built](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)             | resource    |
| [aws_s3_bucket_object.source_zip_file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource    |
| [random_string.build_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                      | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)        | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                    | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                          | data source |
| [external_external.validate](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external)           | data source |

## Inputs

| Name                                                                                                                                       | Description                                                                                                                                                                              | Type                                                                                           | Default                                            | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | -------------------------------------------------- | :------: |
| <a name="input_build_mode"></a> [build_mode](#input_build_mode)                                                                            | The build mode to use, one of `CODEBUILD`, `DISABLED`, `FILENAME`, `LAMBDA`, `S3`.                                                                                                       | `string`                                                                                       | `"DISABLED"`                                       |    no    |
| <a name="input_codebuild_environment_compute_type"></a> [codebuild_environment_compute_type](#input_codebuild_environment_compute_type)    | Compute type for CodeBuild. See https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html                                                                  | `string`                                                                                       | `"BUILD_GENERAL1_SMALL"`                           |    no    |
| <a name="input_codebuild_environment_image"></a> [codebuild_environment_image](#input_codebuild_environment_image)                         | Image for CodeBuild. See https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html                                                                             | `string`                                                                                       | `"aws/codebuild/amazonlinux2-x86_64-standard:3.0"` |    no    |
| <a name="input_codebuild_environment_type"></a> [codebuild_environment_type](#input_codebuild_environment_type)                            | The type of CodeBuild build environment to use. See https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html                                              | `string`                                                                                       | `"LINUX_CONTAINER"`                                |    no    |
| <a name="input_codebuild_queued_timeout_in_minutes"></a> [codebuild_queued_timeout_in_minutes](#input_codebuild_queued_timeout_in_minutes) | The number of minutes CodeBuild is allowed to be queued before it times out.                                                                                                             | `number`                                                                                       | `15`                                               |    no    |
| <a name="input_codebuild_timeout_in_minutes"></a> [codebuild_timeout_in_minutes](#input_codebuild_timeout_in_minutes)                      | The number of minutes CodeBuild is allowed to run before it times out.                                                                                                                   | `number`                                                                                       | `60`                                               |    no    |
| <a name="input_create_role"></a> [create_role](#input_create_role)                                                                         | Create an IAM role for the function. Only required when `role` is a computed/unknown value.                                                                                              | `bool`                                                                                         | `null`                                             |    no    |
| <a name="input_dead_letter_config"></a> [dead_letter_config](#input_dead_letter_config)                                                    | Nested block to configure the function's dead letter queue. See details below.                                                                                                           | <pre>object({<br> target_arn = string<br> })</pre>                                             | `null`                                             |    no    |
| <a name="input_description"></a> [description](#input_description)                                                                         | Description of what your Lambda Function does.                                                                                                                                           | `string`                                                                                       | `null`                                             |    no    |
| <a name="input_empty_dirs"></a> [empty_dirs](#input_empty_dirs)                                                                            | Include empty directories in the Lambda package.                                                                                                                                         | `bool`                                                                                         | `false`                                            |    no    |
| <a name="input_enabled"></a> [enabled](#input_enabled)                                                                                     | Create resources.                                                                                                                                                                        | `bool`                                                                                         | `true`                                             |    no    |
| <a name="input_environment"></a> [environment](#input_environment)                                                                         | The Lambda environment's configuration settings.                                                                                                                                         | <pre>object({<br> variables = map(string)<br> })</pre>                                         | `null`                                             |    no    |
| <a name="input_filename"></a> [filename](#input_filename)                                                                                  | The path to the function's deployment package within the local filesystem. If defined, The s3\_-prefixed options cannot be used.                                                         | `string`                                                                                       | `null`                                             |    no    |
| <a name="input_function_name"></a> [function_name](#input_function_name)                                                                   | A unique name for your Lambda Function.                                                                                                                                                  | `string`                                                                                       | n/a                                                |   yes    |
| <a name="input_handler"></a> [handler](#input_handler)                                                                                     | The function entrypoint in your code.                                                                                                                                                    | `string`                                                                                       | n/a                                                |   yes    |
| <a name="input_kms_key_arn"></a> [kms_key_arn](#input_kms_key_arn)                                                                         | Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt environment variables.                                                                    | `string`                                                                                       | `null`                                             |    no    |
| <a name="input_lambda_builder_memory_size"></a> [lambda_builder_memory_size](#input_lambda_builder_memory_size)                            | Memory size for the builder Lambda function.                                                                                                                                             | `number`                                                                                       | `512`                                              |    no    |
| <a name="input_lambda_builder_timeout"></a> [lambda_builder_timeout](#input_lambda_builder_timeout)                                        | Timeout for the builder Lambda function.                                                                                                                                                 | `number`                                                                                       | `900`                                              |    no    |
| <a name="input_layers"></a> [layers](#input_layers)                                                                                        | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function.                                                                                                      | `list(string)`                                                                                 | `null`                                             |    no    |
| <a name="input_memory_size"></a> [memory_size](#input_memory_size)                                                                         | Amount of memory in MB your Lambda Function can use at runtime.                                                                                                                          | `number`                                                                                       | `null`                                             |    no    |
| <a name="input_publish"></a> [publish](#input_publish)                                                                                     | Whether to publish creation/change as new Lambda Function Version.                                                                                                                       | `bool`                                                                                         | `null`                                             |    no    |
| <a name="input_reserved_concurrent_executions"></a> [reserved_concurrent_executions](#input_reserved_concurrent_executions)                | The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations.                     | `number`                                                                                       | `null`                                             |    no    |
| <a name="input_role"></a> [role](#input_role)                                                                                              | IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to.                     | `string`                                                                                       | `null`                                             |    no    |
| <a name="input_role_cloudwatch_logs"></a> [role_cloudwatch_logs](#input_role_cloudwatch_logs)                                              | If `role` is not provided, one will be created with a policy that enables CloudWatch Logs.                                                                                               | `bool`                                                                                         | `false`                                            |    no    |
| <a name="input_role_custom_policies"></a> [role_custom_policies](#input_role_custom_policies)                                              | If `role` is not provided, one will be created with these JSON policies attached.                                                                                                        | `list(string)`                                                                                 | `[]`                                               |    no    |
| <a name="input_role_custom_policies_count"></a> [role_custom_policies_count](#input_role_custom_policies_count)                            | The number of `role_custom_policies` to attach. Only required when `role_custom_policies` is a computed/unknown value.                                                                   | `number`                                                                                       | `null`                                             |    no    |
| <a name="input_role_policy_arns"></a> [role_policy_arns](#input_role_policy_arns)                                                          | If `role` is not provided, one will be created with these policy ARNs attached.                                                                                                          | `list(string)`                                                                                 | `[]`                                               |    no    |
| <a name="input_role_policy_arns_count"></a> [role_policy_arns_count](#input_role_policy_arns_count)                                        | The number of `role_policy_arns` to attach. Only required when `role_policy_arns` is a computed/unknown value.                                                                           | `number`                                                                                       | `null`                                             |    no    |
| <a name="input_runtime"></a> [runtime](#input_runtime)                                                                                     | The identifier of the function's runtime.                                                                                                                                                | `string`                                                                                       | n/a                                                |   yes    |
| <a name="input_s3_bucket"></a> [s3_bucket](#input_s3_bucket)                                                                               | The S3 bucket location containing the function's deployment package. Conflicts with filename. This bucket must reside in the same AWS region where you are creating the Lambda function. | `string`                                                                                       | `null`                                             |    no    |
| <a name="input_s3_key"></a> [s3_key](#input_s3_key)                                                                                        | The S3 key of an object containing the function's deployment package. Conflicts with filename.                                                                                           | `string`                                                                                       | `null`                                             |    no    |
| <a name="input_s3_object_version"></a> [s3_object_version](#input_s3_object_version)                                                       | The object version containing the function's deployment package. Conflicts with filename.                                                                                                | `string`                                                                                       | `null`                                             |    no    |
| <a name="input_source_code_hash"></a> [source_code_hash](#input_source_code_hash)                                                          | Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key.                                                       | `string`                                                                                       | `null`                                             |    no    |
| <a name="input_source_dir"></a> [source_dir](#input_source_dir)                                                                            | Local source directory for the Lambda package. This will be zipped and uploaded to the S3 bucket. Requires `s3_bucket`. Conflicts with `s3_key`, `s3_object_version` and `filename`.     | `string`                                                                                       | `""`                                               |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                              | A mapping of tags to assign to the object.                                                                                                                                               | `map(string)`                                                                                  | `null`                                             |    no    |
| <a name="input_timeout"></a> [timeout](#input_timeout)                                                                                     | The amount of time your Lambda Function has to run in seconds.                                                                                                                           | `number`                                                                                       | `null`                                             |    no    |
| <a name="input_tracing_config"></a> [tracing_config](#input_tracing_config)                                                                | Provide this to configure tracing.                                                                                                                                                       | <pre>object({<br> mode = string<br> })</pre>                                                   | `null`                                             |    no    |
| <a name="input_vpc_config"></a> [vpc_config](#input_vpc_config)                                                                            | Provide this to allow your function to access your VPC.                                                                                                                                  | <pre>object({<br> security_group_ids = list(string)<br> subnet_ids = list(string)<br> })</pre> | `null`                                             |    no    |

## Outputs

| Name                                                                                                                          | Description                                                                                                            |
| ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| <a name="output_arn"></a> [arn](#output_arn)                                                                                  | The Amazon Resource Name (ARN) identifying your Lambda Function.                                                       |
| <a name="output_dead_letter_config"></a> [dead_letter_config](#output_dead_letter_config)                                     | The function's dead letter queue configuration.                                                                        |
| <a name="output_description"></a> [description](#output_description)                                                          | Description of what your Lambda Function does.                                                                         |
| <a name="output_environment"></a> [environment](#output_environment)                                                          | The Lambda environment's configuration settings.                                                                       |
| <a name="output_function_name"></a> [function_name](#output_function_name)                                                    | The unique name for your Lambda Function.                                                                              |
| <a name="output_handler"></a> [handler](#output_handler)                                                                      | The function entrypoint in your code.                                                                                  |
| <a name="output_invoke_arn"></a> [invoke_arn](#output_invoke_arn)                                                             | The ARN to be used for invoking Lambda Function from API Gateway.                                                      |
| <a name="output_kms_key_arn"></a> [kms_key_arn](#output_kms_key_arn)                                                          | The ARN for the KMS encryption key.                                                                                    |
| <a name="output_last_modified"></a> [last_modified](#output_last_modified)                                                    | The date this resource was last modified.                                                                              |
| <a name="output_layers"></a> [layers](#output_layers)                                                                         | List of Lambda Layer Version ARNs attached to your Lambda Function.                                                    |
| <a name="output_log_group_name"></a> [log_group_name](#output_log_group_name)                                                 | The log group name for your Lambda Function.                                                                           |
| <a name="output_log_group_name_edge"></a> [log_group_name_edge](#output_log_group_name_edge)                                  | The log group name for your Lambda@Edge Function.                                                                      |
| <a name="output_memory_size"></a> [memory_size](#output_memory_size)                                                          | Amount of memory in MB your Lambda Function can use at runtime.                                                        |
| <a name="output_publish"></a> [publish](#output_publish)                                                                      | Whether creation/changes will publish a new Lambda Function Version.                                                   |
| <a name="output_qualified_arn"></a> [qualified_arn](#output_qualified_arn)                                                    | The Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true). |
| <a name="output_reserved_concurrent_executions"></a> [reserved_concurrent_executions](#output_reserved_concurrent_executions) | The amount of reserved concurrent executions for this lambda function.                                                 |
| <a name="output_role"></a> [role](#output_role)                                                                               | IAM role attached to the Lambda Function.                                                                              |
| <a name="output_role_name"></a> [role_name](#output_role_name)                                                                | The name of the IAM role attached to the Lambda Function.                                                              |
| <a name="output_runtime"></a> [runtime](#output_runtime)                                                                      | The identifier of the function's runtime.                                                                              |
| <a name="output_s3_bucket"></a> [s3_bucket](#output_s3_bucket)                                                                | The S3 bucket location containing the function's deployment package.                                                   |
| <a name="output_s3_key"></a> [s3_key](#output_s3_key)                                                                         | The S3 key of an object containing the function's deployment package.                                                  |
| <a name="output_s3_object_version"></a> [s3_object_version](#output_s3_object_version)                                        | The object version containing the function's deployment package.                                                       |
| <a name="output_source_code_hash"></a> [source_code_hash](#output_source_code_hash)                                           | Base64-encoded representation of raw SHA-256 sum of the zip file.                                                      |
| <a name="output_source_code_size"></a> [source_code_size](#output_source_code_size)                                           | The size in bytes of the function .zip file.                                                                           |
| <a name="output_tags"></a> [tags](#output_tags)                                                                               | A mapping of tags assigned to the object.                                                                              |
| <a name="output_timeout"></a> [timeout](#output_timeout)                                                                      | The amount of time your Lambda Function has to run in seconds.                                                         |
| <a name="output_tracing_config"></a> [tracing_config](#output_tracing_config)                                                 | The tracing configuration.                                                                                             |
| <a name="output_version"></a> [version](#output_version)                                                                      | Latest published version of your Lambda Function.                                                                      |
| <a name="output_vpc_config"></a> [vpc_config](#output_vpc_config)                                                             | The VPC configuration.                                                                                                 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
