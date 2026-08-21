# Live-Build Configuration for Lumina OS

This directory contains the configuration for building Lumina OS ISOs using Debian’s **live-build** tool.

## Current Structure

```
live-build/
├── auto/
│   └── config                          # Main live-build configuration
├── config/
│   ├── package-lists/
│   │   └── lumina.list.chroot          # Packages to install
│   ├── includes.chroot/
│   │   └── etc/hostname                # Default hostname
│   └── hooks/
│       └── normal/
│           ├── 0100-lumina-branding.hook.chroot
│           └── 0200-yggdrasil-prep.hook.chroot
└── README.md
```

## How to use (once dependencies are installed)

```bash
cd live-build
sudo lb config          # applies auto/config
sudo lb build           # builds the ISO
```

## Goals

- Based on pure Debian 13 (Trixie)
- Native Yggdrasil identity generation on first boot
- AI Swarm (Elara, Lyra, Xen) pre-installed
- Nexus branding and sensible defaults
- Fully reproducible builds

## Status

Foundation is in place. The configuration is intentionally minimal and clean so it can grow step by step.
