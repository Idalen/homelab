#!/usr/bin/env bash
set -euo pipefail

: "${LXC_SSH_USER:?LXC_SSH_USER is required}"
: "${NGINX_CONFIG_DIR:?NGINX_CONFIG_DIR is required}"

retry() {
  local i=0
  while [ "$i" -lt 30 ]; do
    if bash -lc "$1"; then
      return 0
    fi
    i=$((i + 1))
    sleep 2
  done
  return 1
}

retry "id -u ${LXC_SSH_USER} >/dev/null 2>&1 || useradd -m -s /bin/bash ${LXC_SSH_USER}"
retry "install -d -m 700 /home/${LXC_SSH_USER}/.ssh"
retry "if [ -f /root/.ssh/authorized_keys ]; then cp /root/.ssh/authorized_keys /home/${LXC_SSH_USER}/.ssh/authorized_keys; fi"
retry "chmod 600 /home/${LXC_SSH_USER}/.ssh/authorized_keys"
retry "chown -R ${LXC_SSH_USER}:${LXC_SSH_USER} /home/${LXC_SSH_USER}/.ssh"
retry "apt-get update && apt-get install -y nginx ca-certificates curl openssl"
retry "install -d -m 755 /etc/nginx/sites-available /etc/nginx/sites-enabled"
retry "install -d -m 755 /etc/nginx/certs"

if [ ! -f /etc/nginx/certs/home-arpa.key ] || [ ! -f /etc/nginx/certs/home-arpa.crt ]; then
  retry "openssl req -x509 -nodes -newkey rsa:2048 -days 3650 \
    -keyout /etc/nginx/certs/home-arpa.key \
    -out /etc/nginx/certs/home-arpa.crt \
    -subj '/CN=*.home.arpa' \
    -addext 'subjectAltName=DNS:*.home.arpa,DNS:home.arpa,DNS:localhost'"
fi

for config in "${NGINX_CONFIG_DIR}"/*; do
  [ -f "${config}" ] || continue

  config_name="$(basename "${config}")"
  config_b64="$(base64 < "${config}" | tr -d '\n')"

  retry "printf %s '${config_b64}' | base64 -d > /etc/nginx/sites-available/${config_name}"
  retry "ln -sfn /etc/nginx/sites-available/${config_name} /etc/nginx/sites-enabled/${config_name}"
done

retry "rm -f /etc/nginx/sites-enabled/default"
retry "nginx -t"
retry "systemctl enable --now nginx"
retry "systemctl reload nginx || systemctl restart nginx"
