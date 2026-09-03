# AWS Global Accelerator Wrapper Module Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and verify a typed Terraform wrapper for AWS Standard Global Accelerator that delegates resource creation to `terraform-aws-modules/global-accelerator/aws` and accepts existing endpoint identifiers.

**Architecture:** One local module normalizes a grouped consumer contract into the upstream v3 `listeners = any` shape. The wrapper declares no direct Global Accelerator resources, validates all input-only AWS invariants, exposes stable outputs, and uses native Terraform mock-provider tests so verification never contacts AWS.

**Tech Stack:** Terraform `>= 1.3.0`, Terraform test framework `1.7.5`, HashiCorp AWS provider `~> 5.0`, `terraform-aws-modules/global-accelerator/aws ~> 3.0`, GitHub Actions.

---

## Chunk 1: TDD Implementation And Delivery

### File Structure

- `modules/global-accelerator/versions.tf`: Terraform and AWS provider constraints only.
- `modules/global-accelerator/variables.tf`: typed public contract and input-only validation.
- `modules/global-accelerator/locals.tf`: grouped-input normalization into upstream v3 fields.
- `modules/global-accelerator/main.tf`: one upstream module block; no direct resources.
- `modules/global-accelerator/outputs.tf`: stable accelerator values and keyed ARN maps.
- `modules/global-accelerator/README.md`: usage, examples, constraints, and generated tables.
- `modules/global-accelerator/tests/contract.tftest.hcl`: successful mocked contract and normalization assertions.
- `modules/global-accelerator/tests/validation.tftest.hcl`: negative custom-validation tests.
- `modules/global-accelerator/tests/basic.tftest.hcl`: mocked plan of the basic fixture.
- `modules/global-accelerator/tests/flow-logs.tftest.hcl`: mocked plan of the flow-log fixture.
- `modules/global-accelerator/tests/assert-flow-logs.sh`: verifies the verbose mocked plan contains the three upstream accelerator flow-log attributes.
- `modules/global-accelerator/tests/basic/{0-setup.tf,1-example.tf,2-assert.tf,README.md}`: copy-pasteable IPv4/TCP example.
- `modules/global-accelerator/tests/flow-logs/{0-setup.tf,1-example.tf,2-assert.tf,README.md}`: copy-pasteable UDP/flow-log example.
- `.github/workflows/terraform-test.yaml`: module matrix entry and isolated Terraform 1.7.5 init/test path.
- `.github/workflows/tflint.yaml`: module matrix entry.
- `.github/workflows/checkov.yaml`: module matrix entry.
- `specs/003-global-accelerator-module/{spec.md,plan.md,tasks.md}`: module-change evidence.

### Task 1: Commit Planning Evidence

**Files:**

- Create: `specs/003-global-accelerator-module/spec.md`
- Create: `specs/003-global-accelerator-module/plan.md`
- Create: `specs/003-global-accelerator-module/tasks.md`
- Create: `docs/superpowers/plans/2026-08-28-global-accelerator-module.md`

- [ ] **Step 1: Verify all required evidence exists before module edits**

Run:

```bash
test -f specs/003-global-accelerator-module/spec.md
test -f specs/003-global-accelerator-module/plan.md
test -f specs/003-global-accelerator-module/tasks.md
test -f docs/superpowers/plans/2026-08-28-global-accelerator-module.md
git diff --check
```

Expected: exit code 0 and no whitespace diagnostics.

- [ ] **Step 2: Commit the planning baseline**

```bash
git add specs/003-global-accelerator-module docs/superpowers/plans/2026-08-28-global-accelerator-module.md
SKIP=terraform_docs git commit -m "docs: plan global accelerator wrapper module"
```

Expected: one docs-only commit; unrelated README files remain unchanged.

### Task 2: Write Contract Tests And Observe RED

**Files:**

