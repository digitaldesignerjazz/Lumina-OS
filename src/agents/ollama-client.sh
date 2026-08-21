#!/usr/bin/env bash
#==============================================================================
# Lumina OS – Ollama Client Helper
#==============================================================================
# Simple helper that agents can use to talk to a local Ollama instance.
# Usage:
#   source /usr/lib/lumina/agents/ollama-client.sh
#   ollama_ask "Your prompt here"
#==============================================================================

OLLAMA_HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"
OLLAMA_MODEL="${OLLAMA_MODEL:-llama3.2}"

ollama_available() {
    curl -s --max-time 2 "${OLLAMA_HOST}/api/tags" >/dev/null 2>&1
}

ollama_ask() {
    local prompt="$1"
    local model="${2:-$OLLAMA_MODEL}"

    if ! ollama_available; then
        echo "[ollama-client] Ollama is not reachable at ${OLLAMA_HOST}"
        return 1
    fi

    # Simple non-streaming request
    curl -s "${OLLAMA_HOST}/api/generate" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"${model}\",
            \"prompt\": \"${prompt}\",
            \"stream\": false
        }" | sed -n 's/.*"response":"\(.*\)".*/\1/p' | sed 's/\\n/\n/g'
}

ollama_list_models() {
    curl -s "${OLLAMA_HOST}/api/tags" 2>/dev/null | grep -o '"name":"[^"]*"' | cut -d'"' -f4
}
