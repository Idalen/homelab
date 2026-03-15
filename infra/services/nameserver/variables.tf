
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

variable "vmid" {
  type        = string
  description = "Container ID"
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
}

variable "lxc_gateway" {
  type        = string
  description = "Container default gateway"
}

variable "lxc_ssh_keys" {
  type        = string
  description = "SSH public keys to authorize for the container"
  sensitive   = true
}

variable "lxc_ssh_user" {
  type        = string
  description = "SSH user to create inside the container"
}

variable "pihole_dns_1" {
  type        = string
  description = "Primary upstream DNS server for Pi-hole"
  default     = "1.1.1.1"
}

variable "pihole_dns_2" {
  type        = string
  description = "Secondary upstream DNS server for Pi-hole"
  default     = "8.8.8.8"
}

variable "pihole_webpassword" {
  type        = string
  description = "Pi-hole web UI password (empty string to auto-generate)"
  default     = ""
}
