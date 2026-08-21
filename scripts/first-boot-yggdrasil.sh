#!/usr/bin/env bash
#==============================================================================
# Lumina OS – First Boot Yggdrasil Identity Script
#==============================================================================
# This script runs on first boot of a Lumina OS system.
# It ensures a permanent Yggdrasil identity exists and applies the Nexus
# closed overlay configuration.
#
# Location in the final system: /usr/lib/lumina/first-boot-yggdrasil.sh
# Triggered by a oneshot systemd service.
#==============================================================================

set -euo pipefail

YGG_CONF="/etc/yggdrasil/yggdrasil.conf"
YGG_CONF_DIR="/etc/yggdrasil"
MARKER="/var/lib/lumina/yggdrasil-firstboot-done"
GROUP_PASSWORD="NexusClosedOverlay-Hannover-2026-SecretSeed"

log() { echo "[Lumina FirstBoot] $*"; }

if [ -f "${MARKER}" ]; then
    log "Yggdrasil first-boot already completed. Exiting."
    exit 0
fi

log "Starting Yggdrasil first-boot identity setup..."

mkdir -p "${YGG_CONF_DIR}"
mkdir -p /var/lib/lumina

# Generate a new config if none exists or if it is still the default empty one
if [ ! -f "${YGG_CONF}" ] || ! grep -q "PrivateKey:" "${YGG_CONF}" 2>/dev/null; then
    log "Generating new Yggdrasil identity..."
    yggdrasil -genconf > "${YGG_CONF}"
fi

# Apply Nexus GroupPassword (closed overlay)
# Note: GroupPassword is supported in recent Yggdrasil versions
if grep -q "GroupPassword:" "${YGG_CONF}"; then
    # Replace existing value
    sed -i "s|GroupPassword:.*|GroupPassword: \"${GROUP_PASSWORD}\"|" "${YGG_CONF}"
else
    # Insert after PrivateKey block (simple approach)
    sed -i "/PrivateKey:/a\  GroupPassword: \"${GROUP_PASSWORD}\"" "${YGG_CONF}"
fi

# Add a sensible set of public peers for reachability (Germany / Europe focused)
# These are only for reaching the wider network; the GroupPassword keeps the
# private Nexus overlay closed.

cat >> "${YGG_CONF}" << 'EOF'

  # Public peers for reachability (Lumina OS default set)
  # The closed overlay is protected by GroupPassword.
  Peers:
  [
    "tls://ygg.mkg20001.io:443"
    "tls://ygg1.mk16.de:1338"
    "tls://yggdrasil.neilalexander.dev:64648"
  ]
EOF

# Set NodeInfo so other Nexus nodes can identify this machine
if ! grep -q "NodeInfo:" "${YGG_CONF}"; then
    cat >> "${YGG_CONF}" << 'EOF'

  NodeInfo:
  {
    name: "lumina-node"
    os: "Lumina OS"
    swarm: "elara+lyra+xen"
  }
EOF
fi

# Fix permissions
chown root:yggdrasil "${YGG_CONF}" 2>/dev/null || chown root:root "${YGG_CONF}"
chmod 640 "${YGG_CONF}"

# Enable and start the service if systemd is available
if command -v systemctl >/dev/null 2>&1; then
    systemctl enable yggdrasil.service || true
    systemctl restart yggdrasil.service || true
fi

touch "${MARKER}"
log "Yggdrasil first-boot identity setup completed."
