resource "aws_route53_zone" "main" {
  name = var.zone
}

resource "aws_route53_record" "add_record" {
 for_each = { for record in var.records : record.id => record}
 zone_id  = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = each.value.value
  ttl     = var.ttl

  depends_on = [
    aws_route53_zone.main
  ]
}
