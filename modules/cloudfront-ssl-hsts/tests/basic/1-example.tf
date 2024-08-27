module "this" {
  source  = "../../"
  zone    = [local.zone]
  aliases = [local.domain]
  origins = [
    {
      id          = "s3"
      domain_name = aws_s3_bucket.this.id
      type        = "bucket"
    }
  ]

  providers = {
    aws          = aws
    aws.virginia = aws.virginia
  }
}
