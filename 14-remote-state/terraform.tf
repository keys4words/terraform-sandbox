terraform {
  backend "s3" {
    bucket = "my-special-bucket-01"
    key = "finance/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "state-locking"
  }
}