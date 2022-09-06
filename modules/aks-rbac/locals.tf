locals {
  role_binding = flatten([
    for assignment_index, assignment in var.assignment : [
      for role_index, role in assignment.role : {
        group     = assignment.group
        namespace = assignment.group
        name      = assignment.name
        actions   = role.actions
        resources = role.resources
      }
    ]
  ])
}
