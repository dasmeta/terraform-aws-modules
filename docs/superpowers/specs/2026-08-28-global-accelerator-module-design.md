# AWS Global Accelerator Wrapper Module Design

**Date:** 2026-08-28
**Status:** Design approved in conversation; independent spec review passed; awaiting written-spec confirmation
**Target repository:** `terraform-aws-modules`
**Target module:** `modules/global-accelerator`

## Context

The repository needs a reusable AWS Global Accelerator module without reimplementing Global Accelerator resources directly. The module will follow the repository's recent `modules/nlb` precedent: expose a smaller DasMeta-oriented interface and delegate resource creation to a maintained upstream module.

The selected baseline is [`terraform-aws-modules/global-accelerator/aws`](https://registry.terraform.io/modules/terraform-aws-modules/global-accelerator/aws/latest) version `~> 3.0`. The upstream module creates the standard accelerator, listeners, and endpoint groups. The local module adds typed inputs, grouped configuration, defaults, validation, stable outputs, examples, and repository CI integration.

## Goals

- Create a reusable Standard Accelerator wrapper at `modules/global-accelerator`.
- Use the upstream module instead of declaring Global Accelerator resources directly.
- Accept identifiers for existing ALB, NLB, EC2, and Elastic IP endpoints.
- Support multiple TCP or UDP listeners and multiple regional endpoint groups.
- Support endpoint weights, regional traffic dials, health checks, port overrides, IPv4, and Dual Stack.
- Optionally publish flow logs to an existing S3 bucket, disabled by default.
- Expose a typed, validated interface rather than forwarding the upstream `listeners = any` contract.
- Add useful outputs, copy-pasteable documentation, executable validation fixtures, and CI matrix coverage.

## Non-goals

- Creating ALBs, NLBs, EC2 instances, Elastic IP addresses, or S3 buckets.
- Creating or modifying the S3 bucket policy required for flow-log delivery.
- Supporting Custom Routing Accelerators.
- Supporting BYOIP through the upstream `ip_addresses` input.
- Supporting cross-account endpoint attachments through `attachment_arn`.
- Exposing upstream resource timeouts, `create`, or `create_listeners` controls.
- Passing through the complete upstream input surface.

## Approaches Considered

### 1. Typed opinionated wrapper — selected

Expose strongly typed listener, endpoint-group, endpoint, health-check, and flow-log objects. Normalize these objects in `locals.tf` and pass the normalized structure to the upstream module.

This adds a stable consumer contract, catches invalid configuration early, and keeps the supported interface intentionally smaller than the upstream module.

### 2. Thin upstream pass-through

Forward `listeners` as `any` and expose the upstream flat flow-log variables. This would require less wrapper code but would add little value, provide no reliable contract, and couple consumers directly to the upstream module's internal input shape.

### 3. Separate accelerator and endpoint-group submodules

Create one local submodule for the accelerator/listeners and another for endpoint groups. This would permit more provider wiring flexibility but would make the common Standard Accelerator case unnecessarily complex. The selected upstream module already supports nested multi-region endpoint groups.

## Architecture

The local module contains one upstream module block and no direct AWS resource blocks.

```text
Consumer configuration
        |
        v
Typed wrapper inputs and validation
        |
        v
locals.tf normalization
        |
        v
terraform-aws-modules/global-accelerator/aws ~> 3.0
        |
        v
AWS Standard Accelerator, listeners, and endpoint groups
```

One module instance creates one Standard Accelerator. A listener owns one or more endpoint groups, and each endpoint group is explicitly associated with one AWS Region and one or more existing endpoints. This matches the AWS hierarchy documented for [standard accelerators](https://docs.aws.amazon.com/global-accelerator/latest/dg/work-with-standard-accelerators.html).

The wrapper always creates its accelerator when instantiated. Consumers can temporarily stop traffic by setting `enabled = false`; they do not receive a separate resource-creation flag.

## Dependencies and Version Constraints

`versions.tf` will preserve the layout used by the repository's recent `modules/nlb` module:

```hcl
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

`main.tf` will use:

```hcl
module "this" {
  source  = "terraform-aws-modules/global-accelerator/aws"
  version = "~> 3.0"
}
```

Upstream version 3 requires `hashicorp/aws >= 5.84`. Combined with the wrapper constraint, dependency resolution is effectively `>= 5.84, < 6.0`. Terraform `>= 1.3.0` is required because the wrapper uses optional object attributes with defaults. The module's native mock-provider test suite requires Terraform `>= 1.7.0`; this is a test-tooling requirement and does not raise the consumer-facing module minimum.

No separate `providers.tf` is needed because the module does not configure a provider and the related repository precedent keeps `required_providers` in `versions.tf`.

## Public Input Contract

### Top-level inputs

| Input | Type | Required | Default | Purpose |
| --- | --- | --- | --- | --- |
| `name` | `string` | yes | — | Accelerator name |
| `enabled` | `bool` | no | `true` | Whether the accelerator accepts and routes traffic |
| `ip_address_type` | `string` | no | `"IPV4"` | `IPV4` or `DUAL_STACK` |
| `listeners` | typed map | yes | — | Listener, endpoint-group, and endpoint configuration |
| `flow_logs` | typed object | no | `{ enabled = false }` | Optional delivery to an existing S3 bucket |
| `tags` | `map(string)` | no | `{}` | Tags forwarded to supported resources |

The wrapper intentionally does not expose upstream `create`, `create_listeners`, `ip_addresses`, listener timeouts, endpoint-group timeouts, or cross-account attachment fields.

### Listener and endpoint-group shape

The intended type contract is:

```hcl
map(object({
  protocol        = optional(string, "TCP")
  client_affinity = optional(string, "NONE")

  port_ranges = list(object({
    from_port = number
    to_port   = number
  }))

  endpoint_groups = map(object({
    endpoint_group_region   = string
    traffic_dial_percentage = optional(number, 100)

    health_check = optional(object({
      protocol         = optional(string, "TCP")
      port             = optional(number)
      path             = optional(string)
      interval_seconds = optional(number, 30)
      threshold_count  = optional(number, 3)
    }), {})

    endpoints = list(object({
      endpoint_id                    = string
      weight                         = optional(number, 128)
      client_ip_preservation_enabled = optional(bool)
    }))

    port_overrides = optional(list(object({
      listener_port = number
      endpoint_port = number
    })), [])
  }))
}))
```

The exact Terraform formatting may change during implementation, but field names, requiredness, defaults, and nesting are part of the approved public contract.

`client_ip_preservation_enabled` intentionally has no wrapper default. When omitted, the wrapper passes no explicit value and lets the upstream module/provider apply endpoint-type behavior. The README will document that support varies by endpoint type and that preserving client IP can require security-group changes.

### Flow-log shape

```hcl
object({
  enabled   = optional(bool, false)
  s3_bucket = optional(string)
  s3_prefix = optional(string)
})
```

When `enabled` is `false`, the bucket and prefix may be omitted. When it is `true`, both values must be non-null and non-empty. The bucket must already exist and the caller owns its delivery permissions. AWS publishes Global Accelerator flow logs to an [existing S3 bucket](https://docs.aws.amazon.com/global-accelerator/latest/dg/monitoring-global-accelerator.flow-logs.html).

## Normalization and Data Flow

`locals.tf` will translate the consumer-friendly grouped input into the upstream shape:

- `health_check.protocol` becomes `health_check_protocol`.
- `health_check.port` becomes `health_check_port`.
- `health_check.path` becomes `health_check_path`.
- `health_check.interval_seconds` becomes `health_check_interval_seconds`.
- `health_check.threshold_count` becomes `threshold_count`.
- `endpoints` becomes `endpoint_configuration`.
- `port_overrides` becomes `port_override`.
- The `flow_logs` object becomes the upstream flat `flow_logs_enabled`, `flow_logs_s3_bucket`, and `flow_logs_s3_prefix` inputs.

Listener map keys and endpoint-group map keys remain stable logical identifiers. The wrapper will not infer AWS Regions from endpoint IDs; `endpoint_group_region` is explicit and required.

Both listener and endpoint-group map keys must match `^[A-Za-z0-9][A-Za-z0-9_-]*$`. In particular, keys cannot be empty or contain `:`. This keeps the upstream v3 composite endpoint-group address (`"${listener_key}:${endpoint_group_key}"`) collision-free and makes keyed wrapper outputs deterministic.

## Validation and Error Handling

Terraform variable validation will reject structurally invalid inputs before AWS API calls:

- `name` must contain from 1 through 64 characters, use only alphanumeric characters and hyphens, and not begin or end with a hyphen. Although the AWS API model has historically described periods as acceptable, [AWS provider 5.84 validates accelerator names](https://github.com/hashicorp/terraform-provider-aws/blob/v5.84.0/internal/service/globalaccelerator/accelerator.go) with `^[0-9A-Za-z-]+$`; the wrapper follows the selected provider contract.
- `listeners` must contain at least one listener.
- Listener and endpoint-group map keys must match `^[A-Za-z0-9][A-Za-z0-9_-]*$` so they are non-empty and safe for upstream composite addressing.
- Each listener must contain from one through ten port ranges and at least one endpoint group.
- `protocol` must be `TCP` or `UDP`.
- `client_affinity` must be `NONE` or `SOURCE_IP`.
- Listener and override ports must be integers from 1 through 65535.
- Each port range must satisfy `from_port <= to_port`.
- Listener port ranges must not overlap within one listener or across different listeners. Port numbers are unique for the accelerator regardless of listener protocol, matching the AWS `InvalidPortRangeException` contract. Validation will compare interval boundaries directly rather than expand large ranges into individual port numbers.
- Every `port_override.listener_port` must belong to one of its parent listener's configured port ranges.
- A `port_override.endpoint_port` must not fall within any listener port range configured anywhere on the accelerator.
- Within one endpoint group, override pairs, listener ports, and endpoint ports must be unique. Across the accelerator, one endpoint port must not map from more than one distinct listener port; repeating the same mapping for equivalent regional endpoint groups remains valid.
- Each endpoint group must have a non-empty Region and from one through ten endpoints.
- A listener cannot contain more than one endpoint group for the same Region.
- Each endpoint group can contain at most ten port overrides.
- `traffic_dial_percentage` must be from 0 through 100.
- Health-check protocol must be `TCP`, `HTTP`, or `HTTPS`.
- Health-check interval must be 10 or 30 seconds.
- Health-check port, when set, must be from 1 through 65535.
- Health-check threshold must be an integer from 1 through 10.
- Health-check path, when set, is allowed only for `HTTP` or `HTTPS`, must contain from 1 through 255 characters, and must match the AWS pattern `^/[-a-zA-Z0-9@:%_\\+.~#?&/=]*$`.
- Endpoint IDs must be non-empty.
- Endpoint weights must be integers from 0 through 255; the default is 128, matching [AWS endpoint-weight behavior](https://docs.aws.amazon.com/global-accelerator/latest/dg/about-endpoints-endpoint-weights.html).
- Enabling flow logs requires non-empty S3 bucket and prefix values.

Some conditions cannot be determined from Terraform input strings. AWS/provider errors remain authoritative for:

- Whether an ARN, instance ID, or allocation ID exists and is active.
- Whether an endpoint belongs to the configured endpoint-group Region.
- Whether a Dual Stack accelerator's endpoints support Dual Stack.
- Whether client IP preservation is supported for the selected endpoint and listener combination.
- Whether the S3 bucket policy permits flow-log delivery.

The README will call out these runtime constraints and will not imply that the module creates or repairs endpoint or S3 configuration.

## Outputs

The module will expose:

| Output | Shape | Purpose |
| --- | --- | --- |
| `accelerator_arn` | `string` | Accelerator ARN |
| `dns_name` | `string` | IPv4 accelerator DNS name |
| `dual_stack_dns_name` | `string` or `null` | Dual Stack DNS name for `DUAL_STACK`; explicitly `null` for `IPV4` |
| `hosted_zone_id` | `string` | Route53 alias hosted-zone ID |
| `ip_sets` | `list(object({ ip_addresses = list(string), ip_family = string }))` | Assigned IPv4 and, for Dual Stack, IPv6 address sets |
| `listener_arns` | `map(string)` | Listener ARN keyed by listener key |
| `endpoint_group_arns` | `map(map(string))` | Endpoint-group ARN keyed first by listener key and then endpoint-group key |

The wrapper will derive the two ARN maps from upstream resource outputs rather than expose the entire upstream resource objects. This keeps the consumer contract stable while returning values needed for DNS, monitoring, and downstream references. `ip_sets` preserves the provider's list of objects without promising element order; each object contains an IP family and that family's assigned address list. The wrapper normalizes the upstream empty-string behavior for an IPv4-only `dual_stack_dns_name` to `null`.

## Documentation and Examples

`README.md` will include:

- A minimal Standard Accelerator example using a neutral example ALB ARN.
- A multi-region example with endpoint weights and traffic dials.
- A flow-log example using an existing S3 bucket.
- Input/output tables generated or kept consistent with repository tooling.
- Notes about effective AWS provider compatibility (`>= 5.84, < 6.0`).
- Notes about Dual Stack endpoint compatibility, client IP preservation, and caller-owned S3 permissions.
- Explicit non-goals so consumers do not assume endpoint resources or buckets are created.

All examples, tests, comments, and identifiers will use `example`, `test`, or DasMeta-neutral naming and will not include customer-specific names or hostnames.

## Tests and Verification

Two executable Terraform fixtures will follow the repository's `0-setup.tf`, `1-example.tf`, `2-assert.tf`, and `README.md` convention:

### `tests/basic`

- One TCP listener.
- One endpoint group with an existing example ALB ARN.
- Default IPv4 behavior.
- Default flow logs disabled.
- Output references for the accelerator, listener, and endpoint group.

### `tests/flow-logs`

- One UDP listener.
- Explicit endpoint weights.
- Flow logs enabled with an existing example bucket and prefix.
- Output references that exercise the public output contract.

The fixtures remain copy-pasteable validation examples. In addition, native Terraform tests will be added directly under `tests/`:

- `tests/contract.tftest.hcl` will use a mocked AWS provider and plan-time generated values. Successful runs will verify defaults, the consumer-to-upstream listener and endpoint-group normalization, keyed ARN outputs, the exact `ip_sets` shape, `dual_stack_dns_name = null` for IPv4, and the Dual Stack output path. The test can inspect the wrapper's child-module outputs (`module.this.listeners` and `module.this.endpoint_groups`) without adding test-only public outputs.
- `tests/validation.tftest.hcl` will use plan runs with `expect_failures`. Every custom validation family will have at least one negative case: name and IP type, listener presence/key grammar/protocol/affinity/range bounds and overlap, endpoint-group key grammar/Region/cardinality, traffic dial, health-check settings/path, endpoint ID/weight, port-override membership/overlap/duplicates, and incomplete flow-log configuration.
- `tests/basic.tftest.hcl` and `tests/flow-logs.tftest.hcl` will plan the two fixture directories with the mocked provider so the documented examples remain executable.

[Mock-provider testing](https://developer.hashicorp.com/terraform/language/tests/mocking) requires Terraform `>= 1.7.0` and guarantees that no test contacts AWS or applies real infrastructure. The currently pinned reusable test action runs `terraform test` without first initializing a clean checkout, so the Global Accelerator matrix entry needs a dedicated conditional path in `terraform-test.yaml`: checkout, set up Terraform `1.7.5`, run `terraform init -backend=false`, and then run `terraform test`. The existing reusable-action step will be skipped only for this matrix entry and will remain unchanged for every existing module.

```text
terraform fmt -check -recursive modules/global-accelerator
terraform -chdir=modules/global-accelerator init -backend=false
terraform -chdir=modules/global-accelerator validate
terraform -chdir=modules/global-accelerator/tests/basic init -backend=false
terraform -chdir=modules/global-accelerator/tests/basic validate
terraform -chdir=modules/global-accelerator/tests/flow-logs init -backend=false
terraform -chdir=modules/global-accelerator/tests/flow-logs validate
terraform -chdir=modules/global-accelerator test
```

The module path will be added to the matrices in:

- `.github/workflows/terraform-test.yaml`
- `.github/workflows/tflint.yaml`
- `.github/workflows/checkov.yaml`

## Planned File Scope

```text
docs/superpowers/specs/2026-08-28-global-accelerator-module-design.md
specs/003-global-accelerator-module/
modules/global-accelerator/
  main.tf
  variables.tf
  locals.tf
  outputs.tf
  versions.tf
  README.md
  tests/basic/
  tests/flow-logs/
  tests/basic.tftest.hcl
  tests/flow-logs.tftest.hcl
  tests/contract.tftest.hcl
  tests/validation.tftest.hcl
.github/workflows/terraform-test.yaml
.github/workflows/tflint.yaml
.github/workflows/checkov.yaml
```

No existing module source or interface is changed.

## Speckit and Governance

This is module-impacting work and requires a corresponding evidence package. The repository contains `specs/` packages but does not contain `.specify/`. Following the accepted `specs/001-nlb-module` repository precedent, planning will create a manual package at `specs/003-global-accelerator-module/` with at least `spec.md`, `plan.md`, and `tasks.md` before any Terraform module files are edited.

The missing `.specify/` bootstrap will be recorded as a bounded workflow gap. If a strict downstream gate requires `.specify/feature.json`, Spec Kit bootstrap must be handled separately before merge.

Shared module standards come from the Terraform Module Developer constitution references; repository-local files will contain only module-specific behavior and usage guidance.

## Modern Capabilities Classification

The following net-new abilities are classified as **supported** based on current AWS and provider documentation:

- Standard Accelerator creation.
- TCP and UDP listeners.
- IPv4 and Dual Stack accelerators.
- Regional endpoint groups with health checks and traffic dials.
- ALB, NLB, EC2, and Elastic IP endpoints with weights.
- Flow-log delivery to an existing S3 bucket.

No deprecated capability is selected, no replacement is required, and no exception is requested. Custom routing, BYOIP, and cross-account attachment support are outside this change.

## Risks and Mitigations

| Risk | Mitigation |
| --- | --- |
| Upstream `listeners` is untyped | Keep the local public contract typed and normalize it before delegation |
| Upstream endpoint-group addresses join map keys with `:` | Restrict listener and endpoint-group keys to a colon-free grammar and test invalid keys |
| Upstream v3 requires AWS provider `>= 5.84` | Document the effective range created by `~> 5.0` plus the upstream constraint |
| Upstream shape changes in a future major version | Pin to `~> 3.0` and expose stable wrapper outputs instead of raw objects |
| Invalid or incompatible endpoint identifiers | Validate what is knowable locally and document AWS runtime validation |
| Port overrides conflict across listeners or endpoint groups | Validate parent-listener membership, endpoint-port overlap, and mapping uniqueness across the typed listener input |
| Listener ranges reuse an accelerator port | Reject interval overlap within and across listeners before the provider reaches AWS |
| Flow logs enabled without working S3 permissions | Require bucket/prefix inputs and document caller-owned bucket policy |
| Dual Stack used with unsupported endpoints | Document AWS endpoint compatibility requirements |
| Client IP preservation has endpoint-specific side effects | Do not force a default; document security-group and lifecycle implications |
| Strict module-change gate expects `.specify/` metadata | Include manual Speckit evidence and surface bootstrap as a merge-time requirement if enforced |

## Acceptance Criteria

- The wrapper uses `terraform-aws-modules/global-accelerator/aws ~> 3.0` and declares no direct Global Accelerator resources.
- AWS provider is constrained to `~> 5.0`, resolving with the upstream minimum of 5.84.
- The public interface is typed and rejects invalid names, logical map keys, protocols, duplicate or overlapping listener ports, invalid port overrides, traffic dials, weights, health-check settings, and incomplete flow-log configuration.
- The module supports multiple listeners, endpoint groups, Regions, and existing supported endpoint types.
- Flow logs are disabled by default and can target an existing S3 bucket when enabled.
- Outputs provide accelerator identity/DNS/IP information with documented stable shapes and keyed listener/endpoint-group ARNs.
- README and both test fixtures match the live interface.
- Formatting, initialization, validation, and mocked native Terraform tests succeed without contacting AWS.
- The module is present in all three repository CI matrices.
- A corresponding manual Speckit `spec.md`, `plan.md`, and `tasks.md` package exists before module implementation begins.
