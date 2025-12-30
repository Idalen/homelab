
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

module "cloud_config" {
  source = "../../modules/cloud_config"

  proxmox_host = var.proxmox_host
  ssh_user     = var.proxmox_ssh_user
  vm_name      = "media"
}

module "media_vm" {
  source = "../../modules/proxmox_vm"

  name        = "media"
  description = "Runs qBittorrent and Jellyfin"
  vmid        = var.vmid

  vm_ip      = var.vm_ip
  vm_gateway = var.vm_gateway
  ciuser     = var.vm_ssh_user
  sshkeys    = var.vm_ssh_keys
  cicustom   = "vendor=local:snippets/${basename(module.cloud_config.snippet_path)}"

  memory    = 2048
  balloon   = 1024
  cores     = 2
  sockets   = 1
  disk_size = "30G"

  usb_device = "0bc2:2322"
}

resource "null_resource" "configure_media" {
  depends_on = [module.media_vm]

  connection {
    type        = "ssh"
    host        = split("/", var.vm_ip)[0]
    user        = var.vm_ssh_user
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "../../../scripts/bootstrap.sh"
    destination = "/home/${var.vm_ssh_user}/bootstrap.sh"
  }

  provisioner "file" {
    source      = "../../../scripts/media.sh"
    destination = "/home/${var.vm_ssh_user}/media.sh"
  }

  provisioner "file" {
    source      = "../../../docker/media-compose.yaml"
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
