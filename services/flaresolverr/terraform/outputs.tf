output "lxc_ip" {
  description = "Container IPv4 address"
  value       = module.lxc.ip_address
}

output "vmid" {
  description = "Container ID"
  value       = module.lxc.vmid
}

output "hostname" {
  description = "Container hostname"
  value       = module.lxc.hostname
}
