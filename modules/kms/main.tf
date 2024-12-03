resource "aws_kms_key" "this" {
  description         = var.kms_key_description
  enable_key_rotation = true
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.kms_alias_name}"
  target_key_id = aws_kms_key.this.id
}


resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = var.kms_key_cloudwatch ? local.cloudwatch_logs_policy : var.kms_key_policy
}
