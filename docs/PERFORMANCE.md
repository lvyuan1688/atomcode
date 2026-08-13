# Performance

## Methodology

Benchmarks run via scripts/bench.sh on:
- CPU: AMD Ryzen 9 7950X (16 cores)
- RAM: 64GB DDR5
- Storage: NVMe SSD
- OS: Ubuntu 24.04 LTS

## Baselines (v0.1.0)

| Metric | Value |
|---|---|
| cargo build --release | 312s |
| cargo test --release | 18s |
| Cold start to first LLM call | 0.8s |
| Memory idle | 24MB |
