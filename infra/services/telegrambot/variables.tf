
variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "pm_user" {
  type        = string
  description = "Proxmox API token ID"
}

variable "pm_password" {
  type        = string
  description = "Proxmox API token secret"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification"
  default     = true
}

variable "proxmox_host" {
  type        = string
  description = "Proxmox host to connect to over SSH."
  default     = "192.168.0.100"
}

variable "proxmox_ssh_user" {
  type        = string
  description = "SSH user for the Proxmox host."
  default     = "root"
}

variable "target_node" {
  type        = string
  description = "Proxmox target node"
  default     = "pve"
}

variable "ostemplate" {
  type        = string
  description = "Container OS template"
  default     = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
}

variable "bridge" {
  type        = string
  description = "Network bridge"
  default     = "vmbr0"
}

variable "storage" {
  type        = string
  description = "Root filesystem storage backend"
  default     = "local-lvm"
}

variable "lxc_ip" {
  type        = string
  description = "Container IP address in CIDR format (use dhcp for DHCP)"
  default     = "192.168.0.201/24"
}

variable "lxc_gateway" {
  type        = string
  description = "Container default gateway"
  default     = "192.168.0.1"
}

variable "lxc_ssh_keys" {
  type        = string
  description = "SSH public keys for container access"
  sensitive   = true
}

variable "lxc_ssh_user" {
  type        = string
  description = "SSH user to create in the container"
}

variable "vmid" {
  type        = string
  description = "Container ID"
  default     = "201"
}
