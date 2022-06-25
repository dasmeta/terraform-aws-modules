resource "aws_iam_user" "api-gw-user" {
  name = "api-gw-user"
  path = "/system/"


}

resource "aws_iam_access_key" "api-gw-ak" {
  user = aws_iam_user.api-gw-user.name
}

resource "aws_iam_user_policy" "api-gw-policy" {
  name = "API-Gateway-policy"
  user = aws_iam_user.api-gw-user.name

  policy = file("${path.module}/src/iam-policy.json")
}




