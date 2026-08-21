#!/usr/bin/env bash
#==============================================================================
# Lumina OS - Create Minimal Debian System
#==============================================================================
# Builds a minimal Debian system using debootstrap.
# Target: Debian 13 (trixie) – the base of Lumina OS.
#
# Usage:
#   sudo ./scripts/build-minimal-debian.sh
#==============================================================================

set -euo pipefail

#------------------------------------------------------------------------------
# Configuration
#------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build"
CHROOT_DIR="${BUILD_DIR}/minimal-debian"
DISTRO="trixie"
MIRROR="http://deb.debian.org/debian"
ARCH="amd64"

#------------------------------------------------------------------------------
# Colors
#------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()     { echo -e "${BLUE}[+]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

#------------------------------------------------------------------------------
# Checks
#------------------------------------------------------------------------------
if [ "$(id -u)" -ne 0 ]; then
    error "This script must be run as root (use sudo)."
fi

if ! command -v debootstrap >/dev/null 2>&1; then
    error "debootstrap is not installed. Run: apt install debootstrap"
fi

#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------
main() {
    echo "=============================================="
    echo "  Lumina OS – Minimal Debian System Builder"
    echo "=============================================="
    echo
    log "Distribution : ${DISTRO}"
    log "Architecture : ${ARCH}"
    log "Target       : ${CHROOT_DIR}"
    echo

    # Clean previous build if exists
    if [ -d "${CHROOT_DIR}" ]; then
        warn "Existing directory found. Removing..."
        rm -rf "${CHROOT_DIR}"
    fi

    mkdir -p "${BUILD_DIR}"

    log "Starting debootstrap (this can take several minutes)..."
    debootstrap \
        --arch="${ARCH}" \
        --variant=minbase \
        --include=sudo,ca-certificates,apt-transport-https,curl,wget,gnupg \
        "${DISTRO}" \
        "${CHROOT_DIR}" \
        "${MIRROR}"

    success "Minimal Debian system created successfully!"

    # Basic configuration inside the chroot
    log "Applying basic Lumina configuration..."

    # Hostname
    echo "lumina" > "${CHROOT_DIR}/etc/hostname"

    # Simple motd
    cat > "${CHROOT_DIR}/etc/motd" << EOF
Welcome to Lumina OS (Minimal Base)

This is a minimal Debian ${DISTRO} system prepared for Lumina OS.
EOF

    # DNS (so the chroot can resolve names)
    cat > "${CHROOT_DIR}/etc/resolv.conf" << EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

    success "Basic configuration applied."

    echo
    echo "----------------------------------------------"
    echo "  Result"
    echo "----------------------------------------------"
    echo
    echo "Minimal Debian system is ready at:"
    echo "  ${CHROOT_DIR}"
    echo
    echo "You can enter the system with:"
    echo "  sudo chroot ${CHROOT_DIR} /bin/bash"
    echo
    echo "Next steps for Lumina OS:"
    echo "  - Install Yggdrasil"
    echo "  - Add AI Swarm components"
    echo "  - Configure Nexus identity"
    echo
}

main "$@"
