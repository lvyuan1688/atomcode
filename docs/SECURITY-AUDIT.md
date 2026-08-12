# Security Self-Audit

## Checklist

- [ ] No secrets in git history (git log -p | grep -iE 'pat|token|key')
- [ ] Dependencies audited (cargo audit)
- [ ] No hardcoded endpoints in binaries
- [ ] Input validation on all user-facing APIs
- [ ] Error messages don't leak internal paths

## Frequency

Run before every minor release (v0.X.0).
