locals {
  custom_domains_map = { for custom_domain in var.custom_domains : "${custom_domain.name}.${custom_domain.zone_name}" => custom_domain }

  r53_records = flatten([for key, custom_domain in var.custom_domains : try(length(var.custom_domain_additional_options[key]), 0) == 0 ? [
    merge(
      {
        key : "${custom_domain.name}.${custom_domain.zone_name}-primary",
        set_identifier             = null
        geolocation_routing_policy = {}
      },
      custom_domain
    )
    ] : [
    for additional_options in var.custom_domain_additional_options[key] : merge(
      { key : additional_options.set_identifier },
      custom_domain,
      additional_options
    )
  ]])
}
