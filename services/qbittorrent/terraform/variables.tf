variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
  default     = "https://192.168.0.100:8006/api2/json"
}

variable "pm_user" {
  type        = string
  description = "Proxmox API username"
  default     = "root@pam"
}

variable "pm_password" {
  type        = string
  description = "Proxmox API password"
  default     = "root"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification"
  default     = true
}

variable "vmid" {
  type        = number
  description = "LXC ID"
  default     = 112
}

variable "node_name" {
  type        = string
  description = "Proxmox node name"
  default     = "pve"
}

variable "disk_size" {
  type        = number
  description = "Root filesystem size in GiB; media storage configured separately"
  default     = 16
}

variable "datastore_id" {
  type        = string
  description = "Storage backend for root filesystem"
  default     = "local-lvm"
}

variable "template_file_id" {
  type        = string
  description = "Ubuntu LXC template ID"
  default     = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_password" {
  type        = string
  description = "Initial LXC root password"
  default     = "00000000"
  sensitive   = true
}