- Create: `modules/global-accelerator/tests/contract.tftest.hcl`
- Create: `modules/global-accelerator/tests/validation.tftest.hcl`
- Create: `modules/global-accelerator/tests/basic.tftest.hcl`
- Create: `modules/global-accelerator/tests/flow-logs.tftest.hcl`
- Create: `modules/global-accelerator/tests/assert-flow-logs.sh`
- Create: `modules/global-accelerator/tests/basic/0-setup.tf`
- Create: `modules/global-accelerator/tests/basic/1-example.tf`
- Create: `modules/global-accelerator/tests/basic/2-assert.tf`
- Create: `modules/global-accelerator/tests/basic/README.md`
- Create: `modules/global-accelerator/tests/flow-logs/0-setup.tf`
- Create: `modules/global-accelerator/tests/flow-logs/1-example.tf`
- Create: `modules/global-accelerator/tests/flow-logs/2-assert.tf`
- Create: `modules/global-accelerator/tests/flow-logs/README.md`

- [ ] **Step 1: Write the successful contract test against the desired API**

Use a complete mock of the computed provider values consumed by outputs:

```hcl
mock_provider "aws" {
  override_during = plan

  mock_resource "aws_globalaccelerator_accelerator" {
    defaults = {
      arn                 = "arn:aws:globalaccelerator::123456789012:accelerator/example"
      dns_name            = "a1234567890example.awsglobalaccelerator.com"
      dual_stack_dns_name = "a1234567890example.dualstack.awsglobalaccelerator.com"
      hosted_zone_id      = "Z2BJ6XQ5FK7U4H"
      ip_sets = [{
        ip_addresses = ["192.0.2.10", "192.0.2.11"]
        ip_family    = "IPv4"
      }]
    }
  }

  mock_resource "aws_globalaccelerator_listener" {
    defaults = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/example"
    }
  }

  mock_resource "aws_globalaccelerator_endpoint_group" {
    defaults = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/example/endpoint-group/example"
    }
  }
}

variables {
  name = "example-global-accelerator"
  listeners = {
    web = {
      port_ranges = [{ from_port = 443, to_port = 443 }]
      endpoint_groups = {
        primary = {
          endpoint_group_region = "eu-central-1"
          health_check = {
            protocol = "HTTPS"
            port     = 443
            path     = "/health"
          }
          endpoints = [{
            endpoint_id = "arn:aws:elasticloadbalancing:eu-central-1:123456789012:loadbalancer/app/example/0123456789abcdef"
            weight      = 200
          }]
          port_overrides = [{ listener_port = 443, endpoint_port = 8443 }]
        }
        secondary = {
          endpoint_group_region = "us-east-1"
          endpoints = [{
            endpoint_id = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/example/0123456789abcdef"
          }]
          port_overrides = [{ listener_port = 443, endpoint_port = 8443 }]
        }
      }
    }
    dns = {
      protocol    = "UDP"
      port_ranges = [{ from_port = 53, to_port = 53 }]
      endpoint_groups = {
        primary = {
          endpoint_group_region = "eu-west-1"
          endpoints = [{
            endpoint_id = "i-0123456789abcdef0"
          }]
        }
      }
    }
  }
}

run "normalizes_standard_accelerator" {
  command = plan

  assert {
    condition     = module.this.listeners["web"].protocol == "TCP"
    error_message = "The wrapper must default listener protocol to TCP."
  }

  assert {
    condition     = module.this.endpoint_groups["web:primary"].health_check_protocol == "HTTPS"
    error_message = "The grouped health check must be normalized for upstream v3."
  }

  assert {
    condition     = one(module.this.endpoint_groups["web:primary"].endpoint_configuration).weight == 200
    error_message = "Endpoint weight must reach the upstream endpoint configuration."
  }

  assert {
    condition     = one(module.this.endpoint_groups["web:primary"].port_override).endpoint_port == 8443
    error_message = "Port overrides must reach the upstream endpoint group."
  }

  assert {
    condition     = output.dual_stack_dns_name == null
    error_message = "IPv4 accelerators must expose null for dual_stack_dns_name."
  }

  assert {
    condition     = toset(keys(output.listener_arns)) == toset(["web", "dns"]) && toset(keys(output.endpoint_group_arns["web"])) == toset(["primary", "secondary"])
    error_message = "ARN outputs must retain consumer logical keys."
  }

  assert {
    condition     = output.ip_sets[0].ip_family == "IPv4" && output.ip_sets[0].ip_addresses == ["192.0.2.10", "192.0.2.11"]
    error_message = "The IPv4 IP-set structure must remain stable."
  }

  assert {
    condition     = var.flow_logs.enabled == false
    error_message = "Flow logs must be disabled by default."
  }
}
```

