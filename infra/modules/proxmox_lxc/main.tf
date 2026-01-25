resource "proxmox_lxc" "lxc" {
  target_node  = var.target_node
  hostname     = var.hostname
  ostemplate   = var.ostemplate
  vmid         = var.vmid != "" ? var.vmid : null
  onboot       = var.onboot
  start        = var.start
  unprivileged = var.unprivileged
  ssh_public_keys = trimspace(var.ssh_public_keys)
  memory       = var.memory

  rootfs {
    storage = var.storage
    size    = var.disk_size
  }

  network {
    name   = var.network_name
    bridge = var.bridge
    ip     = var.ip_address
    gw     = var.gateway != "" ? var.gateway : null
  }
}
