variable "pm_api_url" {
  type        = string
  description = "Proxmox VE API endpoint (e.g., https://192.168.0.100:8006/api2/json)"
}

variable "pm_api_token" {
  type        = string
  description = "Proxmox VE API token (e.g., root@pam!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification"
  default     = true
}

variable "proxmox_host" {
  type        = string
  description = "Proxmox host for SSH (cloud-config copy)"
  default     = "192.168.0.100"
}

variable "proxmox_ssh_user" {
  type        = string
  description = "SSH user for Proxmox host"
  default     = "root"
}

variable "proxmox_ssh_password" {
  type        = string
  description = "SSH password for Proxmox host (or use SSH agent)"
  default     = ""
  sensitive   = true
}

variable "target_node" {
  type        = string
  description = "Proxmox target node"
  default     = "pve"
}

variable "vmid" {
  type        = string
  description = "VM ID for the media VM"
  default     = "103"
}

variable "clone_source_vmid" {
  type        = number
  description = "Source VM/template ID to clone from"
}

variable "vm_ssh_user" {
  type        = string
  description = "Cloud-init SSH user"
}

variable "vm_ssh_public_key" {
  type        = string
  description = "Path to SSH public key for cloud-init user"
}

variable "cpu_cores" {
  type        = number
  description = "CPU cores"
  default     = 3
}

variable "cpu_sockets" {
  type        = number
  description = "CPU sockets"
  default     = 1
}

variable "memory_dedicated" {
  type        = number
  description = "Dedicated memory in MB"
  default     = 6144
}

variable "memory_floating" {
  type        = number
  description = "Floating/balloon memory in MB"
  default     = 0
}

variable "network_bridge" {
  type        = string
  description = "Network bridge"
  default     = "vmbr0"
}

variable "disk_datastore" {
  type        = string
  description = "Disk datastore"
  default     = "local-lvm"
}

variable "disk_size_gb" {
  type        = number
  description = "Root disk size in GB"
  default     = 30
}

variable "vm_ip" {
  type        = string
  description = "Static IP for the media VM"
  default     = "192.168.0.103"
}

variable "vm_gateway" {
  type        = string
  description = "Default gateway"
  default     = "192.168.0.1"
}

variable "vm_dns_servers" {
  type        = string
  description = "DNS servers (comma-separated)"
  default     = "192.168.0.2,1.1.1.1"
}

variable "vm_dns_domain" {
  type        = string
  description = "DNS search domain"
  default     = "home.arpa"
}

variable "usb_device_id" {
  type        = string
  description = "USB device ID for passthrough (e.g., 0bc2:2322)"
  default     = "0bc2:2322"
}
