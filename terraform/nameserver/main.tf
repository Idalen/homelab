
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure
}

module "cloud_config" {
  source = "../modules/cloud_config"

  proxmox_host = var.proxmox_host
  ssh_user     = var.proxmox_ssh_user
  vm_name      = "nameserver"
}

module "nameserver_vm" {
  source = "../modules/proxmox_vm"

  name        = "nameserver"
  description = "Runs pi-hole"
  vmid        = var.vmid

  vm_ip      = var.vm_ip
  vm_gateway = var.vm_gateway
  ciuser     = var.vm_ssh_user
  sshkeys    = var.vm_ssh_keys
  cicustom   = "vendor=local:snippets/${basename(module.cloud_config.snippet_path)}"

  memory    = 1024
  cores     = 2
  sockets   = 1
  disk_size = "10G"
}

resource "null_resource" "configure_nameserver" {
  depends_on = [module.nameserver_vm]

  connection {
    type        = "ssh"
    host        = split("/", var.vm_ip)[0]
    user        = var.vm_ssh_user
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "../../scripts/bootstrap.sh"
    destination = "/home/${var.vm_ssh_user}/bootstrap.sh"
  }

  provisioner "file" {
    source      = "../../scripts/pihole.sh"
    destination = "/home/${var.vm_ssh_user}/pihole.sh"
  }

  provisioner "file" {
    source      = "../../docker/nameserver-compose.yaml"
    destination = "/home/${var.vm_ssh_user}/nameserver-compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.vm_ssh_user}/bootstrap.sh",
      "chmod +x /home/${var.vm_ssh_user}/pihole.sh",
      "bash /home/${var.vm_ssh_user}/pihole.sh",
    ]
  }
}
