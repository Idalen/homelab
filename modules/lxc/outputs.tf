output "ip_address" {
  description = "Container IP address (without CIDR)"
  value       = split("/", proxmox_virtual_environment_container.container.initialization[0].ip_config[0].ipv4[0].address)[0]
}

output "vmid" {
  description = "Container VM ID"
  value       = proxmox_virtual_environment_container.container.vm_id
}

output "hostname" {
  description = "Container hostname"
  value       = proxmox_virtual_environment_container.container.initialization[0].hostname
}