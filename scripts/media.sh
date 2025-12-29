#!/usr/bin/env bash
set -euo pipefail

set -x

bash bootstrap.sh

echo "Mounting USB external disk..."

DEVICE="/dev/sda1"
MOUNT_POINT="/mnt/media"

# Ensure mount point exists
if [ ! -d "$MOUNT_POINT" ]; then
  sudo mkdir -p "$MOUNT_POINT"
fi

# Get UUID of the device
UUID=$(blkid -s UUID -o value "$DEVICE")

if [ -z "$UUID" ]; then
  echo "ERROR: Could not determine UUID for $DEVICE"
  exit 1
fi

# Add to /etc/fstab if not already present
if ! grep -q "$UUID" /etc/fstab; then
  echo "Adding disk to /etc/fstab..."
  echo "UUID=$UUID  $MOUNT_POINT  ext4  defaults,nofail  0  2" | sudo tee -a /etc/fstab
else
  echo "Disk already present in /etc/fstab"
fi

# Mount (safe if already mounted)
sudo mount "$MOUNT_POINT" || true

echo "USB disk mounted at $MOUNT_POINT"

echo "Deploying media services..."
cd "$HOME"
sudo docker compose -f "$HOME/media-compose.yaml" up -d
