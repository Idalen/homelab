#!/usr/bin/env bash
set -euo pipefail

: "${VMID:?VMID is required}"
: "${LXC_SSH_USER:?LXC_SSH_USER is required}"
: "${LXC_IP:?LXC_IP is required}"
: "${PIHOLE_DNS_1:?PIHOLE_DNS_1 is required}"
: "${PIHOLE_DNS_2:?PIHOLE_DNS_2 is required}"
PIHOLE_WEBPASSWORD="${PIHOLE_WEBPASSWORD-}"

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

retry "id -u ${LXC_SSH_USER} >/dev/null 2>&1 || useradd -m -s /bin/bash ${LXC_SSH_USER}"
retry "install -d -m 700 /home/${LXC_SSH_USER}/.ssh"
retry "if [ -f /root/.ssh/authorized_keys ]; then cp /root/.ssh/authorized_keys /home/${LXC_SSH_USER}/.ssh/authorized_keys; fi"
retry "chmod 600 /home/${LXC_SSH_USER}/.ssh/authorized_keys"
retry "chown -R ${LXC_SSH_USER}:${LXC_SSH_USER} /home/${LXC_SSH_USER}/.ssh"
retry "if systemctl is-enabled systemd-resolved >/dev/null 2>&1; then systemctl disable --now systemd-resolved; fi"
retry "printf 'nameserver %s\nnameserver %s\n' '${PIHOLE_DNS_1}' '${PIHOLE_DNS_2}' > /etc/resolv.conf"
retry "install -d -m 755 /etc/pihole"
retry "cat > /etc/pihole/setupVars.conf <<'VARS'\nPIHOLE_INTERFACE=eth0\nIPV4_ADDRESS=${LXC_IP}\nIPV6_ADDRESS=\nPIHOLE_DNS_1=${PIHOLE_DNS_1}\nPIHOLE_DNS_2=${PIHOLE_DNS_2}\nQUERY_LOGGING=true\nINSTALL_WEB_SERVER=true\nINSTALL_WEB_INTERFACE=true\nLIGHTTPD_ENABLED=true\nCACHE_SIZE=10000\nDNS_FQDN_REQUIRED=true\nDNS_BOGUS_PRIV=true\nDNSMASQ_LISTENING=local\nVARS"

retry "apt-get update && apt-get install -y ca-certificates curl"

retry "export DEBIAN_FRONTEND=noninteractive; \
export PIHOLE_SKIP_OS_CHECK=true; \
export PIHOLE_SKIP_STATIC_IP_CHECK=true; \
${PIHOLE_WEBPASSWORD:+export WEBPASSWORD='${PIHOLE_WEBPASSWORD}'; } \
curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended"
retry "cat > /etc/pihole/setupVars.conf <<'VARS'\nPIHOLE_INTERFACE=eth0\nIPV4_ADDRESS=${LXC_IP}\nIPV6_ADDRESS=\nPIHOLE_DNS_1=${PIHOLE_DNS_1}\nPIHOLE_DNS_2=${PIHOLE_DNS_2}\nQUERY_LOGGING=true\nINSTALL_WEB_SERVER=true\nINSTALL_WEB_INTERFACE=true\nLIGHTTPD_ENABLED=true\nCACHE_SIZE=10000\nDNS_FQDN_REQUIRED=true\nDNS_BOGUS_PRIV=true\nDNSMASQ_LISTENING=local\nVARS"
retry "/usr/local/bin/pihole -a setdns 1.1.1.1 1.0.0.1"
retry "cat > /etc/dnsmasq.d/99-home.conf <<'CONF'\naddress=/.home/192.168.0.103\nCONF"
retry "/usr/local/bin/pihole -g"
retry "/usr/local/bin/pihole restartdns"
