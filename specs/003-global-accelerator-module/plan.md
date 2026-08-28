# Implementation Plan: AWS Global Accelerator Wrapper Module

**Branch**: `DMVP-10477` | **Date**: 2026-08-28 | **Spec**: [spec.md](spec.md)
**Input**: Approved design in `docs/superpowers/specs/2026-08-28-global-accelerator-module-design.md`

## Summary

Add `modules/global-accelerator` as a narrow, typed wrapper around `terraform-aws-modules/global-accelerator/aws ~> 3.0`. The wrapper creates one Standard Accelerator, listeners, and regional endpoint groups for existing endpoints; it adds grouped inputs, safe defaults, input validation, normalized stable outputs, mock-provider tests, examples, documentation, and repository CI coverage.

## Technical Context

**Language/Version**: Terraform `>= 1.3.0`; Terraform `1.7.5` for mock tests
**Primary Dependencies**: AWS provider `~> 5.0` with effective upstream range `>= 5.84, < 6.0`; `terraform-aws-modules/global-accelerator/aws ~> 3.0`
**Storage**: Existing S3 bucket only when flow logs are explicitly enabled
**Testing**: `terraform fmt`, `terraform init`, `terraform validate`, native `terraform test` with mocked AWS provider
**Target Platform**: AWS Global Accelerator Standard Accelerator
**Project Type**: Terraform module repository
**Performance Goals**: No runtime application code; configuration evaluation remains bounded by small AWS listener/endpoint quotas.
**Constraints**: No raw Global Accelerator resources; no endpoint or bucket creation; no customer-specific naming; no AWS calls from tests.
**Scale/Scope**: One additive module, two fixtures, four native test files, three workflow matrix updates, one dedicated conditional test path.

## Constitution Check

- **Scope Gate**: PASS. Work stays inside this repository and the new module's CI entries.
- **Ownership Gate**: PASS. The module and automation remain owned by this repository.
- **Records Gate**: PASS WITH APPROVED EXCEPTION. The repository lacks `.specify/`; `specs/003-global-accelerator-module` records manual evidence.
- **Controls Gate**: PASS. Formatting, initialization, validation, native tests, tflint, checkov, and independent code review are planned.
- **Change Gate**: PASS. The module is additive and does not alter existing module interfaces.

## Current Repository Module State

The repository contains no `modules/global-accelerator` directory. `modules/nlb` is the closest recent wrapper precedent: it uses an upstream `terraform-aws-modules` module, typed object inputs, `versions.tf`, README documentation, Terraform fixtures, and workflow matrix entries. Repository CI currently pins the reusable Terraform test action to Terraform 1.3.6 and does not initialize before its `terraform test` command.

## Gaps Versus Internal Standards

Because the target module does not exist, it lacks the standard wrapper files, typed inputs, defaults, validations, outputs, README, examples, tests, version declarations, and CI entries. The implementation must create all of them while preserving the repository convention of declaring `required_providers` in `versions.tf` and omitting `providers.tf` when no provider configuration is required.

## Wrapper-Preservation Assessment

The selected interface is an opinionated wrapper rather than a passthrough. Related listener, endpoint-group, endpoint, health-check, port-override, and flow-log attributes are grouped into typed objects with optional non-critical fields. Requiredness remains explicit: listeners, ranges, endpoint groups, Regions, and endpoint IDs are required; defaults cover common behavior. Upstream create flags, BYOIP addresses, attachments, timeouts, and raw resource objects are intentionally not exposed.

## Provider Collection Checked

Checked the approved AWS collection `terraform-aws-modules` and the upstream Terraform Registry metadata.

## Candidate Upstream Modules Considered

- `terraform-aws-modules/global-accelerator/aws`: selected because its scope exactly covers Standard Accelerators, listeners, and endpoint groups.
- Direct `aws_globalaccelerator_*` resources: rejected because the selected upstream module is suitable and the user requested reuse.
- Custom Routing Accelerator modules/resources: rejected as out of scope.

## Chosen Wrapper Baseline And Added Usability

Use `terraform-aws-modules/global-accelerator/aws ~> 3.0`. The local wrapper adds a smaller typed interface, grouped health and flow-log configuration, common defaults, validation of AWS input invariants, collision-safe logical keys, IPv4 output normalization, keyed ARN outputs, mock-provider contract tests, and DasMeta repository integration.

## Constitution Repository Source Used

Shared governance comes from `/Users/vazgen/.agents/skills/constitution/terraform-module-developer/`, specifically `references/internal-module-standards.md`, `references/speckit-module-workflow.md`, and `references/planning-checklist.md`. Repository-local documentation will contain only module behavior and usage.

## Speckit Evidence