Add a second valid run with `ip_address_type = "DUAL_STACK"`. Inside that run, use an `override_resource` targeting `module.this.aws_globalaccelerator_accelerator.this[0]` and set `ip_sets` to complete IPv4 and IPv6 objects. Assert the mocked Dual Stack DNS value, both families, and both address lists are exposed through wrapper outputs:

```hcl
override_resource {
  target = module.this.aws_globalaccelerator_accelerator.this[0]
  values = {
    dual_stack_dns_name = "a1234567890example.dualstack.awsglobalaccelerator.com"
    ip_sets = [
      {
        ip_addresses = ["192.0.2.10", "192.0.2.11"]
        ip_family    = "IPv4"
      },
      {
        ip_addresses = ["2001:db8::10", "2001:db8::11"]
        ip_family    = "IPv6"
      }
    ]
  }
}
```

- [ ] **Step 2: Write negative validation runs**

Create one baseline valid `variables` block, then one `command = plan` run per row. Each run must use `expect_failures = [var.<name>]`.

| Run | Invalid mutation | Expected checkable |
| --- | --- | --- |
| `rejects_invalid_name` | `name = "invalid.name"` | `var.name` |
| `rejects_invalid_ip_type` | `ip_address_type = "ipv6"` | `var.ip_address_type` |
| `rejects_empty_listeners` | `listeners = {}` | `var.listeners` |
| `rejects_unsafe_listener_key` | listener key `"web:tcp"` | `var.listeners` |
| `rejects_unsafe_group_key` | group key `"eu:primary"` | `var.listeners` |
| `rejects_invalid_protocol` | protocol `"HTTP"` | `var.listeners` |
| `rejects_invalid_affinity` | affinity `"COOKIE"` | `var.listeners` |
| `rejects_empty_port_ranges` | listener has zero ranges | `var.listeners` |
| `rejects_too_many_port_ranges` | listener has eleven ranges | `var.listeners` |
| `rejects_empty_endpoint_groups` | listener has zero groups | `var.listeners` |
| `rejects_invalid_range` | `from_port = 443`, `to_port = 80` | `var.listeners` |
| `rejects_port_below_range` | range contains port `0` | `var.listeners` |
| `rejects_port_above_range` | range contains port `65536` | `var.listeners` |
| `rejects_fractional_port` | range contains port `443.5` | `var.listeners` |
| `rejects_overlapping_ranges` | ranges `80-90` and `90-100` | `var.listeners` |
| `rejects_cross_listener_overlap` | separate listeners both include port 443 | `var.listeners` |
| `rejects_empty_region` | group Region is whitespace | `var.listeners` |
| `rejects_duplicate_region` | two groups use `eu-central-1` | `var.listeners` |
| `rejects_empty_endpoints` | group has zero endpoints | `var.listeners` |
| `rejects_too_many_endpoints` | group has eleven endpoints | `var.listeners` |
| `rejects_empty_endpoint_id` | endpoint ID is whitespace | `var.listeners` |
| `rejects_invalid_traffic_dial` | percentage `101` | `var.listeners` |
| `rejects_invalid_health_protocol` | health protocol `"UDP"` | `var.listeners` |
| `rejects_invalid_health_interval` | interval `20` | `var.listeners` |
| `rejects_invalid_health_port` | health port `0` | `var.listeners` |
| `rejects_fractional_health_port` | health port `443.5` | `var.listeners` |
| `rejects_invalid_health_threshold` | threshold `11` | `var.listeners` |
| `rejects_invalid_health_path` | HTTP path `"health"` | `var.listeners` |
| `rejects_tcp_health_path` | TCP health check with `/health` | `var.listeners` |
| `rejects_invalid_weight` | weight `256` | `var.listeners` |
| `rejects_fractional_weight` | weight `127.5` | `var.listeners` |
| `rejects_too_many_overrides` | group has eleven overrides | `var.listeners` |
| `rejects_invalid_override_port` | override contains port `0` | `var.listeners` |
| `rejects_fractional_override_port` | override contains port `8443.5` | `var.listeners` |
| `rejects_foreign_override_port` | listener owns 443, override uses 80 | `var.listeners` |
| `rejects_override_endpoint_overlap` | endpoint port equals any accelerator listener port | `var.listeners` |
| `rejects_duplicate_override_listener_port` | one group maps the same listener port twice | `var.listeners` |
| `rejects_duplicate_override_endpoint_port` | one group maps two listener ports to the same endpoint port | `var.listeners` |
| `rejects_cross_group_conflicting_mapping` | two regional groups map different listener ports to endpoint port 8080 | `var.listeners` |
| `requires_flow_log_bucket_and_prefix` | logs enabled with missing values | `var.flow_logs` |

