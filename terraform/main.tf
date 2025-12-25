terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.0.100:8006/api2/json"
  #pm_debug = true
  pm_tls_insecure = true
}

resource "proxmox_lxc" "dns" {
  target_node  = "pve"
  hostname     = "lxc-basic"
  ostemplate   = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  ostype       = "ubuntu"
  unprivileged = true

  onboot = true
  start  = true

  features {
    nesting = true
  #   keyctl  = true
  }

  ssh_public_keys = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlt4k3k7qE3KYw2IuJcDF0ua6PaoBgGzrxo9xVWHlbz idalenm@proton.me
  EOT

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.0.50/24"
    gw     = "192.168.0.1"
  }
}

resource "null_resource" "configure" {
  depends_on = [proxmox_lxc.dns]

  connection {
    type        = "ssh"
    host        = "192.168.0.50"
    user        = "root"
    agent       = true
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "../scripts/bootstrap.sh"
    destination = "/root/bootstrap.sh"
  }

  provisioner "file" {
    source      = "../docker/docker-compose.yaml"
    destination = "/root/docker-compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/bootstrap.sh",
      "/root/bootstrap.sh",
    ]
  }
}
