output "vmid" {
  description = "VM ID"
  value       = proxmox_cloned_vm.media_vm.id
}

output "vm_ip" {
  description = "VM IP address"
  value       = var.vm_ip
}

output "vm_name" {
  description = "VM name"
  value       = proxmox_cloned_vm.media_vm.name
}

output "snippet_path" {
  description = "Cloud-config snippet path on Proxmox host"
  value       = module.cloud_config.snippet_path
}
