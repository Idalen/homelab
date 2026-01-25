variable "target_node" {
  type        = string
  description = "Proxmox target node"
  default     = "pve"
}

variable "vmid" {
  type        = string
  description = "Container ID"
  default     = ""
}

variable "hostname" {
  type        = string
  description = "LXC hostname"
}

variable "ostemplate" {
  type        = string
  description = "Container OS template"
  default     = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
}

variable "onboot" {
  type        = bool
  description = "Start container on Proxmox boot"
  default     = true
}

variable "start" {
  type        = bool
  description = "Start the container after creation"
  default     = true
}

variable "memory" {
  type        = number
  description = "Memory in MB"
  default     = 512
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public keys to authorize for the container"
  default     = ""
}

variable "unprivileged" {
  type        = bool
  description = "Run container as unprivileged"
  default     = true
}

variable "storage" {
  type        = string
  description = "Root filesystem storage backend"
  default     = "local-zfs"
}

variable "disk_size" {
  type        = string
  description = "Root filesystem size"
  default     = "8G"
}

variable "network_name" {
  type        = string
  description = "Network interface name"
  default     = "eth0"
}

variable "bridge" {
  type        = string
  description = "Network bridge"
  default     = "vmbr0"
}

variable "ip_address" {
  type        = string
  description = "IP address (use dhcp for DHCP)"
  default     = "dhcp"
}

variable "gateway" {
  type        = string
  description = "Default gateway (leave empty for none)"
  default     = ""
}
