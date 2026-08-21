#!/bin/bash
#==============================================================================
# Lumina OS – First Boot Yggdrasil Identity Script
#==============================================================================
set -euo pipefail

YGG_CONF="/etc/yggdrasil/yggdrasil.conf"
MARKER="/var/lib/lumina/yggdrasil-firstboot-done"
GROUP_PASSWORD="NexusClosedOverlay-Hannover-2026-SecretSeed"

if [ -f "${MARKER}" ]; then
  echo "[Lumina] Yggdrasil first-boot already done."
  exit 0
fi

echo "[Lumina] Running Yggdrasil first-boot identity setup..."

mkdir -p /etc/yggdrasil /var/lib/lumina

if [ ! -f "${YGG_CONF}" ] || ! grep -q "PrivateKey:" "${YGG_CONF}" 2>/dev/null; then
  yggdrasil -genconf > "${YGG_CONF}"
fi

# Apply GroupPassword
if grep -q "GroupPassword:" "${YGG_CONF}"; then
  sed -i "s|GroupPassword:.*|GroupPassword: \"${GROUP_PASSWORD}\"|" "${YGG_CONF}"
else
  sed -i "/PrivateKey:/a\  GroupPassword: \"${GROUP_PASSWORD}\"" "${YGG_CONF}"
fi

# Add public peers if not already present
if ! grep -q "tls://ygg.mkg20001.io:443" "${YGG_CONF}"; then
  cat >> "${YGG_CONF}" << EOF

  Peers: [
    "tls://ygg.mkg20001.io:443"
    "tls://ygg1.mk16.de:1338"
    "tls://yggdrasil.neilalexander.dev:64648"
  ]
EOF
fi

chown root:yggdrasil "${YGG_CONF}" 2>/dev/null || true
chmod 640 "${YGG_CONF}"

if command -v systemctl >/dev/null 2>&1; then
  systemctl enable yggdrasil.service || true
  systemctl restart yggdrasil.service || true
fi

touch "${MARKER}"
echo "[Lumina] Yggdrasil first-boot completed."
