# Session Format

atomcode stores each session as a JSONL file under `~/.atomcode/sessions/`. One line = one event.

## Event types

### `meta`
```json
{"type":"meta","session_id":"...","started_at":"...","model":"..."}
```

### `user`
```json
{"type":"user","text":"...","tokens":{"in":N,"out":0}}
```

### `assistant`
```json
{"type":"assistant","text":"...","tool_calls":[...],"tokens":{"in":N,"out":M}}
```

### `tool`
```json
{"type":"tool","name":"...","args":{...},"result":...}
```

## Replaying

```bash
atomcode sessions replay <session_id>  # re-runs every tool call in dry-run mode
```

The format is stable across v0.1.x; v0.2 adds a `cost_usd` field (see docs/COST-ESTIMATION.md).