- [ ] **Step 3: Write executable fixture modules**

`tests/basic/1-example.tf` calls `../..` with one TCP 443 listener, one `eu-central-1` endpoint group, a neutral example ALB ARN, default IPv4, default weights, and flow logs omitted. `tests/flow-logs/1-example.tf` calls `../..` with one UDP 53 listener, one EC2 instance ID endpoint with an explicit weight, and:

```hcl
flow_logs = {
  enabled   = true
  s3_bucket = "example-global-accelerator-flow-logs"
  s3_prefix = "global-accelerator"
}
```

Each `0-setup.tf` declares Terraform `>= 1.3.0` and AWS `~> 5.0`. Each `2-assert.tf` references accelerator ARN/DNS, IP sets, listener ARNs, and endpoint-group ARNs.

- [ ] **Step 4: Add native fixture runners**

Each runner declares `mock_provider "aws" { override_during = plan }` and a plan run with the alternate local module:

```hcl
run "basic_fixture_plans" {
  command = plan

  module {
    source = "./tests/basic"
  }
}
```

Use `./tests/flow-logs` for the second runner.

- [ ] **Step 5: Add an end-to-end flow-log wiring assertion**

Because upstream v3 does not expose accelerator attributes as outputs, assert the actual nested resource plan rather than a test-only wrapper output. `tests/assert-flow-logs.sh` must run only the flow-log test with `-verbose -no-color`, capture output in a `mktemp` file, and require all three configured child-resource attributes:

```bash
#!/usr/bin/env bash
set -euo pipefail

module_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_file="$(mktemp)"
trap 'rm -f "$output_file"' EXIT

terraform -chdir="$module_dir" test -filter=tests/flow-logs.tftest.hcl -verbose -no-color >"$output_file"

grep -Eq 'flow_logs_enabled[[:space:]]*=[[:space:]]*true' "$output_file"
grep -Eq 'flow_logs_s3_bucket[[:space:]]*=[[:space:]]*"example-global-accelerator-flow-logs"' "$output_file"
grep -Eq 'flow_logs_s3_prefix[[:space:]]*=[[:space:]]*"global-accelerator"' "$output_file"
```

This script fails if any of the three wrapper-to-upstream arguments is removed. The module-specific CI path and full local verification must run it after `terraform test`.

Run `chmod +x modules/global-accelerator/tests/assert-flow-logs.sh` after creating it.

- [ ] **Step 6: Run tests and verify RED**

Run:

