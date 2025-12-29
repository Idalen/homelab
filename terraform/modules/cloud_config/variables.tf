variable "proxmox_host" {
  type        = string
  description = "Proxmox host to connect to over SSH."
  default     = "192.168.0.100"
}

variable "ssh_user" {
  type        = string
  description = "SSH user for the Proxmox host."
  default     = "root"
}

variable "cloud_config_src" {
  type        = string
  description = "Local path to the cloud-config YAML."
  default     = ""
}

variable "cloud_config_dst" {
  type        = string
  description = "Destination path for the snippet on the Proxmox host."
  default     = ""
}

variable "vm_name" {
  type        = string
  description = "VM name used to derive the cloud-config path."
}
