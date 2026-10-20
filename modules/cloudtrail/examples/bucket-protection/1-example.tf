module "example" {
  source = "../.."
  name   = "example-audit"

  bucket_protection = {
    force_destroy              = false
    versioning_enabled         = true
    governance_retention_years = 5
    governance_bypass_role_arns = [
      "arn:aws:iam::123456789012:role/example-audit-emergency"
    ]
  }
}
