# All providers are mocked: apply runs below simulate state only, never AWS APIs.
mock_provider "aws" {
  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "123456789012"
      arn        = "arn:aws:iam::123456789012:root"
      id         = "123456789012"
    }
  }
  mock_resource "aws_s3_bucket" {
    defaults = {
      id  = "example-audit-cloud-trail-bucket"
      arn = "arn:aws:s3:::example-audit-cloud-trail-bucket"
    }
  }
}

variables {
  name = "example-audit"
}

run "legacy_defaults" {
  command = apply
  assert {
    condition     = aws_s3_bucket.s3[0].force_destroy && length(aws_s3_bucket_versioning.s3) == 0 && length(aws_s3_bucket_object_lock_configuration.s3) == 0
    error_message = "Existing consumers must retain the legacy resource set and force_destroy default."
  }
  assert {
    condition     = length(jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement) == 2 && aws_cloudtrail.cloudtrail.is_multi_region_trail && aws_cloudtrail.cloudtrail.enable_log_file_validation
    error_message = "Default delivery policy, multi-region coverage and digest validation must remain unchanged."
  }
}

run "five_year_governance" {
  command = apply
  variables {
    bucket_protection = {
      force_destroy               = false
      versioning_enabled          = true
      governance_retention_days   = 1827
      governance_bypass_role_arns = ["arn:aws:iam::123456789012:role/example-audit-emergency"]
    }
  }
  assert {
    condition     = !aws_s3_bucket.s3[0].force_destroy && aws_s3_bucket_versioning.s3[0].versioning_configuration[0].status == "Enabled"
    error_message = "Protected buckets must disable forced deletion and enable versioning."
  }
  assert {
    condition     = aws_s3_bucket_object_lock_configuration.s3[0].object_lock_enabled == "Enabled" && aws_s3_bucket_object_lock_configuration.s3[0].rule[0].default_retention[0].mode == "GOVERNANCE" && aws_s3_bucket_object_lock_configuration.s3[0].rule[0].default_retention[0].days == 1827 && aws_s3_bucket_object_lock_configuration.s3[0].rule[0].default_retention[0].years == null
    error_message = "The same bucket must receive five calendar years of Governance default retention."
  }
  assert {
    condition     = jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[2].Effect == "Deny" && jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[2].Principal == "*" && jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[2].Action == "s3:BypassGovernanceRetention" && jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[2].Condition.ArnNotEquals["aws:PrincipalArn"] == ["arn:aws:iam::123456789012:role/example-audit-emergency"]
    error_message = "Only the exact approved emergency role may be exempted from the bypass deny."
  }
  assert {
    condition     = jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[0].Action == "s3:GetBucketAcl" && jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[0].Principal.Service == "cloudtrail.amazonaws.com" && jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[1].Action == "s3:PutObject" && jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[1].Principal.Service == ["cloudtrail.amazonaws.com", "config.amazonaws.com"] && jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[1].Condition.StringEquals["s3:x-amz-acl"] == "bucket-owner-full-control"
    error_message = "CloudTrail and Config delivery statements must be preserved."
  }
  assert {
    condition     = aws_s3_bucket_object_lock_configuration.s3[0].bucket == aws_s3_bucket.s3[0].id && aws_s3_bucket_versioning.s3[0].bucket == aws_s3_bucket.s3[0].id
    error_message = "Both configurations must target the existing managed bucket identity."
  }
}

run "no_emergency_exception" {
  command = apply
  variables {
    bucket_protection = {
      force_destroy              = false
      versioning_enabled         = true
      governance_retention_years = 5
    }
  }
  assert {
    condition     = jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[2].Effect == "Deny" && !can(jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement[2].Condition)
    error_message = "An empty exception list must deny bypass unconditionally, without an empty IAM condition."
  }
}

run "legacy_year_unit" {
  command = apply
  variables {
    bucket_protection = { force_destroy = false, versioning_enabled = true, governance_retention_years = 5 }
  }
  assert {
    condition     = aws_s3_bucket_object_lock_configuration.s3[0].rule[0].default_retention[0].years == 5 && aws_s3_bucket_object_lock_configuration.s3[0].rule[0].default_retention[0].days == null
    error_message = "Existing year-based consumers must retain their selected unit."
  }
}

run "versioning_only" {
  command = apply
  variables {
    bucket_protection = {
      versioning_enabled = true
    }
  }
  assert {
    condition     = length(aws_s3_bucket_versioning.s3) == 1 && length(aws_s3_bucket_object_lock_configuration.s3) == 0 && length(jsondecode(aws_s3_bucket_policy.s3[0].policy).Statement) == 2
    error_message = "Versioning alone must not silently enable irreversible Object Lock or deny bypass."
  }
}

run "external_bucket_ownership" {
  command = apply
  variables {
    create_s3_bucket = false
    bucket_name      = "example-existing-audit"
    bucket_protection = {
      force_destroy              = false
      versioning_enabled         = true
      governance_retention_years = 5
    }
  }
  assert {
    condition     = length(aws_s3_bucket.s3) == 0 && length(aws_s3_bucket_policy.s3) == 0 && length(aws_s3_bucket_versioning.s3) == 0 && length(aws_s3_bucket_object_lock_configuration.s3) == 0 && aws_cloudtrail.cloudtrail.s3_bucket_name == "example-existing-audit"
    error_message = "Externally owned buckets must not be created, configured or taken over."
  }
}

run "reject_lock_without_versioning" {
  command = plan
  variables {
    bucket_protection = { force_destroy = false, governance_retention_days = 1827 }
  }
  expect_failures = [var.bucket_protection]
}
run "reject_lock_with_force_destroy" {
  command = plan
  variables {
    bucket_protection = { versioning_enabled = true, governance_retention_days = 1827 }
  }
  expect_failures = [var.bucket_protection]
}
run "reject_fractional_years" {
  command = plan
  variables {
    bucket_protection = { force_destroy = false, versioning_enabled = true, governance_retention_years = 1.5 }
  }
  expect_failures = [var.bucket_protection]
}
run "reject_negative_years" {
  command = plan
  variables {
    bucket_protection = { governance_retention_years = -1 }
  }
  expect_failures = [var.bucket_protection]
}
run "reject_wildcard_override" {
  command = plan
  variables {
    bucket_protection = { governance_bypass_role_arns = ["arn:aws:iam::123456789012:role/*"] }
  }
  expect_failures = [var.bucket_protection]
}
run "reject_non_role_override" {
  command = plan
  variables {
    bucket_protection = { governance_bypass_role_arns = ["arn:aws:iam::123456789012:user/example"] }
  }
  expect_failures = [var.bucket_protection]
}

run "reject_both_units" {
  command = plan
  variables {
    bucket_protection = { force_destroy = false, versioning_enabled = true, governance_retention_days = 1827, governance_retention_years = 5 }
  }
  expect_failures = [var.bucket_protection]
}

run "reject_fractional_days" {
  command = plan
  variables {
    bucket_protection = { force_destroy = false, versioning_enabled = true, governance_retention_days = 1827.5 }
  }
  expect_failures = [var.bucket_protection]
}

run "reject_negative_days" {
  command = plan
  variables {
    bucket_protection = { force_destroy = false, versioning_enabled = true, governance_retention_days = -1 }
  }
  expect_failures = [var.bucket_protection]
}

run "reject_excessive_days" {
  command = plan
  variables {
    bucket_protection = { force_destroy = false, versioning_enabled = true, governance_retention_days = 36501 }
  }
  expect_failures = [var.bucket_protection]
}
