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

resource "proxmox_vm_qemu" "nameserver" {
  name = "nameserver"
  description = "Runs pi-hole"
  vmid = "2180"
  target_node = "pve"
  
  agent  = 1 
  clone  = "debian12-cloudinit"
  scsihw = "virtio-scsi-single"
  boot   = "order=scsi0"
  vm_state = "running"
  automatic_reboot = true

  os_type = "cloud_init"
  ipconfig0 = "ip=${var.vm_ip},gw=${var.vm_gateway}"  
  ciuser  = var.vm_ssh_user
  sshkeys = var.vm_ssh_keys
  ciupgrade  = true
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml"

  memory = 1024
  
  cpu {
    cores = 2
    sockets = 1
  }

  network {
    id = 0
    bridge = "vmbr0"
    model = "virtio"
  }

  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "10G" 
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }
}

resource "null_resource" "configure" {
  depends_on = [proxmox_vm_qemu.nameserver]

  connection {
    type    = "ssh"
    host    = split("/", var.vm_ip)[0]
    user    = "damv"
    agent   = true
    timeout = "2m"
  }

  provisioner "file" {
    source      = "../scripts/bootstrap.sh"
    destination = "/home/${var.vm_ssh_user}/bootstrap.sh"
  }

  provisioner "file" {
    source      = "../scripts/pihole.sh"
    destination = "/home/${var.vm_ssh_user}/pihole.sh"
  }


  provisioner "file" {
    source      = "../docker/docker-compose.yaml"
    destination = "/home/${var.vm_ssh_user}/docker-compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.vm_ssh_user}/bootstrap.sh",
      "chmod +x /home/${var.vm_ssh_user}/pihole.sh",
      "bash /home/${var.vm_ssh_user}/pihole.sh",
    ]
  }
}
