# Ollama Integration in Lumina OS

Ollama provides the local large language model backend for the Lumina AI Swarm.

## Goals

- Run models completely locally
- No forced cloud dependency
- Simple interface for Elara, Lyra and Xen
- Easy model management for the user

## Architecture

```
User / System Event
        │
        ▼
   Elara / Lyra / Xen
        │
        ▼
  ollama-client.sh
        │
        ▼
   Ollama (localhost:11434)
        │
        ▼
   Local Model (e.g. llama3.2)
```

## Installation

On a running Lumina system:

```bash
sudo ./scripts/setup-ollama.sh
```

Or manually:

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull llama3.2
```

## Configuration

Default config file: `/etc/lumina/ollama.yaml`

```yaml
host: "http://127.0.0.1:11434"
default_model: "llama3.2"
```

## Using the client from agents

```bash
source /usr/lib/lumina/agents/ollama-client.sh

if ollama_available; then
    response=$(ollama_ask "Explain the current system status in one sentence.")
    echo "$response"
fi
```

## Recommended models for Lumina OS

| Model       | Size   | Use case                     |
|-------------|--------|------------------------------|
| llama3.2    | ~2 GB  | Good general default         |
| phi3        | ~2 GB  | Fast and capable             |
| gemma2:2b   | ~1.6 GB| Very light systems           |
| mistral     | ~4 GB  | Higher quality when RAM allows |

## Current Status

- Setup script available
- Client helper available
- systemd integration prepared
- Agents can optionally call Ollama (placeholder stage)

Real conversational loops will be added in the next iteration of the agent runtimes.
