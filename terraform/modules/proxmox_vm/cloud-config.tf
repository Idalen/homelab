variable "proxmox_host" {
  type        = string
  description = "Proxmox host to connect to over SSH."
  default     = "192.168.0.100"
}

variable "ssh_user" {
  type        = string
  description = "SSH user for the Proxmox host."
  default     = "root"
}

locals {
  cloud_config_src = "${path.root}/../../cloud-config/cloud-config.yaml"
  cloud_config_dst = "/var/lib/vz/snippets/cloud-config.yaml"
}

resource "null_resource" "cloud_config_snippet" {
  triggers = {
    cloud_config_hash = filesha256(local.cloud_config_src)
  }

  connection {
    type  = "ssh"
    host  = var.proxmox_host
    user  = var.ssh_user
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /var/lib/vz/snippets"
    ]
  }

  provisioner "file" {
    source      = local.cloud_config_src
    destination = local.cloud_config_dst
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0644 ${local.cloud_config_dst}"
    ]
  }
}
output "snippet_path" {
  value = "/var/lib/vz/snippets/cloud-config.yaml"
}
