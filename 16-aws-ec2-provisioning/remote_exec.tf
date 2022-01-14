resource "aws_instance" "app_server" {
  ami           = "ami-04ad2567c9e3d7893"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = ["sudo apt update",
            "sudo apt install nginx -y",
            "sudo systemctl enable nginx",
            "sudo systemctl start nginx",
            ]
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/root/.ssh/web")
  }
  # manual ssh
  # key_name = aws_key_pair.web.id
  
  # using new security group - look sec group resource below
  # vpc_security_group_ids = [aws_security_group.ssh-access.id]

  # using existing security group
  vpc_security_group_ids = "sg-0aeb33d951d536ff8" #[aws_security_group.instance.id]
 
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
