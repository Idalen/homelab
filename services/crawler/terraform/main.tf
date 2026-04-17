terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
  default     = "https://192.168.0.100:8006/api2/json"
}

variable "pm_user" {
  type        = string
  description = "Proxmox API username"
  default     = "root@pam"
}

variable "pm_password" {
  type        = string
  description = "Proxmox API password"
  default     = "root"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification"
  default     = true
}

provider "proxmox" {
  endpoint = var.pm_api_url
  username = var.pm_user
  password = var.pm_password
  insecure = var.pm_tls_insecure
}

module "lxc" {
  source = "../../../modules/lxc"

  name        = "crawler"
  description = "A telegram bot that crawls web"
  vmid        = 300

  ip_address = "192.168.0.21/24"
  gateway    = "192.168.0.1"

  dns_servers = ["192.168.0.2"]

  disk_size = 8

  enable_tun_device = false
}