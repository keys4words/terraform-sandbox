resource "aws_iam_user" "Cloud" {
  name = split(":", var.cloud_users)[count.index]
  count = length(split(":", var.cloud_users))
}