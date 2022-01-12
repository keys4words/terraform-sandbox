resource "aws_s3_bucket" "finance" {
  bucket = "finance"
  # acl = "public-read-write"
  tags = {
    Description = "Finance and Payroll"
  }
}

resource "aws_s3_bucket_object" "finance-2022" {
  content = "report_45.doc"
  key = "report_45.doc"
  bucket = aws_s3_bucket.finance.id
}

data "aws_iam_group" "finance-data" {
  group_name = "finance-department"
}

resource "aws_s3_bucket_policy" "finance-department-policy" {
  bucket = aws_s3_bucket.finance.id
  policy = <<EOF
    {
      "Version": "2022-01-01",
      "Statement": [
        {
          "Action": "*",
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::${aws_s3_bucket.finance.id}/*",
          "Principal": {
            "AWS": [
              "${data.aws_iam_group.finance-data.arn}"
            ]
          }
        }
      ]
    }
  EOF
}