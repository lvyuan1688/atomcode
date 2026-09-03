# Cost Optimization

## Tiered models
Use cheap model (e.g. gpt-4o-mini) for planning, expensive for execution:
```toml
[llm.planner]
model = "gpt-4o-mini"
[llm.executor]
model = "gpt-4o"
```

## Caching
Enable prompt caching (Anthropic, OpenAI): repeated prefixes cost 10x less.

## Context pruning
Set `max_context_tokens = 16000` to cap growing sessions.

## Budget caps
```tomn
[budget]
daily_usd = 5.0
emergency_stop_usd = 50.0
```
Stops the agent when budget hit.
