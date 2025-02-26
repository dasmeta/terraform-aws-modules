module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.2.1"

  create = var.create

  name            = local.queue_name
  use_name_prefix = var.use_name_prefix

  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  max_message_size            = var.max_message_size
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  queue_policy_statements     = var.policy
  redrive_policy              = var.redrive_policy
  redrive_allow_policy        = var.redrive_allow_policy
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  deduplication_scope         = var.deduplication_scope
  fifo_throughput_limit       = var.fifo_throughput_limit

  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = var.tags
}

module "iam_user" {
  source  = "dasmeta/modules/aws//modules/aws-iam-user"
  version = "0.35.5"

  create_user   = var.create_iam_user
  username      = local.iam_username
  console       = false
  pgp_key       = var.pgp_key
  create_policy = true

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : var.iam_user_actions,
        "Resource" : ["arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.queue_name}"]
      }
    ]
  })
}
