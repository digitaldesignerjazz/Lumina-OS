# Live-Build Configuration for Lumina OS

This directory contains the configuration for building Lumina OS ISOs using Debian’s **live-build** tool.

## Current Status

Foundation is being prepared. The structure follows official live-build conventions.

## Planned Structure

```
live-build/
├── auto/
│   └── config                 # Main configuration script
├── config/
│   ├── package-lists/         # Packages to install
│   ├── includes.chroot/       # Files copied into the system
│   ├── includes.binary/       # Files for the ISO
│   ├── hooks/                 # Scripts run during build
│   └── bootloaders/           # Bootloader configuration
└── README.md
```

## Key Goals for Lumina OS live-build

- Based on pure Debian 13 (Trixie)
- Native Yggdrasil identity generation on first boot
- AI Swarm (Elara, Lyra, Xen) pre-installed and configured
- Nexus branding and defaults
- Clean, reproducible builds
