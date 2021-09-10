module "mult" {
    for_each = toset(var.domains)

    source = "./certificate"
    domain = each.key
    zone_id = var.zone_id
}
