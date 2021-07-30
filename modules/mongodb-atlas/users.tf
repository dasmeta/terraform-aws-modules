# resource "random_password" "password" {
#   for_each = toset( var.users )
  
#   length           = 16
#   special          = true
#   override_special = "_%@"
# }

# resource "mongodbatlas_database_user" "test" {
#   for_each = toset(var.users)

#   username           = each.key
#   password           = random_password.password[count.index]

#   project_id         = "<PROJECT-ID>"
#   auth_database_name = "admin"

#   roles {
#     role_name     = "readWrite"
#     database_name = "dbforApp"
#   }

#   roles {
#     role_name     = "readAnyDatabase"
#     database_name = "admin"
#   }

#   labels {
#     key   = "My Key"
#     value = "My Value"
#   }

#   scopes {
#     name   = "My cluster name"
#     type = "CLUSTER"
#   }

#   scopes {
#     name   = "My second cluster name"
#     type = "CLUSTER"
#   }
# }

# output users {
#   value       = ""
#   sensitive   = true
#   description = "description"
#   depends_on  = []
# }
