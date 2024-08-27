module "this" {
  source  = "../../"
  zone    = [local.zone]
  aliases = [local.domain]
  origins = [
    {
      id          = "alb"
      domain_name = aws_lb.test.dns_name
      behavior = {
        path_pattern = "/api/*"
      }
    },
    {
      id          = "s3"
      domain_name = aws_s3_bucket.test.id
      type        = "bucket"
    }
  ]

  providers = {
    aws          = aws
    aws.virginia = aws.virginia
  }
}
