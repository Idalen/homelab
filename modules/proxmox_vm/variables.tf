
variable "name" {
  type        = string
  description = "VM name"
}

variable "description" {
  type        = string
  description = "VM description"
}

variable "vmid" {
  type        = string
  description = "VM ID"
}

variable "target_node" {
  type        = string
  description = "Proxmox target node"
  default     = "pve"
}

variable "clone_template" {
  type        = string
  description = "Template to clone"
  default     = "packer-ubuntu2404"
}

variable "memory" {
  type        = number
  description = "Memory in MB"
  default     = 1024
}

variable "balloon" {
  type        = number
  description = "Balloon memory in MB"
  default     = 0
}

variable "cores" {
  type        = number
  description = "CPU cores"
  default     = 2
}

variable "sockets" {
  type        = number
  description = "CPU sockets"
  default     = 1
}

variable "bridge" {
  type        = string
  description = "Network bridge"
  default     = "vmbr0"
}

variable "storage" {
  type        = string
  description = "Storage backend"
  default     = "local-lvm"
}

variable "disk_size" {
  type        = string
  description = "Disk size"
  default     = "10G"
}

variable "vm_ip" {
  type        = string
  description = "VM IP address"
}

variable "vm_gateway" {
  type        = string
  description = "VM default gateway"
}

variable "ciuser" {
  type        = string
  description = "Cloud-init SSH user"
}

variable "sshkeys" {
  type        = string
  description = "SSH public keys for cloud-init"
  sensitive   = true
}

variable "ciupgrade" {
  type        = bool
  description = "Upgrade packages during cloud-init"
  default     = true
}

variable "cicustom" {
  type        = string
  description = "Cloud-init custom snippet"
  default     = "vendor=local:snippets/cloud-config.yaml"
}

variable "agent" {
  type        = number
  description = "Enable QEMU guest agent"
  default     = 1
}

variable "vm_state" {
  type        = string
  description = "Initial VM power state"
  default     = "running"
}

variable "automatic_reboot" {
  type        = bool
  description = "Automatically reboot on config change"
  default     = true
}

variable "usb_device" {
  type        = string
  description = "USB device ID"
  default     = null
}
