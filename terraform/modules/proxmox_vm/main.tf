
resource "proxmox_vm_qemu" "vm" {
  name        = var.name
  description = var.description
  vmid        = var.vmid
  target_node = var.target_node

  agent            = var.agent
  clone            = var.clone_template
  vm_state         = var.vm_state
  automatic_reboot = var.automatic_reboot

  scsihw  = "virtio-scsi-pci"
  boot    = "order=virtio0"
  os_type = "cloud_init"

  ipconfig0 = "ip=${var.vm_ip},gw=${var.vm_gateway}"
  ciuser    = var.ciuser
  sshkeys   = var.sshkeys
  ciupgrade = var.ciupgrade
  cicustom  = var.cicustom

  memory  = var.memory
  balloon = var.balloon

  cpu {
    cores   = var.cores
    sockets = var.sockets
    type    = "kvm64"
  }

  network {
    id     = 0
    bridge = var.bridge
    model  = "virtio"
  }

  serial {
    id = 0
  }

  dynamic "usb" {
    for_each = var.usb_device != null ? [var.usb_device] : []
    content {
      id        = 0
      device_id = usb.value
      usb3      = true
    }
  }

  disks {
    virtio {
      virtio0 {
        disk {
          storage = var.storage
          size    = var.disk_size
        }
      }
    }

    ide {
      ide1 {
        cloudinit {
          storage = var.storage
        }
      }
    }
  }
}
