#!/usr/bin/env bash
#==============================================================================
# Lumina OS - Build Dependency Checker
#==============================================================================
# This script checks whether the current system has the required tools
# to build Lumina OS images.
#
# Usage:
#   ./scripts/check-build-deps.sh
#==============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=============================================="
echo "  Lumina OS – Build Dependency Check"
echo "=============================================="
echo

MISSING=0

check_command() {
    local cmd="$1"
    local package="$2"

    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${GREEN}[OK]${NC}  $cmd is available"
    else
        echo -e "${RED}[MISSING]${NC}  $cmd  (install package: $package)"
        MISSING=$((MISSING + 1))
    fi
}

echo "Checking required tools..."
echo

# Core tools for Debian-based image building
check_command "debootstrap"   "debootstrap"
check_command "lb"            "live-build"          # live-build command
check_command "xorriso"       "xorriso"
check_command "mksquashfs"    "squashfs-tools"
check_command "gpg"           "gnupg"
check_command "curl"          "curl"
check_command "git"           "git"
check_command "rsync"         "rsync"

echo
if [ "$MISSING" -eq 0 ]; then
    echo -e "${GREEN}All required build dependencies are installed.${NC}"
    echo "You can proceed with the ISO build process."
    exit 0
else
    echo -e "${YELLOW}$MISSING required tool(s) are missing.${NC}"
    echo
    echo "On Debian/Ubuntu you can install the main packages with:"
    echo
    echo "  sudo apt update"
    echo "  sudo apt install -y live-build debootstrap xorriso squashfs-tools gnupg curl git rsync"
    echo
    exit 1
fi
