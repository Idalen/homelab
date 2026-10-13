terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.100"
    }
  }
}

provider "proxmox" {
  endpoint = var.pm_api_url
  username = var.pm_user
  password = var.pm_password
  insecure = var.pm_tls_insecure
}

locals {
  network = yamldecode(file("${path.module}/../../../shared/network.yml"))
}

module "lxc" {
  source = "../../../modules/lxc"

  name        = "qbittorrent"
  description = "qBittorrent torrent download and seeding"
  vmid        = var.vmid
  node_name   = var.node_name

  unprivileged = false

  bind_mounts = [{
    host_path      = "/mnt/storage"
    container_path = "/mnt/storage"
  }]

  ip_address = "${local.network.ips.qbittorrent}/${split("/", local.network.subnet)[1]}"
  gateway    = local.network.gateway

  dns_domain  = local.network.domain
  dns_servers = concat([local.network.ips.pihole], local.network.external_dns)

  cpu_cores           = 1
  memory_dedicated    = 1024
  disk_size           = var.disk_size
  datastore_id        = var.datastore_id
  template_file_id    = var.template_file_id
  ssh_public_key_path = var.ssh_public_key_path
  ssh_password        = var.ssh_password
  enable_nesting      = true
  enable_tun_device   = false
}
