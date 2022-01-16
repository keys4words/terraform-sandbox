resource "aws_instance" "app_server" {
  ami           = "ami-04ad2567c9e3d7893"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    on_failure = fail   # fail/continue
    command = "echo ${aws_instance.webserver.public_ip} Created! > /tmp/instance_state.txt"
  }

  provisioner "local-exec" {
    when = destroy
    command = "echo ${aws_instance.webserver.public_ip} Destroyed! > /tmp/instance_state.txt"
  }
}

# elastic ip
resource "aws_eip" "eip" {
  vpc = true
  instance = aws_instance.app_server.ip
  provisioner "local-exec" {
      command = "echo ${aws_eip.eip.public_dns} >> /root/cerberus_public_dns.txt"
  }
}