module "zone" {
  source = "./zone"
  count  = var.create_zone ? 1 : 0

  name = var.zone
}

data "aws_route53_zone" "main" {
  count = var.create_zone ? 0 : 1

  name = var.zone
}

resource "aws_route53_record" "add_record" {
  for_each = { for record in var.records : record.name => record }

  zone_id = var.create_zone ? module.zone[0].zone_id : data.aws_route53_zone.main[0].zone_id
  name    = each.value.name
  type    = each.value.type
  records = each.value.value
  ttl     = var.ttl
}
