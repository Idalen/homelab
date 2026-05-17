#!/usr/bin/env bash
# configure-vm.sh — configure cloud-init + USB passthrough on Proxmox host, then start VM
set -euo pipefail

PROXMOX_HOST="${PROXMOX_HOST:-192.168.0.100}"
VMID="${1:?Usage: $0 <vmid>}"
SSH_USER="${SSH_USER:-root}"

CLOUD_CONFIG_SNIPPET="${CLOUD_CONFIG_SNIPPET:-local:snippets/media-v2-cloud-config.yaml}"
VM_IP="${VM_IP:-192.168.0.103}"
VM_CIDR="${VM_CIDR:-24}"
VM_GATEWAY="${VM_GATEWAY:-192.168.0.1}"
VM_DNS="${VM_DNS:-192.168.0.2,1.1.1.1}"
VM_DOMAIN="${VM_DOMAIN:-home.arpa}"
VM_USER="${VM_USER:-ubuntu}"
SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY:-~/.ssh/id_rsa.pub}"
USB_DEVICE_ID="${USB_DEVICE_ID:-0bc2:2322}"

SSH_CMD="ssh -o StrictHostKeyChecking=no ${SSH_USER}@${PROXMOX_HOST}"

echo "=== Configuring cloud-init for VM ${VMID} ==="

"${SSH_CMD}" qm set "${VMID}" --ciuser "${VM_USER}"

SSH_KEY=$(cat "${SSH_PUBLIC_KEY/#\~/$HOME}")
"${SSH_CMD}" qm set "${VMID}" --sshkeys "${SSH_KEY}"

"${SSH_CMD}" qm set "${VMID}" --ipconfig0 "ip=${VM_IP}/${VM_CIDR},gw=${VM_GATEWAY}"
"${SSH_CMD}" qm set "${VMID}" --nameserver "${VM_DNS}" --searchdomain "${VM_DOMAIN}"
"${SSH_CMD}" qm set "${VMID}" --cicustom "vendor=${CLOUD_CONFIG_SNIPPET}"
"${SSH_CMD}" qm set "${VMID}" --agent 1

echo "=== Configuring USB passthrough for VM ${VMID} ==="

"${SSH_CMD}" qm set "${VMID}" --usb0 "host=${USB_DEVICE_ID},usb3=1"

echo "=== Regenerating cloud-init ISO ==="

"${SSH_CMD}" qm cloudinit push "${VMID}"

echo "=== Starting VM ${VMID} ==="

"${SSH_CMD}" qm start "${VMID}"

echo "=== VM ${VMID} configured and started ==="
echo "IP: ${VM_IP}/${VM_CIDR}"
echo "Waiting for SSH..."

for i in $(seq 1 60); do
  if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 "${VM_USER}@${VM_IP}" true 2>/dev/null; then
    echo "SSH ready after ${i}s"
    break
  fi
  sleep 2
done

echo "Done"
