variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "pm_user" {
  type        = string
  description = "Proxmox API username"
}

variable "pm_password" {
  type        = string
  description = "Proxmox API password"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification"
  default     = true
}

variable "vmid" {
  type        = number
  description = "Container ID"
}

variable "vm_ip" {
  type        = string
  description = "Container IP address"
}

variable "vm_gateway" {
  type        = string
  description = "Container default gateway"
}

variable "vm_ssh_user" {
  type        = string
  description = "SSH user for the container"
}

variable "vm_ssh_password" {
  type        = string
  description = "Password for the SSH user"
  sensitive   = true
}

