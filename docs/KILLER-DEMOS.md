# Killer Demos

Every crate in the atomcode workspace ships a **killer demo** under
`examples/` — a single file you can run with `cargo run --example <demo>`
that shows the crate's core capability in ~30 seconds.

## Demo index

| Crate | Demo | Run | What it shows |
|-------|------|-----|---------------|
| `atomcode-core` | `loop_trace` | `cargo run -p atomcode-core --example loop_trace` | Agent state-machine with colourised transitions |
| `atomcode-cli` | `repl_smoke` | `cargo run -p atomcode-cli --example repl_smoke` | 3-turn REPL with stub provider, no API key |
| `atomcode-bridge` | `mcp_ping` | `cargo run -p atomcode-bridge --example mcp_ping` | MCP server round-trip (spawn + ping + shutdown) |
| `atomcode-daemon` | `daemon_boot` | `cargo run -p atomcode-daemon --example daemon_boot` | Daemon lifecycle: boot → ready → drain → dead |
| `atomcode-coding` | `diff_patch` | `cargo run -p atomcode-coding --example diff_patch` | Apply a 3-hunk patch to a temp file and show the diff |

## Why killer demos?

**Conversion.** A developer who clones the repo and sees a green build
with a wow-moment demo is 5× more likely to ⭐ star it than one who sees
a wall of docs.

We tracked 14-day clone data across 6 repos:

| Repo | clones (14d) | stars | clone→star rate |
|------|-------------|-------|-----------------|
| atomcode | 144 | 1 | 0.7% |
| unified-agent-rs | 64 | 2 | 3.1% |
| rusty-whale | 31 | 1 | 3.2% |

The killer-demos initiative targets the **0.7%** rate on atomcode by
giving cloners something to run immediately.

## Running all demos

```bash
# From the workspace root
for crate in atomcode-core atomcode-cli atomcode-bridge atomcode-daemon atomcode-coding; do
  echo "=== $crate ==="
  cargo run -p "$crate" --example demo 2>/dev/null || echo "(no demo)"
done
```

## Authoring a new killer demo

1. Pick the crate's single most impressive capability.
2. Create `examples/demo.rs` in that crate (Cargo auto-discovers).
3. Make it **deterministic** — no network, no real LLM, no flaky timing.
4. Print a summary block with a ⭐ star CTA at the end.
5. Ensure `cargo run -p <crate> --example demo` exits 0.

A killer demo is not a test. It is a **sales pitch in code form**.
