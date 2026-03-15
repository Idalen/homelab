
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure
}

module "nameserver_lxc" {
  source = "../../modules/proxmox_lxc"

  hostname        = "nameserver"
  vmid            = var.vmid
  target_node     = var.target_node
  ostemplate      = var.ostemplate
  bridge          = var.bridge
  ip_address      = var.lxc_ip
  gateway         = var.lxc_gateway
  storage         = var.storage
  disk_size       = "20G"
  memory          = 1024
  ssh_public_keys = var.lxc_ssh_keys
}

resource "null_resource" "configure_nameserver" {
  depends_on = [module.nameserver_lxc]

  connection {
    type    = "ssh"
    host    = var.proxmox_host
    user    = var.proxmox_ssh_user
    agent   = true
    timeout = "2m"
  }

  provisioner "file" {
    source      = "${path.module}/bootstrap.sh"
    destination = "/tmp/nameserver-bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [<<-EOT
set -e

VMID=${var.vmid} \
LXC_SSH_USER=${var.lxc_ssh_user} \
LXC_IP=${var.lxc_ip} \
PIHOLE_DNS_1=${var.pihole_dns_1} \
PIHOLE_DNS_2=${var.pihole_dns_2} \
PIHOLE_WEBPASSWORD=${var.pihole_webpassword} \
bash /tmp/nameserver-bootstrap.sh
EOT
    ]
  }
}
