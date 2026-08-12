# Architecture

## Workspace Layout

```
atomcode/
  crates/           # Rust workspace members
  docs/              # Documentation
  docker/            # Dockerfiles (Daemon + TUI variants)
  scripts/           # Cross-platform install + release scripts
  webui/             # Web UI (React + Vite + Tailwind)
```

## Core Loop

1. LLM Call: send context + tools to connected LLM
2. Tool Dispatch: execute tool calls
3. Verify: run configured verification
4. Iterate: feed result back, repeat until done
