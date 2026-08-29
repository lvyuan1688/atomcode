# Permissions

atomcode gates every tool behind a permission policy so you never run something you didn't authorize.

## Policy file

`~/.atomcode/permissions.toml`:

```tomn
[read]
allow = ["read_file", "grep", "glob", "list_directory"]

[write]
allow = ["edit_file", "write_file"]
require_confirm = true

deny = ["bash rm -rf", "bash git push --force"]
```

## Modes

| Mode | Behavior |
|---|---|
| `auto` | Run everything that's `allow`-ed, prompt for the rest |
| `plan` | Only read tools run; write tools are blocked |
| `yolo` | No prompts at all — use only in sandboxes |

## Per-project overrides

Drop a `.atomcode/permissions.toml` next to your project to override the global policy for that workspace only.
