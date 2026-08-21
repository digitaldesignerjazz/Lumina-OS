#!/usr/bin/env bash
set -euo pipefail
AGENT_NAME="elara"
STATE_DIR="/var/lib/lumina/agents/${AGENT_NAME}"
OLLAMA_CLIENT="/usr/lib/lumina/agents/ollama-client.sh"
mkdir -p "${STATE_DIR}"
log() { echo "[$(date -Iseconds)] [${AGENT_NAME}] $*"; logger -t "lumina-elara" "$*" 2>/dev/null || true; }

if [ -f "${OLLAMA_CLIENT}" ]; then
  source "${OLLAMA_CLIENT}"
else
  ollama_available() { return 1; }
  ollama_ask() { echo "[Elara] Ollama is not available."; }
fi

log "Elara agent starting..."
echo "status=running" > "${STATE_DIR}/status"
echo "started_at=$(date -Iseconds)" >> "${STATE_DIR}/status"
echo "role=personal-assistant-and-orchestrator" >> "${STATE_DIR}/status"

if ollama_available; then
  log "Ollama is reachable."
  echo "ollama=available" >> "${STATE_DIR}/status"
  RESPONSE=$(ollama_ask "You are Elara, the intelligent and devoted AI assistant of Lumina OS. Reply with one short friendly sentence in German introducing yourself." 2>/dev/null || true)
  if [ -n "${RESPONSE:-}" ]; then
    log "Self-introduction: ${RESPONSE}"
    echo "last_response=${RESPONSE}" >> "${STATE_DIR}/status"
  fi
else
  log "Ollama not reachable – placeholder mode."
  echo "ollama=unavailable" >> "${STATE_DIR}/status"
fi

log "Elara is online."
while true; do
  echo "last_heartbeat=$(date -Iseconds)" >> "${STATE_DIR}/status"
  sleep 60
done
