variable "pm_api_url" {
  type = string
  default = "https://192.168.0.100:8006/api2/json"
}

variable "pm_api_token_id" {
  type = string
}

variable "pm_api_token_secret" {
  type = string
  sensitive = true
}

variable "pm_node" {
  type = string
  default = "pve"
}

variable "ssh_username" {
  type = string
  default = "damv"
}
