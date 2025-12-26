variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "pm_api_token_id" {
  type        = string
  description = "Proxmox API token ID"
  sensitive   = true
}

variable "pm_api_token_secret" {
  type        = string
  description = "Proxmox API token secret"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification"
  default     = true
}

variable "vm_ssh_user" {
  type        = string
  description = "Cloud-init SSH user"
}

variable "vm_ssh_keys" {
  type        = string
  description = "SSH public keys for cloud-init"
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

