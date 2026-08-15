# Benchmarks 2026

## Hardware
AMD Ryzen 9 7950X / 64GB DDR5 / NVMe

| Scenario | v0.1.0 | v0.1.15 |
|---|---|---|
| Cold start to first LLM call | 0.8s | 0.6s |
| Tool dispatch (local) | 4ms | 2ms |
| Memory idle | 24MB | 21MB |
| cargo test --release | 18s | 15s |

## Methodology
Run scripts/bench.sh on the reference machine above.
