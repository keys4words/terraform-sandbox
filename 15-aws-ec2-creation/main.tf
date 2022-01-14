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

# EC2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-04ad2567c9e3d7893"
  instance_type = "t2.micro"

  # manual ssh
  # key_name = aws_key_pair.web.id
  
  # using new security group - look sec group resource below
  # vpc_security_group_ids = [aws_security_group.ssh-access.id]

  # using existing security group
  vpc_security_group_ids = "sg-0aeb33d951d536ff8" #[aws_security_group.instance.id]
  user_data = file("user_data_ami_1.sh")
  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "Hey, dude!" > index.html
  #             nohup busybox httpd -f -p ${var.server_port} &
  #             EOF

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

# manual ssh
# resource "aws_key_pair" "web" {
#   public_key = file("/root/.ssh/web.pub")
# }

# create security group
# resource "aws_security_group" "ssh-access" {
#   name = "terraform-example-instance"

#   ingress = [{
#     prefix_list_ids  = []
#     self             = false
#     security_groups  = []
#     description      = "web traffic"
#     from_port        = var.server_port
#     to_port          = var.server_port
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0" ]
#     ipv6_cidr_blocks = []
#   }]
  
# }
