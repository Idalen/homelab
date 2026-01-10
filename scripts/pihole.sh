#!/usr/bin/env bash
set -euo pipefail

set -x

bash bootstrap.sh

echo "Disabling systemd-resolved DNS"
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo rm -f /etc/resolv.conf
printf "nameserver 1.1.1.1\nnameserver 8.8.8.8\n" | sudo tee /etc/resolv.conf >/dev/null

echo "Deploying Pi-hole..."
cd "$HOME"
sudo docker compose -f "$HOME/nameserver-compose.yaml" up -d
