resource "aws_appconfig_configuration_profile" "main" {
  for_each = { for item in var.configs : "${item.name}-${item.version}" => item }

  application_id = aws_appconfig_application.main.id
  name           = "${each.value.name}-v${each.value.version}"
  description    = each.value.description
  location_uri   = each.value.location_uri
  type           = each.value.type

  dynamic "validator" {
    for_each = toset(each.value.validators)
    content {
      content = validator.value.content
      type    = validator.value.type
    }
  }
}

resource "aws_appconfig_hosted_configuration_version" "main" {
  for_each = { for item in var.configs : "${item.name}-${item.version}" => item if item.location_uri == "hosted" }

  application_id           = aws_appconfig_application.main.id
  configuration_profile_id = aws_appconfig_configuration_profile.main["${each.value.name}-${each.value.version}"].configuration_profile_id
  description              = each.value.description
  content_type             = each.value.content_type

  content = each.value.content != null ? each.value.content : jsonencode({
    version = "1"
    flags = { for flag in each.value.flags : "${flag.name}" => {
      name = flag.name
      _deprecation = {
        status = flag.deprecation_status
      }
      attributes = { for attribute in flag.attributes : attribute.name => {
        constraints = {
          type     = attribute.type
          required = attribute.required
        }
      } }
    } }
    values = { for flag in each.value.flags : "${flag.name}" =>

      merge(
        { enabled = flag.enabled },
        { for attribute in flag.attributes : attribute.name => attribute.value if !contains(["number", "boolean"], attribute.type) },
        { for attribute in flag.attributes : attribute.name => jsondecode(attribute.value) if attribute.type == "number" },
        { for attribute in flag.attributes : attribute.name => jsondecode(attribute.value) if attribute.type == "boolean" },
      )
    }
  })
}
