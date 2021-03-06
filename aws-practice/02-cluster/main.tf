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

resource "aws_launch_configuration" "node" {
  image_id = "ami-04ad2567c9e3d7893"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p
              ${var.server_port} &
            EOF

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
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

resource "aws_autoscaling_group" "group" {
  launch_configuration = aws_launch_configuration.node.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids
  min_size = 2
  max_size = 10
  tag {
    key  = "Name"
    value = "terraform-asge"
    propagate_at_launch = true
  }
}