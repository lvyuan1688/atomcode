# Plugin Registry

The plugin registry is the central index of installed plugins for atomcode.
It lives at `~/.atomcode/plugins/registry.json` and is rebuilt whenever a
plugin is added, removed, upgraded, or enabled/disabled.

## Schema

```json
{
  "version": 1,
  "plugins": [
    {
      "name": "rust-docs",
      "version": "0.2.1",
      "kind": "tool_provider",
      "enabled": true,
      "source": "github:lvyuan1688/atomcode-plugin-rust-docs",
      "installed_at": "2026-08-28T10:00:00Z",
      "signature": "ed25519:..."
    }
  ]
}
```

| Field | Meaning |
|-------|---------|
| `version` | Registry schema version (currently 1) |
| `name` | Unique plugin identifier, lowercase + hyphens |
| `version` | Semver of the plugin |
| `kind` | `tool_provider`, `auth_backend`, `transport_adapter`, or `policy_hook` |
| `enabled` | Whether the agent loads this plugin at startup |
| `source` | Origin: `github:owner/repo`, `local:/path`, or `registry:slug` |
| `signature` | Detached signature for verification |

## Commands

```bash
atomcode plugin install github:lvyuan1688/atomcode-plugin-rust-docs
atomcode plugin list
atomcode plugin enable rust-docs
atomcode plugin disable rust-docs
atomcode plugin remove rust-docs
atomcode plugin update --all
```

## Resolution order

When two plugins register the same tool name, the registry applies this
priority to decide which one the agent calls:

1. Plugins with `enabled = true`, sorted by `installed_at` (newest wins)
2. Built-in tools
3. Disabled plugins (never called)

Override the default by setting an explicit `priority` in the plugin
manifest. Higher priority wins.

## Verification

```bash
atomcode doctor --check plugin-registry
```

Confirms the registry file parses, reports how many plugins are enabled,
flags any plugin whose signature no longer verifies, and warns on
plugins whose declared `kind` is not recognized by the current atomcode
version.
