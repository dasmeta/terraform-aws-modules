module "efs" {
  source         = "../../"
  creation_token = "EFS-minimal-test"

  lifecycle_policy = {
    transition_to_ia                    = "AFTER_60_DAYS"
    transition_to_archive               = "AFTER_90_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
}
