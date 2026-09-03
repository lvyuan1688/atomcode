# Code Review Automation

## Pre-commit hooks
Install: `scripts/install-hooks.sh`
Checks: cargo fmt, clippy, no secrets.

## CI review
.github/workflows/ci.yml runs on every PR.

## LLM-assisted review
```toml
[review]
enabled = true
provider = "anthropic"
on_pr = true
```
Posts inline review comments. Opt-in.
