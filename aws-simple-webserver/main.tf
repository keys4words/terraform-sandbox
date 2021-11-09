variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}
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
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hey, dude!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress = [{
    prefix_list_ids  = []
    self             = false
    security_groups  = []
    description      = "web traffic"
    from_port        = var.server_port
    to_port          = var.server_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0" ]
    ipv6_cidr_blocks = []
  }]
  
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
  description = "The public IP address of the web server"
}