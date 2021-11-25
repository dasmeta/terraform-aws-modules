resource "aws_route53_zone" "main" {
  name = var.zone
}

resource "aws_route53_record" "addrecord" {
 for_each = { for record in var.type_record : record.recordid => record}
 zone_id = aws_route53_zone.main.zone_id
#  name    = each.value.recordname
  name    = each.value.recordname
  type    = each.value.recordtype
  records = each.value.recordvalue
  ttl     = var.ttl

  depends_on = [
    aws_route53_zone.main
  ]
}