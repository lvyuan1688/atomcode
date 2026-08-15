# Telemetry (opt-in, v0.3+)

## Principles
- Off by default, explicit user consent
- Local-only until user opts in
- No PII, no source content

## Metrics planned
- Tool call count per session
- Tokens consumed
- Agent iterations
- Error rate

All emitted via OpenTelemetry if user configures exporter.
