terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.100"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = var.pm_api_token
  insecure  = var.pm_tls_insecure

  ssh {
    agent = true
    username = var.proxmox_ssh_user
  }
}

locals {
  ssh_key_path = replace(var.vm_ssh_public_key, "~", pathexpand("~"))
}

module "cloud_config" {
  source = "../../../modules/cloud_config"

  proxmox_host     = var.proxmox_host
  ssh_user         = var.proxmox_ssh_user
  ssh_password     = var.proxmox_ssh_password
  vm_name          = "media-v2"
  cloud_config_src = "cloud-config.yaml"
}

resource "proxmox_cloned_vm" "media_vm" {
  node_name = var.target_node
  name      = "media-v2"
  id        = tonumber(var.vmid)
  description = "Jellyfin + qBittorrent media stack (v2, bpg provider)"

  clone {
    source_vm_id     = var.clone_source_vmid
    full             = true
    retries          = 3
  }

  cpu {
    cores = var.cpu_cores
    sockets = var.cpu_sockets
  }

  memory {
    dedicated = var.memory_dedicated
    floating  = var.memory_floating
  }

  network = {
    net0 = {
      bridge = var.network_bridge
    }
  }

  disk = {
    scsi0 = {
      datastore_id = var.disk_datastore
      size_gb      = var.disk_size_gb
    }
  }

  started          = false
  stop_on_destroy  = false
  purge_on_destroy = true

  tags = ["media-v2", "jellyfin", "qbittorrent"]

  lifecycle {
    ignore_changes = [started]
  }
}
