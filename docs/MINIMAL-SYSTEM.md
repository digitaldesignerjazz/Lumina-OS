# Minimal Debian System for Lumina OS

This document describes the current minimal system that serves as the foundation for Lumina OS.

## Status (2026-08-21)

A minimal Debian 13 (trixie) system has been successfully created with:

- **Base**: Debian 13 “Trixie” (minbase + essential tools)
- **Yggdrasil**: Installed (version 0.5.14) with a fresh configuration
- **AI Swarm structure**: Directory layout prepared for Elara, Lyra and Xen

## Location (current working copy)

```
/tmp/lumina-minimal-debian
```

## What is already inside

### Yggdrasil
- Binary: `/usr/bin/yggdrasil` and `yggdrasilctl`
- Config: `/etc/yggdrasil/yggdrasil.conf` (freshly generated)
- Ready for Nexus GroupPassword and public/private peers

### AI Swarm Structure
```
/etc/lumina/
├── version
└── agents/

/var/lib/lumina/agents/
├── elara/
├── lyra/
└── xen/
```

### Basic identity
- Hostname: `lumina`
- MOTD: Lumina OS welcome message

## How to enter the system

```bash
sudo chroot /tmp/lumina-minimal-debian /bin/bash
```

## Next steps

1. Add Nexus GroupPassword and trusted peers to Yggdrasil config
2. Create first-boot identity generation script
3. Add actual AI agent runtime placeholders
4. Integrate this chroot into the live-build / ISO pipeline

## Build script

The system can be recreated with:

```bash
sudo ./scripts/build-minimal-debian.sh
```
