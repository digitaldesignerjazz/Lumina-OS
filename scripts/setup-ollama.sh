#!/usr/bin/env bash
#==============================================================================
# Lumina OS – Ollama Setup Script
#==============================================================================
# Installs Ollama and prepares it for the AI Swarm.
# This script is intended to be run on a running Lumina system or during
# image customization.
#
# Usage:
#   sudo ./scripts/setup-ollama.sh
#==============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log()     { echo -e "${BLUE}[+]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

if [ "$(id -u)" -ne 0 ]; then
    error "This script must be run as root."
fi

echo "=============================================="
echo "  Lumina OS – Ollama Setup"
echo "=============================================="
echo

# Install Ollama via official installer
if command -v ollama >/dev/null 2>&1; then
    success "Ollama is already installed: $(ollama --version 2>/dev/null || echo 'unknown version')"
else
    log "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
    success "Ollama installed"
fi

# Ensure systemd service exists and is enabled
if [ -f /etc/systemd/system/ollama.service ] || systemctl list-unit-files | grep -q ollama.service; then
    log "Enabling and starting Ollama service..."
    systemctl enable ollama.service || true
    systemctl start ollama.service || true
    success "Ollama service started"
else
    log "Creating basic Ollama systemd service..."
    cat > /etc/systemd/system/ollama.service << EOF
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[Install]
WantedBy=multi-user.target
EOF
    # Create user if missing
    id ollama >/dev/null 2>&1 || useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama
    systemctl daemon-reload
    systemctl enable --now ollama.service
    success "Ollama service created and started"
fi

# Create Lumina Ollama config
mkdir -p /etc/lumina
cat > /etc/lumina/ollama.yaml << EOF
# Lumina OS – Ollama configuration for AI Swarm
host: "http://127.0.0.1:11434"
default_model: "llama3.2"
# Recommended small models for lower-end hardware:
#   - llama3.2
#   - phi3
#   - gemma2:2b
EOF

success "Configuration written to /etc/lumina/ollama.yaml"

echo
echo "Next steps:"
echo "  1. Pull a model, e.g.:  ollama pull llama3.2"
echo "  2. Test:               ollama run llama3.2"
echo "  3. The AI Swarm agents can now use the ollama-client helper"
echo
