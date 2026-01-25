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

module "telegrambot_lxc" {
  source = "../../modules/proxmox_lxc"

  hostname        = "telegrambot"
  vmid            = var.vmid
  target_node     = var.target_node
  ostemplate      = var.ostemplate
  bridge          = var.bridge
  ip_address      = var.lxc_ip
  gateway         = var.lxc_gateway
  storage         = var.storage
  disk_size       = "10G"
  memory          = 512
  ssh_public_keys = var.lxc_ssh_keys
}

resource "null_resource" "configure_telegrambot_user" {
  depends_on = [module.telegrambot_lxc]

  connection {
    type  = "ssh"
    host  = var.proxmox_host
    user  = var.proxmox_ssh_user
    agent = true
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "pct exec ${var.vmid} -- bash -lc \"id -u ${var.lxc_ssh_user} >/dev/null 2>&1 || useradd -m -s /bin/bash ${var.lxc_ssh_user}\"",
      "pct exec ${var.vmid} -- bash -lc \"install -d -m 700 /home/${var.lxc_ssh_user}/.ssh\"",
      "pct exec ${var.vmid} -- bash -lc \"cat > /home/${var.lxc_ssh_user}/.ssh/authorized_keys <<'EOF'\n${trimspace(var.lxc_ssh_keys)}\nEOF\"",
      "pct exec ${var.vmid} -- bash -lc \"chmod 600 /home/${var.lxc_ssh_user}/.ssh/authorized_keys\"",
      "pct exec ${var.vmid} -- bash -lc \"chown -R ${var.lxc_ssh_user}:${var.lxc_ssh_user} /home/${var.lxc_ssh_user}/.ssh\"",
    ]
  }
}
