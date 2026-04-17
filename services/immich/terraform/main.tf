terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  endpoint = var.pm_api_url
  username = var.pm_user
  password = var.pm_password
  insecure = var.pm_tls_insecure
}

module "lxc" {
  source = "../../../modules/lxc"

  name        = "immich"
  description = "Immich photo backup server"
  vmid        = var.vmid

  ip_address = var.vm_ip
  gateway    = var.vm_gateway

  dns_servers = ["192.168.0.2"]

  ssh_password = var.vm_ssh_password

  cpu_cores        = 2
  memory_dedicated = 4096

  disk_size = 20

  enable_tun_device = true
}