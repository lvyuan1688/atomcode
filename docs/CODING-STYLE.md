# Coding Style

## Formatting
- cargo fmt is canonical
- 4-space indent
- Max line 100 chars

## Patterns
- Prefer ? over match for error propagation
- Use anyhow for app errors, thiserror for library errors
- Avoid unwrap() in production paths; use expect() with context

## Naming
- snake_case for fns/vars, PascalCase for types
- Single-letter lifetimes only in small scopes
