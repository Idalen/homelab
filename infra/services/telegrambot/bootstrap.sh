#!/usr/bin/env bash
set -euo pipefail

: "${VMID:?VMID is required}"
: "${LXC_SSH_USER:?LXC_SSH_USER is required}"
: "${START_B64:?START_B64 is required}"
: "${SERVICE_B64:?SERVICE_B64 is required}"
: "${TELEGRAM_BOT_TOKEN:?TELEGRAM_BOT_TOKEN is required}"
: "${GO_VERSION:?GO_VERSION is required}"

retry() {
  local i=0
  while [ "$i" -lt 30 ]; do
    if pct exec "$VMID" -- bash -lc "$1"; then
      return 0
    fi
    i=$((i + 1))
    sleep 2
  done
  return 1
}

TOKEN_B64=$(printf 'TELEGRAM_BOT_TOKEN=%s\n' "$TELEGRAM_BOT_TOKEN" | base64 -w 0)

retry "id -u ${LXC_SSH_USER} >/dev/null 2>&1 || useradd -m -s /bin/bash ${LXC_SSH_USER}"
retry "install -d -m 700 /home/${LXC_SSH_USER}/.ssh"
retry "if [ -f /root/.ssh/authorized_keys ]; then cp /root/.ssh/authorized_keys /home/${LXC_SSH_USER}/.ssh/authorized_keys; fi"
retry "chmod 600 /home/${LXC_SSH_USER}/.ssh/authorized_keys"
retry "chown -R ${LXC_SSH_USER}:${LXC_SSH_USER} /home/${LXC_SSH_USER}/.ssh"
retry "apt-get update && apt-get install -y git ca-certificates curl tar"
retry "rm -rf /usr/local/go && curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/go.tgz && tar -C /usr/local -xzf /tmp/go.tgz && ln -sf /usr/local/go/bin/go /usr/local/bin/go"
retry "install -d -m 755 /usr/local/bin"
retry "printf %s $START_B64 | base64 -d > /usr/local/bin/telegrambot-start.sh"
retry "chmod +x /usr/local/bin/telegrambot-start.sh"
retry "printf %s $TOKEN_B64 | base64 -d > /etc/telegrambot.env"
retry "chmod 600 /etc/telegrambot.env"
retry "printf %s $SERVICE_B64 | base64 -d > /etc/systemd/system/telegrambot.service"
retry "systemctl daemon-reload"
retry "systemctl enable --now telegrambot.service"
