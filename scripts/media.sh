#!/usr/bin/env bash
set -euo pipefail

bash bootstrap.sh

echo "Deploying media services..."
cd "$HOME"
sudo docker compose -f "$HOME/media-compose.yaml" up -d
