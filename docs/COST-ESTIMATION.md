# Cost Estimation

atomcode can forecast the token cost of a session before you run it, so you can pick the cheapest model that still gets the job done.

## How it works

1. A dry-run planner reads your prompt + project map and estimates input/output tokens.
2. It multiplies by the per-model price table in `config/pricing.toml`.
3. The estimate is shown in the TUI before the first LLM call.

## Price table

```toml
[gpt-4o]
input = 5.00e-6    # USD per token
output = 1.50e-5

[deepseek-v3]
input = 1.10e-6
output = 1.10e-6
```

## CLI

```bash
atomcode --estimate "refactor the auth module"
# → ~12.4k input tokens, ~3.1k output tokens
# → gpt-4o: $0.11  |  deepseek-v3: $0.02
```

## Caching

Prompt caching is detected automatically when the provider reports `cached_tokens`. Cached input is priced at 10% of the normal rate.
