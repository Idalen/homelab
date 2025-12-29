#!/usr/bin/env bash
set -euo pipefail

set -x

bash bootstrap.sh

echo "Disabling systemd-resolved DNS"
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved

echo "Deploying Pi-hole..."
cd "$HOME"
sudo docker compose -f "$HOME/nameserver-compose.yaml" up -d
