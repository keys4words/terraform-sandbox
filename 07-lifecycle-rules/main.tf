resource "local_file" "pet" {
  filename = "/root/pets.txt"
  content = "We love pets!"
  file_permission = "0700"

  lifecycle {
    create_before_destroy = true
    # prevent_destroy = true
  }
}

resource "aws_instance" "webserver" {
  ami = "ami-0eda"
  instance_type = "t2.micro"
  tags = {
    Name = "myWebServer"
  }
  lifecycle {
    ignore_changes = [
      tags, ami
    ]
    # ignore_changes = all
  }
}