# Observability

atomcode emits structured telemetry so you can wire it into any observability stack.

## Spans

Every agent loop iteration is a span:
- `agent.loop` — one think→act→observe cycle
- `tool.call` — one tool invocation, with name + args hash
- `llm.request` — one LLM round-trip, with model + token counts

Spans are exported via OpenTelemetry when `telemetry.otlp_endpoint` is set.

## Metrics

| Metric | Type | Labels |
|---|---|---|
| `atomcode_tool_calls_total` | counter | tool, status |
| `atomcode_llm_tokens_total` | counter | model, direction |
| `atomcode_loop_duration_seconds` | histogram | session_id |

## Local inspection

```bash
atomcode --telemetry-stdout  # pretty-print spans to stderr
```

See docs/TELEMETRY.md for the config schema.
