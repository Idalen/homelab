
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

variable "proxmox_ssh_password" {
  type        = string
  description = "SSH password for the Proxmox host (optional)."
  default     = ""
  sensitive   = true
}

variable "vm_ssh_user" {
  type        = string
  description = "Cloud-init SSH user"
}

variable "vm_ssh_keys" {
  type        = string
  description = "Path to SSH public key file for cloud-init (e.g., ~/.ssh/id_rsa.pub)"
  sensitive   = true
}

variable "vm_ip" {
  type        = string
  description = "VM IP address"
}

variable "vm_gateway" {
  type        = string
  description = "VM default gateway"
}

variable "vmid" {
  type        = string
  description = "VM ID"
}
