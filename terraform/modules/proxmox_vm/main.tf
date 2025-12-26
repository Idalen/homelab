
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.name
  description = var.description
  vmid        = var.vmid
  target_node = var.target_node

  agent            = var.agent
  clone            = var.clone_template
  scsihw           = "virtio-scsi-single"
  boot             = "order=scsi0"
  vm_state         = var.vm_state
  automatic_reboot = var.automatic_reboot

  os_type   = "cloud_init"
  ipconfig0 = "ip=${var.vm_ip},gw=${var.vm_gateway}"
  ciuser    = var.ciuser
  sshkeys   = var.sshkeys
  ciupgrade = var.ciupgrade
  cicustom  = var.cicustom

  memory = var.memory

  cpu {
    cores   = var.cores
    sockets = var.sockets
  }

  network {
    id     = 0
    bridge = var.bridge
    model  = "virtio"
  }

  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
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
