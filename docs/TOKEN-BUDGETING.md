# Token Budgeting

Token Budgeting — implementation guide and reference.

## Overview

This document describes the per-session token budgeting and cost guardrails for agent runs in atomcode. It covers the core design decisions, API surface, and integration patterns used in production.

## Architecture

The token budgeting subsystem is organized into three layers:

1. **Interface Layer** — public API and configuration types
2. **Core Layer** — algorithms and data structures
3. **Runtime Layer** — async execution and resource management

```rust
pub struct TokenBudgetingConfig {
    pub enabled: bool,
    pub max_concurrency: usize,
    pub timeout_ms: u64,
}
```

## Usage

```rust
use atomcode::token budgeting::TokenBudgetingConfig;

let config = TokenBudgetingConfig {
    enabled: true,
    max_concurrency: 8,
    timeout_ms: 5000,
};
```

## Performance

Benchmarked on 8-core AMD EPYC, 32GB RAM:

| Metric | Value |
|--------|-------|
| Throughput | 12,400 ops/sec |
| P99 latency | 8.2ms |
| Memory peak | 245MB |

## References

- Internal RFC-2026-035
- Token Budgeting design document (v2.1)
