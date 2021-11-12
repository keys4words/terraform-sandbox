terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
# resource "aws_vpc" "myvpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "prod"
#   }
# }

# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.myvpc.id

#   tags = {
#     Name = "mygateway"
#   }
# }

# resource "aws_route_table" "prod-table" {
#   vpc_id = aws_vpc.myvpc.id

#   route = [
#     {
#       cidr_block = "0.0.0.0/0"
#       gateway_id = aws_internet_gateway.gw.id
#     },
#     {
#       ipv6_cidr_block        = "::/0"
#       gateway_id = aws_internet_gateway.gw.id
#     }
#   ]

#   tags = {
#     Name = "prod-table"
#   }
# }


# resource "aws_subnet" "mysubnet" {
#   vpc_id     = aws_vpc.myvpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-1"

#   tags = {
#     Name = "prod-subnet"
#   }
# }

# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.mysubnet.id
#   route_table_id = aws_route_table.prod-table.id
# }

# resource "aws_security_group" "allow_web" {
#   name        = "allow_web_traffic"
#   description = "Allow web traffic"
#   vpc_id      = aws_vpc.myvpc.id

#   ingress = [
#     {
#       description      = "HTTPS traffic"
#       from_port        = 443
#       to_port          = 443
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#     },
#     {
#       description      = "HTTP"
#       from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#     },
#     {
#       description      = "SSH"
#       from_port        = 22
#       to_port          = 22
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#     }
#   ]

#   egress = [
#     {
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#   ]

#   tags = {
#     Name = "allow_web"
#   }
# }

# resource "aws_network_interface" "mynic" {
#   subnet_id       = aws_subnet.mysubnet.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.allow_web.id]

#   # attachment {
#   #   instance     = aws_instance.test.id
#   #   device_index = 1
#   # }
# }

# resource "aws_eip" "one" {
#   vpc                       = true
#   network_interface         = aws_network_interface.mynic.id
#   associate_with_private_ip = "10.0.1.50"
#   depends_on = [
#     aws_internet_gateway.gw
#   ]
# }

resource "aws_instance" "master" {
  ami = "ami-04ad2567c9e3d7893"
  instance_type = "t2.micro"
  availability_zone = "us-east-1c"
  vpc_security_group_ids = ["sg-0aeb33d951d536ff8"]
  key_name = "myAwsKey"

  # network_interface {
  #   device_index = 0
  #   network_interface_id = aws_network_interface.mynic.id
  # }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    # sudo apt install apache2 -y
    # sudo systemctl start apache2
    # sudo bash -c 'echo "<h1>Hey, dude!</h1>" > /var/www/html/index.html'
  EOF

  tags = {
    Name = "ansible-master"
  }
}

output "public_ip" {
  value = aws_instance.master.public_ip
  description = "The public IP address of the web server"
}