```bash
terraform -chdir=modules/global-accelerator init -backend=false
terraform -chdir=modules/global-accelerator test
```

Expected: `init` can load the test configurations, and `test` fails because the desired wrapper variables, child module, and outputs do not yet exist. Confirm the failure is about missing implementation, not invalid test syntax.

- [ ] **Step 7: Commit RED tests**

```bash
git add modules/global-accelerator/tests
SKIP=terraform_docs git commit -m "test: define global accelerator module contract"
```

### Task 3: Implement The Minimal Typed Wrapper And Reach GREEN

**Files:**

- Create: `modules/global-accelerator/versions.tf`
- Create: `modules/global-accelerator/variables.tf`
- Create: `modules/global-accelerator/locals.tf`
- Create: `modules/global-accelerator/main.tf`
- Create: `modules/global-accelerator/outputs.tf`

- [ ] **Step 1: Add exact dependency constraints**

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

- [ ] **Step 2: Add the typed public contract**

Define `name`, `enabled`, `ip_address_type`, `listeners`, `flow_logs`, and `tags`. The `listeners` type must be exactly:

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

The `flow_logs` type is:

```hcl
object({
  enabled   = optional(bool, false)
  s3_bucket = optional(string)
  s3_prefix = optional(string)
})
```

Its default is `{ enabled = false }`; accelerator `enabled` defaults to `true`, IP type to `IPV4`, and tags to `{}`.

- [ ] **Step 3: Implement top-level, key, enum, and cardinality validations**

Use separate validation blocks with full-sentence errors for name, IP type, non-empty listeners, key grammar, listener cardinality, group cardinality, protocol, affinity, non-empty Region, endpoint cardinality, and unique sibling Regions. Key and cardinality expressions must use only the declared variable:

```hcl
alltrue([
  for listener_key, listener in var.listeners :
  can(regex("^[A-Za-z0-9][A-Za-z0-9_-]*$", listener_key)) &&
  alltrue([
    for group_key in keys(listener.endpoint_groups) :
    can(regex("^[A-Za-z0-9][A-Za-z0-9_-]*$", group_key))
  ])
])
```

```hcl
alltrue([
  for listener in values(var.listeners) :
  length(listener.port_ranges) >= 1 && length(listener.port_ranges) <= 10 &&
  length(listener.endpoint_groups) >= 1
])
```

```hcl
alltrue([
  for listener in values(var.listeners) :
  length(distinct([
    for group in values(listener.endpoint_groups) : group.endpoint_group_region
  ])) == length(listener.endpoint_groups)
])
```

- [ ] **Step 4: Implement port range bounds, integrality, ordering, and global non-overlap**

Bounds and integrality use `floor(port) == port`. Global non-overlap must compare interval pairs without expanding ranges:

```hcl
alltrue(flatten([
  for listener_key, listener in var.listeners : [
    for range_index, port_range in listener.port_ranges : [
      for other_listener_key, other_listener in var.listeners : [
        for other_range_index, other_port_range in other_listener.port_ranges :
        (listener_key == other_listener_key && range_index == other_range_index) ||
        port_range.to_port < other_port_range.from_port ||
        other_port_range.to_port < port_range.from_port
      ]
    ]
  ]
]))
```

This rejects touching overlap such as `80-90` plus `90-100`, both within and across listeners, regardless of protocol.

- [ ] **Step 5: Implement endpoint, traffic-dial, and nullable health-check validations**

Validate traffic dial 0-100; health protocol TCP/HTTP/HTTPS; interval 10 or 30; threshold integer 1-10; trimmed endpoint IDs of length 1-255; and integer weights 0-255. Nullable health fields must use a conditional so Terraform never evaluates numeric/string functions on null:

```hcl
group.health_check.port == null ? true : (
  group.health_check.port >= 1 &&
  group.health_check.port <= 65535 &&
  floor(group.health_check.port) == group.health_check.port
)
```

