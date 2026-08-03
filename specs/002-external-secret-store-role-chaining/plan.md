# Implementation Plan: External Secret Store via IAM Role Chaining

**Branch**: `external-secret-improvements` | **Date**: 2026-08-03 |
**Spec**: `specs/002-external-secret-store-role-chaining/spec.md`

## Summary

Replace the module's IAM user, access key and credentials Kubernetes Secret with a per-store IAM
role trusted by the External Secrets controller's base role, and render the store to authenticate
through `spec.provider.aws.role`. Keep the store resource address stable so upgrades update it in
place.

## Technical Context

**Language/Version**: Terraform `~> 1.3`
**Primary Dependencies**: AWS provider `>= 5.0, < 7.0`, `gavinbunney/kubectl` `>= 1.7.0`
**Storage**: Terraform state holds the IAM role and policy; no secret material is stored
**Testing**: `terraform validate`, `terraform fmt`, tflint, tfsec, checkov
**Target Platform**: AWS Secrets Manager and Kubernetes via External Secrets
**Project Type**: Standalone Terraform module consumed alongside the dasmeta EKS module
**Constraints**: Store resource must not be recreated; role name must satisfy the controller's
prefix grant
**Scale/Scope**: `modules/external-secret-store` only

## Constitution Check

- **Shared source of truth**: No conflict found between the `terraform-module-developer` skill
  guidance and repository-local conventions.
- **Workflow enforcement**: **Deviation - see Process Note.** Authored after implementation.
- **Wrapper-first, safe interfaces**: The input surface shrinks rather than widens - five
  credential-related inputs are removed and one required input is added. This is a deliberate
  breaking change, covered by the paired upgrade guide entry in the EKS module.
- **Evidence-first verification**: Formatting, validation, tflint, tfsec, checkov and a live
  cluster apply were run. Gaps recorded under Validation.
- **Documentation and compatibility**: README rewritten to describe the auth model; the
  cross-repository upgrade ordering is documented in the EKS module's upgrade guide, which is
  where consumers of both modules will look.
- **Modern capability classification**: **replaced**. The previous IAM-user-with-static-keys path
  is replaced by role chaining, the supported mechanism for granting scoped AWS access to
  workloads that already hold an identity.

### Process Note

The Speckit package was authored after the module was implemented and verified, rather than
before it. It records what was built rather than a plan that guided the build. The branch name
also does not follow the `NNN-slug` convention.

## Project Structure

```text
modules/external-secret-store/
├── iam.tf          # per-store role, least-privilege policy, attachment
├── store.tf        # SecretStore / ClusterSecretStore manifest
├── locals.tf       # name sanitisation, role naming, region resolution
├── variables.tf
├── outputs.tf
├── versions.tf
└── README.md
specs/002-external-secret-store-role-chaining/
├── spec.md
├── plan.md
└── tasks.md
```

**Structure Decision**: Keep one file per concern. `providers.tf` was renamed to `versions.tf`
since it only ever declared version constraints and configured no provider.

## Current State and Standards Assessment

- Prior state: `iam-user.tf` created an IAM user via an upstream module, `iam-policy.tf` attached
  a scoped read policy to it, `secret.tf` wrote the access key into a Kubernetes Secret, and
  `store.tf` rendered a template file referencing that Secret.
- The `controller` input existed with the description "Not sure what is this for yet" and was
  unused; it is removed.
- The default `external_secrets_api_version` was `external-secrets.io/v1alpha1` with a TODO to
  move forward; the supported default is now `external-secrets.io/v1`.
- The store manifest was a `templatefile`; rendering it with `yamlencode` removes the need to
  hand-manage indentation and makes the namespace conditional expressible.

## Proposed File Changes

- Delete `iam-user.tf`, `secret.tf` and `secret-store.tmpl`.
- Replace `iam-policy.tf` with `iam.tf` creating the role, policy and attachment.
- Rewrite `store.tf` to render via `yamlencode`, setting `spec.provider.aws.role` and including
  `metadata.namespace` only for the namespaced kind.
- Add `outputs.tf`; extend `locals.tf` with role naming and region resolution.
- Rewrite `variables.tf`: remove the credential inputs and the unused `controller`, add
  `controller_role_arn`, `region` and `store_role_name_prefix`, and validate `kind`.
- Rename `providers.tf` to `versions.tf` and add the AWS provider constraint.

## Risks and Approvals

- **Breaking change**: `controller_role_arn` is newly required and five inputs are removed.
  Approved as the intent of the change; the ordering that makes it safe (upgrade the EKS module
  first) is documented in the EKS module's upgrade guide.
- **Destroyed resources**: the IAM user, access key and credentials Secret are destroyed. This is
  the point of the change, but it means a consumer who upgrades this module before the EKS module
  will break secret sync until the controller identity exists.
- **Silent failure mode**: a store whose credentials stop working keeps serving the last synced
  Kubernetes Secret, so validation must force a refetch rather than trust workload health.
- **Wildcard-prefix coupling**: the controller grants `sts:AssumeRole` on a role-name wildcard.
  If `store_role_name_prefix` is broadened, the controller becomes able to assume unrelated
  roles sharing that prefix.
- **Partition hardcoding**: ARNs are built with the `aws` partition, consistent with the rest of
  the repository. GovCloud/China unsupported here as elsewhere. Noted, not changed.

## Validation

1. `terraform fmt -check -recursive`.
2. `terraform validate` for the module.
3. `tflint`, `tfsec` and `checkov` against the module.
4. Confirm the rendered store's name, kind and apiVersion match what the consuming chart's
   ExternalSecret references, and that the secret name it reads falls inside the role's scope.
5. Apply against a live cluster and confirm secrets sync.

### Verification Gaps Found

- The region attribute used to resolve the provider region existed only in AWS provider 6.x
  while the module's constraint still allowed 5.x, and consumers pairing this with the dasmeta
  EKS module resolve to 5.x because that module caps below 6.0. Static validation in isolation
  did not surface it because the module alone resolves the newer provider; it was found by
  inspecting both providers' schemas. Resolution uses the attribute available in both.
- No `terraform plan` was run during authoring - no AWS credentials were available in the
  authoring environment - so upgrade behaviour was reasoned from module source and
  consumer-supplied plan output rather than reproduced locally.
