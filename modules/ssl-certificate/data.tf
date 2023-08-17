data "aws_route53_zone" "zones" {
  for_each = var.validate == true ? local.all_zones : {}

  name         = each.value
  private_zone = false
}
