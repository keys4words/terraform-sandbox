variable "ami" {
  type = map
  default = {
              "us-east-1" = "ami-xyz",
              "ca-central-1" = "ami-eft",
              "ap-south-2" = "ami-gje"
            }
  description = "A map of AMI ID's for specific regions"
} 