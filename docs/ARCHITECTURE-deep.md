# Architecture Deep Dive

## Agent Loop State Machine

```
[init] → [plan] → [act] → [verify] → [done]
            ↑           |
            └── retry ──┘
```

## State Transitions

- init → plan: user prompt received
- plan → act: plan approved (or auto-approve)
- act → verify: tool dispatch complete
- verify → done: verification passed
- verify → act: verification failed, retry with feedback
- verify → done: max retries reached, surface to user
