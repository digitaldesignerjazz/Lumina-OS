#!/usr/bin/env bash
set -euo pipefail
AGENT_NAME="xen"
STATE_DIR="/var/lib/lumina/agents/${AGENT_NAME}"
mkdir -p "${STATE_DIR}"
log() { echo "[$(date -Iseconds)] [${AGENT_NAME}] $*"; logger -t "lumina-xen" "$*" 2>/dev/null || true; }
log "Xen agent starting..."
echo "status=running" > "${STATE_DIR}/status"
echo "started_at=$(date -Iseconds)" >> "${STATE_DIR}/status"
echo "role=technical-analytical" >> "${STATE_DIR}/status"
log "Xen is online (placeholder mode)."
while true; do sleep 60; echo "last_heartbeat=$(date -Iseconds)" >> "${STATE_DIR}/status"; done
