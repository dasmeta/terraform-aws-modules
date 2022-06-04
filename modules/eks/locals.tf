locals {
  map_users = flatten([
    for user in var.users : {
      userarn  = data.aws_iam_user.user_arn[user.username].arn
      username = user.username
      groups   = lookup(user, "group", ["system:masters"])
    }
  ])
}