```hcl
group.health_check.path == null ? true : (
  contains(["HTTP", "HTTPS"], group.health_check.protocol) &&
  length(group.health_check.path) >= 1 &&
  length(group.health_check.path) <= 255 &&
  can(regex("^/[-a-zA-Z0-9@:%_+.~#?&/=]*$", group.health_check.path))
)
```

- [ ] **Step 6: Implement port-override cardinality, bounds, membership, collision, and mapping validations**

Validate at most ten overrides and integer ports 1-65535. Parent-listener membership and endpoint-port non-overlap use interval comparisons:

```hcl
alltrue(flatten([
  for listener in values(var.listeners) : [
    for group in values(listener.endpoint_groups) : [
      for override in group.port_overrides :
      anytrue([
        for port_range in listener.port_ranges :
        override.listener_port >= port_range.from_port &&
        override.listener_port <= port_range.to_port
      ])
    ]
  ]
]))
```

```hcl
alltrue(flatten([
  for listener in values(var.listeners) : [
    for group in values(listener.endpoint_groups) : [
      for override in group.port_overrides :
      alltrue(flatten([
        for other_listener in values(var.listeners) : [
          for port_range in other_listener.port_ranges :
          override.endpoint_port < port_range.from_port ||
          override.endpoint_port > port_range.to_port
        ]
      ]))
    ]
  ]
]))
```

Within each group, compare `length(distinct(...))` with override count for both listener ports and endpoint ports. Across groups, reject one endpoint port mapped from distinct listener ports:

```hcl
alltrue(flatten([
  for listener in values(var.listeners) : [
    for group in values(listener.endpoint_groups) : [
      for override in group.port_overrides : [
        for other_listener in values(var.listeners) : [
          for other_group in values(other_listener.endpoint_groups) : [
            for other_override in other_group.port_overrides :
            override.endpoint_port != other_override.endpoint_port ||
            override.listener_port == other_override.listener_port
          ]
        ]
      ]
    ]
  ]
]))
```

- [ ] **Step 7: Implement null-safe flow-log validation**

```hcl
!var.flow_logs.enabled || (
  try(length(trimspace(var.flow_logs.s3_bucket)) >= 1, false) &&
  try(length(var.flow_logs.s3_bucket) <= 255, false) &&
  try(length(trimspace(var.flow_logs.s3_prefix)) >= 1, false) &&
  try(length(var.flow_logs.s3_prefix) <= 255, false)
)
```

- [ ] **Step 8: Normalize the public input**

`locals.tf` builds `local.listeners`. Preserve map keys and port ranges, flatten health fields to `health_check_*`, map `endpoints` to `endpoint_configuration`, and map `port_overrides` to `port_override`. Use `merge` to omit `health_check_port`, `health_check_path`, and `client_ip_preservation_enabled` when their public values are null.

Required normalized fields:

```hcl
{
  protocol        = listener.protocol
  client_affinity = listener.client_affinity
  port_ranges     = listener.port_ranges
  endpoint_groups = {
    group_key = {
      endpoint_group_region         = group.endpoint_group_region
      traffic_dial_percentage       = group.traffic_dial_percentage
      health_check_protocol         = group.health_check.protocol
      health_check_interval_seconds = group.health_check.interval_seconds
      threshold_count               = group.health_check.threshold_count
      endpoint_configuration        = group.endpoints
      port_override                 = group.port_overrides
    }
  }
}
```

- [ ] **Step 9: Add the one upstream module block**

```hcl
module "this" {
  source  = "terraform-aws-modules/global-accelerator/aws"
  version = "~> 3.0"

  name            = var.name
  enabled         = var.enabled
  ip_address_type = var.ip_address_type
  listeners       = local.listeners

  flow_logs_enabled   = var.flow_logs.enabled
  flow_logs_s3_bucket = var.flow_logs.s3_bucket
  flow_logs_s3_prefix = var.flow_logs.s3_prefix

  tags = var.tags
}
```

- [ ] **Step 10: Add stable outputs**

