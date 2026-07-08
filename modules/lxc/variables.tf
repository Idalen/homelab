variable "name" {
  type        = string
  description = "Container name (used for hostname and description)"
}

variable "description" {
  type        = string
  description = "Container description"
  default     = ""
}

variable "vmid" {
  type        = number
  description = "Container ID"
}

variable "node_name" {
  type        = string
  description = "Proxmox node name"
  default     = "pve"
}

variable "unprivileged" {
  type        = bool
  description = "Run container as unprivileged"
  default     = true
}

variable "ip_address" {
  type        = string
  description = "IPv4 address in CIDR notation (e.g., 192.168.0.2/24)"
}

variable "gateway" {
  type        = string
  description = "Default gateway"
  default     = "192.168.0.1"
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers"
  default     = ["1.1.1.1"]
}

variable "dns_domain" {
  type        = string
  description = "DNS domain"
  default     = "home.arpa"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key for container access"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_password" {
  type        = string
  description = "SSH password for container"
  default     = "00000000"
  sensitive   = true
}

variable "network_name" {
  type        = string
  description = "Network interface name"
  default     = "eth0"
}

variable "datastore_id" {
  type        = string
  description = "Storage backend for root filesystem"
  default     = "local-lvm"
}

variable "disk_size" {
  type        = number
  description = "Root filesystem size in GB"
  default     = 8
}

variable "enable_keyctl" {
  type        = bool
  description = "Enable keyctl in container features"
  default     = false
}

variable "enable_nesting" {
  type        = bool
  description = "Enable container nesting (needed for Docker)"
  default     = false
}

variable "template_file_id" {
  type        = string
  description = "OS template ID"
  default     = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "cpu_cores" {
  type        = number
  description = "CPU cores"
  default     = 1
}

variable "memory_dedicated" {
  type        = number
  description = "Dedicated memory in MB"
  default     = 512
}

variable "enable_tun_device" {
  type        = bool
  description = "Enable /dev/net/tun device passthrough"
  default     = true
}