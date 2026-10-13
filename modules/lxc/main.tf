locals {
  container_description = var.description != "" ? var.description : var.name
  ssh_key_path          = replace(var.ssh_public_key_path, "~", pathexpand("~"))
}

resource "proxmox_virtual_environment_container" "container" {
  description = local.container_description
  node_name   = var.node_name
  vm_id       = var.vmid

  unprivileged = var.unprivileged

  features {
    nesting = var.enable_nesting
    keyctl  = var.enable_keyctl
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_dedicated
    swap      = 0
  }

  initialization {
    hostname = var.name

    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    dns {
      domain  = var.dns_domain
      servers = var.dns_servers
    }

    dynamic "user_account" {
      for_each = var.configure_initial_user ? [1] : []
      content {
        password = var.ssh_password
        keys = [
          file(local.ssh_key_path)
        ]
      }
    }
  }

  network_interface {
    name = var.network_name
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }

  dynamic "mount_point" {
    for_each = var.bind_mounts
    content {
      volume    = mount_point.value.host_path
      path      = mount_point.value.container_path
      read_only = mount_point.value.read_only
    }
  }

  dynamic "device_passthrough" {
    for_each = concat(var.enable_tun_device ? [{ path = "/dev/net/tun", mode = "0666" }] : [], var.device_passthrough)
    content {
      path       = device_passthrough.value.path
      mode       = device_passthrough.value.mode
      deny_write = false
    }
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "ubuntu"
  }
}
