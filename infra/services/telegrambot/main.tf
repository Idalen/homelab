terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure
}

module "telegrambot_lxc" {
  source = "../../modules/proxmox_lxc"

  hostname        = "telegrambot"
  vmid            = var.vmid
  target_node     = var.target_node
  ostemplate      = var.ostemplate
  bridge          = var.bridge
  ip_address      = var.lxc_ip
  gateway         = var.lxc_gateway
  storage         = var.storage
  disk_size       = "8G"
  memory          = 512
  ssh_public_keys = var.lxc_ssh_keys
}

resource "null_resource" "configure_telegrambot_user" {
  depends_on = [module.telegrambot_lxc]

  connection {
    type    = "ssh"
    host    = var.proxmox_host
    user    = var.proxmox_ssh_user
    agent   = true
    timeout = "2m"
  }

  provisioner "file" {
    source      = "${path.module}/bootstrap.sh"
    destination = "/tmp/telegrambot-bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [<<-EOT
set -e

START_B64=${jsonencode(base64encode(<<-SCRIPT
#!/usr/bin/env bash
set -euo pipefail
REPO_DIR=/home/${var.lxc_ssh_user}/telegrambot
if [ -d "$REPO_DIR/.git" ]; then
  cd "$REPO_DIR"
  git pull --ff-only
else
  git clone https://github.com/Idalen/telegrambot.git "$REPO_DIR"
  cd "$REPO_DIR"
fi
exec /usr/local/bin/go run main.go
SCRIPT
      ))}

SERVICE_B64=${jsonencode(base64encode(<<-UNIT
[Unit]
Description=Telegram Bot
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=${var.lxc_ssh_user}
WorkingDirectory=/home/${var.lxc_ssh_user}
EnvironmentFile=/etc/telegrambot.env
ExecStart=/usr/local/bin/telegrambot-start.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT
))}

VMID=${var.vmid} \
LXC_SSH_USER=${var.lxc_ssh_user} \
TELEGRAM_BOT_TOKEN=${var.telegram_bot_token} \
GO_VERSION=${var.go_version} \
START_B64=$START_B64 \
SERVICE_B64=$SERVICE_B64 \
bash /tmp/telegrambot-bootstrap.sh
EOT
]
}
}
