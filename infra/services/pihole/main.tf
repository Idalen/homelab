terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60" # adjust to latest stable
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.0.100:8006/api2/json"

  username = "root@pam"
  password = "root"

  insecure = true
}

resource "proxmox_virtual_environment_container" "pihole" {

  description = "Pi-hole DNS sinkhole"

  node_name = "pve"
  vm_id     = 105

  unprivileged = true


  initialization {
    hostname = "pihole"

    ip_config {
      ipv4 {
        address = "192.168.0.2/24"
        gateway = "192.168.0.1"
      }
    }

    dns {
      domain  = "home.arpa"
      servers = ["192.168.0.101"]
    }


    user_account {
      password = "00000000"
      keys = [
        file("~/.ssh/id_rsa.pub")
      ]
    }
  }

  network_interface {
    name = "eth0"
  }


  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
    type             = "ubuntu"
  }

}
