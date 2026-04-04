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

locals {
  nginx_config_files = sort(fileset("${path.module}/nginx", "*"))
}

module "reverseproxy_lxc" {
  source = "../../modules/proxmox_lxc"

  hostname        = "reverseproxy"
  vmid            = var.vmid
  target_node     = var.target_node
  ostemplate      = var.ostemplate
  bridge          = var.bridge
  ip_address      = var.lxc_ip
  gateway         = var.lxc_gateway
  storage         = var.storage
  disk_size       = "8G"
  memory          = 512
  ssh_public_keys = var.lxc_ssh_keys
}

resource "null_resource" "configure_reverseproxy" {
  depends_on = [module.reverseproxy_lxc]

  triggers = {
    bootstrap_hash = filesha256("${path.module}/bootstrap.sh")
    nginx_dir_hash = sha256(jsonencode({
      for config in local.nginx_config_files :
      config => filesha256("${path.module}/nginx/${config}")
    }))
  }

  connection {
    type        = "ssh"
    host        = split("/", var.lxc_ip)[0]
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }
  provisioner "file" {
    source      = "${path.module}/bootstrap.sh"
    destination = "/tmp/reverseproxy-bootstrap.sh"
  }

  provisioner "file" {
    source      = "${path.module}/nginx"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [<<-EOT
set -e

LXC_SSH_USER=${var.lxc_ssh_user} \
NGINX_CONFIG_DIR=/tmp/nginx \
bash /tmp/reverseproxy-bootstrap.sh
EOT
    ]
  }
}

resource "null_resource" "verify_reverseproxy" {
  count      = var.enable_post_boot_verify ? 1 : 0
  depends_on = [null_resource.configure_reverseproxy]

  connection {
    type        = "ssh"
    host        = split("/", var.lxc_ip)[0]
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [<<-EOT
set -e
systemctl is-active nginx
nginx -t
curl -I http://localhost
EOT
    ]
  }
}
