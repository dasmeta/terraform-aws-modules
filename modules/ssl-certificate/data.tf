data "aws_route53_zone" "zones" {
  for_each = var.validate_in_aws == true ? local.all_zones : {}

  name         = each.value
  private_zone = false
}
