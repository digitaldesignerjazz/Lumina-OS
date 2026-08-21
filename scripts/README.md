# Scripts

This directory contains the build and helper scripts for Lumina OS.

## Available Scripts

| Script | Description |
|--------|-------------|
| `check-build-deps.sh` | Checks whether all required tools for building are installed |
| `build-iso.sh` | Main ISO build script (currently prepares the environment) |

## Usage

Make the scripts executable (first time only):

```bash
chmod +x scripts/*.sh
```

Check dependencies:

```bash
./scripts/check-build-deps.sh
```

Prepare / start the build process:

```bash
./scripts/build-iso.sh
```

## Future Scripts

- `prepare-yggdrasil.sh` – First-boot Yggdrasil identity setup
- `setup-agents.sh` – Initialize the AI Swarm
- `update-mesh-peers.sh` – Manage Yggdrasil peers
