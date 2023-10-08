
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}
provider "proxmox" {
  pm_api_url = "http://192.168.50.150:8006/api2/json"
}