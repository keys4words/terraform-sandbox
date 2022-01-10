terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "> 1.2.0, < 2.0.0, != 1.4.0"
      # version = "~> 1.2"
    }
  }
}

resource "local_file" "pet" {
  filename = "/root/pets.txt"
  content = "We love pets!"
}