module "sqs" {
  source = "../../"

  name            = "test"
  create_iam_user = false
}
