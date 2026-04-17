
#!/usr/bin/env bash
set -euo pipefail

set -x

echo "Waiting for cloud-init to finish (if present)..."
if command -v cloud-init >/dev/null 2>&1; then
  cloud-init status --wait || true
fi

echo "Installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg

echo "Setting up Docker APT repository (Ubuntu)..."
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker’s official GPG key (keyring format)
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
fi

# Add the repository
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
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

