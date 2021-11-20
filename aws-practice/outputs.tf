output "public_ip" {
  value       = aws_eip.webserver.public_ip
  description = "The public IP address of the web server"
}