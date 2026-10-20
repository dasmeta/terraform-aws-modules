# Implementation Plan: CloudTrail bucket protection

**Branch**: `004-cloudtrail-bucket-protection` | **Date**: 2026-10-20 | **Spec**: [spec.md](spec.md)

## Summary
Extend the existing CloudTrail module and account wrapper with a bounded bucket_protection object. Preserve defaults and addresses. Sela explicitly requests versioning, Governance five years, force_destroy=false and a dedicated emergency-role exception. User authorized implementation; no production apply, shared merge or release is authorized.

## Technical Context
Terraform native module; Sela consumes AWS ~>5.0. Existing CloudTrail module code is unchanged between installed 2.18.3 and current main; account main matches current 1.7.0. Test with AWS 5.x and mocked providers on Terraform 1.15.7. Do not raise runtime floors just for testing.

## Constitution Check
No downstream constitution or root AGENTS.md is present. Follow installed module standards and operator CloudBrowser/Jira identity rules. Preserve the existing direct-resource module (no new module or refactor); grouped child object uses optional fields and a complete default, matching existing cmdb_integration/alerts and the >=1.3 basic setup. Account already requires ~>1.3, so nested optional fields are supported. This is a requested narrow opt-in extension, not a broad upstream passthrough or default-weakening change.

## Design
- Child bucket_protection object: force_destroy bool (default true), versioning_enabled bool (false), governance_retention_days number (0 = unset), governance_retention_years number (0 = unset), governance_bypass_role_arns list(string) ([]).
- Governance days must be 0 or an integer 1..36500, years 0 or an integer 1..100; select at most one positive unit. Nonzero retention requires versioning and force_destroy=false. Approved bypass values must be concrete IAM role ARNs without wildcards.
- Keep aws_s3_bucket.s3[0] and aws_s3_bucket_policy.s3[0] addresses. Set force_destroy from the object. Do not set aws_s3_bucket.object_lock_enabled (ForceNew in AWS5).
- Owned buckets only: standalone aws_s3_bucket_versioning and aws_s3_bucket_object_lock_configuration, with explicit versioning-before-lock ordering. Lock mode fixed to GOVERNANCE and the selected days or years from the object.
- Preserve two delivery statements; append explicit s3:BypassGovernanceRetention deny when Governance is enabled. With exceptions, use ArnNotEquals aws:PrincipalArn; without exceptions, omit Condition to deny all bypass. No invented policy-administration grants or destructive state migration.
- CloudTrail creation depends on delivery policy/versioning/lock readiness. Existing resource arguments remain unchanged.
- Account wrapper exposes optional grouped fields with identical defaults and passes the complete object to the child. During draft review use immutable Git commit pins; move to supported releases before deployment. No releases are created by this task.

## Modern Capabilities
Standalone versioning/Object Lock configuration: supported by official AWS provider 5.100.0; existing-bucket API support confirmed by AWS. Preserve legacy bucket arguments except requested force_destroy parameterization. No broad deprecation refactor or provider minimum bump.

## Validation
Native mocked plan tests cover unchanged defaults, protected resources and five-year mode, preserved delivery statements, exact bypass deny, empty allowlist, invalid configurations and externally owned buckets. Static check verifies bucket object_lock_enabled absent and explicit depends_on. Mocked plans cannot prove zero replacement against real existing state; require a separate live plan and ingestion readback before apply. Account verification checks typed passthrough and real child behavior without AWS APIs.

## Layout and Delivery
modules/cloudtrail/{s3.tf,variables.tf,cloudtrail.tf,README.md}, examples/bucket-protection/{0-setup.tf,1-example.tf}, tests/bucket_protection.tftest.hcl.
Keep tests independently expressed from examples. Retain existing unrelated automation/layout. Speckit package accompanies this shared-module PR; no new Markdown in Sela MR !183. Record exact tests and dependency commits after implementation. Create draft dependency PR; no merge or release. Regenerate Sela Terraform with the same installed renderer used earlier.

## Rollout and recovery
Review source/plan for unchanged bucket/trail addresses, zero bucket/trail replacement, healthy delivery/digests, exact SSO trust and role policy. Versioning can take time to propagate; AWS recommends waiting before object PUT/DELETE after first enabling it. Default lock covers new versions only; separately approve historical-object protection. Lock enablement is irreversible; removing configuration removes the default rule rather than unlocking old versions. Do not shorten retained history during rollback.

## Review correction: calendar-year minimum
Use explicit 1827-day Governance retention in the protected example and Sela consumer to cover five calendar years including leap days. Add optional governance_retention_days (default zero), retaining the years input for compatibility; require exactly one positive unit when enabling retention, integer bounds, versioning and force_destroy=false. Verify the actual child resource uses days=1827 with years unset.