Expose upstream `arn`, `dns_name`, `hosted_zone_id`, and `ip_sets`. Normalize Dual Stack DNS with:

```hcl
value = var.ip_address_type == "DUAL_STACK" ? module.this.dual_stack_dns_name : null
```

Derive ARN maps with:

```hcl
value = { for key, listener in module.this.listeners : key => listener.arn }
```

and:

```hcl
value = {
  for listener_key, listener in var.listeners : listener_key => {
    for group_key in keys(listener.endpoint_groups) :
    group_key => module.this.endpoint_groups["${listener_key}:${group_key}"].arn
  }
}
```

- [ ] **Step 11: Format and run targeted tests**

Run:

```bash
terraform fmt -recursive modules/global-accelerator
terraform -chdir=modules/global-accelerator init -backend=false -upgrade
terraform -chdir=modules/global-accelerator test -filter=tests/contract.tftest.hcl
terraform -chdir=modules/global-accelerator test -filter=tests/validation.tftest.hcl
```

Expected: both test files pass. If any test reveals a defect, add or retain the failing run before changing implementation.

- [ ] **Step 12: Run the full suite and flow-log wiring assertion, then commit GREEN implementation**

Run:

```bash
terraform -chdir=modules/global-accelerator test
modules/global-accelerator/tests/assert-flow-logs.sh
```

Expected: all contract, validation, and fixture runs pass without AWS credentials.

```bash
git add modules/global-accelerator
SKIP=terraform_docs git commit -m "feat: add global accelerator wrapper module"
```

### Task 4: Document The Live Interface

**Files:**

- Create: `modules/global-accelerator/README.md`
- Modify: `modules/global-accelerator/tests/basic/README.md`
- Modify: `modules/global-accelerator/tests/flow-logs/README.md`

- [ ] **Step 1: Write README content around the tested interface**

Include:

- A minimal TCP/ALB example.
- A multi-region example with weights and traffic dials.
- A flow-log example using an existing bucket.
- Scope and non-goals.
- Effective AWS provider range `>= 5.84, < 6.0`.
- Existing endpoint requirements, Dual Stack compatibility, client IP preservation caveats, and caller-owned S3 policy.
- Exact output behavior, including IPv4 `dual_stack_dns_name = null`.
- Local commands for init, validate, and mock tests.
- The exact repository-compatible `<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->` and `<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->` markers, with an empty line between them, in all three new READMEs.

- [ ] **Step 2: Generate Terraform documentation tables**

Run:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject modules/global-accelerator
terraform-docs markdown table --output-file README.md --output-mode inject modules/global-accelerator/tests/basic
terraform-docs markdown table --output-file README.md --output-mode inject modules/global-accelerator/tests/flow-logs
```

Expected: only the three new README files change.

- [ ] **Step 3: Re-run tests after documentation reconciliation**

```bash
terraform fmt -check -recursive modules/global-accelerator
terraform -chdir=modules/global-accelerator validate
terraform -chdir=modules/global-accelerator test
```

Expected: all commands pass.

- [ ] **Step 4: Commit documentation**

```bash
git add modules/global-accelerator/README.md modules/global-accelerator/tests/basic/README.md modules/global-accelerator/tests/flow-logs/README.md
SKIP=terraform_docs git commit -m "docs: document global accelerator module"
```

### Task 5: Integrate Repository Automation

**Files:**

- Modify: `.github/workflows/terraform-test.yaml`
- Modify: `.github/workflows/tflint.yaml`
- Modify: `.github/workflows/checkov.yaml`

- [ ] **Step 1: Add the module to all three matrices**

Insert `modules/global-accelerator` in alphabetical position in each module path list.

- [ ] **Step 2: Isolate the native-test CI path**

Add `if: matrix.path != 'modules/global-accelerator'` to the existing reusable Terraform test step. Add four steps with `if: matrix.path == 'modules/global-accelerator'`:

```yaml
- name: Check out Global Accelerator module
  if: matrix.path == 'modules/global-accelerator'
  uses: actions/checkout@v3