Active evidence directory: `specs/003-global-accelerator-module/`, containing `spec.md`, `plan.md`, and `tasks.md` before module-impacting Terraform edits.

## Module-Change Gate Compatibility

The manual package is review-visible and follows the existing NLB precedent. This is a bounded exception because `.specify/` is absent. A gate that strictly requires `.specify/feature.json` will still require a separate bootstrap and is not silently bypassed.

## Fallback Rationale

No fallback scratch-template or direct-resource scaffolding is needed because the provider-maintained upstream module is suitable.

## Interface And Data Flow

1. Consumers provide `name`, optional accelerator settings, a typed `listeners` map, optional `flow_logs`, and tags.
2. `locals.tf` converts grouped health checks, endpoints, and port overrides into the flat nested shape expected by upstream v3.
3. `main.tf` passes only the approved interface to one upstream module block.
4. `outputs.tf` returns accelerator identity values and derives keyed listener and endpoint-group ARN maps without exposing raw upstream resources.

## Proposed File Changes

- Add `modules/global-accelerator/versions.tf` for Terraform and AWS constraints.
- Add `modules/global-accelerator/variables.tf` for the complete typed and validated interface.
- Add `modules/global-accelerator/locals.tf` for upstream input normalization.
- Add `modules/global-accelerator/main.tf` with the single upstream module block.
- Add `modules/global-accelerator/outputs.tf` for stable public outputs.
- Add `modules/global-accelerator/README.md` with examples, requirements, runtime constraints, and generated tables.
- Add `modules/global-accelerator/tests/basic/*` and `tests/flow-logs/*` fixtures.
- Add `modules/global-accelerator/tests/*.tftest.hcl` native contract, validation, and fixture tests.
- Add `modules/global-accelerator` to `.github/workflows/terraform-test.yaml`, `.github/workflows/tflint.yaml`, and `.github/workflows/checkov.yaml`.
- Add a module-specific conditional checkout/setup/init/test path to `terraform-test.yaml` while preserving the reusable action for existing modules.
- Add this Speckit evidence and the detailed execution plan under `docs/superpowers/plans/`.

## Potential Breaking Changes

None. This is a new module and no existing module interface changes.

## Potential Interface Widening

None. The wrapper deliberately omits uncommon upstream inputs and raw passthrough objects.

## Conflicts Requiring Approval

None. The provider constraint, upstream version, interface shape, defaults, outputs, test approach, and manual Speckit exception were approved in the design phase.

## Modern Capabilities Classification

All net-new abilities use currently supported Standard Accelerator capabilities:

- **supported**: Standard Accelerator, TCP/UDP listeners, regional endpoint groups, existing ALB/NLB/EC2/EIP endpoints, weights, traffic dials, and health checks.
- **supported**: IPv4 and Dual Stack address types.
- **supported**: Endpoint-group port overrides.
- **supported**: Flow-log delivery to an existing S3 bucket.

Custom routing, BYOIP, and cross-account attachments remain out of scope rather than using deprecated or replacement paths.

## Test Strategy

TDD begins with native `.tftest.hcl` files and fixtures before production module files. The first `terraform test` must fail because the desired wrapper inputs and outputs do not yet exist. The minimal wrapper implementation then makes the success cases pass. Negative `expect_failures` runs cover each validation family. Mock-provider tests exercise real Terraform module logic and upstream resource schemas while isolating the external AWS API.

## CI Strategy

For existing matrix entries, retain `dasmeta/reusable-actions-workflows/terraform-test@4.2.1`. For `modules/global-accelerator`, skip that composite step and run conditional steps that check out the repository, install Terraform 1.7.5, execute `terraform -chdir=modules/global-accelerator init -backend=false`, and execute `terraform -chdir=modules/global-accelerator test`. Tflint and checkov need only the new module path in their existing matrices.

## Post-Design Constitution Check

- **Scope Gate**: PASS.
- **Ownership Gate**: PASS.
- **Records Gate**: PASS WITH APPROVED EXCEPTION for missing `.specify/`.
- **Controls Gate**: PASS.
- **Change Gate**: PASS.
- **Wrapper Gate**: PASS; the interface remains narrow and typed.
- **Modern Capabilities Gate**: PASS; all in-scope abilities are supported.

## Complexity Tracking

| Deviation | Why Needed | Simpler Alternative Rejected Because |
| --- | --- | --- |
| Manual Speckit package | Repository lacks `.specify/` | Editing module files with no evidence violates the module workflow |
| Terraform 1.7.5 only for tests | Mock providers are unavailable in Terraform 1.3 | Real AWS plans would require credentials and would not safely assert computed outputs |
| Dedicated module-specific test steps | Pinned reusable action does not initialize a clean runner | Changing the shared action/version for every existing module would expand risk and scope |
