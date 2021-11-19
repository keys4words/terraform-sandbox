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
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "mygateway"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "prod-subnet"
  }
}

resource "aws_route_table" "prod-table" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod-table"
  }
}


resource "aws_route_table_association" "routetable" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.prod-table.id
}

resource "aws_network_acl" "myacl" {
  vpc_id = aws_vpc.myvpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# resource "aws_network_interface" "mynic" {
#   subnet_id       = aws_subnet.mysubnet.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.allow_web.id]

#   # attachment {
#   #   instance     = aws_instance.test.id
#   #   device_index = 1
#   # }
# }

resource "aws_eip" "webserver" {
  instance = aws_instance.master.id
  vpc      = true
  #network_interface         = aws_network_interface.mynic.id
  #associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.gw
  ]
}

resource "aws_key_pair" "wpc" {
  key_name   = "wpc"
  public_key = file("${path.module}/id_rsa.pub")
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["099720109477"]
# }

resource "aws_instance" "master" {
  ami = var.ami_type
  # ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name               = aws_key_pair.wpc.key_name
  subnet_id              = aws_subnet.mysubnet.id

  tags = {
    Name = "master"
  }
}

resource "aws_instance" "slave" {
  ami = var.ami_type
  count = length(var.vm_names)
  # ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name               = aws_key_pair.wpc.key_name
  subnet_id              = aws_subnet.mysubnet.id

  connection {
    host = self.private_ip
    type = "ssh"
    user = "ec2-user"
    private_key = aws_key_pair.wpc
  }

  tags = {
    Name = var.vm_names[count.index]
  }
}
#   user_data = <<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     # sudo apt install apache2 -y
#     # sudo systemctl start apache2
#     # sudo bash -c 'echo "<h1>Hey, dude!</h1>" > /var/www/html/index.html'
#   EOF

#   tags = {
#     Name = "ansible-master"
#   }
# }

output "public_ip" {
  value       = aws_eip.webserver.public_ip
  description = "The public IP address of the web server"
}
