
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url           = var.pm_api_url
  pm_api_token_id      = var.pm_api_token_id
  pm_api_token_secret  = var.pm_api_token_secret
  pm_tls_insecure      = var.pm_tls_insecure
}

module "media_vm" {
  source = "../modules/proxmox_vm"

  name        = "media"
  description = "Runs qBittorrent and Jellyfin"
  vmid        = var.vmid

  vm_ip      = var.vm_ip
  vm_gateway = var.vm_gateway
  ciuser     = var.vm_ssh_user
  sshkeys    = var.vm_ssh_keys

  memory    = 2048
  cores     = 2
  sockets   = 1
  disk_size = "20G"
}

resource "null_resource" "configure_media" {
  depends_on = [module.media_vm]

  connection {
    type    = "ssh"
    host    = split("/", var.vm_ip)[0]
    user    = var.vm_ssh_user
    agent   = true
    timeout = "2m"
  }

  provisioner "file" {
    source      = "../../scripts/bootstrap.sh"
    destination = "/home/${var.vm_ssh_user}/bootstrap.sh"
  }

  provisioner "file" {
    source      = "../../scripts/media.sh"
    destination = "/home/${var.vm_ssh_user}/media.sh"
  }

  provisioner "file" {
    source      = "../../docker/media-compose.yaml"
    destination = "/home/${var.vm_ssh_user}/media-compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.vm_ssh_user}/bootstrap.sh",
      "chmod +x /home/${var.vm_ssh_user}/media.sh",
      "bash /home/${var.vm_ssh_user}/media.sh",
    ]
  }
}
