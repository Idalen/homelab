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

locals {
  network = yamldecode(file("${path.module}/../../../shared/network.yml"))
}

provider "proxmox" {
  endpoint = var.pm_api_url
  username = var.pm_user
  password = var.pm_password
  insecure = var.pm_tls_insecure
}

module "lxc" {
  source = "../../../modules/lxc"

  name        = "ladder"
  description = "Ladder web proxy"
  vmid        = 103

  ip_address = "${local.network.ips.ladder}/${split("/", local.network.subnet)[1]}"
  gateway    = local.network.gateway

  dns_domain  = local.network.domain
  dns_servers = [local.network.ips.pihole, local.network.external_dns[0]]

  memory_dedicated  = 256
  disk_size         = 16
  enable_nesting    = true
  enable_tun_device = true
}
