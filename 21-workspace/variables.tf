variable region {
  default = "ca-central-1"
}

variable instance_type {
  default = "t2.micro"  
}

variable ami {
  type = map
  default = {
    "ProjectA" = "ami-0ed40898",
    "ProjectB" = "ami-4d434499j"
  }
}