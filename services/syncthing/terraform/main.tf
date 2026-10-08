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

variable "vmid" {
  type        = number
  description = "Syncthing LXC ID"
  default     = 110
}

variable "disk_size" {
  type        = number
  description = "Root disk size in GB, including synchronized files"
  default     = 32
}

provider "proxmox" {
  endpoint = var.pm_api_url
  username = var.pm_user
  password = var.pm_password
  insecure = var.pm_tls_insecure
}

module "lxc" {
  source = "../../../modules/lxc"

  name        = "syncthing"
  description = "Syncthing file synchronization"
  vmid        = var.vmid

  ip_address = "${local.network.ips.syncthing}/${split("/", local.network.subnet)[1]}"
  gateway    = local.network.gateway

  dns_domain  = local.network.domain
  dns_servers = concat([local.network.ips.pihole], local.network.external_dns)

  memory_dedicated  = 1024
  disk_size         = var.disk_size
  enable_nesting    = true
  enable_tun_device = false
}