- name: Set up Terraform for Global Accelerator tests
  if: matrix.path == 'modules/global-accelerator'
  uses: hashicorp/setup-terraform@v2
  with:
    terraform_version: 1.7.5

- name: Initialize Global Accelerator module
  if: matrix.path == 'modules/global-accelerator'
  run: terraform -chdir=modules/global-accelerator init -backend=false

- name: Test Global Accelerator module
  if: matrix.path == 'modules/global-accelerator'
  run: |
    terraform -chdir=modules/global-accelerator test
    modules/global-accelerator/tests/assert-flow-logs.sh
```

- [ ] **Step 3: Validate workflow syntax and matrix coverage**

Run:

```bash
rg -n "modules/global-accelerator" .github/workflows/terraform-test.yaml .github/workflows/tflint.yaml .github/workflows/checkov.yaml
```

Expected: one matrix occurrence in tflint and checkov; matrix plus conditional test-path occurrences in terraform-test.

- [ ] **Step 4: Commit automation changes**

```bash
git add .github/workflows/terraform-test.yaml .github/workflows/tflint.yaml .github/workflows/checkov.yaml
SKIP=terraform_docs git commit -m "ci: test global accelerator module"
```

### Task 6: Complete Verification And Review

**Files:**

- Modify: `specs/003-global-accelerator-module/tasks.md`

- [ ] **Step 1: Run the complete local verification set**

```bash
git diff --check
terraform fmt -check -recursive modules/global-accelerator
terraform -chdir=modules/global-accelerator init -backend=false
terraform -chdir=modules/global-accelerator validate
terraform -chdir=modules/global-accelerator/tests/basic init -backend=false
terraform -chdir=modules/global-accelerator/tests/basic validate
terraform -chdir=modules/global-accelerator/tests/flow-logs init -backend=false
terraform -chdir=modules/global-accelerator/tests/flow-logs validate
terraform -chdir=modules/global-accelerator test
modules/global-accelerator/tests/assert-flow-logs.sh
```

Expected: every command exits 0; native tests report all runs passed.

- [ ] **Step 2: Run static checks when installed**

```bash
tflint --chdir=modules/global-accelerator
checkov -d modules/global-accelerator --quiet
```

Expected: no blocking findings. If a tool is unavailable, record that fact rather than claiming it passed.

- [ ] **Step 3: Run scope and naming checks**

```bash
! rg -n '^resource "aws_globalaccelerator_' modules/global-accelerator --glob '*.tf'
rg -n 'terraform-aws-modules/global-accelerator/aws|version\s*=\s*"~> 3\.0"' modules/global-accelerator/main.tf
rg -n 'version\s*=\s*"~> 5\.0"' modules/global-accelerator/versions.tf
git status --short
```

Expected: no direct resources, exact upstream/provider constraints found, and only intended files changed.

- [ ] **Step 4: Request independent reviews**

Dispatch one reviewer for specification compliance and one reviewer for code quality. Resolve all blocking findings and repeat affected tests after each change.

After reviewer-driven fixes, stage only files in the approved plan scope, inspect `git diff --cached --stat`, and create a conventional commit describing those fixes. Do not include hook-generated changes to existing module READMEs.

- [ ] **Step 5: Mark Speckit tasks complete and re-run evidence checks**

Update completed checkboxes in `specs/003-global-accelerator-module/tasks.md`, then run `git diff --check` and the full Terraform test suite again.

Before the evidence commit, compare `git diff --name-only 60d6c50..HEAD` plus current working-tree changes against the plan's File Structure list. Any path outside that list is a blocker unless it is separately justified and approved.

- [ ] **Step 6: Commit final evidence updates**

```bash
git add specs/003-global-accelerator-module/tasks.md
SKIP=terraform_docs git commit -m "docs: record global accelerator verification"
```

Expected: implementation remains local until the user explicitly requests push.
