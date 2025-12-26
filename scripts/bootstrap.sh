

#!/usr/bin/env bash
set -euo pipefail

echo "Waiting for cloud-init to finish (if present)..."
if command -v cloud-init >/dev/null 2>&1; then
  cloud-init status --wait || true
fi

echo "Installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl

echo "Setting up Docker APT repository..."
sudo install -m 0755 -d /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/docker.asc ]; then
  curl -fsSL https://download.docker.com/linux/debian/gpg \
    | sudo tee /etc/apt/keyrings/docker.asc >/dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

if [ ! -f /etc/apt/sources.list.d/docker.sources ]; then
  sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
fi

echo "Updating apt with Docker repo..."
sudo apt-get update -y

if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker Engine..."
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable --now docker
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Installing Docker Compose plugin..."
  sudo apt-get install -y docker-compose-plugin
fi

echo "Done"

