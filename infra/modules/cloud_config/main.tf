locals {
  cloud_config_src = var.cloud_config_src != "" ? var.cloud_config_src : "../../services/${var.vm_name}/cloud-config.yaml"
  cloud_config_dst = var.cloud_config_dst != "" ? var.cloud_config_dst : "/var/lib/vz/snippets/${var.vm_name}-cloud-config.yaml"
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
