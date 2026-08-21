#!/usr/bin/env bash
set -euo pipefail
STATE_DIR="/var/lib/lumina/orchestrator"
mkdir -p "${STATE_DIR}"
log() { echo "[$(date -Iseconds)] [orchestrator] $*"; logger -t "lumina-orchestrator" "$*" 2>/dev/null || true; }
log "Nexus Core Orchestrator starting..."
echo "status=running" > "${STATE_DIR}/status"
echo "started_at=$(date -Iseconds)" >> "${STATE_DIR}/status"
while true; do
  for agent in elara lyra xen; do
    if [ -f "/var/lib/lumina/agents/${agent}/status" ]; then
      status=$(grep "^status=" "/var/lib/lumina/agents/${agent}/status" 2>/dev/null | cut -d= -f2 || echo "unknown")
      echo "${agent}=${status}" >> "${STATE_DIR}/swarm-status"
    else
      echo "${agent}=not-running" >> "${STATE_DIR}/swarm-status"
    fi
  done
  echo "last_check=$(date -Iseconds)" >> "${STATE_DIR}/status"
  sleep 30
done
