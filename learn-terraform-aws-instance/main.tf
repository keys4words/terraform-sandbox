terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# EC2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-0279c3b3186e54acd"
  instance_type = "t2.micro"
  user_data = <<-EOF
              #!/bin/bash
              echo "Hey, dude!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "web traffic"
    from_port = 8080
    to_port = 8080
  } ]
  
}