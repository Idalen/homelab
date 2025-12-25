
#!/usr/bin/env bash
set -e

echo "Updating system"
sudo apt update -y

echo "Installing dependencies"
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "Adding Docker GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Adding Docker repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker and Docker Compose"
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Enabling Docker at boot"
sudo systemctl enable docker
sudo systemctl start docker

echo "Running Pi-hole via docker compose"
sudo docker compose up -d pihole

echo "Done"

