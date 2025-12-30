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
  pm_api_token_id         = var.pm_api_token_id
  pm_api_token_secret     = var.pm_api_token_secret
  pm_tls_insecure = var.pm_tls_insecure
}

module "cloud_config" {
  source = "../modules/cloud_config"

  proxmox_host     = var.proxmox_host
  ssh_user         = var.proxmox_ssh_user
  vm_name          = "reverseproxy"
  cloud_config_src = "../reverseproxy/reverseproxy-cloud-config.yaml"
}

module "reverseproxy_vm" {
  source = "../modules/proxmox_vm"
  depends_on = [module.cloud_config]

  name        = "reverseproxy"
  description = "Basically NGINX doing its magic"
  vmid        = var.vmid

  vm_ip      = var.vm_ip
  vm_gateway = var.vm_gateway
  ciuser     = var.vm_ssh_user
  sshkeys    = var.vm_ssh_keys
  cicustom   = "vendor=local:snippets/${basename(module.cloud_config.snippet_path)}"

  memory    = 1024
  cores     = 1
  sockets   = 1
  disk_size = "8G"
}

resource "null_resource" "verify_reverseproxy" {
  count      = var.enable_post_boot_verify ? 1 : 0
  depends_on = [module.reverseproxy_vm]

  connection {
    type    = "ssh"
    host    = split("/", var.vm_ip)[0]
    user    = var.vm_ssh_user
    private_key = file("~/.ssh/id_rsa")
    timeout = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait || true",
      "systemctl is-active nginx",
      "nginx -t",
      "curl -I http://localhost",
    ]
  }
}

# resource "null_resource" "configure_media" {
#   depends_on = [module.media_vm]
#
#   connection {
#     type        = "ssh"
#     host        = split("/", var.vm_ip)[0]
#     user        = var.vm_ssh_user
#     private_key = file("~/.ssh/id_rsa")
#     timeout     = "2m"
#   }
#
#   provisioner "file" {
#     source      = "../../scripts/bootstrap.sh"
#     destination = "/home/${var.vm_ssh_user}/bootstrap.sh"
#   }
#
#   provisioner "file" {
#     source      = "../../scripts/media.sh"
#     destination = "/home/${var.vm_ssh_user}/media.sh"
#   }
#
#   provisioner "file" {
#     source      = "../../docker/media-compose.yaml"
#     destination = "/home/${var.vm_ssh_user}/media-compose.yaml"
#   }
#
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /home/${var.vm_ssh_user}/bootstrap.sh",
#       "chmod +x /home/${var.vm_ssh_user}/media.sh",
#       "bash /home/${var.vm_ssh_user}/media.sh",
#     ]
#   }
# }
