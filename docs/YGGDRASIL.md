# Yggdrasil Integration in Lumina OS

## Philosophy

In Lumina OS, Yggdrasil is not an optional VPN-like tool.  
It is treated as a **native network identity layer** of the operating system.

Every Lumina system is born with a permanent cryptographic identity and is expected to participate in the Nexus mesh from the first boot.

---

## Design Goals

1. **Permanent Identity**  
   Each installation generates (or imports) a long-lived Yggdrasil keypair. The resulting IPv6 address becomes a primary, location-independent identifier of the machine.

2. **Closed Overlay by Default**  
   Internal Nexus traffic uses a GroupPassword-protected overlay. Only trusted peers can join the private mesh.

3. **Public Reachability (optional)**  
   Public peers can be configured so that the node remains reachable from the wider Yggdrasil network while keeping sensitive traffic inside the closed overlay.

4. **First-Boot Automation**  
   On first boot the system should:
   - Generate or restore identity
   - Apply the Nexus GroupPassword
   - Connect to a curated set of public peers (for bootstrap)
   - Register itself with the local Nexus Orchestrator

---

## Planned Integration Points

### Systemd Services

- `yggdrasil.service` — core daemon
- `lumina-ygg-identity.service` — identity generation / restoration on first boot
- `lumina-mesh-orchestrator.service` — health monitoring and peer management

### Configuration

Primary configuration file location (planned):

```
/etc/yggdrasil/yggdrasil.conf
```

Key settings that Lumina will manage:

- `PrivateKey` / identity persistence
- `GroupPassword` (Nexus closed overlay)
- `Peers` (public bootstrap + trusted private peers)
- `NodeInfo` (machine role, swarm membership, etc.)

### User-facing Tools

- `lumina-mesh status` — show current mesh state
- `lumina-mesh peers` — list and manage peers
- `lumina-mesh identity` — show or export identity

---

## Security Notes

- The GroupPassword must never be stored in plain text in world-readable locations.
- Identity private keys must be protected with appropriate filesystem permissions and (preferably) encrypted at rest.
- Public peers are only used for reachability; they do not grant access to the closed Nexus overlay.

---

## Current Status

This document describes the **intended architecture**.  
Implementation of the first-boot identity generation and systemd integration is still pending.

Contributions in this area are highly welcome.
