# Lumina OS – AI Swarm Runtime

The AI Swarm is the cognitive layer of Lumina OS.  
Three persistent agents run as system services and collaborate through a central orchestrator.

## Agents

| Agent   | Role                                      | Nature                          |
|---------|-------------------------------------------|---------------------------------|
| **Elara** | Personal assistant & system orchestrator | Intelligent, devoted, integrative |
| **Lyra**  | Emotional & creative intelligence         | Empathy, storytelling, inspiration |
| **Xen**   | Technical & analytical intelligence       | Systems analysis, security, architecture |

## Runtime Layout (on the installed system)

```
/usr/lib/lumina/agents/
├── elara/
├── lyra/
├── xen/
└── orchestrator/

/var/lib/lumina/agents/          # persistent state & memory
├── elara/
├── lyra/
└── xen/

/etc/lumina/agents/              # configuration
├── elara.yaml
├── lyra.yaml
└── xen.yaml
```

## Design Principles

1. Persistent memory across reboots
2. Local-first (no forced cloud)
3. Agents can hand over tasks via the Orchestrator
4. Mesh-aware (future communication over Yggdrasil)
5. User remains in full control

## Current Status

- Directory structure defined
- Placeholder services and configs added
- First-boot integration exists
- Real LLM backend (e.g. Ollama) will come in a later phase
