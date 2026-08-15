# Migrating to v0.2

## Breaking Changes

### Config format
v0.1 TOML → v0.2 JSON. Run `scripts/migrate-config.sh` to auto-convert.

### Tool names
`run_command` → `exec`. Update verify scripts.

### Plugin hooks
`pre-tool`/`post-tool` renamed to `before_exec`/`after_exec`. Update manifests.

## Non-breaking
Existing Rust API stays. New features additive.
