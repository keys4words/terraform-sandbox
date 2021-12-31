output "public_ip" {
  value       = aws_eip.webserver.public_ip
  description = "The public IP address of the web server"
}

output "list_out" {
  value = var.vm_names
}

output "map_out" {
  sensitive = true
  value = var.map_example["keyOne"]
}

output "bool_out" {
  value = var.test_bool
}