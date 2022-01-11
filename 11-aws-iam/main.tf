resource "aws_iam_user" "admin-user" {
  name = var.project-3-users[count.index]
  count = length(var.project-3-users)

  tags = {
    Description = "Tech support"
  }
}

resource "aws_iam_policy" "adminUser" {
  name = "AdminUsers"
  policy = file("admin-policy.json")

  # policy = <<POLICY
  # {
  #    "Version": "2012-10-17",
  #    "Statement": {
  #      "Effect": "Allow",
  #      "Action": "*",
  #      "Resource": "*"
  #    }
  # }
  # POLICY

}

resource "aws_iam_user_policy_attachment" "project-3-admin-access" {
  user = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.adminUser.arn
}